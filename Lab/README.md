上机实验：

**第一次**:

2019.11.04(第十一周周一）

任务:找到十万以内的所有素数，并在屏幕上输出

Prime.asm：一万以内素数

通过

  .model small
  .386

  .code
  start:

  end start

改装

Prime2.asm：十万以内素数



2019.11.20

任务:输出前50位斐波那契数

fibo.asm 成功输出前46位，但是因为47位之后超出32位寄存器的容量，需要改进



通过adc实现进位加法，用edx存放高位，用eax存放低位

fibo1.asm:求出前50位斐波那契数