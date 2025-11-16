



# 🚀 Quick Start: Hallmark Movie Plot Generator

> ⚠️ **Important**: If you're looking for instructions to run the **TK4 (MVS/COBOL 74)** version,  
> please scroll to the bottom — **this section is for running on PC with GNU COBOL (COBOL 85)**.  
> Most users should start here. TK4 is for legacy mainframe environments only.

---

## ✅ On PC (GNU COBOL / COBOL 85) — Recommended for Beginners

**Run your first Hallmark-style story in under 60 seconds — no mainframe required.**

### 1. Download & Extract

Make sure you have these files in your working directory:
```
hallmark.cob
simosub1.cob
xmas/vars.dat
xmas/plot.dat
```

> 💡 Already have them? Great! Skip to Step 2.

---

### 2. Compile (One-Time Setup)

Open a terminal and run:

```bash
cobc -c simosub1.cob
cobc -x hallmark.cob simosub1.o 
```

✅ Done! You now have a standalone executable called `hallmark`.

---

### 3. Run the Christmas Story

```bash
cd xmas
../hallmark
```

You’ll be prompted to select options for each variable. Example:

```
Select a value for <female_1>:
1. Architect
2. Librarian
3. Teacher
4. Baker
> 1

Select a value for <male_2>:
1. Local Contractor
2. Coffee Shop Owner
3. Winter Festival Organizer
4. Former Soldier
> 2
```

Just type `1`, `2`, `3`, or `4` and press **Enter** for each prompt.

---

### 4. Enjoy Your Story!

Your generated plot will appear — **automatically word-wrapped to ≤80 characters** for clean terminal display:

```
A dedicated Architect decides to restore the old community center...
...and falls for the Coffee Shop Owner during a snowstorm.
After the breakup, she started noticing him — his quiet strength,
his care for the bookstore. Working side by side to save it,
she realized she was falling for him...
```

Perfect for viewing on any terminal, emulator, or even a 3270 screen!

---

## 🔁 Want Thanksgiving Instead?
Navigate to  the `turkey/` folder run `../hallmark` again!
```bash
cd turkey
../hallmark
```
---

## ⚠️ For TK4 (MVS/COBOL 74) Users Only — Legacy Mainframe Version

> 📌 **Only use this section if you’re running on Hercules/MVS3.8 or a COBOL 74 environment.**  
> If you're on a PC, **do not follow these steps** — use the PC section above instead.

### 1. Transfer Files to TK4

Use `IND$FILE` to copy these files from your PC to MVS, **ensuring fixed-length records**:

| Source (PC) | Target (MVS) | Record Length |
|-------------|--------------|---------------|
| `tk4/hallmk74.cob` | `'USER.SOURCE.COBOL(HALLMARK)'` | — |
| `tk4/simosub2.cob` | `'USER.SOURCE.COBOL(SIMOSUB2)'` | — |
| `tk4/tkclist.txt` | `'USER.RUN.CLIST(HALLMARK)'` | — |
| `xmas/vars.txt` | `'USER.HM.XMAS.VARS.DAT'` | **FIXED 80** |
| `xmas/plot.txt` | `'USER.HM.XMAS.PLOT.DAT'` | **FIXED 1024** |

> ⚠️ **Critical**: Set **File Type = FIXED** and specify exact record lengths.  
> Variable-length records will cause runtime failures.

---

### 2. Compile and Link

In MVS, compile the subroutine **SIMOSUB2** the usual way:
```jcl
//COMPILE1 JOB ...
//STEP1    EXEC PGM=IGYCRCTL,PARM='LIB,NOADV'
//SYSIN    DD DSN=USER.SOURCE.COBOL(SIMOSUB2),DISP=SHR
//SYSLIB   DD DSN=SYS1.COBOLLIB,DISP=SHR
//SYSLIN   DD DSN=&&LOADSET,DISP=(,PASS),UNIT=VIO
//SYSUT1   DD UNIT=VIO,SPACE=(CYL,(1,1))
. . .
//LINK     EXEC PGM=IEWL,PARM='XREF,LET'
//SYSLIB   DD DSN=SYS1.SCEELKED,DISP=SHR
//SYSLIN   DD DSN=&&LOADSET,DISP=(OLD,DELETE)
//SYSLMOD  DD DSN=USER.RUN.LOAD(SIMOSUB2),DISP=SHR
//SYSUT1   DD UNIT=VIO,SPACE=(CYL,(1,1))
```
Then compile the main program **HALLMARK** and include the subroutine.
```jcl
//COMPILE2 JOB ...
//STEP1    EXEC PGM=IGYCRCTL,PARM='LIB,NOADV'
//SYSIN    DD DSN=USER.SOURCE.COBOL(HALLMARK),DISP=SHR
//SYSLIB   DD DSN=SYS1.COBOLLIB,DISP=SHR
//SYSLIN   DD DSN=&&LOADSET,DISP=(,PASS),UNIT=VIO
//SYSUT1   DD UNIT=VIO,SPACE=(CYL,(1,1))

. . .
//LINK     EXEC PGM=IEWL,PARM='XREF,LET'
//SYSLIB   DD DSN=SYS1.SCEELKED,DISP=SHR
//SYSLIN   DD DSN=&&LOADSET,DISP=(OLD,DELETE)
//         DD *
   INCLUDE SYSLMOD(SIMOSUB2)
/*
//SYSLMOD  DD DSN=USER.RUN.LOAD(HALLMARK),DISP=SHR
//SYSUT1   DD UNIT=VIO,SPACE=(CYL,(1,1))
```

> ✅ The `INCLUDE SYSLMOD(SIMOSUB2)` link control card is required to bind the search/replace module.

---

### 3. Run the Story

Exit to **READY** mode and type:

```
EX RUN(HALLMARK) 'XMAS'
```

The program will prompt you for selections — just type `1`–`4` and press **Enter**.

---

## 🎬 Sample Execution (Same for Both Versions!)

Regardless of platform, you’ll see:

```
Select a value for <female_1>:
1. Architect
2. Librarian
3. Teacher
4. Baker
> 1

Select a value for <male_2>:
1. Local Contractor
2. Coffee Shop Owner
3. Winter Festival Organizer
4. Former Soldier
> 2
...
```

And your output will be beautifully wrapped:

```
A dedicated Architect decides to restore the old community center...
...and falls for the Coffee Shop Owner during a snowstorm.
After the breakup, she started noticing him — his quiet strength,
his care for the bookstore. Working side by side to save it,
she realized she was falling for him...
```

---

## 🔁 Want Thanksgiving Instead?

- **On PC**: Replace files in `xmas/` with those from `turkey/`
- **On TK4**: Use IND$FILE to transfer `turkey/vars.txt` and `turkey/plot.txt` to `'USER.HM.TURKEY.*'`, then run:  
  ```
  EX RUN(HALLMARK) 'TURKEY'
  ```

---

## 🛠 Need Help?

- Full documentation: [README.md](README.md)  
- Join the conversation: [r/COBOL](https://reddit.com/r/COBOL) | [IBMMainframes.com](https://ibmmainframes.com)

---

> 🎄 Happy plotting! May your stories be cozy, your variables always resolved,  
> and your terminals never overflow beyond 80 columns.



