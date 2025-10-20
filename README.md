# 🧠 Synchronous FIFO Verification — SystemVerilog Project

## 📘 Overview  
This project implements and verifies a **Synchronous FIFO (First-In-First-Out)** design using **SystemVerilog**.  
The goal is to ensure correct data flow, synchronization, and behavior under all operational conditions — including **full**, **empty**, **almost full**, and **almost empty** states — using **coverage-driven** and **assertion-based verification** techniques.

---

## 🧩 Verification Environment  
The verification environment was built **from scratch** using SystemVerilog and structured into multiple components:

- **Transaction Class:** Generates both directed and constrained-random stimuli.  
- **Driver:** Sends stimulus transactions to the DUT.  
- **Monitor:** Observes DUT inputs/outputs and collects data for analysis.  
- **Scoreboard:** Implements a reference model to validate read-after-write correctness.  
- **Assertions (SVA):** Check for protocol violations (overflow, underflow, reset, and signal integrity).  
- **Functional Coverage:** Captures coverage of all FIFO states and transitions (`wr_en`, `rd_en`, `full`, `empty`, `almost_full`, `almost_empty`).

---

## 🐞 Bug Detection and Debugging  
During simulation and waveform analysis in **QuestaSim**, the following design issues were detected and corrected:
1. Underflow signal meant to be sequential  
2. Missing conditions in FIFO control logic  
3. Uninitialized reset signals  
4. Incorrect almost full logic  

---

## 📊 Coverage Results  

| Coverage Type        | Result  |
|----------------------|---------|
| Statement Coverage   | 100% ✅ |
| Branch Coverage      | 100% ✅ |
| Toggle Coverage      | 100% ✅ |
| Functional Coverage  | 100% ✅ |
| Assertion Coverage   | 100% ✅ |

All coverage goals were achieved through a mix of **random** and **directed testing**.

---

## ⚙️ Tools & Methodology  
- **Language:** SystemVerilog (RTL & Testbench)  
- **Simulator:** QuestaSim  
- **Methodology:** Constrained-Random & Coverage-Driven Verification  
- **Design Type:** Synchronous FIFO  

---

## 💡 Key Learnings  
- Implemented a **self-checking verification environment** using SystemVerilog classes.  
- Gained experience in **coverage-driven verification** and **assertion-based debugging**.  
- Strengthened understanding of **synchronization, data integrity, and timing behavior** in digital systems.  
- Achieved **complete verification closure** through simulation-based validation.

---



