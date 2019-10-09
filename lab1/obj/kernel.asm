
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 18             	sub    $0x18,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	ba 20 fd 10 00       	mov    $0x10fd20,%edx
  10000b:	b8 16 ea 10 00       	mov    $0x10ea16,%eax
  100010:	29 c2                	sub    %eax,%edx
  100012:	89 d0                	mov    %edx,%eax
  100014:	83 ec 04             	sub    $0x4,%esp
  100017:	50                   	push   %eax
  100018:	6a 00                	push   $0x0
  10001a:	68 16 ea 10 00       	push   $0x10ea16
  10001f:	e8 9f 2d 00 00       	call   102dc3 <memset>
  100024:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
  100027:	e8 30 15 00 00       	call   10155c <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10002c:	c7 45 f4 60 35 10 00 	movl   $0x103560,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100033:	83 ec 08             	sub    $0x8,%esp
  100036:	ff 75 f4             	pushl  -0xc(%ebp)
  100039:	68 7c 35 10 00       	push   $0x10357c
  10003e:	e8 0a 02 00 00       	call   10024d <cprintf>
  100043:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
  100046:	e8 8c 08 00 00       	call   1008d7 <print_kerninfo>

    grade_backtrace();
  10004b:	e8 79 00 00 00       	call   1000c9 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100050:	e8 32 2a 00 00       	call   102a87 <pmm_init>

    pic_init();                 // init interrupt controller
  100055:	e8 45 16 00 00       	call   10169f <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005a:	e8 c7 17 00 00       	call   101826 <idt_init>

    clock_init();               // init clock interrupt
  10005f:	e8 d9 0c 00 00       	call   100d3d <clock_init>
    intr_enable();              // enable irq interrupt
  100064:	e8 73 17 00 00       	call   1017dc <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  100069:	e8 50 01 00 00       	call   1001be <lab1_switch_test>

    /* do nothing */
    while (1);
  10006e:	eb fe                	jmp    10006e <kern_init+0x6e>

00100070 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100070:	55                   	push   %ebp
  100071:	89 e5                	mov    %esp,%ebp
  100073:	83 ec 08             	sub    $0x8,%esp
    mon_backtrace(0, NULL, NULL);
  100076:	83 ec 04             	sub    $0x4,%esp
  100079:	6a 00                	push   $0x0
  10007b:	6a 00                	push   $0x0
  10007d:	6a 00                	push   $0x0
  10007f:	e8 a7 0c 00 00       	call   100d2b <mon_backtrace>
  100084:	83 c4 10             	add    $0x10,%esp
}
  100087:	90                   	nop
  100088:	c9                   	leave  
  100089:	c3                   	ret    

0010008a <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  10008a:	55                   	push   %ebp
  10008b:	89 e5                	mov    %esp,%ebp
  10008d:	53                   	push   %ebx
  10008e:	83 ec 04             	sub    $0x4,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  100091:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  100094:	8b 55 0c             	mov    0xc(%ebp),%edx
  100097:	8d 5d 08             	lea    0x8(%ebp),%ebx
  10009a:	8b 45 08             	mov    0x8(%ebp),%eax
  10009d:	51                   	push   %ecx
  10009e:	52                   	push   %edx
  10009f:	53                   	push   %ebx
  1000a0:	50                   	push   %eax
  1000a1:	e8 ca ff ff ff       	call   100070 <grade_backtrace2>
  1000a6:	83 c4 10             	add    $0x10,%esp
}
  1000a9:	90                   	nop
  1000aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000ad:	c9                   	leave  
  1000ae:	c3                   	ret    

001000af <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000af:	55                   	push   %ebp
  1000b0:	89 e5                	mov    %esp,%ebp
  1000b2:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace1(arg0, arg2);
  1000b5:	83 ec 08             	sub    $0x8,%esp
  1000b8:	ff 75 10             	pushl  0x10(%ebp)
  1000bb:	ff 75 08             	pushl  0x8(%ebp)
  1000be:	e8 c7 ff ff ff       	call   10008a <grade_backtrace1>
  1000c3:	83 c4 10             	add    $0x10,%esp
}
  1000c6:	90                   	nop
  1000c7:	c9                   	leave  
  1000c8:	c3                   	ret    

001000c9 <grade_backtrace>:

void
grade_backtrace(void) {
  1000c9:	55                   	push   %ebp
  1000ca:	89 e5                	mov    %esp,%ebp
  1000cc:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000cf:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000d4:	83 ec 04             	sub    $0x4,%esp
  1000d7:	68 00 00 ff ff       	push   $0xffff0000
  1000dc:	50                   	push   %eax
  1000dd:	6a 00                	push   $0x0
  1000df:	e8 cb ff ff ff       	call   1000af <grade_backtrace0>
  1000e4:	83 c4 10             	add    $0x10,%esp
}
  1000e7:	90                   	nop
  1000e8:	c9                   	leave  
  1000e9:	c3                   	ret    

001000ea <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  1000ea:	55                   	push   %ebp
  1000eb:	89 e5                	mov    %esp,%ebp
  1000ed:	83 ec 18             	sub    $0x18,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  1000f0:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  1000f3:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  1000f6:	8c 45 f2             	mov    %es,-0xe(%ebp)
  1000f9:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  1000fc:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100100:	0f b7 c0             	movzwl %ax,%eax
  100103:	83 e0 03             	and    $0x3,%eax
  100106:	89 c2                	mov    %eax,%edx
  100108:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  10010d:	83 ec 04             	sub    $0x4,%esp
  100110:	52                   	push   %edx
  100111:	50                   	push   %eax
  100112:	68 81 35 10 00       	push   $0x103581
  100117:	e8 31 01 00 00       	call   10024d <cprintf>
  10011c:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
  10011f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100123:	0f b7 d0             	movzwl %ax,%edx
  100126:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  10012b:	83 ec 04             	sub    $0x4,%esp
  10012e:	52                   	push   %edx
  10012f:	50                   	push   %eax
  100130:	68 8f 35 10 00       	push   $0x10358f
  100135:	e8 13 01 00 00       	call   10024d <cprintf>
  10013a:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
  10013d:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100141:	0f b7 d0             	movzwl %ax,%edx
  100144:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100149:	83 ec 04             	sub    $0x4,%esp
  10014c:	52                   	push   %edx
  10014d:	50                   	push   %eax
  10014e:	68 9d 35 10 00       	push   $0x10359d
  100153:	e8 f5 00 00 00       	call   10024d <cprintf>
  100158:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
  10015b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10015f:	0f b7 d0             	movzwl %ax,%edx
  100162:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100167:	83 ec 04             	sub    $0x4,%esp
  10016a:	52                   	push   %edx
  10016b:	50                   	push   %eax
  10016c:	68 ab 35 10 00       	push   $0x1035ab
  100171:	e8 d7 00 00 00       	call   10024d <cprintf>
  100176:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
  100179:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10017d:	0f b7 d0             	movzwl %ax,%edx
  100180:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100185:	83 ec 04             	sub    $0x4,%esp
  100188:	52                   	push   %edx
  100189:	50                   	push   %eax
  10018a:	68 b9 35 10 00       	push   $0x1035b9
  10018f:	e8 b9 00 00 00       	call   10024d <cprintf>
  100194:	83 c4 10             	add    $0x10,%esp
    round ++;
  100197:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  10019c:	83 c0 01             	add    $0x1,%eax
  10019f:	a3 20 ea 10 00       	mov    %eax,0x10ea20
}
  1001a4:	90                   	nop
  1001a5:	c9                   	leave  
  1001a6:	c3                   	ret    

001001a7 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001a7:	55                   	push   %ebp
  1001a8:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
	asm volatile(
  1001aa:	83 ec 08             	sub    $0x8,%esp
  1001ad:	cd 78                	int    $0x78
  1001af:	89 ec                	mov    %ebp,%esp
		"int %0 \n"//调用 T_SWITCH_TOU 中断
		"movl %%ebp,%%esp"//恢复栈指针
		:
		: "i"(T_SWITCH_TOU)
	);
}
  1001b1:	90                   	nop
  1001b2:	5d                   	pop    %ebp
  1001b3:	c3                   	ret    

001001b4 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001b4:	55                   	push   %ebp
  1001b5:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
	//把tf->tf_cs和tf->tf_ds都设置为内核代码段和内核数据段
	asm volatile(
  1001b7:	cd 79                	int    $0x79
  1001b9:	89 ec                	mov    %ebp,%esp
		"int %0 \n"// //调用T_SWITCH_TOK号中断
		"movl %%ebp, %%esp \n"//强行改为内核态，会让cpu认为没有发生特权级转换，%esp的值就不对了
		:
		: "i"(T_SWITCH_TOK)
	);
}
  1001bb:	90                   	nop
  1001bc:	5d                   	pop    %ebp
  1001bd:	c3                   	ret    

001001be <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001be:	55                   	push   %ebp
  1001bf:	89 e5                	mov    %esp,%ebp
  1001c1:	83 ec 08             	sub    $0x8,%esp
    lab1_print_cur_status();
  1001c4:	e8 21 ff ff ff       	call   1000ea <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001c9:	83 ec 0c             	sub    $0xc,%esp
  1001cc:	68 c8 35 10 00       	push   $0x1035c8
  1001d1:	e8 77 00 00 00       	call   10024d <cprintf>
  1001d6:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
  1001d9:	e8 c9 ff ff ff       	call   1001a7 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001de:	e8 07 ff ff ff       	call   1000ea <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001e3:	83 ec 0c             	sub    $0xc,%esp
  1001e6:	68 e8 35 10 00       	push   $0x1035e8
  1001eb:	e8 5d 00 00 00       	call   10024d <cprintf>
  1001f0:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
  1001f3:	e8 bc ff ff ff       	call   1001b4 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  1001f8:	e8 ed fe ff ff       	call   1000ea <lab1_print_cur_status>
}
  1001fd:	90                   	nop
  1001fe:	c9                   	leave  
  1001ff:	c3                   	ret    

00100200 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  100200:	55                   	push   %ebp
  100201:	89 e5                	mov    %esp,%ebp
  100203:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  100206:	83 ec 0c             	sub    $0xc,%esp
  100209:	ff 75 08             	pushl  0x8(%ebp)
  10020c:	e8 7c 13 00 00       	call   10158d <cons_putc>
  100211:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
  100214:	8b 45 0c             	mov    0xc(%ebp),%eax
  100217:	8b 00                	mov    (%eax),%eax
  100219:	8d 50 01             	lea    0x1(%eax),%edx
  10021c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10021f:	89 10                	mov    %edx,(%eax)
}
  100221:	90                   	nop
  100222:	c9                   	leave  
  100223:	c3                   	ret    

00100224 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100224:	55                   	push   %ebp
  100225:	89 e5                	mov    %esp,%ebp
  100227:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  10022a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100231:	ff 75 0c             	pushl  0xc(%ebp)
  100234:	ff 75 08             	pushl  0x8(%ebp)
  100237:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10023a:	50                   	push   %eax
  10023b:	68 00 02 10 00       	push   $0x100200
  100240:	e8 b4 2e 00 00       	call   1030f9 <vprintfmt>
  100245:	83 c4 10             	add    $0x10,%esp
    return cnt;
  100248:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10024b:	c9                   	leave  
  10024c:	c3                   	ret    

0010024d <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10024d:	55                   	push   %ebp
  10024e:	89 e5                	mov    %esp,%ebp
  100250:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100253:	8d 45 0c             	lea    0xc(%ebp),%eax
  100256:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100259:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10025c:	83 ec 08             	sub    $0x8,%esp
  10025f:	50                   	push   %eax
  100260:	ff 75 08             	pushl  0x8(%ebp)
  100263:	e8 bc ff ff ff       	call   100224 <vcprintf>
  100268:	83 c4 10             	add    $0x10,%esp
  10026b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10026e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100271:	c9                   	leave  
  100272:	c3                   	ret    

00100273 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100273:	55                   	push   %ebp
  100274:	89 e5                	mov    %esp,%ebp
  100276:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
  100279:	83 ec 0c             	sub    $0xc,%esp
  10027c:	ff 75 08             	pushl  0x8(%ebp)
  10027f:	e8 09 13 00 00       	call   10158d <cons_putc>
  100284:	83 c4 10             	add    $0x10,%esp
}
  100287:	90                   	nop
  100288:	c9                   	leave  
  100289:	c3                   	ret    

0010028a <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  10028a:	55                   	push   %ebp
  10028b:	89 e5                	mov    %esp,%ebp
  10028d:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
  100290:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100297:	eb 14                	jmp    1002ad <cputs+0x23>
        cputch(c, &cnt);
  100299:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  10029d:	83 ec 08             	sub    $0x8,%esp
  1002a0:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002a3:	52                   	push   %edx
  1002a4:	50                   	push   %eax
  1002a5:	e8 56 ff ff ff       	call   100200 <cputch>
  1002aa:	83 c4 10             	add    $0x10,%esp
    while ((c = *str ++) != '\0') {
  1002ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1002b0:	8d 50 01             	lea    0x1(%eax),%edx
  1002b3:	89 55 08             	mov    %edx,0x8(%ebp)
  1002b6:	0f b6 00             	movzbl (%eax),%eax
  1002b9:	88 45 f7             	mov    %al,-0x9(%ebp)
  1002bc:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1002c0:	75 d7                	jne    100299 <cputs+0xf>
    }
    cputch('\n', &cnt);
  1002c2:	83 ec 08             	sub    $0x8,%esp
  1002c5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1002c8:	50                   	push   %eax
  1002c9:	6a 0a                	push   $0xa
  1002cb:	e8 30 ff ff ff       	call   100200 <cputch>
  1002d0:	83 c4 10             	add    $0x10,%esp
    return cnt;
  1002d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1002d6:	c9                   	leave  
  1002d7:	c3                   	ret    

001002d8 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1002d8:	55                   	push   %ebp
  1002d9:	89 e5                	mov    %esp,%ebp
  1002db:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1002de:	e8 da 12 00 00       	call   1015bd <cons_getc>
  1002e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1002e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002ea:	74 f2                	je     1002de <getchar+0x6>
        /* do nothing */;
    return c;
  1002ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002ef:	c9                   	leave  
  1002f0:	c3                   	ret    

001002f1 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  1002f1:	55                   	push   %ebp
  1002f2:	89 e5                	mov    %esp,%ebp
  1002f4:	83 ec 18             	sub    $0x18,%esp
    if (prompt != NULL) {
  1002f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1002fb:	74 13                	je     100310 <readline+0x1f>
        cprintf("%s", prompt);
  1002fd:	83 ec 08             	sub    $0x8,%esp
  100300:	ff 75 08             	pushl  0x8(%ebp)
  100303:	68 07 36 10 00       	push   $0x103607
  100308:	e8 40 ff ff ff       	call   10024d <cprintf>
  10030d:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
  100310:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100317:	e8 bc ff ff ff       	call   1002d8 <getchar>
  10031c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10031f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100323:	79 0a                	jns    10032f <readline+0x3e>
            return NULL;
  100325:	b8 00 00 00 00       	mov    $0x0,%eax
  10032a:	e9 82 00 00 00       	jmp    1003b1 <readline+0xc0>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10032f:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100333:	7e 2b                	jle    100360 <readline+0x6f>
  100335:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10033c:	7f 22                	jg     100360 <readline+0x6f>
            cputchar(c);
  10033e:	83 ec 0c             	sub    $0xc,%esp
  100341:	ff 75 f0             	pushl  -0x10(%ebp)
  100344:	e8 2a ff ff ff       	call   100273 <cputchar>
  100349:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
  10034c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10034f:	8d 50 01             	lea    0x1(%eax),%edx
  100352:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100355:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100358:	88 90 40 ea 10 00    	mov    %dl,0x10ea40(%eax)
  10035e:	eb 4c                	jmp    1003ac <readline+0xbb>
        }
        else if (c == '\b' && i > 0) {
  100360:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  100364:	75 1a                	jne    100380 <readline+0x8f>
  100366:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10036a:	7e 14                	jle    100380 <readline+0x8f>
            cputchar(c);
  10036c:	83 ec 0c             	sub    $0xc,%esp
  10036f:	ff 75 f0             	pushl  -0x10(%ebp)
  100372:	e8 fc fe ff ff       	call   100273 <cputchar>
  100377:	83 c4 10             	add    $0x10,%esp
            i --;
  10037a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10037e:	eb 2c                	jmp    1003ac <readline+0xbb>
        }
        else if (c == '\n' || c == '\r') {
  100380:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100384:	74 06                	je     10038c <readline+0x9b>
  100386:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  10038a:	75 8b                	jne    100317 <readline+0x26>
            cputchar(c);
  10038c:	83 ec 0c             	sub    $0xc,%esp
  10038f:	ff 75 f0             	pushl  -0x10(%ebp)
  100392:	e8 dc fe ff ff       	call   100273 <cputchar>
  100397:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
  10039a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10039d:	05 40 ea 10 00       	add    $0x10ea40,%eax
  1003a2:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003a5:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  1003aa:	eb 05                	jmp    1003b1 <readline+0xc0>
        c = getchar();
  1003ac:	e9 66 ff ff ff       	jmp    100317 <readline+0x26>
        }
    }
}
  1003b1:	c9                   	leave  
  1003b2:	c3                   	ret    

001003b3 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003b3:	55                   	push   %ebp
  1003b4:	89 e5                	mov    %esp,%ebp
  1003b6:	83 ec 18             	sub    $0x18,%esp
    if (is_panic) {
  1003b9:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  1003be:	85 c0                	test   %eax,%eax
  1003c0:	75 4a                	jne    10040c <__panic+0x59>
        goto panic_dead;
    }
    is_panic = 1;
  1003c2:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  1003c9:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  1003cc:	8d 45 14             	lea    0x14(%ebp),%eax
  1003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  1003d2:	83 ec 04             	sub    $0x4,%esp
  1003d5:	ff 75 0c             	pushl  0xc(%ebp)
  1003d8:	ff 75 08             	pushl  0x8(%ebp)
  1003db:	68 0a 36 10 00       	push   $0x10360a
  1003e0:	e8 68 fe ff ff       	call   10024d <cprintf>
  1003e5:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  1003e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003eb:	83 ec 08             	sub    $0x8,%esp
  1003ee:	50                   	push   %eax
  1003ef:	ff 75 10             	pushl  0x10(%ebp)
  1003f2:	e8 2d fe ff ff       	call   100224 <vcprintf>
  1003f7:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  1003fa:	83 ec 0c             	sub    $0xc,%esp
  1003fd:	68 26 36 10 00       	push   $0x103626
  100402:	e8 46 fe ff ff       	call   10024d <cprintf>
  100407:	83 c4 10             	add    $0x10,%esp
  10040a:	eb 01                	jmp    10040d <__panic+0x5a>
        goto panic_dead;
  10040c:	90                   	nop
    va_end(ap);

panic_dead:
    intr_disable();
  10040d:	e8 d1 13 00 00       	call   1017e3 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100412:	83 ec 0c             	sub    $0xc,%esp
  100415:	6a 00                	push   $0x0
  100417:	e8 35 08 00 00       	call   100c51 <kmonitor>
  10041c:	83 c4 10             	add    $0x10,%esp
  10041f:	eb f1                	jmp    100412 <__panic+0x5f>

00100421 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100421:	55                   	push   %ebp
  100422:	89 e5                	mov    %esp,%ebp
  100424:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
  100427:	8d 45 14             	lea    0x14(%ebp),%eax
  10042a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  10042d:	83 ec 04             	sub    $0x4,%esp
  100430:	ff 75 0c             	pushl  0xc(%ebp)
  100433:	ff 75 08             	pushl  0x8(%ebp)
  100436:	68 28 36 10 00       	push   $0x103628
  10043b:	e8 0d fe ff ff       	call   10024d <cprintf>
  100440:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
  100443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100446:	83 ec 08             	sub    $0x8,%esp
  100449:	50                   	push   %eax
  10044a:	ff 75 10             	pushl  0x10(%ebp)
  10044d:	e8 d2 fd ff ff       	call   100224 <vcprintf>
  100452:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
  100455:	83 ec 0c             	sub    $0xc,%esp
  100458:	68 26 36 10 00       	push   $0x103626
  10045d:	e8 eb fd ff ff       	call   10024d <cprintf>
  100462:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  100465:	90                   	nop
  100466:	c9                   	leave  
  100467:	c3                   	ret    

00100468 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100468:	55                   	push   %ebp
  100469:	89 e5                	mov    %esp,%ebp
    return is_panic;
  10046b:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  100470:	5d                   	pop    %ebp
  100471:	c3                   	ret    

00100472 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  100472:	55                   	push   %ebp
  100473:	89 e5                	mov    %esp,%ebp
  100475:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  100478:	8b 45 0c             	mov    0xc(%ebp),%eax
  10047b:	8b 00                	mov    (%eax),%eax
  10047d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100480:	8b 45 10             	mov    0x10(%ebp),%eax
  100483:	8b 00                	mov    (%eax),%eax
  100485:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100488:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  10048f:	e9 d2 00 00 00       	jmp    100566 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  100494:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100497:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10049a:	01 d0                	add    %edx,%eax
  10049c:	89 c2                	mov    %eax,%edx
  10049e:	c1 ea 1f             	shr    $0x1f,%edx
  1004a1:	01 d0                	add    %edx,%eax
  1004a3:	d1 f8                	sar    %eax
  1004a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1004a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004ab:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004ae:	eb 04                	jmp    1004b4 <stab_binsearch+0x42>
            m --;
  1004b0:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  1004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004ba:	7c 1f                	jl     1004db <stab_binsearch+0x69>
  1004bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004bf:	89 d0                	mov    %edx,%eax
  1004c1:	01 c0                	add    %eax,%eax
  1004c3:	01 d0                	add    %edx,%eax
  1004c5:	c1 e0 02             	shl    $0x2,%eax
  1004c8:	89 c2                	mov    %eax,%edx
  1004ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1004cd:	01 d0                	add    %edx,%eax
  1004cf:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004d3:	0f b6 c0             	movzbl %al,%eax
  1004d6:	39 45 14             	cmp    %eax,0x14(%ebp)
  1004d9:	75 d5                	jne    1004b0 <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
  1004db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004de:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004e1:	7d 0b                	jge    1004ee <stab_binsearch+0x7c>
            l = true_m + 1;
  1004e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004e6:	83 c0 01             	add    $0x1,%eax
  1004e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  1004ec:	eb 78                	jmp    100566 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  1004ee:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  1004f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004f8:	89 d0                	mov    %edx,%eax
  1004fa:	01 c0                	add    %eax,%eax
  1004fc:	01 d0                	add    %edx,%eax
  1004fe:	c1 e0 02             	shl    $0x2,%eax
  100501:	89 c2                	mov    %eax,%edx
  100503:	8b 45 08             	mov    0x8(%ebp),%eax
  100506:	01 d0                	add    %edx,%eax
  100508:	8b 40 08             	mov    0x8(%eax),%eax
  10050b:	39 45 18             	cmp    %eax,0x18(%ebp)
  10050e:	76 13                	jbe    100523 <stab_binsearch+0xb1>
            *region_left = m;
  100510:	8b 45 0c             	mov    0xc(%ebp),%eax
  100513:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100516:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100518:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10051b:	83 c0 01             	add    $0x1,%eax
  10051e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100521:	eb 43                	jmp    100566 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  100523:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100526:	89 d0                	mov    %edx,%eax
  100528:	01 c0                	add    %eax,%eax
  10052a:	01 d0                	add    %edx,%eax
  10052c:	c1 e0 02             	shl    $0x2,%eax
  10052f:	89 c2                	mov    %eax,%edx
  100531:	8b 45 08             	mov    0x8(%ebp),%eax
  100534:	01 d0                	add    %edx,%eax
  100536:	8b 40 08             	mov    0x8(%eax),%eax
  100539:	39 45 18             	cmp    %eax,0x18(%ebp)
  10053c:	73 16                	jae    100554 <stab_binsearch+0xe2>
            *region_right = m - 1;
  10053e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100541:	8d 50 ff             	lea    -0x1(%eax),%edx
  100544:	8b 45 10             	mov    0x10(%ebp),%eax
  100547:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  100549:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10054c:	83 e8 01             	sub    $0x1,%eax
  10054f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100552:	eb 12                	jmp    100566 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  100554:	8b 45 0c             	mov    0xc(%ebp),%eax
  100557:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10055a:	89 10                	mov    %edx,(%eax)
            l = m;
  10055c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10055f:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  100562:	83 45 18 01          	addl   $0x1,0x18(%ebp)
    while (l <= r) {
  100566:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100569:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  10056c:	0f 8e 22 ff ff ff    	jle    100494 <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
  100572:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100576:	75 0f                	jne    100587 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  100578:	8b 45 0c             	mov    0xc(%ebp),%eax
  10057b:	8b 00                	mov    (%eax),%eax
  10057d:	8d 50 ff             	lea    -0x1(%eax),%edx
  100580:	8b 45 10             	mov    0x10(%ebp),%eax
  100583:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  100585:	eb 3f                	jmp    1005c6 <stab_binsearch+0x154>
        l = *region_right;
  100587:	8b 45 10             	mov    0x10(%ebp),%eax
  10058a:	8b 00                	mov    (%eax),%eax
  10058c:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  10058f:	eb 04                	jmp    100595 <stab_binsearch+0x123>
  100591:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  100595:	8b 45 0c             	mov    0xc(%ebp),%eax
  100598:	8b 00                	mov    (%eax),%eax
  10059a:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  10059d:	7e 1f                	jle    1005be <stab_binsearch+0x14c>
  10059f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005a2:	89 d0                	mov    %edx,%eax
  1005a4:	01 c0                	add    %eax,%eax
  1005a6:	01 d0                	add    %edx,%eax
  1005a8:	c1 e0 02             	shl    $0x2,%eax
  1005ab:	89 c2                	mov    %eax,%edx
  1005ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1005b0:	01 d0                	add    %edx,%eax
  1005b2:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1005b6:	0f b6 c0             	movzbl %al,%eax
  1005b9:	39 45 14             	cmp    %eax,0x14(%ebp)
  1005bc:	75 d3                	jne    100591 <stab_binsearch+0x11f>
        *region_left = l;
  1005be:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005c4:	89 10                	mov    %edx,(%eax)
}
  1005c6:	90                   	nop
  1005c7:	c9                   	leave  
  1005c8:	c3                   	ret    

001005c9 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  1005c9:	55                   	push   %ebp
  1005ca:	89 e5                	mov    %esp,%ebp
  1005cc:	83 ec 38             	sub    $0x38,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  1005cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005d2:	c7 00 48 36 10 00    	movl   $0x103648,(%eax)
    info->eip_line = 0;
  1005d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  1005e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005e5:	c7 40 08 48 36 10 00 	movl   $0x103648,0x8(%eax)
    info->eip_fn_namelen = 9;
  1005ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005ef:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  1005f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005f9:	8b 55 08             	mov    0x8(%ebp),%edx
  1005fc:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  1005ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  100602:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100609:	c7 45 f4 8c 3e 10 00 	movl   $0x103e8c,-0xc(%ebp)
    stab_end = __STAB_END__;
  100610:	c7 45 f0 20 bc 10 00 	movl   $0x10bc20,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100617:	c7 45 ec 21 bc 10 00 	movl   $0x10bc21,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10061e:	c7 45 e8 08 dd 10 00 	movl   $0x10dd08,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100625:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100628:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10062b:	76 0d                	jbe    10063a <debuginfo_eip+0x71>
  10062d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100630:	83 e8 01             	sub    $0x1,%eax
  100633:	0f b6 00             	movzbl (%eax),%eax
  100636:	84 c0                	test   %al,%al
  100638:	74 0a                	je     100644 <debuginfo_eip+0x7b>
        return -1;
  10063a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10063f:	e9 91 02 00 00       	jmp    1008d5 <debuginfo_eip+0x30c>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100644:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  10064b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10064e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100651:	29 c2                	sub    %eax,%edx
  100653:	89 d0                	mov    %edx,%eax
  100655:	c1 f8 02             	sar    $0x2,%eax
  100658:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  10065e:	83 e8 01             	sub    $0x1,%eax
  100661:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  100664:	ff 75 08             	pushl  0x8(%ebp)
  100667:	6a 64                	push   $0x64
  100669:	8d 45 e0             	lea    -0x20(%ebp),%eax
  10066c:	50                   	push   %eax
  10066d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  100670:	50                   	push   %eax
  100671:	ff 75 f4             	pushl  -0xc(%ebp)
  100674:	e8 f9 fd ff ff       	call   100472 <stab_binsearch>
  100679:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
  10067c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10067f:	85 c0                	test   %eax,%eax
  100681:	75 0a                	jne    10068d <debuginfo_eip+0xc4>
        return -1;
  100683:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100688:	e9 48 02 00 00       	jmp    1008d5 <debuginfo_eip+0x30c>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  10068d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100690:	89 45 dc             	mov    %eax,-0x24(%ebp)
  100693:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100696:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100699:	ff 75 08             	pushl  0x8(%ebp)
  10069c:	6a 24                	push   $0x24
  10069e:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1006a1:	50                   	push   %eax
  1006a2:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1006a5:	50                   	push   %eax
  1006a6:	ff 75 f4             	pushl  -0xc(%ebp)
  1006a9:	e8 c4 fd ff ff       	call   100472 <stab_binsearch>
  1006ae:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
  1006b1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1006b4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006b7:	39 c2                	cmp    %eax,%edx
  1006b9:	7f 7c                	jg     100737 <debuginfo_eip+0x16e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  1006bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006be:	89 c2                	mov    %eax,%edx
  1006c0:	89 d0                	mov    %edx,%eax
  1006c2:	01 c0                	add    %eax,%eax
  1006c4:	01 d0                	add    %edx,%eax
  1006c6:	c1 e0 02             	shl    $0x2,%eax
  1006c9:	89 c2                	mov    %eax,%edx
  1006cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006ce:	01 d0                	add    %edx,%eax
  1006d0:	8b 00                	mov    (%eax),%eax
  1006d2:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1006d5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1006d8:	29 d1                	sub    %edx,%ecx
  1006da:	89 ca                	mov    %ecx,%edx
  1006dc:	39 d0                	cmp    %edx,%eax
  1006de:	73 22                	jae    100702 <debuginfo_eip+0x139>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  1006e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006e3:	89 c2                	mov    %eax,%edx
  1006e5:	89 d0                	mov    %edx,%eax
  1006e7:	01 c0                	add    %eax,%eax
  1006e9:	01 d0                	add    %edx,%eax
  1006eb:	c1 e0 02             	shl    $0x2,%eax
  1006ee:	89 c2                	mov    %eax,%edx
  1006f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006f3:	01 d0                	add    %edx,%eax
  1006f5:	8b 10                	mov    (%eax),%edx
  1006f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1006fa:	01 c2                	add    %eax,%edx
  1006fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006ff:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100702:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100705:	89 c2                	mov    %eax,%edx
  100707:	89 d0                	mov    %edx,%eax
  100709:	01 c0                	add    %eax,%eax
  10070b:	01 d0                	add    %edx,%eax
  10070d:	c1 e0 02             	shl    $0x2,%eax
  100710:	89 c2                	mov    %eax,%edx
  100712:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100715:	01 d0                	add    %edx,%eax
  100717:	8b 50 08             	mov    0x8(%eax),%edx
  10071a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10071d:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100720:	8b 45 0c             	mov    0xc(%ebp),%eax
  100723:	8b 40 10             	mov    0x10(%eax),%eax
  100726:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100729:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10072c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  10072f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100732:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100735:	eb 15                	jmp    10074c <debuginfo_eip+0x183>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100737:	8b 45 0c             	mov    0xc(%ebp),%eax
  10073a:	8b 55 08             	mov    0x8(%ebp),%edx
  10073d:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  100740:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100743:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  100746:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100749:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  10074c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10074f:	8b 40 08             	mov    0x8(%eax),%eax
  100752:	83 ec 08             	sub    $0x8,%esp
  100755:	6a 3a                	push   $0x3a
  100757:	50                   	push   %eax
  100758:	e8 da 24 00 00       	call   102c37 <strfind>
  10075d:	83 c4 10             	add    $0x10,%esp
  100760:	89 c2                	mov    %eax,%edx
  100762:	8b 45 0c             	mov    0xc(%ebp),%eax
  100765:	8b 40 08             	mov    0x8(%eax),%eax
  100768:	29 c2                	sub    %eax,%edx
  10076a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10076d:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  100770:	83 ec 0c             	sub    $0xc,%esp
  100773:	ff 75 08             	pushl  0x8(%ebp)
  100776:	6a 44                	push   $0x44
  100778:	8d 45 d0             	lea    -0x30(%ebp),%eax
  10077b:	50                   	push   %eax
  10077c:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  10077f:	50                   	push   %eax
  100780:	ff 75 f4             	pushl  -0xc(%ebp)
  100783:	e8 ea fc ff ff       	call   100472 <stab_binsearch>
  100788:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
  10078b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10078e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100791:	39 c2                	cmp    %eax,%edx
  100793:	7f 24                	jg     1007b9 <debuginfo_eip+0x1f0>
        info->eip_line = stabs[rline].n_desc;
  100795:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100798:	89 c2                	mov    %eax,%edx
  10079a:	89 d0                	mov    %edx,%eax
  10079c:	01 c0                	add    %eax,%eax
  10079e:	01 d0                	add    %edx,%eax
  1007a0:	c1 e0 02             	shl    $0x2,%eax
  1007a3:	89 c2                	mov    %eax,%edx
  1007a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007a8:	01 d0                	add    %edx,%eax
  1007aa:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  1007ae:	0f b7 d0             	movzwl %ax,%edx
  1007b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007b4:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007b7:	eb 13                	jmp    1007cc <debuginfo_eip+0x203>
        return -1;
  1007b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1007be:	e9 12 01 00 00       	jmp    1008d5 <debuginfo_eip+0x30c>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  1007c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007c6:	83 e8 01             	sub    $0x1,%eax
  1007c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  1007cc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007d2:	39 c2                	cmp    %eax,%edx
  1007d4:	7c 56                	jl     10082c <debuginfo_eip+0x263>
           && stabs[lline].n_type != N_SOL
  1007d6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007d9:	89 c2                	mov    %eax,%edx
  1007db:	89 d0                	mov    %edx,%eax
  1007dd:	01 c0                	add    %eax,%eax
  1007df:	01 d0                	add    %edx,%eax
  1007e1:	c1 e0 02             	shl    $0x2,%eax
  1007e4:	89 c2                	mov    %eax,%edx
  1007e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007e9:	01 d0                	add    %edx,%eax
  1007eb:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007ef:	3c 84                	cmp    $0x84,%al
  1007f1:	74 39                	je     10082c <debuginfo_eip+0x263>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  1007f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007f6:	89 c2                	mov    %eax,%edx
  1007f8:	89 d0                	mov    %edx,%eax
  1007fa:	01 c0                	add    %eax,%eax
  1007fc:	01 d0                	add    %edx,%eax
  1007fe:	c1 e0 02             	shl    $0x2,%eax
  100801:	89 c2                	mov    %eax,%edx
  100803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100806:	01 d0                	add    %edx,%eax
  100808:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10080c:	3c 64                	cmp    $0x64,%al
  10080e:	75 b3                	jne    1007c3 <debuginfo_eip+0x1fa>
  100810:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100813:	89 c2                	mov    %eax,%edx
  100815:	89 d0                	mov    %edx,%eax
  100817:	01 c0                	add    %eax,%eax
  100819:	01 d0                	add    %edx,%eax
  10081b:	c1 e0 02             	shl    $0x2,%eax
  10081e:	89 c2                	mov    %eax,%edx
  100820:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100823:	01 d0                	add    %edx,%eax
  100825:	8b 40 08             	mov    0x8(%eax),%eax
  100828:	85 c0                	test   %eax,%eax
  10082a:	74 97                	je     1007c3 <debuginfo_eip+0x1fa>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  10082c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10082f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100832:	39 c2                	cmp    %eax,%edx
  100834:	7c 46                	jl     10087c <debuginfo_eip+0x2b3>
  100836:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100839:	89 c2                	mov    %eax,%edx
  10083b:	89 d0                	mov    %edx,%eax
  10083d:	01 c0                	add    %eax,%eax
  10083f:	01 d0                	add    %edx,%eax
  100841:	c1 e0 02             	shl    $0x2,%eax
  100844:	89 c2                	mov    %eax,%edx
  100846:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100849:	01 d0                	add    %edx,%eax
  10084b:	8b 00                	mov    (%eax),%eax
  10084d:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100850:	8b 55 ec             	mov    -0x14(%ebp),%edx
  100853:	29 d1                	sub    %edx,%ecx
  100855:	89 ca                	mov    %ecx,%edx
  100857:	39 d0                	cmp    %edx,%eax
  100859:	73 21                	jae    10087c <debuginfo_eip+0x2b3>
        info->eip_file = stabstr + stabs[lline].n_strx;
  10085b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10085e:	89 c2                	mov    %eax,%edx
  100860:	89 d0                	mov    %edx,%eax
  100862:	01 c0                	add    %eax,%eax
  100864:	01 d0                	add    %edx,%eax
  100866:	c1 e0 02             	shl    $0x2,%eax
  100869:	89 c2                	mov    %eax,%edx
  10086b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10086e:	01 d0                	add    %edx,%eax
  100870:	8b 10                	mov    (%eax),%edx
  100872:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100875:	01 c2                	add    %eax,%edx
  100877:	8b 45 0c             	mov    0xc(%ebp),%eax
  10087a:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  10087c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10087f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100882:	39 c2                	cmp    %eax,%edx
  100884:	7d 4a                	jge    1008d0 <debuginfo_eip+0x307>
        for (lline = lfun + 1;
  100886:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100889:	83 c0 01             	add    $0x1,%eax
  10088c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  10088f:	eb 18                	jmp    1008a9 <debuginfo_eip+0x2e0>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100891:	8b 45 0c             	mov    0xc(%ebp),%eax
  100894:	8b 40 14             	mov    0x14(%eax),%eax
  100897:	8d 50 01             	lea    0x1(%eax),%edx
  10089a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10089d:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  1008a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008a3:	83 c0 01             	add    $0x1,%eax
  1008a6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008a9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008ac:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  1008af:	39 c2                	cmp    %eax,%edx
  1008b1:	7d 1d                	jge    1008d0 <debuginfo_eip+0x307>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008b6:	89 c2                	mov    %eax,%edx
  1008b8:	89 d0                	mov    %edx,%eax
  1008ba:	01 c0                	add    %eax,%eax
  1008bc:	01 d0                	add    %edx,%eax
  1008be:	c1 e0 02             	shl    $0x2,%eax
  1008c1:	89 c2                	mov    %eax,%edx
  1008c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008c6:	01 d0                	add    %edx,%eax
  1008c8:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1008cc:	3c a0                	cmp    $0xa0,%al
  1008ce:	74 c1                	je     100891 <debuginfo_eip+0x2c8>
        }
    }
    return 0;
  1008d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1008d5:	c9                   	leave  
  1008d6:	c3                   	ret    

001008d7 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  1008d7:	55                   	push   %ebp
  1008d8:	89 e5                	mov    %esp,%ebp
  1008da:	83 ec 08             	sub    $0x8,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  1008dd:	83 ec 0c             	sub    $0xc,%esp
  1008e0:	68 52 36 10 00       	push   $0x103652
  1008e5:	e8 63 f9 ff ff       	call   10024d <cprintf>
  1008ea:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  1008ed:	83 ec 08             	sub    $0x8,%esp
  1008f0:	68 00 00 10 00       	push   $0x100000
  1008f5:	68 6b 36 10 00       	push   $0x10366b
  1008fa:	e8 4e f9 ff ff       	call   10024d <cprintf>
  1008ff:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
  100902:	83 ec 08             	sub    $0x8,%esp
  100905:	68 5a 35 10 00       	push   $0x10355a
  10090a:	68 83 36 10 00       	push   $0x103683
  10090f:	e8 39 f9 ff ff       	call   10024d <cprintf>
  100914:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
  100917:	83 ec 08             	sub    $0x8,%esp
  10091a:	68 16 ea 10 00       	push   $0x10ea16
  10091f:	68 9b 36 10 00       	push   $0x10369b
  100924:	e8 24 f9 ff ff       	call   10024d <cprintf>
  100929:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
  10092c:	83 ec 08             	sub    $0x8,%esp
  10092f:	68 20 fd 10 00       	push   $0x10fd20
  100934:	68 b3 36 10 00       	push   $0x1036b3
  100939:	e8 0f f9 ff ff       	call   10024d <cprintf>
  10093e:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  100941:	b8 20 fd 10 00       	mov    $0x10fd20,%eax
  100946:	05 ff 03 00 00       	add    $0x3ff,%eax
  10094b:	ba 00 00 10 00       	mov    $0x100000,%edx
  100950:	29 d0                	sub    %edx,%eax
  100952:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  100958:	85 c0                	test   %eax,%eax
  10095a:	0f 48 c2             	cmovs  %edx,%eax
  10095d:	c1 f8 0a             	sar    $0xa,%eax
  100960:	83 ec 08             	sub    $0x8,%esp
  100963:	50                   	push   %eax
  100964:	68 cc 36 10 00       	push   $0x1036cc
  100969:	e8 df f8 ff ff       	call   10024d <cprintf>
  10096e:	83 c4 10             	add    $0x10,%esp
}
  100971:	90                   	nop
  100972:	c9                   	leave  
  100973:	c3                   	ret    

00100974 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100974:	55                   	push   %ebp
  100975:	89 e5                	mov    %esp,%ebp
  100977:	81 ec 28 01 00 00    	sub    $0x128,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  10097d:	83 ec 08             	sub    $0x8,%esp
  100980:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100983:	50                   	push   %eax
  100984:	ff 75 08             	pushl  0x8(%ebp)
  100987:	e8 3d fc ff ff       	call   1005c9 <debuginfo_eip>
  10098c:	83 c4 10             	add    $0x10,%esp
  10098f:	85 c0                	test   %eax,%eax
  100991:	74 15                	je     1009a8 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100993:	83 ec 08             	sub    $0x8,%esp
  100996:	ff 75 08             	pushl  0x8(%ebp)
  100999:	68 f6 36 10 00       	push   $0x1036f6
  10099e:	e8 aa f8 ff ff       	call   10024d <cprintf>
  1009a3:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  1009a6:	eb 65                	jmp    100a0d <print_debuginfo+0x99>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1009af:	eb 1c                	jmp    1009cd <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  1009b1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1009b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009b7:	01 d0                	add    %edx,%eax
  1009b9:	0f b6 00             	movzbl (%eax),%eax
  1009bc:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1009c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1009c5:	01 ca                	add    %ecx,%edx
  1009c7:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009c9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1009cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009d0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  1009d3:	7c dc                	jl     1009b1 <print_debuginfo+0x3d>
        fnname[j] = '\0';
  1009d5:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  1009db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009de:	01 d0                	add    %edx,%eax
  1009e0:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  1009e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  1009e6:	8b 55 08             	mov    0x8(%ebp),%edx
  1009e9:	89 d1                	mov    %edx,%ecx
  1009eb:	29 c1                	sub    %eax,%ecx
  1009ed:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1009f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1009f3:	83 ec 0c             	sub    $0xc,%esp
  1009f6:	51                   	push   %ecx
  1009f7:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1009fd:	51                   	push   %ecx
  1009fe:	52                   	push   %edx
  1009ff:	50                   	push   %eax
  100a00:	68 12 37 10 00       	push   $0x103712
  100a05:	e8 43 f8 ff ff       	call   10024d <cprintf>
  100a0a:	83 c4 20             	add    $0x20,%esp
}
  100a0d:	90                   	nop
  100a0e:	c9                   	leave  
  100a0f:	c3                   	ret    

00100a10 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a10:	55                   	push   %ebp
  100a11:	89 e5                	mov    %esp,%ebp
  100a13:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a16:	8b 45 04             	mov    0x4(%ebp),%eax
  100a19:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a1f:	c9                   	leave  
  100a20:	c3                   	ret    

00100a21 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a21:	55                   	push   %ebp
  100a22:	89 e5                	mov    %esp,%ebp
  100a24:	83 ec 28             	sub    $0x28,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100a27:	89 e8                	mov    %ebp,%eax
  100a29:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  100a2c:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t v_ebp=read_ebp();
  100a2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t v_eip=read_eip();
  100a32:	e8 d9 ff ff ff       	call   100a10 <read_eip>
  100a37:	89 45 f0             	mov    %eax,-0x10(%ebp)
	for(int i=0;i<STACKFRAME_DEPTH&&v_ebp!=0;++i)
  100a3a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100a41:	e9 90 00 00 00       	jmp    100ad6 <print_stackframe+0xb5>
	{
		cprintf("ebp: 0x%08x , eip: 0x%08x , ",v_ebp,v_eip);
  100a46:	83 ec 04             	sub    $0x4,%esp
  100a49:	ff 75 f0             	pushl  -0x10(%ebp)
  100a4c:	ff 75 f4             	pushl  -0xc(%ebp)
  100a4f:	68 24 37 10 00       	push   $0x103724
  100a54:	e8 f4 f7 ff ff       	call   10024d <cprintf>
  100a59:	83 c4 10             	add    $0x10,%esp
		uint32_t *args=(uint32_t *)v_ebp +2;
  100a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a5f:	83 c0 08             	add    $0x8,%eax
  100a62:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for(int j=0;j<4;++j)
  100a65:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a6c:	eb 29                	jmp    100a97 <print_stackframe+0x76>
		{
			cprintf("args[%d] = 0x%08x   ",j,args[j]);
  100a6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a71:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100a7b:	01 d0                	add    %edx,%eax
  100a7d:	8b 00                	mov    (%eax),%eax
  100a7f:	83 ec 04             	sub    $0x4,%esp
  100a82:	50                   	push   %eax
  100a83:	ff 75 e8             	pushl  -0x18(%ebp)
  100a86:	68 41 37 10 00       	push   $0x103741
  100a8b:	e8 bd f7 ff ff       	call   10024d <cprintf>
  100a90:	83 c4 10             	add    $0x10,%esp
		for(int j=0;j<4;++j)
  100a93:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100a97:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a9b:	7e d1                	jle    100a6e <print_stackframe+0x4d>
		}
		cprintf("\n");
  100a9d:	83 ec 0c             	sub    $0xc,%esp
  100aa0:	68 56 37 10 00       	push   $0x103756
  100aa5:	e8 a3 f7 ff ff       	call   10024d <cprintf>
  100aaa:	83 c4 10             	add    $0x10,%esp
		print_debuginfo(v_eip-1);
  100aad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100ab0:	83 e8 01             	sub    $0x1,%eax
  100ab3:	83 ec 0c             	sub    $0xc,%esp
  100ab6:	50                   	push   %eax
  100ab7:	e8 b8 fe ff ff       	call   100974 <print_debuginfo>
  100abc:	83 c4 10             	add    $0x10,%esp
		v_eip=((uint32_t *)v_ebp)[1];
  100abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ac2:	83 c0 04             	add    $0x4,%eax
  100ac5:	8b 00                	mov    (%eax),%eax
  100ac7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		v_ebp=((uint32_t *)v_ebp)[0];
  100aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100acd:	8b 00                	mov    (%eax),%eax
  100acf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for(int i=0;i<STACKFRAME_DEPTH&&v_ebp!=0;++i)
  100ad2:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100ad6:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100ada:	7f 0a                	jg     100ae6 <print_stackframe+0xc5>
  100adc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100ae0:	0f 85 60 ff ff ff    	jne    100a46 <print_stackframe+0x25>
	}


}
  100ae6:	90                   	nop
  100ae7:	c9                   	leave  
  100ae8:	c3                   	ret    

00100ae9 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100ae9:	55                   	push   %ebp
  100aea:	89 e5                	mov    %esp,%ebp
  100aec:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
  100aef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100af6:	eb 0c                	jmp    100b04 <parse+0x1b>
            *buf ++ = '\0';
  100af8:	8b 45 08             	mov    0x8(%ebp),%eax
  100afb:	8d 50 01             	lea    0x1(%eax),%edx
  100afe:	89 55 08             	mov    %edx,0x8(%ebp)
  100b01:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b04:	8b 45 08             	mov    0x8(%ebp),%eax
  100b07:	0f b6 00             	movzbl (%eax),%eax
  100b0a:	84 c0                	test   %al,%al
  100b0c:	74 1e                	je     100b2c <parse+0x43>
  100b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  100b11:	0f b6 00             	movzbl (%eax),%eax
  100b14:	0f be c0             	movsbl %al,%eax
  100b17:	83 ec 08             	sub    $0x8,%esp
  100b1a:	50                   	push   %eax
  100b1b:	68 d8 37 10 00       	push   $0x1037d8
  100b20:	e8 df 20 00 00       	call   102c04 <strchr>
  100b25:	83 c4 10             	add    $0x10,%esp
  100b28:	85 c0                	test   %eax,%eax
  100b2a:	75 cc                	jne    100af8 <parse+0xf>
        }
        if (*buf == '\0') {
  100b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  100b2f:	0f b6 00             	movzbl (%eax),%eax
  100b32:	84 c0                	test   %al,%al
  100b34:	74 65                	je     100b9b <parse+0xb2>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100b36:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100b3a:	75 12                	jne    100b4e <parse+0x65>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100b3c:	83 ec 08             	sub    $0x8,%esp
  100b3f:	6a 10                	push   $0x10
  100b41:	68 dd 37 10 00       	push   $0x1037dd
  100b46:	e8 02 f7 ff ff       	call   10024d <cprintf>
  100b4b:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
  100b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b51:	8d 50 01             	lea    0x1(%eax),%edx
  100b54:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100b57:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b61:	01 c2                	add    %eax,%edx
  100b63:	8b 45 08             	mov    0x8(%ebp),%eax
  100b66:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b68:	eb 04                	jmp    100b6e <parse+0x85>
            buf ++;
  100b6a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  100b71:	0f b6 00             	movzbl (%eax),%eax
  100b74:	84 c0                	test   %al,%al
  100b76:	74 8c                	je     100b04 <parse+0x1b>
  100b78:	8b 45 08             	mov    0x8(%ebp),%eax
  100b7b:	0f b6 00             	movzbl (%eax),%eax
  100b7e:	0f be c0             	movsbl %al,%eax
  100b81:	83 ec 08             	sub    $0x8,%esp
  100b84:	50                   	push   %eax
  100b85:	68 d8 37 10 00       	push   $0x1037d8
  100b8a:	e8 75 20 00 00       	call   102c04 <strchr>
  100b8f:	83 c4 10             	add    $0x10,%esp
  100b92:	85 c0                	test   %eax,%eax
  100b94:	74 d4                	je     100b6a <parse+0x81>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b96:	e9 69 ff ff ff       	jmp    100b04 <parse+0x1b>
            break;
  100b9b:	90                   	nop
        }
    }
    return argc;
  100b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b9f:	c9                   	leave  
  100ba0:	c3                   	ret    

00100ba1 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100ba1:	55                   	push   %ebp
  100ba2:	89 e5                	mov    %esp,%ebp
  100ba4:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100ba7:	83 ec 08             	sub    $0x8,%esp
  100baa:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100bad:	50                   	push   %eax
  100bae:	ff 75 08             	pushl  0x8(%ebp)
  100bb1:	e8 33 ff ff ff       	call   100ae9 <parse>
  100bb6:	83 c4 10             	add    $0x10,%esp
  100bb9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100bbc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100bc0:	75 0a                	jne    100bcc <runcmd+0x2b>
        return 0;
  100bc2:	b8 00 00 00 00       	mov    $0x0,%eax
  100bc7:	e9 83 00 00 00       	jmp    100c4f <runcmd+0xae>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bcc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100bd3:	eb 59                	jmp    100c2e <runcmd+0x8d>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100bd5:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100bd8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100bdb:	89 d0                	mov    %edx,%eax
  100bdd:	01 c0                	add    %eax,%eax
  100bdf:	01 d0                	add    %edx,%eax
  100be1:	c1 e0 02             	shl    $0x2,%eax
  100be4:	05 00 e0 10 00       	add    $0x10e000,%eax
  100be9:	8b 00                	mov    (%eax),%eax
  100beb:	83 ec 08             	sub    $0x8,%esp
  100bee:	51                   	push   %ecx
  100bef:	50                   	push   %eax
  100bf0:	e8 6f 1f 00 00       	call   102b64 <strcmp>
  100bf5:	83 c4 10             	add    $0x10,%esp
  100bf8:	85 c0                	test   %eax,%eax
  100bfa:	75 2e                	jne    100c2a <runcmd+0x89>
            return commands[i].func(argc - 1, argv + 1, tf);
  100bfc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100bff:	89 d0                	mov    %edx,%eax
  100c01:	01 c0                	add    %eax,%eax
  100c03:	01 d0                	add    %edx,%eax
  100c05:	c1 e0 02             	shl    $0x2,%eax
  100c08:	05 08 e0 10 00       	add    $0x10e008,%eax
  100c0d:	8b 10                	mov    (%eax),%edx
  100c0f:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c12:	83 c0 04             	add    $0x4,%eax
  100c15:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100c18:	83 e9 01             	sub    $0x1,%ecx
  100c1b:	83 ec 04             	sub    $0x4,%esp
  100c1e:	ff 75 0c             	pushl  0xc(%ebp)
  100c21:	50                   	push   %eax
  100c22:	51                   	push   %ecx
  100c23:	ff d2                	call   *%edx
  100c25:	83 c4 10             	add    $0x10,%esp
  100c28:	eb 25                	jmp    100c4f <runcmd+0xae>
    for (i = 0; i < NCOMMANDS; i ++) {
  100c2a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c31:	83 f8 02             	cmp    $0x2,%eax
  100c34:	76 9f                	jbe    100bd5 <runcmd+0x34>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100c36:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100c39:	83 ec 08             	sub    $0x8,%esp
  100c3c:	50                   	push   %eax
  100c3d:	68 fb 37 10 00       	push   $0x1037fb
  100c42:	e8 06 f6 ff ff       	call   10024d <cprintf>
  100c47:	83 c4 10             	add    $0x10,%esp
    return 0;
  100c4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c4f:	c9                   	leave  
  100c50:	c3                   	ret    

00100c51 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100c51:	55                   	push   %ebp
  100c52:	89 e5                	mov    %esp,%ebp
  100c54:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100c57:	83 ec 0c             	sub    $0xc,%esp
  100c5a:	68 14 38 10 00       	push   $0x103814
  100c5f:	e8 e9 f5 ff ff       	call   10024d <cprintf>
  100c64:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
  100c67:	83 ec 0c             	sub    $0xc,%esp
  100c6a:	68 3c 38 10 00       	push   $0x10383c
  100c6f:	e8 d9 f5 ff ff       	call   10024d <cprintf>
  100c74:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
  100c77:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c7b:	74 0e                	je     100c8b <kmonitor+0x3a>
        print_trapframe(tf);
  100c7d:	83 ec 0c             	sub    $0xc,%esp
  100c80:	ff 75 08             	pushl  0x8(%ebp)
  100c83:	e8 d8 0d 00 00       	call   101a60 <print_trapframe>
  100c88:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c8b:	83 ec 0c             	sub    $0xc,%esp
  100c8e:	68 61 38 10 00       	push   $0x103861
  100c93:	e8 59 f6 ff ff       	call   1002f1 <readline>
  100c98:	83 c4 10             	add    $0x10,%esp
  100c9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100ca2:	74 e7                	je     100c8b <kmonitor+0x3a>
            if (runcmd(buf, tf) < 0) {
  100ca4:	83 ec 08             	sub    $0x8,%esp
  100ca7:	ff 75 08             	pushl  0x8(%ebp)
  100caa:	ff 75 f4             	pushl  -0xc(%ebp)
  100cad:	e8 ef fe ff ff       	call   100ba1 <runcmd>
  100cb2:	83 c4 10             	add    $0x10,%esp
  100cb5:	85 c0                	test   %eax,%eax
  100cb7:	78 02                	js     100cbb <kmonitor+0x6a>
        if ((buf = readline("K> ")) != NULL) {
  100cb9:	eb d0                	jmp    100c8b <kmonitor+0x3a>
                break;
  100cbb:	90                   	nop
            }
        }
    }
}
  100cbc:	90                   	nop
  100cbd:	c9                   	leave  
  100cbe:	c3                   	ret    

00100cbf <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100cbf:	55                   	push   %ebp
  100cc0:	89 e5                	mov    %esp,%ebp
  100cc2:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100cc5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100ccc:	eb 3c                	jmp    100d0a <mon_help+0x4b>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100cce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100cd1:	89 d0                	mov    %edx,%eax
  100cd3:	01 c0                	add    %eax,%eax
  100cd5:	01 d0                	add    %edx,%eax
  100cd7:	c1 e0 02             	shl    $0x2,%eax
  100cda:	05 04 e0 10 00       	add    $0x10e004,%eax
  100cdf:	8b 08                	mov    (%eax),%ecx
  100ce1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100ce4:	89 d0                	mov    %edx,%eax
  100ce6:	01 c0                	add    %eax,%eax
  100ce8:	01 d0                	add    %edx,%eax
  100cea:	c1 e0 02             	shl    $0x2,%eax
  100ced:	05 00 e0 10 00       	add    $0x10e000,%eax
  100cf2:	8b 00                	mov    (%eax),%eax
  100cf4:	83 ec 04             	sub    $0x4,%esp
  100cf7:	51                   	push   %ecx
  100cf8:	50                   	push   %eax
  100cf9:	68 65 38 10 00       	push   $0x103865
  100cfe:	e8 4a f5 ff ff       	call   10024d <cprintf>
  100d03:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < NCOMMANDS; i ++) {
  100d06:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d0d:	83 f8 02             	cmp    $0x2,%eax
  100d10:	76 bc                	jbe    100cce <mon_help+0xf>
    }
    return 0;
  100d12:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d17:	c9                   	leave  
  100d18:	c3                   	ret    

00100d19 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d19:	55                   	push   %ebp
  100d1a:	89 e5                	mov    %esp,%ebp
  100d1c:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100d1f:	e8 b3 fb ff ff       	call   1008d7 <print_kerninfo>
    return 0;
  100d24:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d29:	c9                   	leave  
  100d2a:	c3                   	ret    

00100d2b <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100d2b:	55                   	push   %ebp
  100d2c:	89 e5                	mov    %esp,%ebp
  100d2e:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100d31:	e8 eb fc ff ff       	call   100a21 <print_stackframe>
    return 0;
  100d36:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d3b:	c9                   	leave  
  100d3c:	c3                   	ret    

00100d3d <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d3d:	55                   	push   %ebp
  100d3e:	89 e5                	mov    %esp,%ebp
  100d40:	83 ec 18             	sub    $0x18,%esp
  100d43:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100d49:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d4d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100d51:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100d55:	ee                   	out    %al,(%dx)
  100d56:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d5c:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d60:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d64:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d68:	ee                   	out    %al,(%dx)
  100d69:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100d6f:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
  100d73:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d77:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d7b:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100d7c:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  100d83:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100d86:	83 ec 0c             	sub    $0xc,%esp
  100d89:	68 6e 38 10 00       	push   $0x10386e
  100d8e:	e8 ba f4 ff ff       	call   10024d <cprintf>
  100d93:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
  100d96:	83 ec 0c             	sub    $0xc,%esp
  100d99:	6a 00                	push   $0x0
  100d9b:	e8 d2 08 00 00       	call   101672 <pic_enable>
  100da0:	83 c4 10             	add    $0x10,%esp
}
  100da3:	90                   	nop
  100da4:	c9                   	leave  
  100da5:	c3                   	ret    

00100da6 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100da6:	55                   	push   %ebp
  100da7:	89 e5                	mov    %esp,%ebp
  100da9:	83 ec 10             	sub    $0x10,%esp
  100dac:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100db2:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100db6:	89 c2                	mov    %eax,%edx
  100db8:	ec                   	in     (%dx),%al
  100db9:	88 45 f1             	mov    %al,-0xf(%ebp)
  100dbc:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100dc2:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100dc6:	89 c2                	mov    %eax,%edx
  100dc8:	ec                   	in     (%dx),%al
  100dc9:	88 45 f5             	mov    %al,-0xb(%ebp)
  100dcc:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100dd2:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100dd6:	89 c2                	mov    %eax,%edx
  100dd8:	ec                   	in     (%dx),%al
  100dd9:	88 45 f9             	mov    %al,-0x7(%ebp)
  100ddc:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100de2:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100de6:	89 c2                	mov    %eax,%edx
  100de8:	ec                   	in     (%dx),%al
  100de9:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100dec:	90                   	nop
  100ded:	c9                   	leave  
  100dee:	c3                   	ret    

00100def <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100def:	55                   	push   %ebp
  100df0:	89 e5                	mov    %esp,%ebp
  100df2:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100df5:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100dfc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100dff:	0f b7 00             	movzwl (%eax),%eax
  100e02:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100e06:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e09:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100e0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e11:	0f b7 00             	movzwl (%eax),%eax
  100e14:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e18:	74 12                	je     100e2c <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100e1a:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100e21:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100e28:	b4 03 
  100e2a:	eb 13                	jmp    100e3f <cga_init+0x50>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100e2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e2f:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e33:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100e36:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100e3d:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100e3f:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e46:	0f b7 c0             	movzwl %ax,%eax
  100e49:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100e4d:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e51:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100e55:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100e59:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100e5a:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e61:	83 c0 01             	add    $0x1,%eax
  100e64:	0f b7 c0             	movzwl %ax,%eax
  100e67:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e6b:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100e6f:	89 c2                	mov    %eax,%edx
  100e71:	ec                   	in     (%dx),%al
  100e72:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100e75:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100e79:	0f b6 c0             	movzbl %al,%eax
  100e7c:	c1 e0 08             	shl    $0x8,%eax
  100e7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100e82:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e89:	0f b7 c0             	movzwl %ax,%eax
  100e8c:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100e90:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e94:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100e98:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100e9c:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100e9d:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100ea4:	83 c0 01             	add    $0x1,%eax
  100ea7:	0f b7 c0             	movzwl %ax,%eax
  100eaa:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100eae:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100eb2:	89 c2                	mov    %eax,%edx
  100eb4:	ec                   	in     (%dx),%al
  100eb5:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100eb8:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100ebc:	0f b6 c0             	movzbl %al,%eax
  100ebf:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100ec2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ec5:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ecd:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100ed3:	90                   	nop
  100ed4:	c9                   	leave  
  100ed5:	c3                   	ret    

00100ed6 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100ed6:	55                   	push   %ebp
  100ed7:	89 e5                	mov    %esp,%ebp
  100ed9:	83 ec 38             	sub    $0x38,%esp
  100edc:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100ee2:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ee6:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100eea:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100eee:	ee                   	out    %al,(%dx)
  100eef:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100ef5:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
  100ef9:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100efd:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100f01:	ee                   	out    %al,(%dx)
  100f02:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100f08:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
  100f0c:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100f10:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100f14:	ee                   	out    %al,(%dx)
  100f15:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f1b:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
  100f1f:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f23:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f27:	ee                   	out    %al,(%dx)
  100f28:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100f2e:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
  100f32:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f36:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f3a:	ee                   	out    %al,(%dx)
  100f3b:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  100f41:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
  100f45:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f49:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f4d:	ee                   	out    %al,(%dx)
  100f4e:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f54:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
  100f58:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f5c:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f60:	ee                   	out    %al,(%dx)
  100f61:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f67:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100f6b:	89 c2                	mov    %eax,%edx
  100f6d:	ec                   	in     (%dx),%al
  100f6e:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100f71:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f75:	3c ff                	cmp    $0xff,%al
  100f77:	0f 95 c0             	setne  %al
  100f7a:	0f b6 c0             	movzbl %al,%eax
  100f7d:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100f82:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f88:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100f8c:	89 c2                	mov    %eax,%edx
  100f8e:	ec                   	in     (%dx),%al
  100f8f:	88 45 f1             	mov    %al,-0xf(%ebp)
  100f92:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  100f98:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100f9c:	89 c2                	mov    %eax,%edx
  100f9e:	ec                   	in     (%dx),%al
  100f9f:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100fa2:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100fa7:	85 c0                	test   %eax,%eax
  100fa9:	74 0d                	je     100fb8 <serial_init+0xe2>
        pic_enable(IRQ_COM1);
  100fab:	83 ec 0c             	sub    $0xc,%esp
  100fae:	6a 04                	push   $0x4
  100fb0:	e8 bd 06 00 00       	call   101672 <pic_enable>
  100fb5:	83 c4 10             	add    $0x10,%esp
    }
}
  100fb8:	90                   	nop
  100fb9:	c9                   	leave  
  100fba:	c3                   	ret    

00100fbb <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100fbb:	55                   	push   %ebp
  100fbc:	89 e5                	mov    %esp,%ebp
  100fbe:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fc1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100fc8:	eb 09                	jmp    100fd3 <lpt_putc_sub+0x18>
        delay();
  100fca:	e8 d7 fd ff ff       	call   100da6 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fcf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100fd3:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  100fd9:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100fdd:	89 c2                	mov    %eax,%edx
  100fdf:	ec                   	in     (%dx),%al
  100fe0:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  100fe3:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  100fe7:	84 c0                	test   %al,%al
  100fe9:	78 09                	js     100ff4 <lpt_putc_sub+0x39>
  100feb:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  100ff2:	7e d6                	jle    100fca <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
  100ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  100ff7:	0f b6 c0             	movzbl %al,%eax
  100ffa:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  101000:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101003:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101007:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10100b:	ee                   	out    %al,(%dx)
  10100c:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101012:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101016:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10101a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10101e:	ee                   	out    %al,(%dx)
  10101f:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  101025:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
  101029:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10102d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101031:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101032:	90                   	nop
  101033:	c9                   	leave  
  101034:	c3                   	ret    

00101035 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101035:	55                   	push   %ebp
  101036:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  101038:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10103c:	74 0d                	je     10104b <lpt_putc+0x16>
        lpt_putc_sub(c);
  10103e:	ff 75 08             	pushl  0x8(%ebp)
  101041:	e8 75 ff ff ff       	call   100fbb <lpt_putc_sub>
  101046:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  101049:	eb 1e                	jmp    101069 <lpt_putc+0x34>
        lpt_putc_sub('\b');
  10104b:	6a 08                	push   $0x8
  10104d:	e8 69 ff ff ff       	call   100fbb <lpt_putc_sub>
  101052:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
  101055:	6a 20                	push   $0x20
  101057:	e8 5f ff ff ff       	call   100fbb <lpt_putc_sub>
  10105c:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
  10105f:	6a 08                	push   $0x8
  101061:	e8 55 ff ff ff       	call   100fbb <lpt_putc_sub>
  101066:	83 c4 04             	add    $0x4,%esp
}
  101069:	90                   	nop
  10106a:	c9                   	leave  
  10106b:	c3                   	ret    

0010106c <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  10106c:	55                   	push   %ebp
  10106d:	89 e5                	mov    %esp,%ebp
  10106f:	53                   	push   %ebx
  101070:	83 ec 24             	sub    $0x24,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101073:	8b 45 08             	mov    0x8(%ebp),%eax
  101076:	b0 00                	mov    $0x0,%al
  101078:	85 c0                	test   %eax,%eax
  10107a:	75 07                	jne    101083 <cga_putc+0x17>
        c |= 0x0700;
  10107c:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101083:	8b 45 08             	mov    0x8(%ebp),%eax
  101086:	0f b6 c0             	movzbl %al,%eax
  101089:	83 f8 0a             	cmp    $0xa,%eax
  10108c:	74 52                	je     1010e0 <cga_putc+0x74>
  10108e:	83 f8 0d             	cmp    $0xd,%eax
  101091:	74 5d                	je     1010f0 <cga_putc+0x84>
  101093:	83 f8 08             	cmp    $0x8,%eax
  101096:	0f 85 8e 00 00 00    	jne    10112a <cga_putc+0xbe>
    case '\b':
        if (crt_pos > 0) {
  10109c:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010a3:	66 85 c0             	test   %ax,%ax
  1010a6:	0f 84 a4 00 00 00    	je     101150 <cga_putc+0xe4>
            crt_pos --;
  1010ac:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010b3:	83 e8 01             	sub    $0x1,%eax
  1010b6:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1010bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1010bf:	b0 00                	mov    $0x0,%al
  1010c1:	83 c8 20             	or     $0x20,%eax
  1010c4:	89 c1                	mov    %eax,%ecx
  1010c6:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1010cb:	0f b7 15 64 ee 10 00 	movzwl 0x10ee64,%edx
  1010d2:	0f b7 d2             	movzwl %dx,%edx
  1010d5:	01 d2                	add    %edx,%edx
  1010d7:	01 d0                	add    %edx,%eax
  1010d9:	89 ca                	mov    %ecx,%edx
  1010db:	66 89 10             	mov    %dx,(%eax)
        }
        break;
  1010de:	eb 70                	jmp    101150 <cga_putc+0xe4>
    case '\n':
        crt_pos += CRT_COLS;
  1010e0:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010e7:	83 c0 50             	add    $0x50,%eax
  1010ea:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1010f0:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  1010f7:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  1010fe:	0f b7 c1             	movzwl %cx,%eax
  101101:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101107:	c1 e8 10             	shr    $0x10,%eax
  10110a:	89 c2                	mov    %eax,%edx
  10110c:	66 c1 ea 06          	shr    $0x6,%dx
  101110:	89 d0                	mov    %edx,%eax
  101112:	c1 e0 02             	shl    $0x2,%eax
  101115:	01 d0                	add    %edx,%eax
  101117:	c1 e0 04             	shl    $0x4,%eax
  10111a:	29 c1                	sub    %eax,%ecx
  10111c:	89 ca                	mov    %ecx,%edx
  10111e:	89 d8                	mov    %ebx,%eax
  101120:	29 d0                	sub    %edx,%eax
  101122:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  101128:	eb 27                	jmp    101151 <cga_putc+0xe5>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  10112a:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  101130:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101137:	8d 50 01             	lea    0x1(%eax),%edx
  10113a:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  101141:	0f b7 c0             	movzwl %ax,%eax
  101144:	01 c0                	add    %eax,%eax
  101146:	01 c8                	add    %ecx,%eax
  101148:	8b 55 08             	mov    0x8(%ebp),%edx
  10114b:	66 89 10             	mov    %dx,(%eax)
        break;
  10114e:	eb 01                	jmp    101151 <cga_putc+0xe5>
        break;
  101150:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101151:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101158:	66 3d cf 07          	cmp    $0x7cf,%ax
  10115c:	76 59                	jbe    1011b7 <cga_putc+0x14b>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  10115e:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101163:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101169:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  10116e:	83 ec 04             	sub    $0x4,%esp
  101171:	68 00 0f 00 00       	push   $0xf00
  101176:	52                   	push   %edx
  101177:	50                   	push   %eax
  101178:	e8 86 1c 00 00       	call   102e03 <memmove>
  10117d:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101180:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101187:	eb 15                	jmp    10119e <cga_putc+0x132>
            crt_buf[i] = 0x0700 | ' ';
  101189:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  10118e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101191:	01 d2                	add    %edx,%edx
  101193:	01 d0                	add    %edx,%eax
  101195:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10119a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10119e:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011a5:	7e e2                	jle    101189 <cga_putc+0x11d>
        }
        crt_pos -= CRT_COLS;
  1011a7:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011ae:	83 e8 50             	sub    $0x50,%eax
  1011b1:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011b7:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1011be:	0f b7 c0             	movzwl %ax,%eax
  1011c1:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  1011c5:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
  1011c9:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1011cd:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1011d1:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  1011d2:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011d9:	66 c1 e8 08          	shr    $0x8,%ax
  1011dd:	0f b6 c0             	movzbl %al,%eax
  1011e0:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  1011e7:	83 c2 01             	add    $0x1,%edx
  1011ea:	0f b7 d2             	movzwl %dx,%edx
  1011ed:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  1011f1:	88 45 e9             	mov    %al,-0x17(%ebp)
  1011f4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1011f8:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1011fc:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  1011fd:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  101204:	0f b7 c0             	movzwl %ax,%eax
  101207:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  10120b:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
  10120f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101213:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101217:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101218:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10121f:	0f b6 c0             	movzbl %al,%eax
  101222:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  101229:	83 c2 01             	add    $0x1,%edx
  10122c:	0f b7 d2             	movzwl %dx,%edx
  10122f:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  101233:	88 45 f1             	mov    %al,-0xf(%ebp)
  101236:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10123a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10123e:	ee                   	out    %al,(%dx)
}
  10123f:	90                   	nop
  101240:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101243:	c9                   	leave  
  101244:	c3                   	ret    

00101245 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101245:	55                   	push   %ebp
  101246:	89 e5                	mov    %esp,%ebp
  101248:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10124b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101252:	eb 09                	jmp    10125d <serial_putc_sub+0x18>
        delay();
  101254:	e8 4d fb ff ff       	call   100da6 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101259:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10125d:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101263:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101267:	89 c2                	mov    %eax,%edx
  101269:	ec                   	in     (%dx),%al
  10126a:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10126d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101271:	0f b6 c0             	movzbl %al,%eax
  101274:	83 e0 20             	and    $0x20,%eax
  101277:	85 c0                	test   %eax,%eax
  101279:	75 09                	jne    101284 <serial_putc_sub+0x3f>
  10127b:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101282:	7e d0                	jle    101254 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
  101284:	8b 45 08             	mov    0x8(%ebp),%eax
  101287:	0f b6 c0             	movzbl %al,%eax
  10128a:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101290:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101293:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101297:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10129b:	ee                   	out    %al,(%dx)
}
  10129c:	90                   	nop
  10129d:	c9                   	leave  
  10129e:	c3                   	ret    

0010129f <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  10129f:	55                   	push   %ebp
  1012a0:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
  1012a2:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012a6:	74 0d                	je     1012b5 <serial_putc+0x16>
        serial_putc_sub(c);
  1012a8:	ff 75 08             	pushl  0x8(%ebp)
  1012ab:	e8 95 ff ff ff       	call   101245 <serial_putc_sub>
  1012b0:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  1012b3:	eb 1e                	jmp    1012d3 <serial_putc+0x34>
        serial_putc_sub('\b');
  1012b5:	6a 08                	push   $0x8
  1012b7:	e8 89 ff ff ff       	call   101245 <serial_putc_sub>
  1012bc:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
  1012bf:	6a 20                	push   $0x20
  1012c1:	e8 7f ff ff ff       	call   101245 <serial_putc_sub>
  1012c6:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
  1012c9:	6a 08                	push   $0x8
  1012cb:	e8 75 ff ff ff       	call   101245 <serial_putc_sub>
  1012d0:	83 c4 04             	add    $0x4,%esp
}
  1012d3:	90                   	nop
  1012d4:	c9                   	leave  
  1012d5:	c3                   	ret    

001012d6 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1012d6:	55                   	push   %ebp
  1012d7:	89 e5                	mov    %esp,%ebp
  1012d9:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1012dc:	eb 33                	jmp    101311 <cons_intr+0x3b>
        if (c != 0) {
  1012de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1012e2:	74 2d                	je     101311 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  1012e4:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1012e9:	8d 50 01             	lea    0x1(%eax),%edx
  1012ec:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  1012f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1012f5:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  1012fb:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101300:	3d 00 02 00 00       	cmp    $0x200,%eax
  101305:	75 0a                	jne    101311 <cons_intr+0x3b>
                cons.wpos = 0;
  101307:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  10130e:	00 00 00 
    while ((c = (*proc)()) != -1) {
  101311:	8b 45 08             	mov    0x8(%ebp),%eax
  101314:	ff d0                	call   *%eax
  101316:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101319:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10131d:	75 bf                	jne    1012de <cons_intr+0x8>
            }
        }
    }
}
  10131f:	90                   	nop
  101320:	c9                   	leave  
  101321:	c3                   	ret    

00101322 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101322:	55                   	push   %ebp
  101323:	89 e5                	mov    %esp,%ebp
  101325:	83 ec 10             	sub    $0x10,%esp
  101328:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10132e:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101332:	89 c2                	mov    %eax,%edx
  101334:	ec                   	in     (%dx),%al
  101335:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101338:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  10133c:	0f b6 c0             	movzbl %al,%eax
  10133f:	83 e0 01             	and    $0x1,%eax
  101342:	85 c0                	test   %eax,%eax
  101344:	75 07                	jne    10134d <serial_proc_data+0x2b>
        return -1;
  101346:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10134b:	eb 2a                	jmp    101377 <serial_proc_data+0x55>
  10134d:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101353:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101357:	89 c2                	mov    %eax,%edx
  101359:	ec                   	in     (%dx),%al
  10135a:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  10135d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  101361:	0f b6 c0             	movzbl %al,%eax
  101364:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101367:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  10136b:	75 07                	jne    101374 <serial_proc_data+0x52>
        c = '\b';
  10136d:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101374:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101377:	c9                   	leave  
  101378:	c3                   	ret    

00101379 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101379:	55                   	push   %ebp
  10137a:	89 e5                	mov    %esp,%ebp
  10137c:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
  10137f:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101384:	85 c0                	test   %eax,%eax
  101386:	74 10                	je     101398 <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  101388:	83 ec 0c             	sub    $0xc,%esp
  10138b:	68 22 13 10 00       	push   $0x101322
  101390:	e8 41 ff ff ff       	call   1012d6 <cons_intr>
  101395:	83 c4 10             	add    $0x10,%esp
    }
}
  101398:	90                   	nop
  101399:	c9                   	leave  
  10139a:	c3                   	ret    

0010139b <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  10139b:	55                   	push   %ebp
  10139c:	89 e5                	mov    %esp,%ebp
  10139e:	83 ec 28             	sub    $0x28,%esp
  1013a1:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013a7:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1013ab:	89 c2                	mov    %eax,%edx
  1013ad:	ec                   	in     (%dx),%al
  1013ae:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1013b1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013b5:	0f b6 c0             	movzbl %al,%eax
  1013b8:	83 e0 01             	and    $0x1,%eax
  1013bb:	85 c0                	test   %eax,%eax
  1013bd:	75 0a                	jne    1013c9 <kbd_proc_data+0x2e>
        return -1;
  1013bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013c4:	e9 5d 01 00 00       	jmp    101526 <kbd_proc_data+0x18b>
  1013c9:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013cf:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1013d3:	89 c2                	mov    %eax,%edx
  1013d5:	ec                   	in     (%dx),%al
  1013d6:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1013d9:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1013dd:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1013e0:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1013e4:	75 17                	jne    1013fd <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  1013e6:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1013eb:	83 c8 40             	or     $0x40,%eax
  1013ee:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  1013f3:	b8 00 00 00 00       	mov    $0x0,%eax
  1013f8:	e9 29 01 00 00       	jmp    101526 <kbd_proc_data+0x18b>
    } else if (data & 0x80) {
  1013fd:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101401:	84 c0                	test   %al,%al
  101403:	79 47                	jns    10144c <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101405:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10140a:	83 e0 40             	and    $0x40,%eax
  10140d:	85 c0                	test   %eax,%eax
  10140f:	75 09                	jne    10141a <kbd_proc_data+0x7f>
  101411:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101415:	83 e0 7f             	and    $0x7f,%eax
  101418:	eb 04                	jmp    10141e <kbd_proc_data+0x83>
  10141a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10141e:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101421:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101425:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  10142c:	83 c8 40             	or     $0x40,%eax
  10142f:	0f b6 c0             	movzbl %al,%eax
  101432:	f7 d0                	not    %eax
  101434:	89 c2                	mov    %eax,%edx
  101436:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10143b:	21 d0                	and    %edx,%eax
  10143d:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101442:	b8 00 00 00 00       	mov    $0x0,%eax
  101447:	e9 da 00 00 00       	jmp    101526 <kbd_proc_data+0x18b>
    } else if (shift & E0ESC) {
  10144c:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101451:	83 e0 40             	and    $0x40,%eax
  101454:	85 c0                	test   %eax,%eax
  101456:	74 11                	je     101469 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101458:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  10145c:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101461:	83 e0 bf             	and    $0xffffffbf,%eax
  101464:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  101469:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10146d:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101474:	0f b6 d0             	movzbl %al,%edx
  101477:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10147c:	09 d0                	or     %edx,%eax
  10147e:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  101483:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101487:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  10148e:	0f b6 d0             	movzbl %al,%edx
  101491:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101496:	31 d0                	xor    %edx,%eax
  101498:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  10149d:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014a2:	83 e0 03             	and    $0x3,%eax
  1014a5:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  1014ac:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014b0:	01 d0                	add    %edx,%eax
  1014b2:	0f b6 00             	movzbl (%eax),%eax
  1014b5:	0f b6 c0             	movzbl %al,%eax
  1014b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014bb:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014c0:	83 e0 08             	and    $0x8,%eax
  1014c3:	85 c0                	test   %eax,%eax
  1014c5:	74 22                	je     1014e9 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1014c7:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1014cb:	7e 0c                	jle    1014d9 <kbd_proc_data+0x13e>
  1014cd:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1014d1:	7f 06                	jg     1014d9 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1014d3:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1014d7:	eb 10                	jmp    1014e9 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  1014d9:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1014dd:	7e 0a                	jle    1014e9 <kbd_proc_data+0x14e>
  1014df:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1014e3:	7f 04                	jg     1014e9 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  1014e5:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1014e9:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014ee:	f7 d0                	not    %eax
  1014f0:	83 e0 06             	and    $0x6,%eax
  1014f3:	85 c0                	test   %eax,%eax
  1014f5:	75 2c                	jne    101523 <kbd_proc_data+0x188>
  1014f7:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  1014fe:	75 23                	jne    101523 <kbd_proc_data+0x188>
        cprintf("Rebooting!\n");
  101500:	83 ec 0c             	sub    $0xc,%esp
  101503:	68 89 38 10 00       	push   $0x103889
  101508:	e8 40 ed ff ff       	call   10024d <cprintf>
  10150d:	83 c4 10             	add    $0x10,%esp
  101510:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101516:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10151a:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  10151e:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101522:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101523:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101526:	c9                   	leave  
  101527:	c3                   	ret    

00101528 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101528:	55                   	push   %ebp
  101529:	89 e5                	mov    %esp,%ebp
  10152b:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
  10152e:	83 ec 0c             	sub    $0xc,%esp
  101531:	68 9b 13 10 00       	push   $0x10139b
  101536:	e8 9b fd ff ff       	call   1012d6 <cons_intr>
  10153b:	83 c4 10             	add    $0x10,%esp
}
  10153e:	90                   	nop
  10153f:	c9                   	leave  
  101540:	c3                   	ret    

00101541 <kbd_init>:

static void
kbd_init(void) {
  101541:	55                   	push   %ebp
  101542:	89 e5                	mov    %esp,%ebp
  101544:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
  101547:	e8 dc ff ff ff       	call   101528 <kbd_intr>
    pic_enable(IRQ_KBD);
  10154c:	83 ec 0c             	sub    $0xc,%esp
  10154f:	6a 01                	push   $0x1
  101551:	e8 1c 01 00 00       	call   101672 <pic_enable>
  101556:	83 c4 10             	add    $0x10,%esp
}
  101559:	90                   	nop
  10155a:	c9                   	leave  
  10155b:	c3                   	ret    

0010155c <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  10155c:	55                   	push   %ebp
  10155d:	89 e5                	mov    %esp,%ebp
  10155f:	83 ec 08             	sub    $0x8,%esp
    cga_init();
  101562:	e8 88 f8 ff ff       	call   100def <cga_init>
    serial_init();
  101567:	e8 6a f9 ff ff       	call   100ed6 <serial_init>
    kbd_init();
  10156c:	e8 d0 ff ff ff       	call   101541 <kbd_init>
    if (!serial_exists) {
  101571:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101576:	85 c0                	test   %eax,%eax
  101578:	75 10                	jne    10158a <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  10157a:	83 ec 0c             	sub    $0xc,%esp
  10157d:	68 95 38 10 00       	push   $0x103895
  101582:	e8 c6 ec ff ff       	call   10024d <cprintf>
  101587:	83 c4 10             	add    $0x10,%esp
    }
}
  10158a:	90                   	nop
  10158b:	c9                   	leave  
  10158c:	c3                   	ret    

0010158d <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  10158d:	55                   	push   %ebp
  10158e:	89 e5                	mov    %esp,%ebp
  101590:	83 ec 08             	sub    $0x8,%esp
    lpt_putc(c);
  101593:	ff 75 08             	pushl  0x8(%ebp)
  101596:	e8 9a fa ff ff       	call   101035 <lpt_putc>
  10159b:	83 c4 04             	add    $0x4,%esp
    cga_putc(c);
  10159e:	83 ec 0c             	sub    $0xc,%esp
  1015a1:	ff 75 08             	pushl  0x8(%ebp)
  1015a4:	e8 c3 fa ff ff       	call   10106c <cga_putc>
  1015a9:	83 c4 10             	add    $0x10,%esp
    serial_putc(c);
  1015ac:	83 ec 0c             	sub    $0xc,%esp
  1015af:	ff 75 08             	pushl  0x8(%ebp)
  1015b2:	e8 e8 fc ff ff       	call   10129f <serial_putc>
  1015b7:	83 c4 10             	add    $0x10,%esp
}
  1015ba:	90                   	nop
  1015bb:	c9                   	leave  
  1015bc:	c3                   	ret    

001015bd <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1015bd:	55                   	push   %ebp
  1015be:	89 e5                	mov    %esp,%ebp
  1015c0:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1015c3:	e8 b1 fd ff ff       	call   101379 <serial_intr>
    kbd_intr();
  1015c8:	e8 5b ff ff ff       	call   101528 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1015cd:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  1015d3:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1015d8:	39 c2                	cmp    %eax,%edx
  1015da:	74 36                	je     101612 <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  1015dc:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015e1:	8d 50 01             	lea    0x1(%eax),%edx
  1015e4:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  1015ea:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  1015f1:	0f b6 c0             	movzbl %al,%eax
  1015f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  1015f7:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015fc:	3d 00 02 00 00       	cmp    $0x200,%eax
  101601:	75 0a                	jne    10160d <cons_getc+0x50>
            cons.rpos = 0;
  101603:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  10160a:	00 00 00 
        }
        return c;
  10160d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101610:	eb 05                	jmp    101617 <cons_getc+0x5a>
    }
    return 0;
  101612:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101617:	c9                   	leave  
  101618:	c3                   	ret    

00101619 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101619:	55                   	push   %ebp
  10161a:	89 e5                	mov    %esp,%ebp
  10161c:	83 ec 14             	sub    $0x14,%esp
  10161f:	8b 45 08             	mov    0x8(%ebp),%eax
  101622:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101626:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10162a:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  101630:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  101635:	85 c0                	test   %eax,%eax
  101637:	74 36                	je     10166f <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  101639:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10163d:	0f b6 c0             	movzbl %al,%eax
  101640:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  101646:	88 45 f9             	mov    %al,-0x7(%ebp)
  101649:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10164d:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101651:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  101652:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101656:	66 c1 e8 08          	shr    $0x8,%ax
  10165a:	0f b6 c0             	movzbl %al,%eax
  10165d:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  101663:	88 45 fd             	mov    %al,-0x3(%ebp)
  101666:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10166a:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10166e:	ee                   	out    %al,(%dx)
    }
}
  10166f:	90                   	nop
  101670:	c9                   	leave  
  101671:	c3                   	ret    

00101672 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101672:	55                   	push   %ebp
  101673:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
  101675:	8b 45 08             	mov    0x8(%ebp),%eax
  101678:	ba 01 00 00 00       	mov    $0x1,%edx
  10167d:	89 c1                	mov    %eax,%ecx
  10167f:	d3 e2                	shl    %cl,%edx
  101681:	89 d0                	mov    %edx,%eax
  101683:	f7 d0                	not    %eax
  101685:	89 c2                	mov    %eax,%edx
  101687:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  10168e:	21 d0                	and    %edx,%eax
  101690:	0f b7 c0             	movzwl %ax,%eax
  101693:	50                   	push   %eax
  101694:	e8 80 ff ff ff       	call   101619 <pic_setmask>
  101699:	83 c4 04             	add    $0x4,%esp
}
  10169c:	90                   	nop
  10169d:	c9                   	leave  
  10169e:	c3                   	ret    

0010169f <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10169f:	55                   	push   %ebp
  1016a0:	89 e5                	mov    %esp,%ebp
  1016a2:	83 ec 40             	sub    $0x40,%esp
    did_init = 1;
  1016a5:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  1016ac:	00 00 00 
  1016af:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  1016b5:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
  1016b9:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1016bd:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1016c1:	ee                   	out    %al,(%dx)
  1016c2:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  1016c8:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
  1016cc:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1016d0:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1016d4:	ee                   	out    %al,(%dx)
  1016d5:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  1016db:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
  1016df:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  1016e3:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  1016e7:	ee                   	out    %al,(%dx)
  1016e8:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  1016ee:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
  1016f2:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  1016f6:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  1016fa:	ee                   	out    %al,(%dx)
  1016fb:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  101701:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
  101705:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101709:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  10170d:	ee                   	out    %al,(%dx)
  10170e:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  101714:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
  101718:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  10171c:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101720:	ee                   	out    %al,(%dx)
  101721:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  101727:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
  10172b:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  10172f:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101733:	ee                   	out    %al,(%dx)
  101734:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  10173a:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
  10173e:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101742:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101746:	ee                   	out    %al,(%dx)
  101747:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  10174d:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
  101751:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101755:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101759:	ee                   	out    %al,(%dx)
  10175a:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  101760:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
  101764:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101768:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10176c:	ee                   	out    %al,(%dx)
  10176d:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  101773:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
  101777:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10177b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10177f:	ee                   	out    %al,(%dx)
  101780:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101786:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
  10178a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10178e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101792:	ee                   	out    %al,(%dx)
  101793:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  101799:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
  10179d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1017a1:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1017a5:	ee                   	out    %al,(%dx)
  1017a6:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  1017ac:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
  1017b0:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1017b4:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1017b8:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1017b9:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017c0:	66 83 f8 ff          	cmp    $0xffff,%ax
  1017c4:	74 13                	je     1017d9 <pic_init+0x13a>
        pic_setmask(irq_mask);
  1017c6:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017cd:	0f b7 c0             	movzwl %ax,%eax
  1017d0:	50                   	push   %eax
  1017d1:	e8 43 fe ff ff       	call   101619 <pic_setmask>
  1017d6:	83 c4 04             	add    $0x4,%esp
    }
}
  1017d9:	90                   	nop
  1017da:	c9                   	leave  
  1017db:	c3                   	ret    

001017dc <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1017dc:	55                   	push   %ebp
  1017dd:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  1017df:	fb                   	sti    
    sti();
}
  1017e0:	90                   	nop
  1017e1:	5d                   	pop    %ebp
  1017e2:	c3                   	ret    

001017e3 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1017e3:	55                   	push   %ebp
  1017e4:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  1017e6:	fa                   	cli    
    cli();
}
  1017e7:	90                   	nop
  1017e8:	5d                   	pop    %ebp
  1017e9:	c3                   	ret    

001017ea <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  1017ea:	55                   	push   %ebp
  1017eb:	89 e5                	mov    %esp,%ebp
  1017ed:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1017f0:	83 ec 08             	sub    $0x8,%esp
  1017f3:	6a 64                	push   $0x64
  1017f5:	68 c0 38 10 00       	push   $0x1038c0
  1017fa:	e8 4e ea ff ff       	call   10024d <cprintf>
  1017ff:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  101802:	83 ec 0c             	sub    $0xc,%esp
  101805:	68 ca 38 10 00       	push   $0x1038ca
  10180a:	e8 3e ea ff ff       	call   10024d <cprintf>
  10180f:	83 c4 10             	add    $0x10,%esp
    panic("EOT: kernel seems ok.");
  101812:	83 ec 04             	sub    $0x4,%esp
  101815:	68 d8 38 10 00       	push   $0x1038d8
  10181a:	6a 12                	push   $0x12
  10181c:	68 ee 38 10 00       	push   $0x1038ee
  101821:	e8 8d eb ff ff       	call   1003b3 <__panic>

00101826 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101826:	55                   	push   %ebp
  101827:	89 e5                	mov    %esp,%ebp
  101829:	83 ec 10             	sub    $0x10,%esp
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
        int num=sizeof(idt)/sizeof(struct gatedesc);
  10182c:	c7 45 f8 00 01 00 00 	movl   $0x100,-0x8(%ebp)
        for(int i=0;i<num;++i)
  101833:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10183a:	e9 c3 00 00 00       	jmp    101902 <idt_init+0xdc>
        {
                SETGATE(idt[i],0,GD_KTEXT,__vectors[i],DPL_KERNEL);
  10183f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101842:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  101849:	89 c2                	mov    %eax,%edx
  10184b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10184e:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  101855:	00 
  101856:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101859:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  101860:	00 08 00 
  101863:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101866:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  10186d:	00 
  10186e:	83 e2 e0             	and    $0xffffffe0,%edx
  101871:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101878:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10187b:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101882:	00 
  101883:	83 e2 1f             	and    $0x1f,%edx
  101886:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  10188d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101890:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101897:	00 
  101898:	83 e2 f0             	and    $0xfffffff0,%edx
  10189b:	83 ca 0e             	or     $0xe,%edx
  10189e:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018a8:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018af:	00 
  1018b0:	83 e2 ef             	and    $0xffffffef,%edx
  1018b3:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018bd:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018c4:	00 
  1018c5:	83 e2 9f             	and    $0xffffff9f,%edx
  1018c8:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018d2:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018d9:	00 
  1018da:	83 ca 80             	or     $0xffffff80,%edx
  1018dd:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e7:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  1018ee:	c1 e8 10             	shr    $0x10,%eax
  1018f1:	89 c2                	mov    %eax,%edx
  1018f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f6:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  1018fd:	00 
        for(int i=0;i<num;++i)
  1018fe:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101902:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101905:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  101908:	0f 8c 31 ff ff ff    	jl     10183f <idt_init+0x19>
        }

        SETGATE(idt[T_SWITCH_TOU],0,GD_KTEXT,__vectors[T_SWITCH_TOU],DPL_USER);
  10190e:	a1 c0 e7 10 00       	mov    0x10e7c0,%eax
  101913:	66 a3 60 f4 10 00    	mov    %ax,0x10f460
  101919:	66 c7 05 62 f4 10 00 	movw   $0x8,0x10f462
  101920:	08 00 
  101922:	0f b6 05 64 f4 10 00 	movzbl 0x10f464,%eax
  101929:	83 e0 e0             	and    $0xffffffe0,%eax
  10192c:	a2 64 f4 10 00       	mov    %al,0x10f464
  101931:	0f b6 05 64 f4 10 00 	movzbl 0x10f464,%eax
  101938:	83 e0 1f             	and    $0x1f,%eax
  10193b:	a2 64 f4 10 00       	mov    %al,0x10f464
  101940:	0f b6 05 65 f4 10 00 	movzbl 0x10f465,%eax
  101947:	83 e0 f0             	and    $0xfffffff0,%eax
  10194a:	83 c8 0e             	or     $0xe,%eax
  10194d:	a2 65 f4 10 00       	mov    %al,0x10f465
  101952:	0f b6 05 65 f4 10 00 	movzbl 0x10f465,%eax
  101959:	83 e0 ef             	and    $0xffffffef,%eax
  10195c:	a2 65 f4 10 00       	mov    %al,0x10f465
  101961:	0f b6 05 65 f4 10 00 	movzbl 0x10f465,%eax
  101968:	83 c8 60             	or     $0x60,%eax
  10196b:	a2 65 f4 10 00       	mov    %al,0x10f465
  101970:	0f b6 05 65 f4 10 00 	movzbl 0x10f465,%eax
  101977:	83 c8 80             	or     $0xffffff80,%eax
  10197a:	a2 65 f4 10 00       	mov    %al,0x10f465
  10197f:	a1 c0 e7 10 00       	mov    0x10e7c0,%eax
  101984:	c1 e8 10             	shr    $0x10,%eax
  101987:	66 a3 66 f4 10 00    	mov    %ax,0x10f466
	SETGATE(idt[T_SWITCH_TOK], 1, KERNEL_CS, __vectors[T_SWITCH_TOK], 3);        
  10198d:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  101992:	66 a3 68 f4 10 00    	mov    %ax,0x10f468
  101998:	66 c7 05 6a f4 10 00 	movw   $0x8,0x10f46a
  10199f:	08 00 
  1019a1:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  1019a8:	83 e0 e0             	and    $0xffffffe0,%eax
  1019ab:	a2 6c f4 10 00       	mov    %al,0x10f46c
  1019b0:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  1019b7:	83 e0 1f             	and    $0x1f,%eax
  1019ba:	a2 6c f4 10 00       	mov    %al,0x10f46c
  1019bf:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  1019c6:	83 c8 0f             	or     $0xf,%eax
  1019c9:	a2 6d f4 10 00       	mov    %al,0x10f46d
  1019ce:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  1019d5:	83 e0 ef             	and    $0xffffffef,%eax
  1019d8:	a2 6d f4 10 00       	mov    %al,0x10f46d
  1019dd:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  1019e4:	83 c8 60             	or     $0x60,%eax
  1019e7:	a2 6d f4 10 00       	mov    %al,0x10f46d
  1019ec:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  1019f3:	83 c8 80             	or     $0xffffff80,%eax
  1019f6:	a2 6d f4 10 00       	mov    %al,0x10f46d
  1019fb:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  101a00:	c1 e8 10             	shr    $0x10,%eax
  101a03:	66 a3 6e f4 10 00    	mov    %ax,0x10f46e
  101a09:	c7 45 f4 60 e5 10 00 	movl   $0x10e560,-0xc(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd));
  101a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101a13:	0f 01 18             	lidtl  (%eax)
	lidt(&idt_pd);
}
  101a16:	90                   	nop
  101a17:	c9                   	leave  
  101a18:	c3                   	ret    

00101a19 <trapname>:

static const char *
trapname(int trapno) {
  101a19:	55                   	push   %ebp
  101a1a:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a1f:	83 f8 13             	cmp    $0x13,%eax
  101a22:	77 0c                	ja     101a30 <trapname+0x17>
        return excnames[trapno];
  101a24:	8b 45 08             	mov    0x8(%ebp),%eax
  101a27:	8b 04 85 40 3c 10 00 	mov    0x103c40(,%eax,4),%eax
  101a2e:	eb 18                	jmp    101a48 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101a30:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101a34:	7e 0d                	jle    101a43 <trapname+0x2a>
  101a36:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a3a:	7f 07                	jg     101a43 <trapname+0x2a>
        return "Hardware Interrupt";
  101a3c:	b8 ff 38 10 00       	mov    $0x1038ff,%eax
  101a41:	eb 05                	jmp    101a48 <trapname+0x2f>
    }
    return "(unknown trap)";
  101a43:	b8 12 39 10 00       	mov    $0x103912,%eax
}
  101a48:	5d                   	pop    %ebp
  101a49:	c3                   	ret    

00101a4a <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101a4a:	55                   	push   %ebp
  101a4b:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  101a50:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a54:	66 83 f8 08          	cmp    $0x8,%ax
  101a58:	0f 94 c0             	sete   %al
  101a5b:	0f b6 c0             	movzbl %al,%eax
}
  101a5e:	5d                   	pop    %ebp
  101a5f:	c3                   	ret    

00101a60 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a60:	55                   	push   %ebp
  101a61:	89 e5                	mov    %esp,%ebp
  101a63:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
  101a66:	83 ec 08             	sub    $0x8,%esp
  101a69:	ff 75 08             	pushl  0x8(%ebp)
  101a6c:	68 53 39 10 00       	push   $0x103953
  101a71:	e8 d7 e7 ff ff       	call   10024d <cprintf>
  101a76:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
  101a79:	8b 45 08             	mov    0x8(%ebp),%eax
  101a7c:	83 ec 0c             	sub    $0xc,%esp
  101a7f:	50                   	push   %eax
  101a80:	e8 b6 01 00 00       	call   101c3b <print_regs>
  101a85:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a88:	8b 45 08             	mov    0x8(%ebp),%eax
  101a8b:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a8f:	0f b7 c0             	movzwl %ax,%eax
  101a92:	83 ec 08             	sub    $0x8,%esp
  101a95:	50                   	push   %eax
  101a96:	68 64 39 10 00       	push   $0x103964
  101a9b:	e8 ad e7 ff ff       	call   10024d <cprintf>
  101aa0:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa6:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101aaa:	0f b7 c0             	movzwl %ax,%eax
  101aad:	83 ec 08             	sub    $0x8,%esp
  101ab0:	50                   	push   %eax
  101ab1:	68 77 39 10 00       	push   $0x103977
  101ab6:	e8 92 e7 ff ff       	call   10024d <cprintf>
  101abb:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101abe:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac1:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101ac5:	0f b7 c0             	movzwl %ax,%eax
  101ac8:	83 ec 08             	sub    $0x8,%esp
  101acb:	50                   	push   %eax
  101acc:	68 8a 39 10 00       	push   $0x10398a
  101ad1:	e8 77 e7 ff ff       	call   10024d <cprintf>
  101ad6:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  101adc:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101ae0:	0f b7 c0             	movzwl %ax,%eax
  101ae3:	83 ec 08             	sub    $0x8,%esp
  101ae6:	50                   	push   %eax
  101ae7:	68 9d 39 10 00       	push   $0x10399d
  101aec:	e8 5c e7 ff ff       	call   10024d <cprintf>
  101af1:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101af4:	8b 45 08             	mov    0x8(%ebp),%eax
  101af7:	8b 40 30             	mov    0x30(%eax),%eax
  101afa:	83 ec 0c             	sub    $0xc,%esp
  101afd:	50                   	push   %eax
  101afe:	e8 16 ff ff ff       	call   101a19 <trapname>
  101b03:	83 c4 10             	add    $0x10,%esp
  101b06:	89 c2                	mov    %eax,%edx
  101b08:	8b 45 08             	mov    0x8(%ebp),%eax
  101b0b:	8b 40 30             	mov    0x30(%eax),%eax
  101b0e:	83 ec 04             	sub    $0x4,%esp
  101b11:	52                   	push   %edx
  101b12:	50                   	push   %eax
  101b13:	68 b0 39 10 00       	push   $0x1039b0
  101b18:	e8 30 e7 ff ff       	call   10024d <cprintf>
  101b1d:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
  101b20:	8b 45 08             	mov    0x8(%ebp),%eax
  101b23:	8b 40 34             	mov    0x34(%eax),%eax
  101b26:	83 ec 08             	sub    $0x8,%esp
  101b29:	50                   	push   %eax
  101b2a:	68 c2 39 10 00       	push   $0x1039c2
  101b2f:	e8 19 e7 ff ff       	call   10024d <cprintf>
  101b34:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b37:	8b 45 08             	mov    0x8(%ebp),%eax
  101b3a:	8b 40 38             	mov    0x38(%eax),%eax
  101b3d:	83 ec 08             	sub    $0x8,%esp
  101b40:	50                   	push   %eax
  101b41:	68 d1 39 10 00       	push   $0x1039d1
  101b46:	e8 02 e7 ff ff       	call   10024d <cprintf>
  101b4b:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b51:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b55:	0f b7 c0             	movzwl %ax,%eax
  101b58:	83 ec 08             	sub    $0x8,%esp
  101b5b:	50                   	push   %eax
  101b5c:	68 e0 39 10 00       	push   $0x1039e0
  101b61:	e8 e7 e6 ff ff       	call   10024d <cprintf>
  101b66:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b69:	8b 45 08             	mov    0x8(%ebp),%eax
  101b6c:	8b 40 40             	mov    0x40(%eax),%eax
  101b6f:	83 ec 08             	sub    $0x8,%esp
  101b72:	50                   	push   %eax
  101b73:	68 f3 39 10 00       	push   $0x1039f3
  101b78:	e8 d0 e6 ff ff       	call   10024d <cprintf>
  101b7d:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b80:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b87:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b8e:	eb 3f                	jmp    101bcf <print_trapframe+0x16f>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b90:	8b 45 08             	mov    0x8(%ebp),%eax
  101b93:	8b 50 40             	mov    0x40(%eax),%edx
  101b96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b99:	21 d0                	and    %edx,%eax
  101b9b:	85 c0                	test   %eax,%eax
  101b9d:	74 29                	je     101bc8 <print_trapframe+0x168>
  101b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ba2:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101ba9:	85 c0                	test   %eax,%eax
  101bab:	74 1b                	je     101bc8 <print_trapframe+0x168>
            cprintf("%s,", IA32flags[i]);
  101bad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bb0:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101bb7:	83 ec 08             	sub    $0x8,%esp
  101bba:	50                   	push   %eax
  101bbb:	68 02 3a 10 00       	push   $0x103a02
  101bc0:	e8 88 e6 ff ff       	call   10024d <cprintf>
  101bc5:	83 c4 10             	add    $0x10,%esp
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101bc8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101bcc:	d1 65 f0             	shll   -0x10(%ebp)
  101bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bd2:	83 f8 17             	cmp    $0x17,%eax
  101bd5:	76 b9                	jbe    101b90 <print_trapframe+0x130>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  101bda:	8b 40 40             	mov    0x40(%eax),%eax
  101bdd:	c1 e8 0c             	shr    $0xc,%eax
  101be0:	83 e0 03             	and    $0x3,%eax
  101be3:	83 ec 08             	sub    $0x8,%esp
  101be6:	50                   	push   %eax
  101be7:	68 06 3a 10 00       	push   $0x103a06
  101bec:	e8 5c e6 ff ff       	call   10024d <cprintf>
  101bf1:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
  101bf4:	83 ec 0c             	sub    $0xc,%esp
  101bf7:	ff 75 08             	pushl  0x8(%ebp)
  101bfa:	e8 4b fe ff ff       	call   101a4a <trap_in_kernel>
  101bff:	83 c4 10             	add    $0x10,%esp
  101c02:	85 c0                	test   %eax,%eax
  101c04:	75 32                	jne    101c38 <print_trapframe+0x1d8>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101c06:	8b 45 08             	mov    0x8(%ebp),%eax
  101c09:	8b 40 44             	mov    0x44(%eax),%eax
  101c0c:	83 ec 08             	sub    $0x8,%esp
  101c0f:	50                   	push   %eax
  101c10:	68 0f 3a 10 00       	push   $0x103a0f
  101c15:	e8 33 e6 ff ff       	call   10024d <cprintf>
  101c1a:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  101c20:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101c24:	0f b7 c0             	movzwl %ax,%eax
  101c27:	83 ec 08             	sub    $0x8,%esp
  101c2a:	50                   	push   %eax
  101c2b:	68 1e 3a 10 00       	push   $0x103a1e
  101c30:	e8 18 e6 ff ff       	call   10024d <cprintf>
  101c35:	83 c4 10             	add    $0x10,%esp
    }
}
  101c38:	90                   	nop
  101c39:	c9                   	leave  
  101c3a:	c3                   	ret    

00101c3b <print_regs>:

void
print_regs(struct pushregs *regs) {
  101c3b:	55                   	push   %ebp
  101c3c:	89 e5                	mov    %esp,%ebp
  101c3e:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101c41:	8b 45 08             	mov    0x8(%ebp),%eax
  101c44:	8b 00                	mov    (%eax),%eax
  101c46:	83 ec 08             	sub    $0x8,%esp
  101c49:	50                   	push   %eax
  101c4a:	68 31 3a 10 00       	push   $0x103a31
  101c4f:	e8 f9 e5 ff ff       	call   10024d <cprintf>
  101c54:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c57:	8b 45 08             	mov    0x8(%ebp),%eax
  101c5a:	8b 40 04             	mov    0x4(%eax),%eax
  101c5d:	83 ec 08             	sub    $0x8,%esp
  101c60:	50                   	push   %eax
  101c61:	68 40 3a 10 00       	push   $0x103a40
  101c66:	e8 e2 e5 ff ff       	call   10024d <cprintf>
  101c6b:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  101c71:	8b 40 08             	mov    0x8(%eax),%eax
  101c74:	83 ec 08             	sub    $0x8,%esp
  101c77:	50                   	push   %eax
  101c78:	68 4f 3a 10 00       	push   $0x103a4f
  101c7d:	e8 cb e5 ff ff       	call   10024d <cprintf>
  101c82:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c85:	8b 45 08             	mov    0x8(%ebp),%eax
  101c88:	8b 40 0c             	mov    0xc(%eax),%eax
  101c8b:	83 ec 08             	sub    $0x8,%esp
  101c8e:	50                   	push   %eax
  101c8f:	68 5e 3a 10 00       	push   $0x103a5e
  101c94:	e8 b4 e5 ff ff       	call   10024d <cprintf>
  101c99:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  101c9f:	8b 40 10             	mov    0x10(%eax),%eax
  101ca2:	83 ec 08             	sub    $0x8,%esp
  101ca5:	50                   	push   %eax
  101ca6:	68 6d 3a 10 00       	push   $0x103a6d
  101cab:	e8 9d e5 ff ff       	call   10024d <cprintf>
  101cb0:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  101cb6:	8b 40 14             	mov    0x14(%eax),%eax
  101cb9:	83 ec 08             	sub    $0x8,%esp
  101cbc:	50                   	push   %eax
  101cbd:	68 7c 3a 10 00       	push   $0x103a7c
  101cc2:	e8 86 e5 ff ff       	call   10024d <cprintf>
  101cc7:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101cca:	8b 45 08             	mov    0x8(%ebp),%eax
  101ccd:	8b 40 18             	mov    0x18(%eax),%eax
  101cd0:	83 ec 08             	sub    $0x8,%esp
  101cd3:	50                   	push   %eax
  101cd4:	68 8b 3a 10 00       	push   $0x103a8b
  101cd9:	e8 6f e5 ff ff       	call   10024d <cprintf>
  101cde:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  101ce4:	8b 40 1c             	mov    0x1c(%eax),%eax
  101ce7:	83 ec 08             	sub    $0x8,%esp
  101cea:	50                   	push   %eax
  101ceb:	68 9a 3a 10 00       	push   $0x103a9a
  101cf0:	e8 58 e5 ff ff       	call   10024d <cprintf>
  101cf5:	83 c4 10             	add    $0x10,%esp
}
  101cf8:	90                   	nop
  101cf9:	c9                   	leave  
  101cfa:	c3                   	ret    

00101cfb <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101cfb:	55                   	push   %ebp
  101cfc:	89 e5                	mov    %esp,%ebp
  101cfe:	83 ec 18             	sub    $0x18,%esp
    char c;

    switch (tf->tf_trapno) {
  101d01:	8b 45 08             	mov    0x8(%ebp),%eax
  101d04:	8b 40 30             	mov    0x30(%eax),%eax
  101d07:	83 f8 2f             	cmp    $0x2f,%eax
  101d0a:	77 1d                	ja     101d29 <trap_dispatch+0x2e>
  101d0c:	83 f8 2e             	cmp    $0x2e,%eax
  101d0f:	0f 83 8a 01 00 00    	jae    101e9f <trap_dispatch+0x1a4>
  101d15:	83 f8 21             	cmp    $0x21,%eax
  101d18:	74 7c                	je     101d96 <trap_dispatch+0x9b>
  101d1a:	83 f8 24             	cmp    $0x24,%eax
  101d1d:	74 50                	je     101d6f <trap_dispatch+0x74>
  101d1f:	83 f8 20             	cmp    $0x20,%eax
  101d22:	74 1c                	je     101d40 <trap_dispatch+0x45>
  101d24:	e9 40 01 00 00       	jmp    101e69 <trap_dispatch+0x16e>
  101d29:	83 f8 78             	cmp    $0x78,%eax
  101d2c:	0f 84 8b 00 00 00    	je     101dbd <trap_dispatch+0xc2>
  101d32:	83 f8 79             	cmp    $0x79,%eax
  101d35:	0f 84 e2 00 00 00    	je     101e1d <trap_dispatch+0x122>
  101d3b:	e9 29 01 00 00       	jmp    101e69 <trap_dispatch+0x16e>
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */

	ticks++;
  101d40:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101d45:	83 c0 01             	add    $0x1,%eax
  101d48:	a3 08 f9 10 00       	mov    %eax,0x10f908
	if(ticks==TICK_NUM)
  101d4d:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101d52:	83 f8 64             	cmp    $0x64,%eax
  101d55:	0f 85 47 01 00 00    	jne    101ea2 <trap_dispatch+0x1a7>
	{
		ticks=0;
  101d5b:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  101d62:	00 00 00 
		print_ticks();
  101d65:	e8 80 fa ff ff       	call   1017ea <print_ticks>
	}		
        break;
  101d6a:	e9 33 01 00 00       	jmp    101ea2 <trap_dispatch+0x1a7>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d6f:	e8 49 f8 ff ff       	call   1015bd <cons_getc>
  101d74:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d77:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d7b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d7f:	83 ec 04             	sub    $0x4,%esp
  101d82:	52                   	push   %edx
  101d83:	50                   	push   %eax
  101d84:	68 a9 3a 10 00       	push   $0x103aa9
  101d89:	e8 bf e4 ff ff       	call   10024d <cprintf>
  101d8e:	83 c4 10             	add    $0x10,%esp
        break;
  101d91:	e9 0d 01 00 00       	jmp    101ea3 <trap_dispatch+0x1a8>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d96:	e8 22 f8 ff ff       	call   1015bd <cons_getc>
  101d9b:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101d9e:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101da2:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101da6:	83 ec 04             	sub    $0x4,%esp
  101da9:	52                   	push   %edx
  101daa:	50                   	push   %eax
  101dab:	68 bb 3a 10 00       	push   $0x103abb
  101db0:	e8 98 e4 ff ff       	call   10024d <cprintf>
  101db5:	83 c4 10             	add    $0x10,%esp
        break;
  101db8:	e9 e6 00 00 00       	jmp    101ea3 <trap_dispatch+0x1a8>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
	tf->tf_eflags |= FL_IOPL_MASK;
  101dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  101dc0:	8b 40 40             	mov    0x40(%eax),%eax
  101dc3:	80 cc 30             	or     $0x30,%ah
  101dc6:	89 c2                	mov    %eax,%edx
  101dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  101dcb:	89 50 40             	mov    %edx,0x40(%eax)
	tf->tf_cs = USER_CS;
  101dce:	8b 45 08             	mov    0x8(%ebp),%eax
  101dd1:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
	tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_ss = tf->tf_fs = USER_DS;
  101dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  101dda:	66 c7 40 24 23 00    	movw   $0x23,0x24(%eax)
  101de0:	8b 45 08             	mov    0x8(%ebp),%eax
  101de3:	0f b7 50 24          	movzwl 0x24(%eax),%edx
  101de7:	8b 45 08             	mov    0x8(%ebp),%eax
  101dea:	66 89 50 48          	mov    %dx,0x48(%eax)
  101dee:	8b 45 08             	mov    0x8(%ebp),%eax
  101df1:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  101df5:	8b 45 08             	mov    0x8(%ebp),%eax
  101df8:	66 89 50 20          	mov    %dx,0x20(%eax)
  101dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  101dff:	0f b7 50 20          	movzwl 0x20(%eax),%edx
  101e03:	8b 45 08             	mov    0x8(%ebp),%eax
  101e06:	66 89 50 28          	mov    %dx,0x28(%eax)
  101e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  101e0d:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101e11:	8b 45 08             	mov    0x8(%ebp),%eax
  101e14:	66 89 50 2c          	mov    %dx,0x2c(%eax)
	break;
  101e18:	e9 86 00 00 00       	jmp    101ea3 <trap_dispatch+0x1a8>
    case T_SWITCH_TOK:
	tf->tf_cs = KERNEL_CS;
  101e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  101e20:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
	tf->tf_ds = tf->tf_es = tf->tf_gs = tf->tf_ss = tf->tf_fs = KERNEL_DS;
  101e26:	8b 45 08             	mov    0x8(%ebp),%eax
  101e29:	66 c7 40 24 10 00    	movw   $0x10,0x24(%eax)
  101e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  101e32:	0f b7 50 24          	movzwl 0x24(%eax),%edx
  101e36:	8b 45 08             	mov    0x8(%ebp),%eax
  101e39:	66 89 50 48          	mov    %dx,0x48(%eax)
  101e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  101e40:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  101e44:	8b 45 08             	mov    0x8(%ebp),%eax
  101e47:	66 89 50 20          	mov    %dx,0x20(%eax)
  101e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  101e4e:	0f b7 50 20          	movzwl 0x20(%eax),%edx
  101e52:	8b 45 08             	mov    0x8(%ebp),%eax
  101e55:	66 89 50 28          	mov    %dx,0x28(%eax)
  101e59:	8b 45 08             	mov    0x8(%ebp),%eax
  101e5c:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101e60:	8b 45 08             	mov    0x8(%ebp),%eax
  101e63:	66 89 50 2c          	mov    %dx,0x2c(%eax)
        break;
  101e67:	eb 3a                	jmp    101ea3 <trap_dispatch+0x1a8>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101e69:	8b 45 08             	mov    0x8(%ebp),%eax
  101e6c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e70:	0f b7 c0             	movzwl %ax,%eax
  101e73:	83 e0 03             	and    $0x3,%eax
  101e76:	85 c0                	test   %eax,%eax
  101e78:	75 29                	jne    101ea3 <trap_dispatch+0x1a8>
            print_trapframe(tf);
  101e7a:	83 ec 0c             	sub    $0xc,%esp
  101e7d:	ff 75 08             	pushl  0x8(%ebp)
  101e80:	e8 db fb ff ff       	call   101a60 <print_trapframe>
  101e85:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
  101e88:	83 ec 04             	sub    $0x4,%esp
  101e8b:	68 ca 3a 10 00       	push   $0x103aca
  101e90:	68 c2 00 00 00       	push   $0xc2
  101e95:	68 ee 38 10 00       	push   $0x1038ee
  101e9a:	e8 14 e5 ff ff       	call   1003b3 <__panic>
        break;
  101e9f:	90                   	nop
  101ea0:	eb 01                	jmp    101ea3 <trap_dispatch+0x1a8>
        break;
  101ea2:	90                   	nop
        }
    }
}
  101ea3:	90                   	nop
  101ea4:	c9                   	leave  
  101ea5:	c3                   	ret    

00101ea6 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101ea6:	55                   	push   %ebp
  101ea7:	89 e5                	mov    %esp,%ebp
  101ea9:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101eac:	83 ec 0c             	sub    $0xc,%esp
  101eaf:	ff 75 08             	pushl  0x8(%ebp)
  101eb2:	e8 44 fe ff ff       	call   101cfb <trap_dispatch>
  101eb7:	83 c4 10             	add    $0x10,%esp
}
  101eba:	90                   	nop
  101ebb:	c9                   	leave  
  101ebc:	c3                   	ret    

00101ebd <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101ebd:	6a 00                	push   $0x0
  pushl $0
  101ebf:	6a 00                	push   $0x0
  jmp __alltraps
  101ec1:	e9 67 0a 00 00       	jmp    10292d <__alltraps>

00101ec6 <vector1>:
.globl vector1
vector1:
  pushl $0
  101ec6:	6a 00                	push   $0x0
  pushl $1
  101ec8:	6a 01                	push   $0x1
  jmp __alltraps
  101eca:	e9 5e 0a 00 00       	jmp    10292d <__alltraps>

00101ecf <vector2>:
.globl vector2
vector2:
  pushl $0
  101ecf:	6a 00                	push   $0x0
  pushl $2
  101ed1:	6a 02                	push   $0x2
  jmp __alltraps
  101ed3:	e9 55 0a 00 00       	jmp    10292d <__alltraps>

00101ed8 <vector3>:
.globl vector3
vector3:
  pushl $0
  101ed8:	6a 00                	push   $0x0
  pushl $3
  101eda:	6a 03                	push   $0x3
  jmp __alltraps
  101edc:	e9 4c 0a 00 00       	jmp    10292d <__alltraps>

00101ee1 <vector4>:
.globl vector4
vector4:
  pushl $0
  101ee1:	6a 00                	push   $0x0
  pushl $4
  101ee3:	6a 04                	push   $0x4
  jmp __alltraps
  101ee5:	e9 43 0a 00 00       	jmp    10292d <__alltraps>

00101eea <vector5>:
.globl vector5
vector5:
  pushl $0
  101eea:	6a 00                	push   $0x0
  pushl $5
  101eec:	6a 05                	push   $0x5
  jmp __alltraps
  101eee:	e9 3a 0a 00 00       	jmp    10292d <__alltraps>

00101ef3 <vector6>:
.globl vector6
vector6:
  pushl $0
  101ef3:	6a 00                	push   $0x0
  pushl $6
  101ef5:	6a 06                	push   $0x6
  jmp __alltraps
  101ef7:	e9 31 0a 00 00       	jmp    10292d <__alltraps>

00101efc <vector7>:
.globl vector7
vector7:
  pushl $0
  101efc:	6a 00                	push   $0x0
  pushl $7
  101efe:	6a 07                	push   $0x7
  jmp __alltraps
  101f00:	e9 28 0a 00 00       	jmp    10292d <__alltraps>

00101f05 <vector8>:
.globl vector8
vector8:
  pushl $8
  101f05:	6a 08                	push   $0x8
  jmp __alltraps
  101f07:	e9 21 0a 00 00       	jmp    10292d <__alltraps>

00101f0c <vector9>:
.globl vector9
vector9:
  pushl $9
  101f0c:	6a 09                	push   $0x9
  jmp __alltraps
  101f0e:	e9 1a 0a 00 00       	jmp    10292d <__alltraps>

00101f13 <vector10>:
.globl vector10
vector10:
  pushl $10
  101f13:	6a 0a                	push   $0xa
  jmp __alltraps
  101f15:	e9 13 0a 00 00       	jmp    10292d <__alltraps>

00101f1a <vector11>:
.globl vector11
vector11:
  pushl $11
  101f1a:	6a 0b                	push   $0xb
  jmp __alltraps
  101f1c:	e9 0c 0a 00 00       	jmp    10292d <__alltraps>

00101f21 <vector12>:
.globl vector12
vector12:
  pushl $12
  101f21:	6a 0c                	push   $0xc
  jmp __alltraps
  101f23:	e9 05 0a 00 00       	jmp    10292d <__alltraps>

00101f28 <vector13>:
.globl vector13
vector13:
  pushl $13
  101f28:	6a 0d                	push   $0xd
  jmp __alltraps
  101f2a:	e9 fe 09 00 00       	jmp    10292d <__alltraps>

00101f2f <vector14>:
.globl vector14
vector14:
  pushl $14
  101f2f:	6a 0e                	push   $0xe
  jmp __alltraps
  101f31:	e9 f7 09 00 00       	jmp    10292d <__alltraps>

00101f36 <vector15>:
.globl vector15
vector15:
  pushl $0
  101f36:	6a 00                	push   $0x0
  pushl $15
  101f38:	6a 0f                	push   $0xf
  jmp __alltraps
  101f3a:	e9 ee 09 00 00       	jmp    10292d <__alltraps>

00101f3f <vector16>:
.globl vector16
vector16:
  pushl $0
  101f3f:	6a 00                	push   $0x0
  pushl $16
  101f41:	6a 10                	push   $0x10
  jmp __alltraps
  101f43:	e9 e5 09 00 00       	jmp    10292d <__alltraps>

00101f48 <vector17>:
.globl vector17
vector17:
  pushl $17
  101f48:	6a 11                	push   $0x11
  jmp __alltraps
  101f4a:	e9 de 09 00 00       	jmp    10292d <__alltraps>

00101f4f <vector18>:
.globl vector18
vector18:
  pushl $0
  101f4f:	6a 00                	push   $0x0
  pushl $18
  101f51:	6a 12                	push   $0x12
  jmp __alltraps
  101f53:	e9 d5 09 00 00       	jmp    10292d <__alltraps>

00101f58 <vector19>:
.globl vector19
vector19:
  pushl $0
  101f58:	6a 00                	push   $0x0
  pushl $19
  101f5a:	6a 13                	push   $0x13
  jmp __alltraps
  101f5c:	e9 cc 09 00 00       	jmp    10292d <__alltraps>

00101f61 <vector20>:
.globl vector20
vector20:
  pushl $0
  101f61:	6a 00                	push   $0x0
  pushl $20
  101f63:	6a 14                	push   $0x14
  jmp __alltraps
  101f65:	e9 c3 09 00 00       	jmp    10292d <__alltraps>

00101f6a <vector21>:
.globl vector21
vector21:
  pushl $0
  101f6a:	6a 00                	push   $0x0
  pushl $21
  101f6c:	6a 15                	push   $0x15
  jmp __alltraps
  101f6e:	e9 ba 09 00 00       	jmp    10292d <__alltraps>

00101f73 <vector22>:
.globl vector22
vector22:
  pushl $0
  101f73:	6a 00                	push   $0x0
  pushl $22
  101f75:	6a 16                	push   $0x16
  jmp __alltraps
  101f77:	e9 b1 09 00 00       	jmp    10292d <__alltraps>

00101f7c <vector23>:
.globl vector23
vector23:
  pushl $0
  101f7c:	6a 00                	push   $0x0
  pushl $23
  101f7e:	6a 17                	push   $0x17
  jmp __alltraps
  101f80:	e9 a8 09 00 00       	jmp    10292d <__alltraps>

00101f85 <vector24>:
.globl vector24
vector24:
  pushl $0
  101f85:	6a 00                	push   $0x0
  pushl $24
  101f87:	6a 18                	push   $0x18
  jmp __alltraps
  101f89:	e9 9f 09 00 00       	jmp    10292d <__alltraps>

00101f8e <vector25>:
.globl vector25
vector25:
  pushl $0
  101f8e:	6a 00                	push   $0x0
  pushl $25
  101f90:	6a 19                	push   $0x19
  jmp __alltraps
  101f92:	e9 96 09 00 00       	jmp    10292d <__alltraps>

00101f97 <vector26>:
.globl vector26
vector26:
  pushl $0
  101f97:	6a 00                	push   $0x0
  pushl $26
  101f99:	6a 1a                	push   $0x1a
  jmp __alltraps
  101f9b:	e9 8d 09 00 00       	jmp    10292d <__alltraps>

00101fa0 <vector27>:
.globl vector27
vector27:
  pushl $0
  101fa0:	6a 00                	push   $0x0
  pushl $27
  101fa2:	6a 1b                	push   $0x1b
  jmp __alltraps
  101fa4:	e9 84 09 00 00       	jmp    10292d <__alltraps>

00101fa9 <vector28>:
.globl vector28
vector28:
  pushl $0
  101fa9:	6a 00                	push   $0x0
  pushl $28
  101fab:	6a 1c                	push   $0x1c
  jmp __alltraps
  101fad:	e9 7b 09 00 00       	jmp    10292d <__alltraps>

00101fb2 <vector29>:
.globl vector29
vector29:
  pushl $0
  101fb2:	6a 00                	push   $0x0
  pushl $29
  101fb4:	6a 1d                	push   $0x1d
  jmp __alltraps
  101fb6:	e9 72 09 00 00       	jmp    10292d <__alltraps>

00101fbb <vector30>:
.globl vector30
vector30:
  pushl $0
  101fbb:	6a 00                	push   $0x0
  pushl $30
  101fbd:	6a 1e                	push   $0x1e
  jmp __alltraps
  101fbf:	e9 69 09 00 00       	jmp    10292d <__alltraps>

00101fc4 <vector31>:
.globl vector31
vector31:
  pushl $0
  101fc4:	6a 00                	push   $0x0
  pushl $31
  101fc6:	6a 1f                	push   $0x1f
  jmp __alltraps
  101fc8:	e9 60 09 00 00       	jmp    10292d <__alltraps>

00101fcd <vector32>:
.globl vector32
vector32:
  pushl $0
  101fcd:	6a 00                	push   $0x0
  pushl $32
  101fcf:	6a 20                	push   $0x20
  jmp __alltraps
  101fd1:	e9 57 09 00 00       	jmp    10292d <__alltraps>

00101fd6 <vector33>:
.globl vector33
vector33:
  pushl $0
  101fd6:	6a 00                	push   $0x0
  pushl $33
  101fd8:	6a 21                	push   $0x21
  jmp __alltraps
  101fda:	e9 4e 09 00 00       	jmp    10292d <__alltraps>

00101fdf <vector34>:
.globl vector34
vector34:
  pushl $0
  101fdf:	6a 00                	push   $0x0
  pushl $34
  101fe1:	6a 22                	push   $0x22
  jmp __alltraps
  101fe3:	e9 45 09 00 00       	jmp    10292d <__alltraps>

00101fe8 <vector35>:
.globl vector35
vector35:
  pushl $0
  101fe8:	6a 00                	push   $0x0
  pushl $35
  101fea:	6a 23                	push   $0x23
  jmp __alltraps
  101fec:	e9 3c 09 00 00       	jmp    10292d <__alltraps>

00101ff1 <vector36>:
.globl vector36
vector36:
  pushl $0
  101ff1:	6a 00                	push   $0x0
  pushl $36
  101ff3:	6a 24                	push   $0x24
  jmp __alltraps
  101ff5:	e9 33 09 00 00       	jmp    10292d <__alltraps>

00101ffa <vector37>:
.globl vector37
vector37:
  pushl $0
  101ffa:	6a 00                	push   $0x0
  pushl $37
  101ffc:	6a 25                	push   $0x25
  jmp __alltraps
  101ffe:	e9 2a 09 00 00       	jmp    10292d <__alltraps>

00102003 <vector38>:
.globl vector38
vector38:
  pushl $0
  102003:	6a 00                	push   $0x0
  pushl $38
  102005:	6a 26                	push   $0x26
  jmp __alltraps
  102007:	e9 21 09 00 00       	jmp    10292d <__alltraps>

0010200c <vector39>:
.globl vector39
vector39:
  pushl $0
  10200c:	6a 00                	push   $0x0
  pushl $39
  10200e:	6a 27                	push   $0x27
  jmp __alltraps
  102010:	e9 18 09 00 00       	jmp    10292d <__alltraps>

00102015 <vector40>:
.globl vector40
vector40:
  pushl $0
  102015:	6a 00                	push   $0x0
  pushl $40
  102017:	6a 28                	push   $0x28
  jmp __alltraps
  102019:	e9 0f 09 00 00       	jmp    10292d <__alltraps>

0010201e <vector41>:
.globl vector41
vector41:
  pushl $0
  10201e:	6a 00                	push   $0x0
  pushl $41
  102020:	6a 29                	push   $0x29
  jmp __alltraps
  102022:	e9 06 09 00 00       	jmp    10292d <__alltraps>

00102027 <vector42>:
.globl vector42
vector42:
  pushl $0
  102027:	6a 00                	push   $0x0
  pushl $42
  102029:	6a 2a                	push   $0x2a
  jmp __alltraps
  10202b:	e9 fd 08 00 00       	jmp    10292d <__alltraps>

00102030 <vector43>:
.globl vector43
vector43:
  pushl $0
  102030:	6a 00                	push   $0x0
  pushl $43
  102032:	6a 2b                	push   $0x2b
  jmp __alltraps
  102034:	e9 f4 08 00 00       	jmp    10292d <__alltraps>

00102039 <vector44>:
.globl vector44
vector44:
  pushl $0
  102039:	6a 00                	push   $0x0
  pushl $44
  10203b:	6a 2c                	push   $0x2c
  jmp __alltraps
  10203d:	e9 eb 08 00 00       	jmp    10292d <__alltraps>

00102042 <vector45>:
.globl vector45
vector45:
  pushl $0
  102042:	6a 00                	push   $0x0
  pushl $45
  102044:	6a 2d                	push   $0x2d
  jmp __alltraps
  102046:	e9 e2 08 00 00       	jmp    10292d <__alltraps>

0010204b <vector46>:
.globl vector46
vector46:
  pushl $0
  10204b:	6a 00                	push   $0x0
  pushl $46
  10204d:	6a 2e                	push   $0x2e
  jmp __alltraps
  10204f:	e9 d9 08 00 00       	jmp    10292d <__alltraps>

00102054 <vector47>:
.globl vector47
vector47:
  pushl $0
  102054:	6a 00                	push   $0x0
  pushl $47
  102056:	6a 2f                	push   $0x2f
  jmp __alltraps
  102058:	e9 d0 08 00 00       	jmp    10292d <__alltraps>

0010205d <vector48>:
.globl vector48
vector48:
  pushl $0
  10205d:	6a 00                	push   $0x0
  pushl $48
  10205f:	6a 30                	push   $0x30
  jmp __alltraps
  102061:	e9 c7 08 00 00       	jmp    10292d <__alltraps>

00102066 <vector49>:
.globl vector49
vector49:
  pushl $0
  102066:	6a 00                	push   $0x0
  pushl $49
  102068:	6a 31                	push   $0x31
  jmp __alltraps
  10206a:	e9 be 08 00 00       	jmp    10292d <__alltraps>

0010206f <vector50>:
.globl vector50
vector50:
  pushl $0
  10206f:	6a 00                	push   $0x0
  pushl $50
  102071:	6a 32                	push   $0x32
  jmp __alltraps
  102073:	e9 b5 08 00 00       	jmp    10292d <__alltraps>

00102078 <vector51>:
.globl vector51
vector51:
  pushl $0
  102078:	6a 00                	push   $0x0
  pushl $51
  10207a:	6a 33                	push   $0x33
  jmp __alltraps
  10207c:	e9 ac 08 00 00       	jmp    10292d <__alltraps>

00102081 <vector52>:
.globl vector52
vector52:
  pushl $0
  102081:	6a 00                	push   $0x0
  pushl $52
  102083:	6a 34                	push   $0x34
  jmp __alltraps
  102085:	e9 a3 08 00 00       	jmp    10292d <__alltraps>

0010208a <vector53>:
.globl vector53
vector53:
  pushl $0
  10208a:	6a 00                	push   $0x0
  pushl $53
  10208c:	6a 35                	push   $0x35
  jmp __alltraps
  10208e:	e9 9a 08 00 00       	jmp    10292d <__alltraps>

00102093 <vector54>:
.globl vector54
vector54:
  pushl $0
  102093:	6a 00                	push   $0x0
  pushl $54
  102095:	6a 36                	push   $0x36
  jmp __alltraps
  102097:	e9 91 08 00 00       	jmp    10292d <__alltraps>

0010209c <vector55>:
.globl vector55
vector55:
  pushl $0
  10209c:	6a 00                	push   $0x0
  pushl $55
  10209e:	6a 37                	push   $0x37
  jmp __alltraps
  1020a0:	e9 88 08 00 00       	jmp    10292d <__alltraps>

001020a5 <vector56>:
.globl vector56
vector56:
  pushl $0
  1020a5:	6a 00                	push   $0x0
  pushl $56
  1020a7:	6a 38                	push   $0x38
  jmp __alltraps
  1020a9:	e9 7f 08 00 00       	jmp    10292d <__alltraps>

001020ae <vector57>:
.globl vector57
vector57:
  pushl $0
  1020ae:	6a 00                	push   $0x0
  pushl $57
  1020b0:	6a 39                	push   $0x39
  jmp __alltraps
  1020b2:	e9 76 08 00 00       	jmp    10292d <__alltraps>

001020b7 <vector58>:
.globl vector58
vector58:
  pushl $0
  1020b7:	6a 00                	push   $0x0
  pushl $58
  1020b9:	6a 3a                	push   $0x3a
  jmp __alltraps
  1020bb:	e9 6d 08 00 00       	jmp    10292d <__alltraps>

001020c0 <vector59>:
.globl vector59
vector59:
  pushl $0
  1020c0:	6a 00                	push   $0x0
  pushl $59
  1020c2:	6a 3b                	push   $0x3b
  jmp __alltraps
  1020c4:	e9 64 08 00 00       	jmp    10292d <__alltraps>

001020c9 <vector60>:
.globl vector60
vector60:
  pushl $0
  1020c9:	6a 00                	push   $0x0
  pushl $60
  1020cb:	6a 3c                	push   $0x3c
  jmp __alltraps
  1020cd:	e9 5b 08 00 00       	jmp    10292d <__alltraps>

001020d2 <vector61>:
.globl vector61
vector61:
  pushl $0
  1020d2:	6a 00                	push   $0x0
  pushl $61
  1020d4:	6a 3d                	push   $0x3d
  jmp __alltraps
  1020d6:	e9 52 08 00 00       	jmp    10292d <__alltraps>

001020db <vector62>:
.globl vector62
vector62:
  pushl $0
  1020db:	6a 00                	push   $0x0
  pushl $62
  1020dd:	6a 3e                	push   $0x3e
  jmp __alltraps
  1020df:	e9 49 08 00 00       	jmp    10292d <__alltraps>

001020e4 <vector63>:
.globl vector63
vector63:
  pushl $0
  1020e4:	6a 00                	push   $0x0
  pushl $63
  1020e6:	6a 3f                	push   $0x3f
  jmp __alltraps
  1020e8:	e9 40 08 00 00       	jmp    10292d <__alltraps>

001020ed <vector64>:
.globl vector64
vector64:
  pushl $0
  1020ed:	6a 00                	push   $0x0
  pushl $64
  1020ef:	6a 40                	push   $0x40
  jmp __alltraps
  1020f1:	e9 37 08 00 00       	jmp    10292d <__alltraps>

001020f6 <vector65>:
.globl vector65
vector65:
  pushl $0
  1020f6:	6a 00                	push   $0x0
  pushl $65
  1020f8:	6a 41                	push   $0x41
  jmp __alltraps
  1020fa:	e9 2e 08 00 00       	jmp    10292d <__alltraps>

001020ff <vector66>:
.globl vector66
vector66:
  pushl $0
  1020ff:	6a 00                	push   $0x0
  pushl $66
  102101:	6a 42                	push   $0x42
  jmp __alltraps
  102103:	e9 25 08 00 00       	jmp    10292d <__alltraps>

00102108 <vector67>:
.globl vector67
vector67:
  pushl $0
  102108:	6a 00                	push   $0x0
  pushl $67
  10210a:	6a 43                	push   $0x43
  jmp __alltraps
  10210c:	e9 1c 08 00 00       	jmp    10292d <__alltraps>

00102111 <vector68>:
.globl vector68
vector68:
  pushl $0
  102111:	6a 00                	push   $0x0
  pushl $68
  102113:	6a 44                	push   $0x44
  jmp __alltraps
  102115:	e9 13 08 00 00       	jmp    10292d <__alltraps>

0010211a <vector69>:
.globl vector69
vector69:
  pushl $0
  10211a:	6a 00                	push   $0x0
  pushl $69
  10211c:	6a 45                	push   $0x45
  jmp __alltraps
  10211e:	e9 0a 08 00 00       	jmp    10292d <__alltraps>

00102123 <vector70>:
.globl vector70
vector70:
  pushl $0
  102123:	6a 00                	push   $0x0
  pushl $70
  102125:	6a 46                	push   $0x46
  jmp __alltraps
  102127:	e9 01 08 00 00       	jmp    10292d <__alltraps>

0010212c <vector71>:
.globl vector71
vector71:
  pushl $0
  10212c:	6a 00                	push   $0x0
  pushl $71
  10212e:	6a 47                	push   $0x47
  jmp __alltraps
  102130:	e9 f8 07 00 00       	jmp    10292d <__alltraps>

00102135 <vector72>:
.globl vector72
vector72:
  pushl $0
  102135:	6a 00                	push   $0x0
  pushl $72
  102137:	6a 48                	push   $0x48
  jmp __alltraps
  102139:	e9 ef 07 00 00       	jmp    10292d <__alltraps>

0010213e <vector73>:
.globl vector73
vector73:
  pushl $0
  10213e:	6a 00                	push   $0x0
  pushl $73
  102140:	6a 49                	push   $0x49
  jmp __alltraps
  102142:	e9 e6 07 00 00       	jmp    10292d <__alltraps>

00102147 <vector74>:
.globl vector74
vector74:
  pushl $0
  102147:	6a 00                	push   $0x0
  pushl $74
  102149:	6a 4a                	push   $0x4a
  jmp __alltraps
  10214b:	e9 dd 07 00 00       	jmp    10292d <__alltraps>

00102150 <vector75>:
.globl vector75
vector75:
  pushl $0
  102150:	6a 00                	push   $0x0
  pushl $75
  102152:	6a 4b                	push   $0x4b
  jmp __alltraps
  102154:	e9 d4 07 00 00       	jmp    10292d <__alltraps>

00102159 <vector76>:
.globl vector76
vector76:
  pushl $0
  102159:	6a 00                	push   $0x0
  pushl $76
  10215b:	6a 4c                	push   $0x4c
  jmp __alltraps
  10215d:	e9 cb 07 00 00       	jmp    10292d <__alltraps>

00102162 <vector77>:
.globl vector77
vector77:
  pushl $0
  102162:	6a 00                	push   $0x0
  pushl $77
  102164:	6a 4d                	push   $0x4d
  jmp __alltraps
  102166:	e9 c2 07 00 00       	jmp    10292d <__alltraps>

0010216b <vector78>:
.globl vector78
vector78:
  pushl $0
  10216b:	6a 00                	push   $0x0
  pushl $78
  10216d:	6a 4e                	push   $0x4e
  jmp __alltraps
  10216f:	e9 b9 07 00 00       	jmp    10292d <__alltraps>

00102174 <vector79>:
.globl vector79
vector79:
  pushl $0
  102174:	6a 00                	push   $0x0
  pushl $79
  102176:	6a 4f                	push   $0x4f
  jmp __alltraps
  102178:	e9 b0 07 00 00       	jmp    10292d <__alltraps>

0010217d <vector80>:
.globl vector80
vector80:
  pushl $0
  10217d:	6a 00                	push   $0x0
  pushl $80
  10217f:	6a 50                	push   $0x50
  jmp __alltraps
  102181:	e9 a7 07 00 00       	jmp    10292d <__alltraps>

00102186 <vector81>:
.globl vector81
vector81:
  pushl $0
  102186:	6a 00                	push   $0x0
  pushl $81
  102188:	6a 51                	push   $0x51
  jmp __alltraps
  10218a:	e9 9e 07 00 00       	jmp    10292d <__alltraps>

0010218f <vector82>:
.globl vector82
vector82:
  pushl $0
  10218f:	6a 00                	push   $0x0
  pushl $82
  102191:	6a 52                	push   $0x52
  jmp __alltraps
  102193:	e9 95 07 00 00       	jmp    10292d <__alltraps>

00102198 <vector83>:
.globl vector83
vector83:
  pushl $0
  102198:	6a 00                	push   $0x0
  pushl $83
  10219a:	6a 53                	push   $0x53
  jmp __alltraps
  10219c:	e9 8c 07 00 00       	jmp    10292d <__alltraps>

001021a1 <vector84>:
.globl vector84
vector84:
  pushl $0
  1021a1:	6a 00                	push   $0x0
  pushl $84
  1021a3:	6a 54                	push   $0x54
  jmp __alltraps
  1021a5:	e9 83 07 00 00       	jmp    10292d <__alltraps>

001021aa <vector85>:
.globl vector85
vector85:
  pushl $0
  1021aa:	6a 00                	push   $0x0
  pushl $85
  1021ac:	6a 55                	push   $0x55
  jmp __alltraps
  1021ae:	e9 7a 07 00 00       	jmp    10292d <__alltraps>

001021b3 <vector86>:
.globl vector86
vector86:
  pushl $0
  1021b3:	6a 00                	push   $0x0
  pushl $86
  1021b5:	6a 56                	push   $0x56
  jmp __alltraps
  1021b7:	e9 71 07 00 00       	jmp    10292d <__alltraps>

001021bc <vector87>:
.globl vector87
vector87:
  pushl $0
  1021bc:	6a 00                	push   $0x0
  pushl $87
  1021be:	6a 57                	push   $0x57
  jmp __alltraps
  1021c0:	e9 68 07 00 00       	jmp    10292d <__alltraps>

001021c5 <vector88>:
.globl vector88
vector88:
  pushl $0
  1021c5:	6a 00                	push   $0x0
  pushl $88
  1021c7:	6a 58                	push   $0x58
  jmp __alltraps
  1021c9:	e9 5f 07 00 00       	jmp    10292d <__alltraps>

001021ce <vector89>:
.globl vector89
vector89:
  pushl $0
  1021ce:	6a 00                	push   $0x0
  pushl $89
  1021d0:	6a 59                	push   $0x59
  jmp __alltraps
  1021d2:	e9 56 07 00 00       	jmp    10292d <__alltraps>

001021d7 <vector90>:
.globl vector90
vector90:
  pushl $0
  1021d7:	6a 00                	push   $0x0
  pushl $90
  1021d9:	6a 5a                	push   $0x5a
  jmp __alltraps
  1021db:	e9 4d 07 00 00       	jmp    10292d <__alltraps>

001021e0 <vector91>:
.globl vector91
vector91:
  pushl $0
  1021e0:	6a 00                	push   $0x0
  pushl $91
  1021e2:	6a 5b                	push   $0x5b
  jmp __alltraps
  1021e4:	e9 44 07 00 00       	jmp    10292d <__alltraps>

001021e9 <vector92>:
.globl vector92
vector92:
  pushl $0
  1021e9:	6a 00                	push   $0x0
  pushl $92
  1021eb:	6a 5c                	push   $0x5c
  jmp __alltraps
  1021ed:	e9 3b 07 00 00       	jmp    10292d <__alltraps>

001021f2 <vector93>:
.globl vector93
vector93:
  pushl $0
  1021f2:	6a 00                	push   $0x0
  pushl $93
  1021f4:	6a 5d                	push   $0x5d
  jmp __alltraps
  1021f6:	e9 32 07 00 00       	jmp    10292d <__alltraps>

001021fb <vector94>:
.globl vector94
vector94:
  pushl $0
  1021fb:	6a 00                	push   $0x0
  pushl $94
  1021fd:	6a 5e                	push   $0x5e
  jmp __alltraps
  1021ff:	e9 29 07 00 00       	jmp    10292d <__alltraps>

00102204 <vector95>:
.globl vector95
vector95:
  pushl $0
  102204:	6a 00                	push   $0x0
  pushl $95
  102206:	6a 5f                	push   $0x5f
  jmp __alltraps
  102208:	e9 20 07 00 00       	jmp    10292d <__alltraps>

0010220d <vector96>:
.globl vector96
vector96:
  pushl $0
  10220d:	6a 00                	push   $0x0
  pushl $96
  10220f:	6a 60                	push   $0x60
  jmp __alltraps
  102211:	e9 17 07 00 00       	jmp    10292d <__alltraps>

00102216 <vector97>:
.globl vector97
vector97:
  pushl $0
  102216:	6a 00                	push   $0x0
  pushl $97
  102218:	6a 61                	push   $0x61
  jmp __alltraps
  10221a:	e9 0e 07 00 00       	jmp    10292d <__alltraps>

0010221f <vector98>:
.globl vector98
vector98:
  pushl $0
  10221f:	6a 00                	push   $0x0
  pushl $98
  102221:	6a 62                	push   $0x62
  jmp __alltraps
  102223:	e9 05 07 00 00       	jmp    10292d <__alltraps>

00102228 <vector99>:
.globl vector99
vector99:
  pushl $0
  102228:	6a 00                	push   $0x0
  pushl $99
  10222a:	6a 63                	push   $0x63
  jmp __alltraps
  10222c:	e9 fc 06 00 00       	jmp    10292d <__alltraps>

00102231 <vector100>:
.globl vector100
vector100:
  pushl $0
  102231:	6a 00                	push   $0x0
  pushl $100
  102233:	6a 64                	push   $0x64
  jmp __alltraps
  102235:	e9 f3 06 00 00       	jmp    10292d <__alltraps>

0010223a <vector101>:
.globl vector101
vector101:
  pushl $0
  10223a:	6a 00                	push   $0x0
  pushl $101
  10223c:	6a 65                	push   $0x65
  jmp __alltraps
  10223e:	e9 ea 06 00 00       	jmp    10292d <__alltraps>

00102243 <vector102>:
.globl vector102
vector102:
  pushl $0
  102243:	6a 00                	push   $0x0
  pushl $102
  102245:	6a 66                	push   $0x66
  jmp __alltraps
  102247:	e9 e1 06 00 00       	jmp    10292d <__alltraps>

0010224c <vector103>:
.globl vector103
vector103:
  pushl $0
  10224c:	6a 00                	push   $0x0
  pushl $103
  10224e:	6a 67                	push   $0x67
  jmp __alltraps
  102250:	e9 d8 06 00 00       	jmp    10292d <__alltraps>

00102255 <vector104>:
.globl vector104
vector104:
  pushl $0
  102255:	6a 00                	push   $0x0
  pushl $104
  102257:	6a 68                	push   $0x68
  jmp __alltraps
  102259:	e9 cf 06 00 00       	jmp    10292d <__alltraps>

0010225e <vector105>:
.globl vector105
vector105:
  pushl $0
  10225e:	6a 00                	push   $0x0
  pushl $105
  102260:	6a 69                	push   $0x69
  jmp __alltraps
  102262:	e9 c6 06 00 00       	jmp    10292d <__alltraps>

00102267 <vector106>:
.globl vector106
vector106:
  pushl $0
  102267:	6a 00                	push   $0x0
  pushl $106
  102269:	6a 6a                	push   $0x6a
  jmp __alltraps
  10226b:	e9 bd 06 00 00       	jmp    10292d <__alltraps>

00102270 <vector107>:
.globl vector107
vector107:
  pushl $0
  102270:	6a 00                	push   $0x0
  pushl $107
  102272:	6a 6b                	push   $0x6b
  jmp __alltraps
  102274:	e9 b4 06 00 00       	jmp    10292d <__alltraps>

00102279 <vector108>:
.globl vector108
vector108:
  pushl $0
  102279:	6a 00                	push   $0x0
  pushl $108
  10227b:	6a 6c                	push   $0x6c
  jmp __alltraps
  10227d:	e9 ab 06 00 00       	jmp    10292d <__alltraps>

00102282 <vector109>:
.globl vector109
vector109:
  pushl $0
  102282:	6a 00                	push   $0x0
  pushl $109
  102284:	6a 6d                	push   $0x6d
  jmp __alltraps
  102286:	e9 a2 06 00 00       	jmp    10292d <__alltraps>

0010228b <vector110>:
.globl vector110
vector110:
  pushl $0
  10228b:	6a 00                	push   $0x0
  pushl $110
  10228d:	6a 6e                	push   $0x6e
  jmp __alltraps
  10228f:	e9 99 06 00 00       	jmp    10292d <__alltraps>

00102294 <vector111>:
.globl vector111
vector111:
  pushl $0
  102294:	6a 00                	push   $0x0
  pushl $111
  102296:	6a 6f                	push   $0x6f
  jmp __alltraps
  102298:	e9 90 06 00 00       	jmp    10292d <__alltraps>

0010229d <vector112>:
.globl vector112
vector112:
  pushl $0
  10229d:	6a 00                	push   $0x0
  pushl $112
  10229f:	6a 70                	push   $0x70
  jmp __alltraps
  1022a1:	e9 87 06 00 00       	jmp    10292d <__alltraps>

001022a6 <vector113>:
.globl vector113
vector113:
  pushl $0
  1022a6:	6a 00                	push   $0x0
  pushl $113
  1022a8:	6a 71                	push   $0x71
  jmp __alltraps
  1022aa:	e9 7e 06 00 00       	jmp    10292d <__alltraps>

001022af <vector114>:
.globl vector114
vector114:
  pushl $0
  1022af:	6a 00                	push   $0x0
  pushl $114
  1022b1:	6a 72                	push   $0x72
  jmp __alltraps
  1022b3:	e9 75 06 00 00       	jmp    10292d <__alltraps>

001022b8 <vector115>:
.globl vector115
vector115:
  pushl $0
  1022b8:	6a 00                	push   $0x0
  pushl $115
  1022ba:	6a 73                	push   $0x73
  jmp __alltraps
  1022bc:	e9 6c 06 00 00       	jmp    10292d <__alltraps>

001022c1 <vector116>:
.globl vector116
vector116:
  pushl $0
  1022c1:	6a 00                	push   $0x0
  pushl $116
  1022c3:	6a 74                	push   $0x74
  jmp __alltraps
  1022c5:	e9 63 06 00 00       	jmp    10292d <__alltraps>

001022ca <vector117>:
.globl vector117
vector117:
  pushl $0
  1022ca:	6a 00                	push   $0x0
  pushl $117
  1022cc:	6a 75                	push   $0x75
  jmp __alltraps
  1022ce:	e9 5a 06 00 00       	jmp    10292d <__alltraps>

001022d3 <vector118>:
.globl vector118
vector118:
  pushl $0
  1022d3:	6a 00                	push   $0x0
  pushl $118
  1022d5:	6a 76                	push   $0x76
  jmp __alltraps
  1022d7:	e9 51 06 00 00       	jmp    10292d <__alltraps>

001022dc <vector119>:
.globl vector119
vector119:
  pushl $0
  1022dc:	6a 00                	push   $0x0
  pushl $119
  1022de:	6a 77                	push   $0x77
  jmp __alltraps
  1022e0:	e9 48 06 00 00       	jmp    10292d <__alltraps>

001022e5 <vector120>:
.globl vector120
vector120:
  pushl $0
  1022e5:	6a 00                	push   $0x0
  pushl $120
  1022e7:	6a 78                	push   $0x78
  jmp __alltraps
  1022e9:	e9 3f 06 00 00       	jmp    10292d <__alltraps>

001022ee <vector121>:
.globl vector121
vector121:
  pushl $0
  1022ee:	6a 00                	push   $0x0
  pushl $121
  1022f0:	6a 79                	push   $0x79
  jmp __alltraps
  1022f2:	e9 36 06 00 00       	jmp    10292d <__alltraps>

001022f7 <vector122>:
.globl vector122
vector122:
  pushl $0
  1022f7:	6a 00                	push   $0x0
  pushl $122
  1022f9:	6a 7a                	push   $0x7a
  jmp __alltraps
  1022fb:	e9 2d 06 00 00       	jmp    10292d <__alltraps>

00102300 <vector123>:
.globl vector123
vector123:
  pushl $0
  102300:	6a 00                	push   $0x0
  pushl $123
  102302:	6a 7b                	push   $0x7b
  jmp __alltraps
  102304:	e9 24 06 00 00       	jmp    10292d <__alltraps>

00102309 <vector124>:
.globl vector124
vector124:
  pushl $0
  102309:	6a 00                	push   $0x0
  pushl $124
  10230b:	6a 7c                	push   $0x7c
  jmp __alltraps
  10230d:	e9 1b 06 00 00       	jmp    10292d <__alltraps>

00102312 <vector125>:
.globl vector125
vector125:
  pushl $0
  102312:	6a 00                	push   $0x0
  pushl $125
  102314:	6a 7d                	push   $0x7d
  jmp __alltraps
  102316:	e9 12 06 00 00       	jmp    10292d <__alltraps>

0010231b <vector126>:
.globl vector126
vector126:
  pushl $0
  10231b:	6a 00                	push   $0x0
  pushl $126
  10231d:	6a 7e                	push   $0x7e
  jmp __alltraps
  10231f:	e9 09 06 00 00       	jmp    10292d <__alltraps>

00102324 <vector127>:
.globl vector127
vector127:
  pushl $0
  102324:	6a 00                	push   $0x0
  pushl $127
  102326:	6a 7f                	push   $0x7f
  jmp __alltraps
  102328:	e9 00 06 00 00       	jmp    10292d <__alltraps>

0010232d <vector128>:
.globl vector128
vector128:
  pushl $0
  10232d:	6a 00                	push   $0x0
  pushl $128
  10232f:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102334:	e9 f4 05 00 00       	jmp    10292d <__alltraps>

00102339 <vector129>:
.globl vector129
vector129:
  pushl $0
  102339:	6a 00                	push   $0x0
  pushl $129
  10233b:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102340:	e9 e8 05 00 00       	jmp    10292d <__alltraps>

00102345 <vector130>:
.globl vector130
vector130:
  pushl $0
  102345:	6a 00                	push   $0x0
  pushl $130
  102347:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  10234c:	e9 dc 05 00 00       	jmp    10292d <__alltraps>

00102351 <vector131>:
.globl vector131
vector131:
  pushl $0
  102351:	6a 00                	push   $0x0
  pushl $131
  102353:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102358:	e9 d0 05 00 00       	jmp    10292d <__alltraps>

0010235d <vector132>:
.globl vector132
vector132:
  pushl $0
  10235d:	6a 00                	push   $0x0
  pushl $132
  10235f:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102364:	e9 c4 05 00 00       	jmp    10292d <__alltraps>

00102369 <vector133>:
.globl vector133
vector133:
  pushl $0
  102369:	6a 00                	push   $0x0
  pushl $133
  10236b:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102370:	e9 b8 05 00 00       	jmp    10292d <__alltraps>

00102375 <vector134>:
.globl vector134
vector134:
  pushl $0
  102375:	6a 00                	push   $0x0
  pushl $134
  102377:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  10237c:	e9 ac 05 00 00       	jmp    10292d <__alltraps>

00102381 <vector135>:
.globl vector135
vector135:
  pushl $0
  102381:	6a 00                	push   $0x0
  pushl $135
  102383:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102388:	e9 a0 05 00 00       	jmp    10292d <__alltraps>

0010238d <vector136>:
.globl vector136
vector136:
  pushl $0
  10238d:	6a 00                	push   $0x0
  pushl $136
  10238f:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102394:	e9 94 05 00 00       	jmp    10292d <__alltraps>

00102399 <vector137>:
.globl vector137
vector137:
  pushl $0
  102399:	6a 00                	push   $0x0
  pushl $137
  10239b:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1023a0:	e9 88 05 00 00       	jmp    10292d <__alltraps>

001023a5 <vector138>:
.globl vector138
vector138:
  pushl $0
  1023a5:	6a 00                	push   $0x0
  pushl $138
  1023a7:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1023ac:	e9 7c 05 00 00       	jmp    10292d <__alltraps>

001023b1 <vector139>:
.globl vector139
vector139:
  pushl $0
  1023b1:	6a 00                	push   $0x0
  pushl $139
  1023b3:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1023b8:	e9 70 05 00 00       	jmp    10292d <__alltraps>

001023bd <vector140>:
.globl vector140
vector140:
  pushl $0
  1023bd:	6a 00                	push   $0x0
  pushl $140
  1023bf:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1023c4:	e9 64 05 00 00       	jmp    10292d <__alltraps>

001023c9 <vector141>:
.globl vector141
vector141:
  pushl $0
  1023c9:	6a 00                	push   $0x0
  pushl $141
  1023cb:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1023d0:	e9 58 05 00 00       	jmp    10292d <__alltraps>

001023d5 <vector142>:
.globl vector142
vector142:
  pushl $0
  1023d5:	6a 00                	push   $0x0
  pushl $142
  1023d7:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1023dc:	e9 4c 05 00 00       	jmp    10292d <__alltraps>

001023e1 <vector143>:
.globl vector143
vector143:
  pushl $0
  1023e1:	6a 00                	push   $0x0
  pushl $143
  1023e3:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1023e8:	e9 40 05 00 00       	jmp    10292d <__alltraps>

001023ed <vector144>:
.globl vector144
vector144:
  pushl $0
  1023ed:	6a 00                	push   $0x0
  pushl $144
  1023ef:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1023f4:	e9 34 05 00 00       	jmp    10292d <__alltraps>

001023f9 <vector145>:
.globl vector145
vector145:
  pushl $0
  1023f9:	6a 00                	push   $0x0
  pushl $145
  1023fb:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102400:	e9 28 05 00 00       	jmp    10292d <__alltraps>

00102405 <vector146>:
.globl vector146
vector146:
  pushl $0
  102405:	6a 00                	push   $0x0
  pushl $146
  102407:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  10240c:	e9 1c 05 00 00       	jmp    10292d <__alltraps>

00102411 <vector147>:
.globl vector147
vector147:
  pushl $0
  102411:	6a 00                	push   $0x0
  pushl $147
  102413:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102418:	e9 10 05 00 00       	jmp    10292d <__alltraps>

0010241d <vector148>:
.globl vector148
vector148:
  pushl $0
  10241d:	6a 00                	push   $0x0
  pushl $148
  10241f:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102424:	e9 04 05 00 00       	jmp    10292d <__alltraps>

00102429 <vector149>:
.globl vector149
vector149:
  pushl $0
  102429:	6a 00                	push   $0x0
  pushl $149
  10242b:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102430:	e9 f8 04 00 00       	jmp    10292d <__alltraps>

00102435 <vector150>:
.globl vector150
vector150:
  pushl $0
  102435:	6a 00                	push   $0x0
  pushl $150
  102437:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  10243c:	e9 ec 04 00 00       	jmp    10292d <__alltraps>

00102441 <vector151>:
.globl vector151
vector151:
  pushl $0
  102441:	6a 00                	push   $0x0
  pushl $151
  102443:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102448:	e9 e0 04 00 00       	jmp    10292d <__alltraps>

0010244d <vector152>:
.globl vector152
vector152:
  pushl $0
  10244d:	6a 00                	push   $0x0
  pushl $152
  10244f:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102454:	e9 d4 04 00 00       	jmp    10292d <__alltraps>

00102459 <vector153>:
.globl vector153
vector153:
  pushl $0
  102459:	6a 00                	push   $0x0
  pushl $153
  10245b:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102460:	e9 c8 04 00 00       	jmp    10292d <__alltraps>

00102465 <vector154>:
.globl vector154
vector154:
  pushl $0
  102465:	6a 00                	push   $0x0
  pushl $154
  102467:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10246c:	e9 bc 04 00 00       	jmp    10292d <__alltraps>

00102471 <vector155>:
.globl vector155
vector155:
  pushl $0
  102471:	6a 00                	push   $0x0
  pushl $155
  102473:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102478:	e9 b0 04 00 00       	jmp    10292d <__alltraps>

0010247d <vector156>:
.globl vector156
vector156:
  pushl $0
  10247d:	6a 00                	push   $0x0
  pushl $156
  10247f:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102484:	e9 a4 04 00 00       	jmp    10292d <__alltraps>

00102489 <vector157>:
.globl vector157
vector157:
  pushl $0
  102489:	6a 00                	push   $0x0
  pushl $157
  10248b:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102490:	e9 98 04 00 00       	jmp    10292d <__alltraps>

00102495 <vector158>:
.globl vector158
vector158:
  pushl $0
  102495:	6a 00                	push   $0x0
  pushl $158
  102497:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  10249c:	e9 8c 04 00 00       	jmp    10292d <__alltraps>

001024a1 <vector159>:
.globl vector159
vector159:
  pushl $0
  1024a1:	6a 00                	push   $0x0
  pushl $159
  1024a3:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1024a8:	e9 80 04 00 00       	jmp    10292d <__alltraps>

001024ad <vector160>:
.globl vector160
vector160:
  pushl $0
  1024ad:	6a 00                	push   $0x0
  pushl $160
  1024af:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1024b4:	e9 74 04 00 00       	jmp    10292d <__alltraps>

001024b9 <vector161>:
.globl vector161
vector161:
  pushl $0
  1024b9:	6a 00                	push   $0x0
  pushl $161
  1024bb:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1024c0:	e9 68 04 00 00       	jmp    10292d <__alltraps>

001024c5 <vector162>:
.globl vector162
vector162:
  pushl $0
  1024c5:	6a 00                	push   $0x0
  pushl $162
  1024c7:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1024cc:	e9 5c 04 00 00       	jmp    10292d <__alltraps>

001024d1 <vector163>:
.globl vector163
vector163:
  pushl $0
  1024d1:	6a 00                	push   $0x0
  pushl $163
  1024d3:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1024d8:	e9 50 04 00 00       	jmp    10292d <__alltraps>

001024dd <vector164>:
.globl vector164
vector164:
  pushl $0
  1024dd:	6a 00                	push   $0x0
  pushl $164
  1024df:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1024e4:	e9 44 04 00 00       	jmp    10292d <__alltraps>

001024e9 <vector165>:
.globl vector165
vector165:
  pushl $0
  1024e9:	6a 00                	push   $0x0
  pushl $165
  1024eb:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1024f0:	e9 38 04 00 00       	jmp    10292d <__alltraps>

001024f5 <vector166>:
.globl vector166
vector166:
  pushl $0
  1024f5:	6a 00                	push   $0x0
  pushl $166
  1024f7:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1024fc:	e9 2c 04 00 00       	jmp    10292d <__alltraps>

00102501 <vector167>:
.globl vector167
vector167:
  pushl $0
  102501:	6a 00                	push   $0x0
  pushl $167
  102503:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102508:	e9 20 04 00 00       	jmp    10292d <__alltraps>

0010250d <vector168>:
.globl vector168
vector168:
  pushl $0
  10250d:	6a 00                	push   $0x0
  pushl $168
  10250f:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102514:	e9 14 04 00 00       	jmp    10292d <__alltraps>

00102519 <vector169>:
.globl vector169
vector169:
  pushl $0
  102519:	6a 00                	push   $0x0
  pushl $169
  10251b:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102520:	e9 08 04 00 00       	jmp    10292d <__alltraps>

00102525 <vector170>:
.globl vector170
vector170:
  pushl $0
  102525:	6a 00                	push   $0x0
  pushl $170
  102527:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10252c:	e9 fc 03 00 00       	jmp    10292d <__alltraps>

00102531 <vector171>:
.globl vector171
vector171:
  pushl $0
  102531:	6a 00                	push   $0x0
  pushl $171
  102533:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102538:	e9 f0 03 00 00       	jmp    10292d <__alltraps>

0010253d <vector172>:
.globl vector172
vector172:
  pushl $0
  10253d:	6a 00                	push   $0x0
  pushl $172
  10253f:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102544:	e9 e4 03 00 00       	jmp    10292d <__alltraps>

00102549 <vector173>:
.globl vector173
vector173:
  pushl $0
  102549:	6a 00                	push   $0x0
  pushl $173
  10254b:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102550:	e9 d8 03 00 00       	jmp    10292d <__alltraps>

00102555 <vector174>:
.globl vector174
vector174:
  pushl $0
  102555:	6a 00                	push   $0x0
  pushl $174
  102557:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  10255c:	e9 cc 03 00 00       	jmp    10292d <__alltraps>

00102561 <vector175>:
.globl vector175
vector175:
  pushl $0
  102561:	6a 00                	push   $0x0
  pushl $175
  102563:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102568:	e9 c0 03 00 00       	jmp    10292d <__alltraps>

0010256d <vector176>:
.globl vector176
vector176:
  pushl $0
  10256d:	6a 00                	push   $0x0
  pushl $176
  10256f:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102574:	e9 b4 03 00 00       	jmp    10292d <__alltraps>

00102579 <vector177>:
.globl vector177
vector177:
  pushl $0
  102579:	6a 00                	push   $0x0
  pushl $177
  10257b:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102580:	e9 a8 03 00 00       	jmp    10292d <__alltraps>

00102585 <vector178>:
.globl vector178
vector178:
  pushl $0
  102585:	6a 00                	push   $0x0
  pushl $178
  102587:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  10258c:	e9 9c 03 00 00       	jmp    10292d <__alltraps>

00102591 <vector179>:
.globl vector179
vector179:
  pushl $0
  102591:	6a 00                	push   $0x0
  pushl $179
  102593:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102598:	e9 90 03 00 00       	jmp    10292d <__alltraps>

0010259d <vector180>:
.globl vector180
vector180:
  pushl $0
  10259d:	6a 00                	push   $0x0
  pushl $180
  10259f:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1025a4:	e9 84 03 00 00       	jmp    10292d <__alltraps>

001025a9 <vector181>:
.globl vector181
vector181:
  pushl $0
  1025a9:	6a 00                	push   $0x0
  pushl $181
  1025ab:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1025b0:	e9 78 03 00 00       	jmp    10292d <__alltraps>

001025b5 <vector182>:
.globl vector182
vector182:
  pushl $0
  1025b5:	6a 00                	push   $0x0
  pushl $182
  1025b7:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1025bc:	e9 6c 03 00 00       	jmp    10292d <__alltraps>

001025c1 <vector183>:
.globl vector183
vector183:
  pushl $0
  1025c1:	6a 00                	push   $0x0
  pushl $183
  1025c3:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1025c8:	e9 60 03 00 00       	jmp    10292d <__alltraps>

001025cd <vector184>:
.globl vector184
vector184:
  pushl $0
  1025cd:	6a 00                	push   $0x0
  pushl $184
  1025cf:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1025d4:	e9 54 03 00 00       	jmp    10292d <__alltraps>

001025d9 <vector185>:
.globl vector185
vector185:
  pushl $0
  1025d9:	6a 00                	push   $0x0
  pushl $185
  1025db:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1025e0:	e9 48 03 00 00       	jmp    10292d <__alltraps>

001025e5 <vector186>:
.globl vector186
vector186:
  pushl $0
  1025e5:	6a 00                	push   $0x0
  pushl $186
  1025e7:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1025ec:	e9 3c 03 00 00       	jmp    10292d <__alltraps>

001025f1 <vector187>:
.globl vector187
vector187:
  pushl $0
  1025f1:	6a 00                	push   $0x0
  pushl $187
  1025f3:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1025f8:	e9 30 03 00 00       	jmp    10292d <__alltraps>

001025fd <vector188>:
.globl vector188
vector188:
  pushl $0
  1025fd:	6a 00                	push   $0x0
  pushl $188
  1025ff:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102604:	e9 24 03 00 00       	jmp    10292d <__alltraps>

00102609 <vector189>:
.globl vector189
vector189:
  pushl $0
  102609:	6a 00                	push   $0x0
  pushl $189
  10260b:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102610:	e9 18 03 00 00       	jmp    10292d <__alltraps>

00102615 <vector190>:
.globl vector190
vector190:
  pushl $0
  102615:	6a 00                	push   $0x0
  pushl $190
  102617:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  10261c:	e9 0c 03 00 00       	jmp    10292d <__alltraps>

00102621 <vector191>:
.globl vector191
vector191:
  pushl $0
  102621:	6a 00                	push   $0x0
  pushl $191
  102623:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102628:	e9 00 03 00 00       	jmp    10292d <__alltraps>

0010262d <vector192>:
.globl vector192
vector192:
  pushl $0
  10262d:	6a 00                	push   $0x0
  pushl $192
  10262f:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102634:	e9 f4 02 00 00       	jmp    10292d <__alltraps>

00102639 <vector193>:
.globl vector193
vector193:
  pushl $0
  102639:	6a 00                	push   $0x0
  pushl $193
  10263b:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102640:	e9 e8 02 00 00       	jmp    10292d <__alltraps>

00102645 <vector194>:
.globl vector194
vector194:
  pushl $0
  102645:	6a 00                	push   $0x0
  pushl $194
  102647:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  10264c:	e9 dc 02 00 00       	jmp    10292d <__alltraps>

00102651 <vector195>:
.globl vector195
vector195:
  pushl $0
  102651:	6a 00                	push   $0x0
  pushl $195
  102653:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102658:	e9 d0 02 00 00       	jmp    10292d <__alltraps>

0010265d <vector196>:
.globl vector196
vector196:
  pushl $0
  10265d:	6a 00                	push   $0x0
  pushl $196
  10265f:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102664:	e9 c4 02 00 00       	jmp    10292d <__alltraps>

00102669 <vector197>:
.globl vector197
vector197:
  pushl $0
  102669:	6a 00                	push   $0x0
  pushl $197
  10266b:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102670:	e9 b8 02 00 00       	jmp    10292d <__alltraps>

00102675 <vector198>:
.globl vector198
vector198:
  pushl $0
  102675:	6a 00                	push   $0x0
  pushl $198
  102677:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  10267c:	e9 ac 02 00 00       	jmp    10292d <__alltraps>

00102681 <vector199>:
.globl vector199
vector199:
  pushl $0
  102681:	6a 00                	push   $0x0
  pushl $199
  102683:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102688:	e9 a0 02 00 00       	jmp    10292d <__alltraps>

0010268d <vector200>:
.globl vector200
vector200:
  pushl $0
  10268d:	6a 00                	push   $0x0
  pushl $200
  10268f:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102694:	e9 94 02 00 00       	jmp    10292d <__alltraps>

00102699 <vector201>:
.globl vector201
vector201:
  pushl $0
  102699:	6a 00                	push   $0x0
  pushl $201
  10269b:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1026a0:	e9 88 02 00 00       	jmp    10292d <__alltraps>

001026a5 <vector202>:
.globl vector202
vector202:
  pushl $0
  1026a5:	6a 00                	push   $0x0
  pushl $202
  1026a7:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1026ac:	e9 7c 02 00 00       	jmp    10292d <__alltraps>

001026b1 <vector203>:
.globl vector203
vector203:
  pushl $0
  1026b1:	6a 00                	push   $0x0
  pushl $203
  1026b3:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1026b8:	e9 70 02 00 00       	jmp    10292d <__alltraps>

001026bd <vector204>:
.globl vector204
vector204:
  pushl $0
  1026bd:	6a 00                	push   $0x0
  pushl $204
  1026bf:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1026c4:	e9 64 02 00 00       	jmp    10292d <__alltraps>

001026c9 <vector205>:
.globl vector205
vector205:
  pushl $0
  1026c9:	6a 00                	push   $0x0
  pushl $205
  1026cb:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1026d0:	e9 58 02 00 00       	jmp    10292d <__alltraps>

001026d5 <vector206>:
.globl vector206
vector206:
  pushl $0
  1026d5:	6a 00                	push   $0x0
  pushl $206
  1026d7:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1026dc:	e9 4c 02 00 00       	jmp    10292d <__alltraps>

001026e1 <vector207>:
.globl vector207
vector207:
  pushl $0
  1026e1:	6a 00                	push   $0x0
  pushl $207
  1026e3:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1026e8:	e9 40 02 00 00       	jmp    10292d <__alltraps>

001026ed <vector208>:
.globl vector208
vector208:
  pushl $0
  1026ed:	6a 00                	push   $0x0
  pushl $208
  1026ef:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1026f4:	e9 34 02 00 00       	jmp    10292d <__alltraps>

001026f9 <vector209>:
.globl vector209
vector209:
  pushl $0
  1026f9:	6a 00                	push   $0x0
  pushl $209
  1026fb:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102700:	e9 28 02 00 00       	jmp    10292d <__alltraps>

00102705 <vector210>:
.globl vector210
vector210:
  pushl $0
  102705:	6a 00                	push   $0x0
  pushl $210
  102707:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  10270c:	e9 1c 02 00 00       	jmp    10292d <__alltraps>

00102711 <vector211>:
.globl vector211
vector211:
  pushl $0
  102711:	6a 00                	push   $0x0
  pushl $211
  102713:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102718:	e9 10 02 00 00       	jmp    10292d <__alltraps>

0010271d <vector212>:
.globl vector212
vector212:
  pushl $0
  10271d:	6a 00                	push   $0x0
  pushl $212
  10271f:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102724:	e9 04 02 00 00       	jmp    10292d <__alltraps>

00102729 <vector213>:
.globl vector213
vector213:
  pushl $0
  102729:	6a 00                	push   $0x0
  pushl $213
  10272b:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102730:	e9 f8 01 00 00       	jmp    10292d <__alltraps>

00102735 <vector214>:
.globl vector214
vector214:
  pushl $0
  102735:	6a 00                	push   $0x0
  pushl $214
  102737:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  10273c:	e9 ec 01 00 00       	jmp    10292d <__alltraps>

00102741 <vector215>:
.globl vector215
vector215:
  pushl $0
  102741:	6a 00                	push   $0x0
  pushl $215
  102743:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102748:	e9 e0 01 00 00       	jmp    10292d <__alltraps>

0010274d <vector216>:
.globl vector216
vector216:
  pushl $0
  10274d:	6a 00                	push   $0x0
  pushl $216
  10274f:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102754:	e9 d4 01 00 00       	jmp    10292d <__alltraps>

00102759 <vector217>:
.globl vector217
vector217:
  pushl $0
  102759:	6a 00                	push   $0x0
  pushl $217
  10275b:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102760:	e9 c8 01 00 00       	jmp    10292d <__alltraps>

00102765 <vector218>:
.globl vector218
vector218:
  pushl $0
  102765:	6a 00                	push   $0x0
  pushl $218
  102767:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  10276c:	e9 bc 01 00 00       	jmp    10292d <__alltraps>

00102771 <vector219>:
.globl vector219
vector219:
  pushl $0
  102771:	6a 00                	push   $0x0
  pushl $219
  102773:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102778:	e9 b0 01 00 00       	jmp    10292d <__alltraps>

0010277d <vector220>:
.globl vector220
vector220:
  pushl $0
  10277d:	6a 00                	push   $0x0
  pushl $220
  10277f:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102784:	e9 a4 01 00 00       	jmp    10292d <__alltraps>

00102789 <vector221>:
.globl vector221
vector221:
  pushl $0
  102789:	6a 00                	push   $0x0
  pushl $221
  10278b:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102790:	e9 98 01 00 00       	jmp    10292d <__alltraps>

00102795 <vector222>:
.globl vector222
vector222:
  pushl $0
  102795:	6a 00                	push   $0x0
  pushl $222
  102797:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  10279c:	e9 8c 01 00 00       	jmp    10292d <__alltraps>

001027a1 <vector223>:
.globl vector223
vector223:
  pushl $0
  1027a1:	6a 00                	push   $0x0
  pushl $223
  1027a3:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1027a8:	e9 80 01 00 00       	jmp    10292d <__alltraps>

001027ad <vector224>:
.globl vector224
vector224:
  pushl $0
  1027ad:	6a 00                	push   $0x0
  pushl $224
  1027af:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1027b4:	e9 74 01 00 00       	jmp    10292d <__alltraps>

001027b9 <vector225>:
.globl vector225
vector225:
  pushl $0
  1027b9:	6a 00                	push   $0x0
  pushl $225
  1027bb:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1027c0:	e9 68 01 00 00       	jmp    10292d <__alltraps>

001027c5 <vector226>:
.globl vector226
vector226:
  pushl $0
  1027c5:	6a 00                	push   $0x0
  pushl $226
  1027c7:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1027cc:	e9 5c 01 00 00       	jmp    10292d <__alltraps>

001027d1 <vector227>:
.globl vector227
vector227:
  pushl $0
  1027d1:	6a 00                	push   $0x0
  pushl $227
  1027d3:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1027d8:	e9 50 01 00 00       	jmp    10292d <__alltraps>

001027dd <vector228>:
.globl vector228
vector228:
  pushl $0
  1027dd:	6a 00                	push   $0x0
  pushl $228
  1027df:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1027e4:	e9 44 01 00 00       	jmp    10292d <__alltraps>

001027e9 <vector229>:
.globl vector229
vector229:
  pushl $0
  1027e9:	6a 00                	push   $0x0
  pushl $229
  1027eb:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1027f0:	e9 38 01 00 00       	jmp    10292d <__alltraps>

001027f5 <vector230>:
.globl vector230
vector230:
  pushl $0
  1027f5:	6a 00                	push   $0x0
  pushl $230
  1027f7:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1027fc:	e9 2c 01 00 00       	jmp    10292d <__alltraps>

00102801 <vector231>:
.globl vector231
vector231:
  pushl $0
  102801:	6a 00                	push   $0x0
  pushl $231
  102803:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102808:	e9 20 01 00 00       	jmp    10292d <__alltraps>

0010280d <vector232>:
.globl vector232
vector232:
  pushl $0
  10280d:	6a 00                	push   $0x0
  pushl $232
  10280f:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102814:	e9 14 01 00 00       	jmp    10292d <__alltraps>

00102819 <vector233>:
.globl vector233
vector233:
  pushl $0
  102819:	6a 00                	push   $0x0
  pushl $233
  10281b:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102820:	e9 08 01 00 00       	jmp    10292d <__alltraps>

00102825 <vector234>:
.globl vector234
vector234:
  pushl $0
  102825:	6a 00                	push   $0x0
  pushl $234
  102827:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  10282c:	e9 fc 00 00 00       	jmp    10292d <__alltraps>

00102831 <vector235>:
.globl vector235
vector235:
  pushl $0
  102831:	6a 00                	push   $0x0
  pushl $235
  102833:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102838:	e9 f0 00 00 00       	jmp    10292d <__alltraps>

0010283d <vector236>:
.globl vector236
vector236:
  pushl $0
  10283d:	6a 00                	push   $0x0
  pushl $236
  10283f:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102844:	e9 e4 00 00 00       	jmp    10292d <__alltraps>

00102849 <vector237>:
.globl vector237
vector237:
  pushl $0
  102849:	6a 00                	push   $0x0
  pushl $237
  10284b:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102850:	e9 d8 00 00 00       	jmp    10292d <__alltraps>

00102855 <vector238>:
.globl vector238
vector238:
  pushl $0
  102855:	6a 00                	push   $0x0
  pushl $238
  102857:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  10285c:	e9 cc 00 00 00       	jmp    10292d <__alltraps>

00102861 <vector239>:
.globl vector239
vector239:
  pushl $0
  102861:	6a 00                	push   $0x0
  pushl $239
  102863:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102868:	e9 c0 00 00 00       	jmp    10292d <__alltraps>

0010286d <vector240>:
.globl vector240
vector240:
  pushl $0
  10286d:	6a 00                	push   $0x0
  pushl $240
  10286f:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102874:	e9 b4 00 00 00       	jmp    10292d <__alltraps>

00102879 <vector241>:
.globl vector241
vector241:
  pushl $0
  102879:	6a 00                	push   $0x0
  pushl $241
  10287b:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102880:	e9 a8 00 00 00       	jmp    10292d <__alltraps>

00102885 <vector242>:
.globl vector242
vector242:
  pushl $0
  102885:	6a 00                	push   $0x0
  pushl $242
  102887:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  10288c:	e9 9c 00 00 00       	jmp    10292d <__alltraps>

00102891 <vector243>:
.globl vector243
vector243:
  pushl $0
  102891:	6a 00                	push   $0x0
  pushl $243
  102893:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102898:	e9 90 00 00 00       	jmp    10292d <__alltraps>

0010289d <vector244>:
.globl vector244
vector244:
  pushl $0
  10289d:	6a 00                	push   $0x0
  pushl $244
  10289f:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1028a4:	e9 84 00 00 00       	jmp    10292d <__alltraps>

001028a9 <vector245>:
.globl vector245
vector245:
  pushl $0
  1028a9:	6a 00                	push   $0x0
  pushl $245
  1028ab:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1028b0:	e9 78 00 00 00       	jmp    10292d <__alltraps>

001028b5 <vector246>:
.globl vector246
vector246:
  pushl $0
  1028b5:	6a 00                	push   $0x0
  pushl $246
  1028b7:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1028bc:	e9 6c 00 00 00       	jmp    10292d <__alltraps>

001028c1 <vector247>:
.globl vector247
vector247:
  pushl $0
  1028c1:	6a 00                	push   $0x0
  pushl $247
  1028c3:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1028c8:	e9 60 00 00 00       	jmp    10292d <__alltraps>

001028cd <vector248>:
.globl vector248
vector248:
  pushl $0
  1028cd:	6a 00                	push   $0x0
  pushl $248
  1028cf:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1028d4:	e9 54 00 00 00       	jmp    10292d <__alltraps>

001028d9 <vector249>:
.globl vector249
vector249:
  pushl $0
  1028d9:	6a 00                	push   $0x0
  pushl $249
  1028db:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1028e0:	e9 48 00 00 00       	jmp    10292d <__alltraps>

001028e5 <vector250>:
.globl vector250
vector250:
  pushl $0
  1028e5:	6a 00                	push   $0x0
  pushl $250
  1028e7:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1028ec:	e9 3c 00 00 00       	jmp    10292d <__alltraps>

001028f1 <vector251>:
.globl vector251
vector251:
  pushl $0
  1028f1:	6a 00                	push   $0x0
  pushl $251
  1028f3:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1028f8:	e9 30 00 00 00       	jmp    10292d <__alltraps>

001028fd <vector252>:
.globl vector252
vector252:
  pushl $0
  1028fd:	6a 00                	push   $0x0
  pushl $252
  1028ff:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102904:	e9 24 00 00 00       	jmp    10292d <__alltraps>

00102909 <vector253>:
.globl vector253
vector253:
  pushl $0
  102909:	6a 00                	push   $0x0
  pushl $253
  10290b:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102910:	e9 18 00 00 00       	jmp    10292d <__alltraps>

00102915 <vector254>:
.globl vector254
vector254:
  pushl $0
  102915:	6a 00                	push   $0x0
  pushl $254
  102917:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  10291c:	e9 0c 00 00 00       	jmp    10292d <__alltraps>

00102921 <vector255>:
.globl vector255
vector255:
  pushl $0
  102921:	6a 00                	push   $0x0
  pushl $255
  102923:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102928:	e9 00 00 00 00       	jmp    10292d <__alltraps>

0010292d <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  10292d:	1e                   	push   %ds
    pushl %es
  10292e:	06                   	push   %es
    pushl %fs
  10292f:	0f a0                	push   %fs
    pushl %gs
  102931:	0f a8                	push   %gs
    pushal
  102933:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102934:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102939:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10293b:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  10293d:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  10293e:	e8 63 f5 ff ff       	call   101ea6 <trap>

    # pop the pushed stack pointer
    popl %esp
  102943:	5c                   	pop    %esp

00102944 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102944:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102945:	0f a9                	pop    %gs
    popl %fs
  102947:	0f a1                	pop    %fs
    popl %es
  102949:	07                   	pop    %es
    popl %ds
  10294a:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  10294b:	83 c4 08             	add    $0x8,%esp
    iret
  10294e:	cf                   	iret   

0010294f <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  10294f:	55                   	push   %ebp
  102950:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102952:	8b 45 08             	mov    0x8(%ebp),%eax
  102955:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102958:	b8 23 00 00 00       	mov    $0x23,%eax
  10295d:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  10295f:	b8 23 00 00 00       	mov    $0x23,%eax
  102964:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102966:	b8 10 00 00 00       	mov    $0x10,%eax
  10296b:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  10296d:	b8 10 00 00 00       	mov    $0x10,%eax
  102972:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102974:	b8 10 00 00 00       	mov    $0x10,%eax
  102979:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  10297b:	ea 82 29 10 00 08 00 	ljmp   $0x8,$0x102982
}
  102982:	90                   	nop
  102983:	5d                   	pop    %ebp
  102984:	c3                   	ret    

00102985 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102985:	55                   	push   %ebp
  102986:	89 e5                	mov    %esp,%ebp
  102988:	83 ec 10             	sub    $0x10,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  10298b:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  102990:	05 00 04 00 00       	add    $0x400,%eax
  102995:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  10299a:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  1029a1:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  1029a3:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  1029aa:	68 00 
  1029ac:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1029b1:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  1029b7:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1029bc:	c1 e8 10             	shr    $0x10,%eax
  1029bf:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  1029c4:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1029cb:	83 e0 f0             	and    $0xfffffff0,%eax
  1029ce:	83 c8 09             	or     $0x9,%eax
  1029d1:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1029d6:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1029dd:	83 c8 10             	or     $0x10,%eax
  1029e0:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1029e5:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1029ec:	83 e0 9f             	and    $0xffffff9f,%eax
  1029ef:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1029f4:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1029fb:	83 c8 80             	or     $0xffffff80,%eax
  1029fe:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102a03:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a0a:	83 e0 f0             	and    $0xfffffff0,%eax
  102a0d:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a12:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a19:	83 e0 ef             	and    $0xffffffef,%eax
  102a1c:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a21:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a28:	83 e0 df             	and    $0xffffffdf,%eax
  102a2b:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a30:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a37:	83 c8 40             	or     $0x40,%eax
  102a3a:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a3f:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a46:	83 e0 7f             	and    $0x7f,%eax
  102a49:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a4e:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102a53:	c1 e8 18             	shr    $0x18,%eax
  102a56:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  102a5b:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102a62:	83 e0 ef             	and    $0xffffffef,%eax
  102a65:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102a6a:	68 10 ea 10 00       	push   $0x10ea10
  102a6f:	e8 db fe ff ff       	call   10294f <lgdt>
  102a74:	83 c4 04             	add    $0x4,%esp
  102a77:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102a7d:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102a81:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102a84:	90                   	nop
  102a85:	c9                   	leave  
  102a86:	c3                   	ret    

00102a87 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102a87:	55                   	push   %ebp
  102a88:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102a8a:	e8 f6 fe ff ff       	call   102985 <gdt_init>
}
  102a8f:	90                   	nop
  102a90:	5d                   	pop    %ebp
  102a91:	c3                   	ret    

00102a92 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102a92:	55                   	push   %ebp
  102a93:	89 e5                	mov    %esp,%ebp
  102a95:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102a98:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102a9f:	eb 04                	jmp    102aa5 <strlen+0x13>
        cnt ++;
  102aa1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (*s ++ != '\0') {
  102aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  102aa8:	8d 50 01             	lea    0x1(%eax),%edx
  102aab:	89 55 08             	mov    %edx,0x8(%ebp)
  102aae:	0f b6 00             	movzbl (%eax),%eax
  102ab1:	84 c0                	test   %al,%al
  102ab3:	75 ec                	jne    102aa1 <strlen+0xf>
    }
    return cnt;
  102ab5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102ab8:	c9                   	leave  
  102ab9:	c3                   	ret    

00102aba <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102aba:	55                   	push   %ebp
  102abb:	89 e5                	mov    %esp,%ebp
  102abd:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102ac0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102ac7:	eb 04                	jmp    102acd <strnlen+0x13>
        cnt ++;
  102ac9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102acd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102ad0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102ad3:	73 10                	jae    102ae5 <strnlen+0x2b>
  102ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  102ad8:	8d 50 01             	lea    0x1(%eax),%edx
  102adb:	89 55 08             	mov    %edx,0x8(%ebp)
  102ade:	0f b6 00             	movzbl (%eax),%eax
  102ae1:	84 c0                	test   %al,%al
  102ae3:	75 e4                	jne    102ac9 <strnlen+0xf>
    }
    return cnt;
  102ae5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102ae8:	c9                   	leave  
  102ae9:	c3                   	ret    

00102aea <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102aea:	55                   	push   %ebp
  102aeb:	89 e5                	mov    %esp,%ebp
  102aed:	57                   	push   %edi
  102aee:	56                   	push   %esi
  102aef:	83 ec 20             	sub    $0x20,%esp
  102af2:	8b 45 08             	mov    0x8(%ebp),%eax
  102af5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102af8:	8b 45 0c             	mov    0xc(%ebp),%eax
  102afb:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102afe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b04:	89 d1                	mov    %edx,%ecx
  102b06:	89 c2                	mov    %eax,%edx
  102b08:	89 ce                	mov    %ecx,%esi
  102b0a:	89 d7                	mov    %edx,%edi
  102b0c:	ac                   	lods   %ds:(%esi),%al
  102b0d:	aa                   	stos   %al,%es:(%edi)
  102b0e:	84 c0                	test   %al,%al
  102b10:	75 fa                	jne    102b0c <strcpy+0x22>
  102b12:	89 fa                	mov    %edi,%edx
  102b14:	89 f1                	mov    %esi,%ecx
  102b16:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102b19:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102b1c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  102b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  102b22:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  102b23:	83 c4 20             	add    $0x20,%esp
  102b26:	5e                   	pop    %esi
  102b27:	5f                   	pop    %edi
  102b28:	5d                   	pop    %ebp
  102b29:	c3                   	ret    

00102b2a <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  102b2a:	55                   	push   %ebp
  102b2b:	89 e5                	mov    %esp,%ebp
  102b2d:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  102b30:	8b 45 08             	mov    0x8(%ebp),%eax
  102b33:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  102b36:	eb 21                	jmp    102b59 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  102b38:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b3b:	0f b6 10             	movzbl (%eax),%edx
  102b3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102b41:	88 10                	mov    %dl,(%eax)
  102b43:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102b46:	0f b6 00             	movzbl (%eax),%eax
  102b49:	84 c0                	test   %al,%al
  102b4b:	74 04                	je     102b51 <strncpy+0x27>
            src ++;
  102b4d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  102b51:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102b55:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    while (len > 0) {
  102b59:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102b5d:	75 d9                	jne    102b38 <strncpy+0xe>
    }
    return dst;
  102b5f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102b62:	c9                   	leave  
  102b63:	c3                   	ret    

00102b64 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  102b64:	55                   	push   %ebp
  102b65:	89 e5                	mov    %esp,%ebp
  102b67:	57                   	push   %edi
  102b68:	56                   	push   %esi
  102b69:	83 ec 20             	sub    $0x20,%esp
  102b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  102b6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102b72:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b75:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  102b78:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102b7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b7e:	89 d1                	mov    %edx,%ecx
  102b80:	89 c2                	mov    %eax,%edx
  102b82:	89 ce                	mov    %ecx,%esi
  102b84:	89 d7                	mov    %edx,%edi
  102b86:	ac                   	lods   %ds:(%esi),%al
  102b87:	ae                   	scas   %es:(%edi),%al
  102b88:	75 08                	jne    102b92 <strcmp+0x2e>
  102b8a:	84 c0                	test   %al,%al
  102b8c:	75 f8                	jne    102b86 <strcmp+0x22>
  102b8e:	31 c0                	xor    %eax,%eax
  102b90:	eb 04                	jmp    102b96 <strcmp+0x32>
  102b92:	19 c0                	sbb    %eax,%eax
  102b94:	0c 01                	or     $0x1,%al
  102b96:	89 fa                	mov    %edi,%edx
  102b98:	89 f1                	mov    %esi,%ecx
  102b9a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102b9d:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102ba0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  102ba3:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  102ba6:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  102ba7:	83 c4 20             	add    $0x20,%esp
  102baa:	5e                   	pop    %esi
  102bab:	5f                   	pop    %edi
  102bac:	5d                   	pop    %ebp
  102bad:	c3                   	ret    

00102bae <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  102bae:	55                   	push   %ebp
  102baf:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102bb1:	eb 0c                	jmp    102bbf <strncmp+0x11>
        n --, s1 ++, s2 ++;
  102bb3:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102bb7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102bbb:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102bbf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102bc3:	74 1a                	je     102bdf <strncmp+0x31>
  102bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  102bc8:	0f b6 00             	movzbl (%eax),%eax
  102bcb:	84 c0                	test   %al,%al
  102bcd:	74 10                	je     102bdf <strncmp+0x31>
  102bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  102bd2:	0f b6 10             	movzbl (%eax),%edx
  102bd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bd8:	0f b6 00             	movzbl (%eax),%eax
  102bdb:	38 c2                	cmp    %al,%dl
  102bdd:	74 d4                	je     102bb3 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  102bdf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102be3:	74 18                	je     102bfd <strncmp+0x4f>
  102be5:	8b 45 08             	mov    0x8(%ebp),%eax
  102be8:	0f b6 00             	movzbl (%eax),%eax
  102beb:	0f b6 d0             	movzbl %al,%edx
  102bee:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bf1:	0f b6 00             	movzbl (%eax),%eax
  102bf4:	0f b6 c0             	movzbl %al,%eax
  102bf7:	29 c2                	sub    %eax,%edx
  102bf9:	89 d0                	mov    %edx,%eax
  102bfb:	eb 05                	jmp    102c02 <strncmp+0x54>
  102bfd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102c02:	5d                   	pop    %ebp
  102c03:	c3                   	ret    

00102c04 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  102c04:	55                   	push   %ebp
  102c05:	89 e5                	mov    %esp,%ebp
  102c07:	83 ec 04             	sub    $0x4,%esp
  102c0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c0d:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102c10:	eb 14                	jmp    102c26 <strchr+0x22>
        if (*s == c) {
  102c12:	8b 45 08             	mov    0x8(%ebp),%eax
  102c15:	0f b6 00             	movzbl (%eax),%eax
  102c18:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102c1b:	75 05                	jne    102c22 <strchr+0x1e>
            return (char *)s;
  102c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  102c20:	eb 13                	jmp    102c35 <strchr+0x31>
        }
        s ++;
  102c22:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
  102c26:	8b 45 08             	mov    0x8(%ebp),%eax
  102c29:	0f b6 00             	movzbl (%eax),%eax
  102c2c:	84 c0                	test   %al,%al
  102c2e:	75 e2                	jne    102c12 <strchr+0xe>
    }
    return NULL;
  102c30:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102c35:	c9                   	leave  
  102c36:	c3                   	ret    

00102c37 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  102c37:	55                   	push   %ebp
  102c38:	89 e5                	mov    %esp,%ebp
  102c3a:	83 ec 04             	sub    $0x4,%esp
  102c3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c40:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102c43:	eb 0f                	jmp    102c54 <strfind+0x1d>
        if (*s == c) {
  102c45:	8b 45 08             	mov    0x8(%ebp),%eax
  102c48:	0f b6 00             	movzbl (%eax),%eax
  102c4b:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102c4e:	74 10                	je     102c60 <strfind+0x29>
            break;
        }
        s ++;
  102c50:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
  102c54:	8b 45 08             	mov    0x8(%ebp),%eax
  102c57:	0f b6 00             	movzbl (%eax),%eax
  102c5a:	84 c0                	test   %al,%al
  102c5c:	75 e7                	jne    102c45 <strfind+0xe>
  102c5e:	eb 01                	jmp    102c61 <strfind+0x2a>
            break;
  102c60:	90                   	nop
    }
    return (char *)s;
  102c61:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102c64:	c9                   	leave  
  102c65:	c3                   	ret    

00102c66 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  102c66:	55                   	push   %ebp
  102c67:	89 e5                	mov    %esp,%ebp
  102c69:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  102c6c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  102c73:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102c7a:	eb 04                	jmp    102c80 <strtol+0x1a>
        s ++;
  102c7c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  102c80:	8b 45 08             	mov    0x8(%ebp),%eax
  102c83:	0f b6 00             	movzbl (%eax),%eax
  102c86:	3c 20                	cmp    $0x20,%al
  102c88:	74 f2                	je     102c7c <strtol+0x16>
  102c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  102c8d:	0f b6 00             	movzbl (%eax),%eax
  102c90:	3c 09                	cmp    $0x9,%al
  102c92:	74 e8                	je     102c7c <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  102c94:	8b 45 08             	mov    0x8(%ebp),%eax
  102c97:	0f b6 00             	movzbl (%eax),%eax
  102c9a:	3c 2b                	cmp    $0x2b,%al
  102c9c:	75 06                	jne    102ca4 <strtol+0x3e>
        s ++;
  102c9e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102ca2:	eb 15                	jmp    102cb9 <strtol+0x53>
    }
    else if (*s == '-') {
  102ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  102ca7:	0f b6 00             	movzbl (%eax),%eax
  102caa:	3c 2d                	cmp    $0x2d,%al
  102cac:	75 0b                	jne    102cb9 <strtol+0x53>
        s ++, neg = 1;
  102cae:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102cb2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  102cb9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102cbd:	74 06                	je     102cc5 <strtol+0x5f>
  102cbf:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  102cc3:	75 24                	jne    102ce9 <strtol+0x83>
  102cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  102cc8:	0f b6 00             	movzbl (%eax),%eax
  102ccb:	3c 30                	cmp    $0x30,%al
  102ccd:	75 1a                	jne    102ce9 <strtol+0x83>
  102ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  102cd2:	83 c0 01             	add    $0x1,%eax
  102cd5:	0f b6 00             	movzbl (%eax),%eax
  102cd8:	3c 78                	cmp    $0x78,%al
  102cda:	75 0d                	jne    102ce9 <strtol+0x83>
        s += 2, base = 16;
  102cdc:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  102ce0:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  102ce7:	eb 2a                	jmp    102d13 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  102ce9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102ced:	75 17                	jne    102d06 <strtol+0xa0>
  102cef:	8b 45 08             	mov    0x8(%ebp),%eax
  102cf2:	0f b6 00             	movzbl (%eax),%eax
  102cf5:	3c 30                	cmp    $0x30,%al
  102cf7:	75 0d                	jne    102d06 <strtol+0xa0>
        s ++, base = 8;
  102cf9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102cfd:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  102d04:	eb 0d                	jmp    102d13 <strtol+0xad>
    }
    else if (base == 0) {
  102d06:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102d0a:	75 07                	jne    102d13 <strtol+0xad>
        base = 10;
  102d0c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  102d13:	8b 45 08             	mov    0x8(%ebp),%eax
  102d16:	0f b6 00             	movzbl (%eax),%eax
  102d19:	3c 2f                	cmp    $0x2f,%al
  102d1b:	7e 1b                	jle    102d38 <strtol+0xd2>
  102d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  102d20:	0f b6 00             	movzbl (%eax),%eax
  102d23:	3c 39                	cmp    $0x39,%al
  102d25:	7f 11                	jg     102d38 <strtol+0xd2>
            dig = *s - '0';
  102d27:	8b 45 08             	mov    0x8(%ebp),%eax
  102d2a:	0f b6 00             	movzbl (%eax),%eax
  102d2d:	0f be c0             	movsbl %al,%eax
  102d30:	83 e8 30             	sub    $0x30,%eax
  102d33:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102d36:	eb 48                	jmp    102d80 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  102d38:	8b 45 08             	mov    0x8(%ebp),%eax
  102d3b:	0f b6 00             	movzbl (%eax),%eax
  102d3e:	3c 60                	cmp    $0x60,%al
  102d40:	7e 1b                	jle    102d5d <strtol+0xf7>
  102d42:	8b 45 08             	mov    0x8(%ebp),%eax
  102d45:	0f b6 00             	movzbl (%eax),%eax
  102d48:	3c 7a                	cmp    $0x7a,%al
  102d4a:	7f 11                	jg     102d5d <strtol+0xf7>
            dig = *s - 'a' + 10;
  102d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  102d4f:	0f b6 00             	movzbl (%eax),%eax
  102d52:	0f be c0             	movsbl %al,%eax
  102d55:	83 e8 57             	sub    $0x57,%eax
  102d58:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102d5b:	eb 23                	jmp    102d80 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  102d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  102d60:	0f b6 00             	movzbl (%eax),%eax
  102d63:	3c 40                	cmp    $0x40,%al
  102d65:	7e 3c                	jle    102da3 <strtol+0x13d>
  102d67:	8b 45 08             	mov    0x8(%ebp),%eax
  102d6a:	0f b6 00             	movzbl (%eax),%eax
  102d6d:	3c 5a                	cmp    $0x5a,%al
  102d6f:	7f 32                	jg     102da3 <strtol+0x13d>
            dig = *s - 'A' + 10;
  102d71:	8b 45 08             	mov    0x8(%ebp),%eax
  102d74:	0f b6 00             	movzbl (%eax),%eax
  102d77:	0f be c0             	movsbl %al,%eax
  102d7a:	83 e8 37             	sub    $0x37,%eax
  102d7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  102d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d83:	3b 45 10             	cmp    0x10(%ebp),%eax
  102d86:	7d 1a                	jge    102da2 <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
  102d88:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102d8c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102d8f:	0f af 45 10          	imul   0x10(%ebp),%eax
  102d93:	89 c2                	mov    %eax,%edx
  102d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d98:	01 d0                	add    %edx,%eax
  102d9a:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  102d9d:	e9 71 ff ff ff       	jmp    102d13 <strtol+0xad>
            break;
  102da2:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  102da3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102da7:	74 08                	je     102db1 <strtol+0x14b>
        *endptr = (char *) s;
  102da9:	8b 45 0c             	mov    0xc(%ebp),%eax
  102dac:	8b 55 08             	mov    0x8(%ebp),%edx
  102daf:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  102db1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  102db5:	74 07                	je     102dbe <strtol+0x158>
  102db7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102dba:	f7 d8                	neg    %eax
  102dbc:	eb 03                	jmp    102dc1 <strtol+0x15b>
  102dbe:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  102dc1:	c9                   	leave  
  102dc2:	c3                   	ret    

00102dc3 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  102dc3:	55                   	push   %ebp
  102dc4:	89 e5                	mov    %esp,%ebp
  102dc6:	57                   	push   %edi
  102dc7:	83 ec 24             	sub    $0x24,%esp
  102dca:	8b 45 0c             	mov    0xc(%ebp),%eax
  102dcd:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  102dd0:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  102dd4:	8b 55 08             	mov    0x8(%ebp),%edx
  102dd7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  102dda:	88 45 f7             	mov    %al,-0x9(%ebp)
  102ddd:	8b 45 10             	mov    0x10(%ebp),%eax
  102de0:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  102de3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102de6:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  102dea:	8b 55 f8             	mov    -0x8(%ebp),%edx
  102ded:	89 d7                	mov    %edx,%edi
  102def:	f3 aa                	rep stos %al,%es:(%edi)
  102df1:	89 fa                	mov    %edi,%edx
  102df3:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102df6:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  102df9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102dfc:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  102dfd:	83 c4 24             	add    $0x24,%esp
  102e00:	5f                   	pop    %edi
  102e01:	5d                   	pop    %ebp
  102e02:	c3                   	ret    

00102e03 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  102e03:	55                   	push   %ebp
  102e04:	89 e5                	mov    %esp,%ebp
  102e06:	57                   	push   %edi
  102e07:	56                   	push   %esi
  102e08:	53                   	push   %ebx
  102e09:	83 ec 30             	sub    $0x30,%esp
  102e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  102e0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e12:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e15:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102e18:	8b 45 10             	mov    0x10(%ebp),%eax
  102e1b:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  102e1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e21:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  102e24:	73 42                	jae    102e68 <memmove+0x65>
  102e26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e29:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102e2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e2f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102e32:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e35:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102e38:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102e3b:	c1 e8 02             	shr    $0x2,%eax
  102e3e:	89 c1                	mov    %eax,%ecx
    asm volatile (
  102e40:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102e43:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e46:	89 d7                	mov    %edx,%edi
  102e48:	89 c6                	mov    %eax,%esi
  102e4a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102e4c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  102e4f:	83 e1 03             	and    $0x3,%ecx
  102e52:	74 02                	je     102e56 <memmove+0x53>
  102e54:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102e56:	89 f0                	mov    %esi,%eax
  102e58:	89 fa                	mov    %edi,%edx
  102e5a:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  102e5d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102e60:	89 45 d0             	mov    %eax,-0x30(%ebp)
            : "memory");
    return dst;
  102e63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  102e66:	eb 36                	jmp    102e9e <memmove+0x9b>
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  102e68:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e6b:	8d 50 ff             	lea    -0x1(%eax),%edx
  102e6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e71:	01 c2                	add    %eax,%edx
  102e73:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e76:	8d 48 ff             	lea    -0x1(%eax),%ecx
  102e79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e7c:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  102e7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e82:	89 c1                	mov    %eax,%ecx
  102e84:	89 d8                	mov    %ebx,%eax
  102e86:	89 d6                	mov    %edx,%esi
  102e88:	89 c7                	mov    %eax,%edi
  102e8a:	fd                   	std    
  102e8b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102e8d:	fc                   	cld    
  102e8e:	89 f8                	mov    %edi,%eax
  102e90:	89 f2                	mov    %esi,%edx
  102e92:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  102e95:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102e98:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  102e9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  102e9e:	83 c4 30             	add    $0x30,%esp
  102ea1:	5b                   	pop    %ebx
  102ea2:	5e                   	pop    %esi
  102ea3:	5f                   	pop    %edi
  102ea4:	5d                   	pop    %ebp
  102ea5:	c3                   	ret    

00102ea6 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  102ea6:	55                   	push   %ebp
  102ea7:	89 e5                	mov    %esp,%ebp
  102ea9:	57                   	push   %edi
  102eaa:	56                   	push   %esi
  102eab:	83 ec 20             	sub    $0x20,%esp
  102eae:	8b 45 08             	mov    0x8(%ebp),%eax
  102eb1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102eb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  102eb7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102eba:	8b 45 10             	mov    0x10(%ebp),%eax
  102ebd:	89 45 ec             	mov    %eax,-0x14(%ebp)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102ec0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ec3:	c1 e8 02             	shr    $0x2,%eax
  102ec6:	89 c1                	mov    %eax,%ecx
    asm volatile (
  102ec8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102ecb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ece:	89 d7                	mov    %edx,%edi
  102ed0:	89 c6                	mov    %eax,%esi
  102ed2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102ed4:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  102ed7:	83 e1 03             	and    $0x3,%ecx
  102eda:	74 02                	je     102ede <memcpy+0x38>
  102edc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102ede:	89 f0                	mov    %esi,%eax
  102ee0:	89 fa                	mov    %edi,%edx
  102ee2:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102ee5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  102ee8:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  102eeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  102eee:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  102eef:	83 c4 20             	add    $0x20,%esp
  102ef2:	5e                   	pop    %esi
  102ef3:	5f                   	pop    %edi
  102ef4:	5d                   	pop    %ebp
  102ef5:	c3                   	ret    

00102ef6 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  102ef6:	55                   	push   %ebp
  102ef7:	89 e5                	mov    %esp,%ebp
  102ef9:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  102efc:	8b 45 08             	mov    0x8(%ebp),%eax
  102eff:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  102f02:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f05:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  102f08:	eb 30                	jmp    102f3a <memcmp+0x44>
        if (*s1 != *s2) {
  102f0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102f0d:	0f b6 10             	movzbl (%eax),%edx
  102f10:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102f13:	0f b6 00             	movzbl (%eax),%eax
  102f16:	38 c2                	cmp    %al,%dl
  102f18:	74 18                	je     102f32 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  102f1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102f1d:	0f b6 00             	movzbl (%eax),%eax
  102f20:	0f b6 d0             	movzbl %al,%edx
  102f23:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102f26:	0f b6 00             	movzbl (%eax),%eax
  102f29:	0f b6 c0             	movzbl %al,%eax
  102f2c:	29 c2                	sub    %eax,%edx
  102f2e:	89 d0                	mov    %edx,%eax
  102f30:	eb 1a                	jmp    102f4c <memcmp+0x56>
        }
        s1 ++, s2 ++;
  102f32:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102f36:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    while (n -- > 0) {
  102f3a:	8b 45 10             	mov    0x10(%ebp),%eax
  102f3d:	8d 50 ff             	lea    -0x1(%eax),%edx
  102f40:	89 55 10             	mov    %edx,0x10(%ebp)
  102f43:	85 c0                	test   %eax,%eax
  102f45:	75 c3                	jne    102f0a <memcmp+0x14>
    }
    return 0;
  102f47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102f4c:	c9                   	leave  
  102f4d:	c3                   	ret    

00102f4e <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102f4e:	55                   	push   %ebp
  102f4f:	89 e5                	mov    %esp,%ebp
  102f51:	83 ec 38             	sub    $0x38,%esp
  102f54:	8b 45 10             	mov    0x10(%ebp),%eax
  102f57:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102f5a:	8b 45 14             	mov    0x14(%ebp),%eax
  102f5d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102f60:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102f63:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102f66:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102f69:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102f6c:	8b 45 18             	mov    0x18(%ebp),%eax
  102f6f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102f72:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102f75:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102f78:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102f7b:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102f7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f81:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102f84:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102f88:	74 1c                	je     102fa6 <printnum+0x58>
  102f8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f8d:	ba 00 00 00 00       	mov    $0x0,%edx
  102f92:	f7 75 e4             	divl   -0x1c(%ebp)
  102f95:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102f98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f9b:	ba 00 00 00 00       	mov    $0x0,%edx
  102fa0:	f7 75 e4             	divl   -0x1c(%ebp)
  102fa3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102fa6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102fa9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102fac:	f7 75 e4             	divl   -0x1c(%ebp)
  102faf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102fb2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102fb5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102fb8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102fbb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102fbe:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102fc1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102fc4:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102fc7:	8b 45 18             	mov    0x18(%ebp),%eax
  102fca:	ba 00 00 00 00       	mov    $0x0,%edx
  102fcf:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  102fd2:	72 41                	jb     103015 <printnum+0xc7>
  102fd4:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  102fd7:	77 05                	ja     102fde <printnum+0x90>
  102fd9:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  102fdc:	72 37                	jb     103015 <printnum+0xc7>
        printnum(putch, putdat, result, base, width - 1, padc);
  102fde:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102fe1:	83 e8 01             	sub    $0x1,%eax
  102fe4:	83 ec 04             	sub    $0x4,%esp
  102fe7:	ff 75 20             	pushl  0x20(%ebp)
  102fea:	50                   	push   %eax
  102feb:	ff 75 18             	pushl  0x18(%ebp)
  102fee:	ff 75 ec             	pushl  -0x14(%ebp)
  102ff1:	ff 75 e8             	pushl  -0x18(%ebp)
  102ff4:	ff 75 0c             	pushl  0xc(%ebp)
  102ff7:	ff 75 08             	pushl  0x8(%ebp)
  102ffa:	e8 4f ff ff ff       	call   102f4e <printnum>
  102fff:	83 c4 20             	add    $0x20,%esp
  103002:	eb 1b                	jmp    10301f <printnum+0xd1>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  103004:	83 ec 08             	sub    $0x8,%esp
  103007:	ff 75 0c             	pushl  0xc(%ebp)
  10300a:	ff 75 20             	pushl  0x20(%ebp)
  10300d:	8b 45 08             	mov    0x8(%ebp),%eax
  103010:	ff d0                	call   *%eax
  103012:	83 c4 10             	add    $0x10,%esp
        while (-- width > 0)
  103015:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  103019:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  10301d:	7f e5                	jg     103004 <printnum+0xb6>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  10301f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103022:	05 10 3d 10 00       	add    $0x103d10,%eax
  103027:	0f b6 00             	movzbl (%eax),%eax
  10302a:	0f be c0             	movsbl %al,%eax
  10302d:	83 ec 08             	sub    $0x8,%esp
  103030:	ff 75 0c             	pushl  0xc(%ebp)
  103033:	50                   	push   %eax
  103034:	8b 45 08             	mov    0x8(%ebp),%eax
  103037:	ff d0                	call   *%eax
  103039:	83 c4 10             	add    $0x10,%esp
}
  10303c:	90                   	nop
  10303d:	c9                   	leave  
  10303e:	c3                   	ret    

0010303f <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  10303f:	55                   	push   %ebp
  103040:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  103042:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  103046:	7e 14                	jle    10305c <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  103048:	8b 45 08             	mov    0x8(%ebp),%eax
  10304b:	8b 00                	mov    (%eax),%eax
  10304d:	8d 48 08             	lea    0x8(%eax),%ecx
  103050:	8b 55 08             	mov    0x8(%ebp),%edx
  103053:	89 0a                	mov    %ecx,(%edx)
  103055:	8b 50 04             	mov    0x4(%eax),%edx
  103058:	8b 00                	mov    (%eax),%eax
  10305a:	eb 30                	jmp    10308c <getuint+0x4d>
    }
    else if (lflag) {
  10305c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103060:	74 16                	je     103078 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  103062:	8b 45 08             	mov    0x8(%ebp),%eax
  103065:	8b 00                	mov    (%eax),%eax
  103067:	8d 48 04             	lea    0x4(%eax),%ecx
  10306a:	8b 55 08             	mov    0x8(%ebp),%edx
  10306d:	89 0a                	mov    %ecx,(%edx)
  10306f:	8b 00                	mov    (%eax),%eax
  103071:	ba 00 00 00 00       	mov    $0x0,%edx
  103076:	eb 14                	jmp    10308c <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  103078:	8b 45 08             	mov    0x8(%ebp),%eax
  10307b:	8b 00                	mov    (%eax),%eax
  10307d:	8d 48 04             	lea    0x4(%eax),%ecx
  103080:	8b 55 08             	mov    0x8(%ebp),%edx
  103083:	89 0a                	mov    %ecx,(%edx)
  103085:	8b 00                	mov    (%eax),%eax
  103087:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  10308c:	5d                   	pop    %ebp
  10308d:	c3                   	ret    

0010308e <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  10308e:	55                   	push   %ebp
  10308f:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  103091:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  103095:	7e 14                	jle    1030ab <getint+0x1d>
        return va_arg(*ap, long long);
  103097:	8b 45 08             	mov    0x8(%ebp),%eax
  10309a:	8b 00                	mov    (%eax),%eax
  10309c:	8d 48 08             	lea    0x8(%eax),%ecx
  10309f:	8b 55 08             	mov    0x8(%ebp),%edx
  1030a2:	89 0a                	mov    %ecx,(%edx)
  1030a4:	8b 50 04             	mov    0x4(%eax),%edx
  1030a7:	8b 00                	mov    (%eax),%eax
  1030a9:	eb 28                	jmp    1030d3 <getint+0x45>
    }
    else if (lflag) {
  1030ab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1030af:	74 12                	je     1030c3 <getint+0x35>
        return va_arg(*ap, long);
  1030b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1030b4:	8b 00                	mov    (%eax),%eax
  1030b6:	8d 48 04             	lea    0x4(%eax),%ecx
  1030b9:	8b 55 08             	mov    0x8(%ebp),%edx
  1030bc:	89 0a                	mov    %ecx,(%edx)
  1030be:	8b 00                	mov    (%eax),%eax
  1030c0:	99                   	cltd   
  1030c1:	eb 10                	jmp    1030d3 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  1030c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1030c6:	8b 00                	mov    (%eax),%eax
  1030c8:	8d 48 04             	lea    0x4(%eax),%ecx
  1030cb:	8b 55 08             	mov    0x8(%ebp),%edx
  1030ce:	89 0a                	mov    %ecx,(%edx)
  1030d0:	8b 00                	mov    (%eax),%eax
  1030d2:	99                   	cltd   
    }
}
  1030d3:	5d                   	pop    %ebp
  1030d4:	c3                   	ret    

001030d5 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  1030d5:	55                   	push   %ebp
  1030d6:	89 e5                	mov    %esp,%ebp
  1030d8:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
  1030db:	8d 45 14             	lea    0x14(%ebp),%eax
  1030de:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  1030e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1030e4:	50                   	push   %eax
  1030e5:	ff 75 10             	pushl  0x10(%ebp)
  1030e8:	ff 75 0c             	pushl  0xc(%ebp)
  1030eb:	ff 75 08             	pushl  0x8(%ebp)
  1030ee:	e8 06 00 00 00       	call   1030f9 <vprintfmt>
  1030f3:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
  1030f6:	90                   	nop
  1030f7:	c9                   	leave  
  1030f8:	c3                   	ret    

001030f9 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  1030f9:	55                   	push   %ebp
  1030fa:	89 e5                	mov    %esp,%ebp
  1030fc:	56                   	push   %esi
  1030fd:	53                   	push   %ebx
  1030fe:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  103101:	eb 17                	jmp    10311a <vprintfmt+0x21>
            if (ch == '\0') {
  103103:	85 db                	test   %ebx,%ebx
  103105:	0f 84 8e 03 00 00    	je     103499 <vprintfmt+0x3a0>
                return;
            }
            putch(ch, putdat);
  10310b:	83 ec 08             	sub    $0x8,%esp
  10310e:	ff 75 0c             	pushl  0xc(%ebp)
  103111:	53                   	push   %ebx
  103112:	8b 45 08             	mov    0x8(%ebp),%eax
  103115:	ff d0                	call   *%eax
  103117:	83 c4 10             	add    $0x10,%esp
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10311a:	8b 45 10             	mov    0x10(%ebp),%eax
  10311d:	8d 50 01             	lea    0x1(%eax),%edx
  103120:	89 55 10             	mov    %edx,0x10(%ebp)
  103123:	0f b6 00             	movzbl (%eax),%eax
  103126:	0f b6 d8             	movzbl %al,%ebx
  103129:	83 fb 25             	cmp    $0x25,%ebx
  10312c:	75 d5                	jne    103103 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  10312e:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  103132:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  103139:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10313c:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  10313f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103146:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103149:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  10314c:	8b 45 10             	mov    0x10(%ebp),%eax
  10314f:	8d 50 01             	lea    0x1(%eax),%edx
  103152:	89 55 10             	mov    %edx,0x10(%ebp)
  103155:	0f b6 00             	movzbl (%eax),%eax
  103158:	0f b6 d8             	movzbl %al,%ebx
  10315b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  10315e:	83 f8 55             	cmp    $0x55,%eax
  103161:	0f 87 05 03 00 00    	ja     10346c <vprintfmt+0x373>
  103167:	8b 04 85 34 3d 10 00 	mov    0x103d34(,%eax,4),%eax
  10316e:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  103170:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  103174:	eb d6                	jmp    10314c <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  103176:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  10317a:	eb d0                	jmp    10314c <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  10317c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  103183:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103186:	89 d0                	mov    %edx,%eax
  103188:	c1 e0 02             	shl    $0x2,%eax
  10318b:	01 d0                	add    %edx,%eax
  10318d:	01 c0                	add    %eax,%eax
  10318f:	01 d8                	add    %ebx,%eax
  103191:	83 e8 30             	sub    $0x30,%eax
  103194:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  103197:	8b 45 10             	mov    0x10(%ebp),%eax
  10319a:	0f b6 00             	movzbl (%eax),%eax
  10319d:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  1031a0:	83 fb 2f             	cmp    $0x2f,%ebx
  1031a3:	7e 39                	jle    1031de <vprintfmt+0xe5>
  1031a5:	83 fb 39             	cmp    $0x39,%ebx
  1031a8:	7f 34                	jg     1031de <vprintfmt+0xe5>
            for (precision = 0; ; ++ fmt) {
  1031aa:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
  1031ae:	eb d3                	jmp    103183 <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  1031b0:	8b 45 14             	mov    0x14(%ebp),%eax
  1031b3:	8d 50 04             	lea    0x4(%eax),%edx
  1031b6:	89 55 14             	mov    %edx,0x14(%ebp)
  1031b9:	8b 00                	mov    (%eax),%eax
  1031bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  1031be:	eb 1f                	jmp    1031df <vprintfmt+0xe6>

        case '.':
            if (width < 0)
  1031c0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1031c4:	79 86                	jns    10314c <vprintfmt+0x53>
                width = 0;
  1031c6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  1031cd:	e9 7a ff ff ff       	jmp    10314c <vprintfmt+0x53>

        case '#':
            altflag = 1;
  1031d2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  1031d9:	e9 6e ff ff ff       	jmp    10314c <vprintfmt+0x53>
            goto process_precision;
  1031de:	90                   	nop

        process_precision:
            if (width < 0)
  1031df:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1031e3:	0f 89 63 ff ff ff    	jns    10314c <vprintfmt+0x53>
                width = precision, precision = -1;
  1031e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1031ec:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1031ef:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  1031f6:	e9 51 ff ff ff       	jmp    10314c <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  1031fb:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  1031ff:	e9 48 ff ff ff       	jmp    10314c <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  103204:	8b 45 14             	mov    0x14(%ebp),%eax
  103207:	8d 50 04             	lea    0x4(%eax),%edx
  10320a:	89 55 14             	mov    %edx,0x14(%ebp)
  10320d:	8b 00                	mov    (%eax),%eax
  10320f:	83 ec 08             	sub    $0x8,%esp
  103212:	ff 75 0c             	pushl  0xc(%ebp)
  103215:	50                   	push   %eax
  103216:	8b 45 08             	mov    0x8(%ebp),%eax
  103219:	ff d0                	call   *%eax
  10321b:	83 c4 10             	add    $0x10,%esp
            break;
  10321e:	e9 71 02 00 00       	jmp    103494 <vprintfmt+0x39b>

        // error message
        case 'e':
            err = va_arg(ap, int);
  103223:	8b 45 14             	mov    0x14(%ebp),%eax
  103226:	8d 50 04             	lea    0x4(%eax),%edx
  103229:	89 55 14             	mov    %edx,0x14(%ebp)
  10322c:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  10322e:	85 db                	test   %ebx,%ebx
  103230:	79 02                	jns    103234 <vprintfmt+0x13b>
                err = -err;
  103232:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  103234:	83 fb 06             	cmp    $0x6,%ebx
  103237:	7f 0b                	jg     103244 <vprintfmt+0x14b>
  103239:	8b 34 9d f4 3c 10 00 	mov    0x103cf4(,%ebx,4),%esi
  103240:	85 f6                	test   %esi,%esi
  103242:	75 19                	jne    10325d <vprintfmt+0x164>
                printfmt(putch, putdat, "error %d", err);
  103244:	53                   	push   %ebx
  103245:	68 21 3d 10 00       	push   $0x103d21
  10324a:	ff 75 0c             	pushl  0xc(%ebp)
  10324d:	ff 75 08             	pushl  0x8(%ebp)
  103250:	e8 80 fe ff ff       	call   1030d5 <printfmt>
  103255:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  103258:	e9 37 02 00 00       	jmp    103494 <vprintfmt+0x39b>
                printfmt(putch, putdat, "%s", p);
  10325d:	56                   	push   %esi
  10325e:	68 2a 3d 10 00       	push   $0x103d2a
  103263:	ff 75 0c             	pushl  0xc(%ebp)
  103266:	ff 75 08             	pushl  0x8(%ebp)
  103269:	e8 67 fe ff ff       	call   1030d5 <printfmt>
  10326e:	83 c4 10             	add    $0x10,%esp
            break;
  103271:	e9 1e 02 00 00       	jmp    103494 <vprintfmt+0x39b>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  103276:	8b 45 14             	mov    0x14(%ebp),%eax
  103279:	8d 50 04             	lea    0x4(%eax),%edx
  10327c:	89 55 14             	mov    %edx,0x14(%ebp)
  10327f:	8b 30                	mov    (%eax),%esi
  103281:	85 f6                	test   %esi,%esi
  103283:	75 05                	jne    10328a <vprintfmt+0x191>
                p = "(null)";
  103285:	be 2d 3d 10 00       	mov    $0x103d2d,%esi
            }
            if (width > 0 && padc != '-') {
  10328a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10328e:	7e 76                	jle    103306 <vprintfmt+0x20d>
  103290:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  103294:	74 70                	je     103306 <vprintfmt+0x20d>
                for (width -= strnlen(p, precision); width > 0; width --) {
  103296:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103299:	83 ec 08             	sub    $0x8,%esp
  10329c:	50                   	push   %eax
  10329d:	56                   	push   %esi
  10329e:	e8 17 f8 ff ff       	call   102aba <strnlen>
  1032a3:	83 c4 10             	add    $0x10,%esp
  1032a6:	89 c2                	mov    %eax,%edx
  1032a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1032ab:	29 d0                	sub    %edx,%eax
  1032ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1032b0:	eb 17                	jmp    1032c9 <vprintfmt+0x1d0>
                    putch(padc, putdat);
  1032b2:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  1032b6:	83 ec 08             	sub    $0x8,%esp
  1032b9:	ff 75 0c             	pushl  0xc(%ebp)
  1032bc:	50                   	push   %eax
  1032bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1032c0:	ff d0                	call   *%eax
  1032c2:	83 c4 10             	add    $0x10,%esp
                for (width -= strnlen(p, precision); width > 0; width --) {
  1032c5:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1032c9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1032cd:	7f e3                	jg     1032b2 <vprintfmt+0x1b9>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1032cf:	eb 35                	jmp    103306 <vprintfmt+0x20d>
                if (altflag && (ch < ' ' || ch > '~')) {
  1032d1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1032d5:	74 1c                	je     1032f3 <vprintfmt+0x1fa>
  1032d7:	83 fb 1f             	cmp    $0x1f,%ebx
  1032da:	7e 05                	jle    1032e1 <vprintfmt+0x1e8>
  1032dc:	83 fb 7e             	cmp    $0x7e,%ebx
  1032df:	7e 12                	jle    1032f3 <vprintfmt+0x1fa>
                    putch('?', putdat);
  1032e1:	83 ec 08             	sub    $0x8,%esp
  1032e4:	ff 75 0c             	pushl  0xc(%ebp)
  1032e7:	6a 3f                	push   $0x3f
  1032e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1032ec:	ff d0                	call   *%eax
  1032ee:	83 c4 10             	add    $0x10,%esp
  1032f1:	eb 0f                	jmp    103302 <vprintfmt+0x209>
                }
                else {
                    putch(ch, putdat);
  1032f3:	83 ec 08             	sub    $0x8,%esp
  1032f6:	ff 75 0c             	pushl  0xc(%ebp)
  1032f9:	53                   	push   %ebx
  1032fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1032fd:	ff d0                	call   *%eax
  1032ff:	83 c4 10             	add    $0x10,%esp
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  103302:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  103306:	89 f0                	mov    %esi,%eax
  103308:	8d 70 01             	lea    0x1(%eax),%esi
  10330b:	0f b6 00             	movzbl (%eax),%eax
  10330e:	0f be d8             	movsbl %al,%ebx
  103311:	85 db                	test   %ebx,%ebx
  103313:	74 26                	je     10333b <vprintfmt+0x242>
  103315:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103319:	78 b6                	js     1032d1 <vprintfmt+0x1d8>
  10331b:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  10331f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103323:	79 ac                	jns    1032d1 <vprintfmt+0x1d8>
                }
            }
            for (; width > 0; width --) {
  103325:	eb 14                	jmp    10333b <vprintfmt+0x242>
                putch(' ', putdat);
  103327:	83 ec 08             	sub    $0x8,%esp
  10332a:	ff 75 0c             	pushl  0xc(%ebp)
  10332d:	6a 20                	push   $0x20
  10332f:	8b 45 08             	mov    0x8(%ebp),%eax
  103332:	ff d0                	call   *%eax
  103334:	83 c4 10             	add    $0x10,%esp
            for (; width > 0; width --) {
  103337:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10333b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10333f:	7f e6                	jg     103327 <vprintfmt+0x22e>
            }
            break;
  103341:	e9 4e 01 00 00       	jmp    103494 <vprintfmt+0x39b>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  103346:	83 ec 08             	sub    $0x8,%esp
  103349:	ff 75 e0             	pushl  -0x20(%ebp)
  10334c:	8d 45 14             	lea    0x14(%ebp),%eax
  10334f:	50                   	push   %eax
  103350:	e8 39 fd ff ff       	call   10308e <getint>
  103355:	83 c4 10             	add    $0x10,%esp
  103358:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10335b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  10335e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103361:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103364:	85 d2                	test   %edx,%edx
  103366:	79 23                	jns    10338b <vprintfmt+0x292>
                putch('-', putdat);
  103368:	83 ec 08             	sub    $0x8,%esp
  10336b:	ff 75 0c             	pushl  0xc(%ebp)
  10336e:	6a 2d                	push   $0x2d
  103370:	8b 45 08             	mov    0x8(%ebp),%eax
  103373:	ff d0                	call   *%eax
  103375:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
  103378:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10337b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10337e:	f7 d8                	neg    %eax
  103380:	83 d2 00             	adc    $0x0,%edx
  103383:	f7 da                	neg    %edx
  103385:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103388:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  10338b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  103392:	e9 9f 00 00 00       	jmp    103436 <vprintfmt+0x33d>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  103397:	83 ec 08             	sub    $0x8,%esp
  10339a:	ff 75 e0             	pushl  -0x20(%ebp)
  10339d:	8d 45 14             	lea    0x14(%ebp),%eax
  1033a0:	50                   	push   %eax
  1033a1:	e8 99 fc ff ff       	call   10303f <getuint>
  1033a6:	83 c4 10             	add    $0x10,%esp
  1033a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033ac:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  1033af:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1033b6:	eb 7e                	jmp    103436 <vprintfmt+0x33d>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  1033b8:	83 ec 08             	sub    $0x8,%esp
  1033bb:	ff 75 e0             	pushl  -0x20(%ebp)
  1033be:	8d 45 14             	lea    0x14(%ebp),%eax
  1033c1:	50                   	push   %eax
  1033c2:	e8 78 fc ff ff       	call   10303f <getuint>
  1033c7:	83 c4 10             	add    $0x10,%esp
  1033ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033cd:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  1033d0:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  1033d7:	eb 5d                	jmp    103436 <vprintfmt+0x33d>

        // pointer
        case 'p':
            putch('0', putdat);
  1033d9:	83 ec 08             	sub    $0x8,%esp
  1033dc:	ff 75 0c             	pushl  0xc(%ebp)
  1033df:	6a 30                	push   $0x30
  1033e1:	8b 45 08             	mov    0x8(%ebp),%eax
  1033e4:	ff d0                	call   *%eax
  1033e6:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
  1033e9:	83 ec 08             	sub    $0x8,%esp
  1033ec:	ff 75 0c             	pushl  0xc(%ebp)
  1033ef:	6a 78                	push   $0x78
  1033f1:	8b 45 08             	mov    0x8(%ebp),%eax
  1033f4:	ff d0                	call   *%eax
  1033f6:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  1033f9:	8b 45 14             	mov    0x14(%ebp),%eax
  1033fc:	8d 50 04             	lea    0x4(%eax),%edx
  1033ff:	89 55 14             	mov    %edx,0x14(%ebp)
  103402:	8b 00                	mov    (%eax),%eax
  103404:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103407:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  10340e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  103415:	eb 1f                	jmp    103436 <vprintfmt+0x33d>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  103417:	83 ec 08             	sub    $0x8,%esp
  10341a:	ff 75 e0             	pushl  -0x20(%ebp)
  10341d:	8d 45 14             	lea    0x14(%ebp),%eax
  103420:	50                   	push   %eax
  103421:	e8 19 fc ff ff       	call   10303f <getuint>
  103426:	83 c4 10             	add    $0x10,%esp
  103429:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10342c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  10342f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  103436:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  10343a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10343d:	83 ec 04             	sub    $0x4,%esp
  103440:	52                   	push   %edx
  103441:	ff 75 e8             	pushl  -0x18(%ebp)
  103444:	50                   	push   %eax
  103445:	ff 75 f4             	pushl  -0xc(%ebp)
  103448:	ff 75 f0             	pushl  -0x10(%ebp)
  10344b:	ff 75 0c             	pushl  0xc(%ebp)
  10344e:	ff 75 08             	pushl  0x8(%ebp)
  103451:	e8 f8 fa ff ff       	call   102f4e <printnum>
  103456:	83 c4 20             	add    $0x20,%esp
            break;
  103459:	eb 39                	jmp    103494 <vprintfmt+0x39b>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  10345b:	83 ec 08             	sub    $0x8,%esp
  10345e:	ff 75 0c             	pushl  0xc(%ebp)
  103461:	53                   	push   %ebx
  103462:	8b 45 08             	mov    0x8(%ebp),%eax
  103465:	ff d0                	call   *%eax
  103467:	83 c4 10             	add    $0x10,%esp
            break;
  10346a:	eb 28                	jmp    103494 <vprintfmt+0x39b>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  10346c:	83 ec 08             	sub    $0x8,%esp
  10346f:	ff 75 0c             	pushl  0xc(%ebp)
  103472:	6a 25                	push   $0x25
  103474:	8b 45 08             	mov    0x8(%ebp),%eax
  103477:	ff d0                	call   *%eax
  103479:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
  10347c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  103480:	eb 04                	jmp    103486 <vprintfmt+0x38d>
  103482:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  103486:	8b 45 10             	mov    0x10(%ebp),%eax
  103489:	83 e8 01             	sub    $0x1,%eax
  10348c:	0f b6 00             	movzbl (%eax),%eax
  10348f:	3c 25                	cmp    $0x25,%al
  103491:	75 ef                	jne    103482 <vprintfmt+0x389>
                /* do nothing */;
            break;
  103493:	90                   	nop
    while (1) {
  103494:	e9 68 fc ff ff       	jmp    103101 <vprintfmt+0x8>
                return;
  103499:	90                   	nop
        }
    }
}
  10349a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  10349d:	5b                   	pop    %ebx
  10349e:	5e                   	pop    %esi
  10349f:	5d                   	pop    %ebp
  1034a0:	c3                   	ret    

001034a1 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  1034a1:	55                   	push   %ebp
  1034a2:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  1034a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034a7:	8b 40 08             	mov    0x8(%eax),%eax
  1034aa:	8d 50 01             	lea    0x1(%eax),%edx
  1034ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034b0:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  1034b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034b6:	8b 10                	mov    (%eax),%edx
  1034b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034bb:	8b 40 04             	mov    0x4(%eax),%eax
  1034be:	39 c2                	cmp    %eax,%edx
  1034c0:	73 12                	jae    1034d4 <sprintputch+0x33>
        *b->buf ++ = ch;
  1034c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034c5:	8b 00                	mov    (%eax),%eax
  1034c7:	8d 48 01             	lea    0x1(%eax),%ecx
  1034ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  1034cd:	89 0a                	mov    %ecx,(%edx)
  1034cf:	8b 55 08             	mov    0x8(%ebp),%edx
  1034d2:	88 10                	mov    %dl,(%eax)
    }
}
  1034d4:	90                   	nop
  1034d5:	5d                   	pop    %ebp
  1034d6:	c3                   	ret    

001034d7 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  1034d7:	55                   	push   %ebp
  1034d8:	89 e5                	mov    %esp,%ebp
  1034da:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  1034dd:	8d 45 14             	lea    0x14(%ebp),%eax
  1034e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  1034e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034e6:	50                   	push   %eax
  1034e7:	ff 75 10             	pushl  0x10(%ebp)
  1034ea:	ff 75 0c             	pushl  0xc(%ebp)
  1034ed:	ff 75 08             	pushl  0x8(%ebp)
  1034f0:	e8 0b 00 00 00       	call   103500 <vsnprintf>
  1034f5:	83 c4 10             	add    $0x10,%esp
  1034f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1034fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1034fe:	c9                   	leave  
  1034ff:	c3                   	ret    

00103500 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  103500:	55                   	push   %ebp
  103501:	89 e5                	mov    %esp,%ebp
  103503:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  103506:	8b 45 08             	mov    0x8(%ebp),%eax
  103509:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10350c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10350f:	8d 50 ff             	lea    -0x1(%eax),%edx
  103512:	8b 45 08             	mov    0x8(%ebp),%eax
  103515:	01 d0                	add    %edx,%eax
  103517:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10351a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  103521:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103525:	74 0a                	je     103531 <vsnprintf+0x31>
  103527:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10352a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10352d:	39 c2                	cmp    %eax,%edx
  10352f:	76 07                	jbe    103538 <vsnprintf+0x38>
        return -E_INVAL;
  103531:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  103536:	eb 20                	jmp    103558 <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  103538:	ff 75 14             	pushl  0x14(%ebp)
  10353b:	ff 75 10             	pushl  0x10(%ebp)
  10353e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  103541:	50                   	push   %eax
  103542:	68 a1 34 10 00       	push   $0x1034a1
  103547:	e8 ad fb ff ff       	call   1030f9 <vprintfmt>
  10354c:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
  10354f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103552:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  103555:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103558:	c9                   	leave  
  103559:	c3                   	ret    
