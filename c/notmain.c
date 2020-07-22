
//-------------------------------------------------------------------
//-------------------------------------------------------------------
void PUT32( unsigned int, unsigned int);
unsigned int GET32 ( unsigned int );
void  dummy ( unsigned int );
unsigned int MCYCLE ( void );
unsigned int AMOSWAP ( unsigned int, unsigned int);

#define GPIOBASE 0x10012000
#define GPIO_VALUE          (GPIOBASE+0x00)
#define GPIO_INPUT_EN       (GPIOBASE+0x04)
#define GPIO_OUTPUT_EN      (GPIOBASE+0x08)
#define GPIO_PORT           (GPIOBASE+0x0C)
#define GPIO_PUE            (GPIOBASE+0x10)
#define GPIO_OUT_XOR        (GPIOBASE+0x40)
#define GPIO_IOF_EN         (GPIOBASE+0x38)
#define GPIO_IOF_SEL        (GPIOBASE+0x3C)

#define UART0BASE       0x10013000
#define UART0_TXDATA    (UART0BASE+0x00)
#define UART0_RXDATA    (UART0BASE+0x04)
#define UART0_TXCTRL    (UART0BASE+0x08)
#define UART0_RXCTRL    (UART0BASE+0x0C)
#define UART0_IE        (UART0BASE+0x10)
#define UART0_IP        (UART0BASE+0x14)
#define UART0_DIV       (UART0BASE+0x18)

#define MTIME 0x0200BFF8

#define get32(a) (*((unsigned *)a))
#define put32(a, b) (*((unsigned *)a) = b)

void uart_put(char c)
{
  /* wait if queue is full. */
  while (1) {
    if ((get32(UART0_TXDATA)&0x80000000) == 0)
      break;
  }
  put32(UART0_TXDATA, c);
}

void notmain(void)
{
  unsigned int ra;

  //11644342/115200 = 101
  ra = get32(GPIO_IOF_SEL);
  ra &= ~(1<<16); //UART0_RX
  ra &= ~(1<<17); //UART0_TX
  put32(GPIO_IOF_SEL, ra);

  ra = GET32(GPIO_IOF_EN);
  ra |= (1<<16); //UART0_RX
  ra |= (1<<17); //UART0_TX

  put32(UART0_DIV, 101-1);
  put32(UART0_TXCTRL, 0x00000003); //txen=1, nstop=1

  uart_put('h');
  uart_put('e');
  uart_put('l');
  uart_put('l');
  uart_put('o');
  uart_put(' ');
  uart_put('w');
  uart_put('o');
  uart_put('r');
  uart_put('l');
  uart_put('d');
  uart_put('\n');

}
