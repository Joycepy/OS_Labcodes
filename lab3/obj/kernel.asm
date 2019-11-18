
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 20 12 00       	mov    $0x122000,%eax
    movl %eax, %cr3
c0100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
c0100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
c010000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
c0100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
c0100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
c0100016:	8d 05 1e 00 10 c0    	lea    0xc010001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
c010001c:	ff e0                	jmp    *%eax

c010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
c010001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
c0100020:	a3 00 20 12 c0       	mov    %eax,0xc0122000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 10 12 c0       	mov    $0xc0121000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c010002f:	e8 02 00 00 00       	call   c0100036 <kern_init>

c0100034 <spin>:

# should never get here
spin:
    jmp spin
c0100034:	eb fe                	jmp    c0100034 <spin>

c0100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));

static void lab1_switch_test(void);

int
kern_init(void) {
c0100036:	55                   	push   %ebp
c0100037:	89 e5                	mov    %esp,%ebp
c0100039:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c010003c:	ba fc 50 12 c0       	mov    $0xc01250fc,%edx
c0100041:	b8 00 40 12 c0       	mov    $0xc0124000,%eax
c0100046:	29 c2                	sub    %eax,%edx
c0100048:	89 d0                	mov    %edx,%eax
c010004a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100055:	00 
c0100056:	c7 04 24 00 40 12 c0 	movl   $0xc0124000,(%esp)
c010005d:	e8 f9 89 00 00       	call   c0108a5b <memset>

    cons_init();                // init the console
c0100062:	e8 06 1e 00 00       	call   c0101e6d <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100067:	c7 45 f4 40 93 10 c0 	movl   $0xc0109340,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100071:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100075:	c7 04 24 5c 93 10 c0 	movl   $0xc010935c,(%esp)
c010007c:	e8 20 02 00 00       	call   c01002a1 <cprintf>

    print_kerninfo();
c0100081:	e8 d2 08 00 00       	call   c0100958 <print_kerninfo>

    grade_backtrace();
c0100086:	e8 95 00 00 00       	call   c0100120 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010008b:	e8 08 72 00 00       	call   c0107298 <pmm_init>

    pic_init();                 // init interrupt controller
c0100090:	e8 35 1f 00 00       	call   c0101fca <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100095:	e8 b9 20 00 00       	call   c0102153 <idt_init>

    vmm_init();                 // init virtual memory management
c010009a:	e8 55 3c 00 00       	call   c0103cf4 <vmm_init>

    ide_init();                 // init ide devices
c010009f:	e8 64 0d 00 00       	call   c0100e08 <ide_init>
    swap_init();                // init swap
c01000a4:	e8 30 46 00 00       	call   c01046d9 <swap_init>

    clock_init();               // init clock interrupt
c01000a9:	e8 75 15 00 00       	call   c0101623 <clock_init>
    intr_enable();              // enable irq interrupt
c01000ae:	e8 52 20 00 00       	call   c0102105 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c01000b3:	eb fe                	jmp    c01000b3 <kern_init+0x7d>

c01000b5 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000b5:	55                   	push   %ebp
c01000b6:	89 e5                	mov    %esp,%ebp
c01000b8:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000bb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000c2:	00 
c01000c3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000ca:	00 
c01000cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000d2:	e8 c5 0c 00 00       	call   c0100d9c <mon_backtrace>
}
c01000d7:	c9                   	leave  
c01000d8:	c3                   	ret    

c01000d9 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000d9:	55                   	push   %ebp
c01000da:	89 e5                	mov    %esp,%ebp
c01000dc:	53                   	push   %ebx
c01000dd:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000e0:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000e6:	8d 55 08             	lea    0x8(%ebp),%edx
c01000e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01000ec:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000f0:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000f4:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000f8:	89 04 24             	mov    %eax,(%esp)
c01000fb:	e8 b5 ff ff ff       	call   c01000b5 <grade_backtrace2>
}
c0100100:	83 c4 14             	add    $0x14,%esp
c0100103:	5b                   	pop    %ebx
c0100104:	5d                   	pop    %ebp
c0100105:	c3                   	ret    

c0100106 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c0100106:	55                   	push   %ebp
c0100107:	89 e5                	mov    %esp,%ebp
c0100109:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c010010c:	8b 45 10             	mov    0x10(%ebp),%eax
c010010f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100113:	8b 45 08             	mov    0x8(%ebp),%eax
c0100116:	89 04 24             	mov    %eax,(%esp)
c0100119:	e8 bb ff ff ff       	call   c01000d9 <grade_backtrace1>
}
c010011e:	c9                   	leave  
c010011f:	c3                   	ret    

c0100120 <grade_backtrace>:

void
grade_backtrace(void) {
c0100120:	55                   	push   %ebp
c0100121:	89 e5                	mov    %esp,%ebp
c0100123:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c0100126:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c010012b:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100132:	ff 
c0100133:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100137:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010013e:	e8 c3 ff ff ff       	call   c0100106 <grade_backtrace0>
}
c0100143:	c9                   	leave  
c0100144:	c3                   	ret    

c0100145 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c0100145:	55                   	push   %ebp
c0100146:	89 e5                	mov    %esp,%ebp
c0100148:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c010014b:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c010014e:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100151:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100154:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100157:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010015b:	0f b7 c0             	movzwl %ax,%eax
c010015e:	83 e0 03             	and    $0x3,%eax
c0100161:	89 c2                	mov    %eax,%edx
c0100163:	a1 00 40 12 c0       	mov    0xc0124000,%eax
c0100168:	89 54 24 08          	mov    %edx,0x8(%esp)
c010016c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100170:	c7 04 24 61 93 10 c0 	movl   $0xc0109361,(%esp)
c0100177:	e8 25 01 00 00       	call   c01002a1 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c010017c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100180:	0f b7 d0             	movzwl %ax,%edx
c0100183:	a1 00 40 12 c0       	mov    0xc0124000,%eax
c0100188:	89 54 24 08          	mov    %edx,0x8(%esp)
c010018c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100190:	c7 04 24 6f 93 10 c0 	movl   $0xc010936f,(%esp)
c0100197:	e8 05 01 00 00       	call   c01002a1 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c010019c:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c01001a0:	0f b7 d0             	movzwl %ax,%edx
c01001a3:	a1 00 40 12 c0       	mov    0xc0124000,%eax
c01001a8:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001ac:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b0:	c7 04 24 7d 93 10 c0 	movl   $0xc010937d,(%esp)
c01001b7:	e8 e5 00 00 00       	call   c01002a1 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001bc:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001c0:	0f b7 d0             	movzwl %ax,%edx
c01001c3:	a1 00 40 12 c0       	mov    0xc0124000,%eax
c01001c8:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001cc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d0:	c7 04 24 8b 93 10 c0 	movl   $0xc010938b,(%esp)
c01001d7:	e8 c5 00 00 00       	call   c01002a1 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001dc:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001e0:	0f b7 d0             	movzwl %ax,%edx
c01001e3:	a1 00 40 12 c0       	mov    0xc0124000,%eax
c01001e8:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001ec:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001f0:	c7 04 24 99 93 10 c0 	movl   $0xc0109399,(%esp)
c01001f7:	e8 a5 00 00 00       	call   c01002a1 <cprintf>
    round ++;
c01001fc:	a1 00 40 12 c0       	mov    0xc0124000,%eax
c0100201:	83 c0 01             	add    $0x1,%eax
c0100204:	a3 00 40 12 c0       	mov    %eax,0xc0124000
}
c0100209:	c9                   	leave  
c010020a:	c3                   	ret    

c010020b <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c010020b:	55                   	push   %ebp
c010020c:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c010020e:	5d                   	pop    %ebp
c010020f:	c3                   	ret    

c0100210 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c0100210:	55                   	push   %ebp
c0100211:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c0100213:	5d                   	pop    %ebp
c0100214:	c3                   	ret    

c0100215 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c0100215:	55                   	push   %ebp
c0100216:	89 e5                	mov    %esp,%ebp
c0100218:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c010021b:	e8 25 ff ff ff       	call   c0100145 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100220:	c7 04 24 a8 93 10 c0 	movl   $0xc01093a8,(%esp)
c0100227:	e8 75 00 00 00       	call   c01002a1 <cprintf>
    lab1_switch_to_user();
c010022c:	e8 da ff ff ff       	call   c010020b <lab1_switch_to_user>
    lab1_print_cur_status();
c0100231:	e8 0f ff ff ff       	call   c0100145 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100236:	c7 04 24 c8 93 10 c0 	movl   $0xc01093c8,(%esp)
c010023d:	e8 5f 00 00 00       	call   c01002a1 <cprintf>
    lab1_switch_to_kernel();
c0100242:	e8 c9 ff ff ff       	call   c0100210 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100247:	e8 f9 fe ff ff       	call   c0100145 <lab1_print_cur_status>
}
c010024c:	c9                   	leave  
c010024d:	c3                   	ret    

c010024e <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c010024e:	55                   	push   %ebp
c010024f:	89 e5                	mov    %esp,%ebp
c0100251:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100254:	8b 45 08             	mov    0x8(%ebp),%eax
c0100257:	89 04 24             	mov    %eax,(%esp)
c010025a:	e8 3a 1c 00 00       	call   c0101e99 <cons_putc>
    (*cnt) ++;
c010025f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100262:	8b 00                	mov    (%eax),%eax
c0100264:	8d 50 01             	lea    0x1(%eax),%edx
c0100267:	8b 45 0c             	mov    0xc(%ebp),%eax
c010026a:	89 10                	mov    %edx,(%eax)
}
c010026c:	c9                   	leave  
c010026d:	c3                   	ret    

c010026e <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c010026e:	55                   	push   %ebp
c010026f:	89 e5                	mov    %esp,%ebp
c0100271:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100274:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c010027b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010027e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0100282:	8b 45 08             	mov    0x8(%ebp),%eax
c0100285:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100289:	8d 45 f4             	lea    -0xc(%ebp),%eax
c010028c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100290:	c7 04 24 4e 02 10 c0 	movl   $0xc010024e,(%esp)
c0100297:	e8 11 8b 00 00       	call   c0108dad <vprintfmt>
    return cnt;
c010029c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010029f:	c9                   	leave  
c01002a0:	c3                   	ret    

c01002a1 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c01002a1:	55                   	push   %ebp
c01002a2:	89 e5                	mov    %esp,%ebp
c01002a4:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c01002a7:	8d 45 0c             	lea    0xc(%ebp),%eax
c01002aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c01002ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002b0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01002b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01002b7:	89 04 24             	mov    %eax,(%esp)
c01002ba:	e8 af ff ff ff       	call   c010026e <vcprintf>
c01002bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01002c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01002c5:	c9                   	leave  
c01002c6:	c3                   	ret    

c01002c7 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c01002c7:	55                   	push   %ebp
c01002c8:	89 e5                	mov    %esp,%ebp
c01002ca:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002cd:	8b 45 08             	mov    0x8(%ebp),%eax
c01002d0:	89 04 24             	mov    %eax,(%esp)
c01002d3:	e8 c1 1b 00 00       	call   c0101e99 <cons_putc>
}
c01002d8:	c9                   	leave  
c01002d9:	c3                   	ret    

c01002da <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c01002da:	55                   	push   %ebp
c01002db:	89 e5                	mov    %esp,%ebp
c01002dd:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c01002e0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c01002e7:	eb 13                	jmp    c01002fc <cputs+0x22>
        cputch(c, &cnt);
c01002e9:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c01002ed:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01002f0:	89 54 24 04          	mov    %edx,0x4(%esp)
c01002f4:	89 04 24             	mov    %eax,(%esp)
c01002f7:	e8 52 ff ff ff       	call   c010024e <cputch>
    while ((c = *str ++) != '\0') {
c01002fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01002ff:	8d 50 01             	lea    0x1(%eax),%edx
c0100302:	89 55 08             	mov    %edx,0x8(%ebp)
c0100305:	0f b6 00             	movzbl (%eax),%eax
c0100308:	88 45 f7             	mov    %al,-0x9(%ebp)
c010030b:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c010030f:	75 d8                	jne    c01002e9 <cputs+0xf>
    }
    cputch('\n', &cnt);
c0100311:	8d 45 f0             	lea    -0x10(%ebp),%eax
c0100314:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100318:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c010031f:	e8 2a ff ff ff       	call   c010024e <cputch>
    return cnt;
c0100324:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0100327:	c9                   	leave  
c0100328:	c3                   	ret    

c0100329 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c0100329:	55                   	push   %ebp
c010032a:	89 e5                	mov    %esp,%ebp
c010032c:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c010032f:	e8 a1 1b 00 00       	call   c0101ed5 <cons_getc>
c0100334:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100337:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010033b:	74 f2                	je     c010032f <getchar+0x6>
        /* do nothing */;
    return c;
c010033d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100340:	c9                   	leave  
c0100341:	c3                   	ret    

c0100342 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100342:	55                   	push   %ebp
c0100343:	89 e5                	mov    %esp,%ebp
c0100345:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100348:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010034c:	74 13                	je     c0100361 <readline+0x1f>
        cprintf("%s", prompt);
c010034e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100351:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100355:	c7 04 24 e7 93 10 c0 	movl   $0xc01093e7,(%esp)
c010035c:	e8 40 ff ff ff       	call   c01002a1 <cprintf>
    }
    int i = 0, c;
c0100361:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100368:	e8 bc ff ff ff       	call   c0100329 <getchar>
c010036d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100370:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100374:	79 07                	jns    c010037d <readline+0x3b>
            return NULL;
c0100376:	b8 00 00 00 00       	mov    $0x0,%eax
c010037b:	eb 79                	jmp    c01003f6 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010037d:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100381:	7e 28                	jle    c01003ab <readline+0x69>
c0100383:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010038a:	7f 1f                	jg     c01003ab <readline+0x69>
            cputchar(c);
c010038c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010038f:	89 04 24             	mov    %eax,(%esp)
c0100392:	e8 30 ff ff ff       	call   c01002c7 <cputchar>
            buf[i ++] = c;
c0100397:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010039a:	8d 50 01             	lea    0x1(%eax),%edx
c010039d:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01003a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01003a3:	88 90 20 40 12 c0    	mov    %dl,-0x3fedbfe0(%eax)
c01003a9:	eb 46                	jmp    c01003f1 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c01003ab:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01003af:	75 17                	jne    c01003c8 <readline+0x86>
c01003b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003b5:	7e 11                	jle    c01003c8 <readline+0x86>
            cputchar(c);
c01003b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01003ba:	89 04 24             	mov    %eax,(%esp)
c01003bd:	e8 05 ff ff ff       	call   c01002c7 <cputchar>
            i --;
c01003c2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01003c6:	eb 29                	jmp    c01003f1 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01003c8:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01003cc:	74 06                	je     c01003d4 <readline+0x92>
c01003ce:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01003d2:	75 1d                	jne    c01003f1 <readline+0xaf>
            cputchar(c);
c01003d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01003d7:	89 04 24             	mov    %eax,(%esp)
c01003da:	e8 e8 fe ff ff       	call   c01002c7 <cputchar>
            buf[i] = '\0';
c01003df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003e2:	05 20 40 12 c0       	add    $0xc0124020,%eax
c01003e7:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01003ea:	b8 20 40 12 c0       	mov    $0xc0124020,%eax
c01003ef:	eb 05                	jmp    c01003f6 <readline+0xb4>
        }
    }
c01003f1:	e9 72 ff ff ff       	jmp    c0100368 <readline+0x26>
}
c01003f6:	c9                   	leave  
c01003f7:	c3                   	ret    

c01003f8 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c01003f8:	55                   	push   %ebp
c01003f9:	89 e5                	mov    %esp,%ebp
c01003fb:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c01003fe:	a1 20 44 12 c0       	mov    0xc0124420,%eax
c0100403:	85 c0                	test   %eax,%eax
c0100405:	74 02                	je     c0100409 <__panic+0x11>
        goto panic_dead;
c0100407:	eb 59                	jmp    c0100462 <__panic+0x6a>
    }
    is_panic = 1;
c0100409:	c7 05 20 44 12 c0 01 	movl   $0x1,0xc0124420
c0100410:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100413:	8d 45 14             	lea    0x14(%ebp),%eax
c0100416:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100419:	8b 45 0c             	mov    0xc(%ebp),%eax
c010041c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100420:	8b 45 08             	mov    0x8(%ebp),%eax
c0100423:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100427:	c7 04 24 ea 93 10 c0 	movl   $0xc01093ea,(%esp)
c010042e:	e8 6e fe ff ff       	call   c01002a1 <cprintf>
    vcprintf(fmt, ap);
c0100433:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100436:	89 44 24 04          	mov    %eax,0x4(%esp)
c010043a:	8b 45 10             	mov    0x10(%ebp),%eax
c010043d:	89 04 24             	mov    %eax,(%esp)
c0100440:	e8 29 fe ff ff       	call   c010026e <vcprintf>
    cprintf("\n");
c0100445:	c7 04 24 06 94 10 c0 	movl   $0xc0109406,(%esp)
c010044c:	e8 50 fe ff ff       	call   c01002a1 <cprintf>
    
    cprintf("stack trackback:\n");
c0100451:	c7 04 24 08 94 10 c0 	movl   $0xc0109408,(%esp)
c0100458:	e8 44 fe ff ff       	call   c01002a1 <cprintf>
    print_stackframe();
c010045d:	e8 40 06 00 00       	call   c0100aa2 <print_stackframe>
    
    va_end(ap);

panic_dead:
    intr_disable();
c0100462:	e8 a4 1c 00 00       	call   c010210b <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100467:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010046e:	e8 5a 08 00 00       	call   c0100ccd <kmonitor>
    }
c0100473:	eb f2                	jmp    c0100467 <__panic+0x6f>

c0100475 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100475:	55                   	push   %ebp
c0100476:	89 e5                	mov    %esp,%ebp
c0100478:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c010047b:	8d 45 14             	lea    0x14(%ebp),%eax
c010047e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100481:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100484:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100488:	8b 45 08             	mov    0x8(%ebp),%eax
c010048b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010048f:	c7 04 24 1a 94 10 c0 	movl   $0xc010941a,(%esp)
c0100496:	e8 06 fe ff ff       	call   c01002a1 <cprintf>
    vcprintf(fmt, ap);
c010049b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010049e:	89 44 24 04          	mov    %eax,0x4(%esp)
c01004a2:	8b 45 10             	mov    0x10(%ebp),%eax
c01004a5:	89 04 24             	mov    %eax,(%esp)
c01004a8:	e8 c1 fd ff ff       	call   c010026e <vcprintf>
    cprintf("\n");
c01004ad:	c7 04 24 06 94 10 c0 	movl   $0xc0109406,(%esp)
c01004b4:	e8 e8 fd ff ff       	call   c01002a1 <cprintf>
    va_end(ap);
}
c01004b9:	c9                   	leave  
c01004ba:	c3                   	ret    

c01004bb <is_kernel_panic>:

bool
is_kernel_panic(void) {
c01004bb:	55                   	push   %ebp
c01004bc:	89 e5                	mov    %esp,%ebp
    return is_panic;
c01004be:	a1 20 44 12 c0       	mov    0xc0124420,%eax
}
c01004c3:	5d                   	pop    %ebp
c01004c4:	c3                   	ret    

c01004c5 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01004c5:	55                   	push   %ebp
c01004c6:	89 e5                	mov    %esp,%ebp
c01004c8:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01004cb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004ce:	8b 00                	mov    (%eax),%eax
c01004d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01004d3:	8b 45 10             	mov    0x10(%ebp),%eax
c01004d6:	8b 00                	mov    (%eax),%eax
c01004d8:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01004e2:	e9 d2 00 00 00       	jmp    c01005b9 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c01004e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01004ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01004ed:	01 d0                	add    %edx,%eax
c01004ef:	89 c2                	mov    %eax,%edx
c01004f1:	c1 ea 1f             	shr    $0x1f,%edx
c01004f4:	01 d0                	add    %edx,%eax
c01004f6:	d1 f8                	sar    %eax
c01004f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01004fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01004fe:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100501:	eb 04                	jmp    c0100507 <stab_binsearch+0x42>
            m --;
c0100503:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
c0100507:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010050a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010050d:	7c 1f                	jl     c010052e <stab_binsearch+0x69>
c010050f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100512:	89 d0                	mov    %edx,%eax
c0100514:	01 c0                	add    %eax,%eax
c0100516:	01 d0                	add    %edx,%eax
c0100518:	c1 e0 02             	shl    $0x2,%eax
c010051b:	89 c2                	mov    %eax,%edx
c010051d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100520:	01 d0                	add    %edx,%eax
c0100522:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100526:	0f b6 c0             	movzbl %al,%eax
c0100529:	3b 45 14             	cmp    0x14(%ebp),%eax
c010052c:	75 d5                	jne    c0100503 <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
c010052e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100531:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100534:	7d 0b                	jge    c0100541 <stab_binsearch+0x7c>
            l = true_m + 1;
c0100536:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100539:	83 c0 01             	add    $0x1,%eax
c010053c:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c010053f:	eb 78                	jmp    c01005b9 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100541:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100548:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010054b:	89 d0                	mov    %edx,%eax
c010054d:	01 c0                	add    %eax,%eax
c010054f:	01 d0                	add    %edx,%eax
c0100551:	c1 e0 02             	shl    $0x2,%eax
c0100554:	89 c2                	mov    %eax,%edx
c0100556:	8b 45 08             	mov    0x8(%ebp),%eax
c0100559:	01 d0                	add    %edx,%eax
c010055b:	8b 40 08             	mov    0x8(%eax),%eax
c010055e:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100561:	73 13                	jae    c0100576 <stab_binsearch+0xb1>
            *region_left = m;
c0100563:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100566:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100569:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c010056b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010056e:	83 c0 01             	add    $0x1,%eax
c0100571:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100574:	eb 43                	jmp    c01005b9 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c0100576:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100579:	89 d0                	mov    %edx,%eax
c010057b:	01 c0                	add    %eax,%eax
c010057d:	01 d0                	add    %edx,%eax
c010057f:	c1 e0 02             	shl    $0x2,%eax
c0100582:	89 c2                	mov    %eax,%edx
c0100584:	8b 45 08             	mov    0x8(%ebp),%eax
c0100587:	01 d0                	add    %edx,%eax
c0100589:	8b 40 08             	mov    0x8(%eax),%eax
c010058c:	3b 45 18             	cmp    0x18(%ebp),%eax
c010058f:	76 16                	jbe    c01005a7 <stab_binsearch+0xe2>
            *region_right = m - 1;
c0100591:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100594:	8d 50 ff             	lea    -0x1(%eax),%edx
c0100597:	8b 45 10             	mov    0x10(%ebp),%eax
c010059a:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c010059c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010059f:	83 e8 01             	sub    $0x1,%eax
c01005a2:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01005a5:	eb 12                	jmp    c01005b9 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01005a7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005ad:	89 10                	mov    %edx,(%eax)
            l = m;
c01005af:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01005b5:	83 45 18 01          	addl   $0x1,0x18(%ebp)
    while (l <= r) {
c01005b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01005bc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01005bf:	0f 8e 22 ff ff ff    	jle    c01004e7 <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
c01005c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01005c9:	75 0f                	jne    c01005da <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01005cb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005ce:	8b 00                	mov    (%eax),%eax
c01005d0:	8d 50 ff             	lea    -0x1(%eax),%edx
c01005d3:	8b 45 10             	mov    0x10(%ebp),%eax
c01005d6:	89 10                	mov    %edx,(%eax)
c01005d8:	eb 3f                	jmp    c0100619 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01005da:	8b 45 10             	mov    0x10(%ebp),%eax
c01005dd:	8b 00                	mov    (%eax),%eax
c01005df:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01005e2:	eb 04                	jmp    c01005e8 <stab_binsearch+0x123>
c01005e4:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c01005e8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005eb:	8b 00                	mov    (%eax),%eax
c01005ed:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01005f0:	7d 1f                	jge    c0100611 <stab_binsearch+0x14c>
c01005f2:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01005f5:	89 d0                	mov    %edx,%eax
c01005f7:	01 c0                	add    %eax,%eax
c01005f9:	01 d0                	add    %edx,%eax
c01005fb:	c1 e0 02             	shl    $0x2,%eax
c01005fe:	89 c2                	mov    %eax,%edx
c0100600:	8b 45 08             	mov    0x8(%ebp),%eax
c0100603:	01 d0                	add    %edx,%eax
c0100605:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100609:	0f b6 c0             	movzbl %al,%eax
c010060c:	3b 45 14             	cmp    0x14(%ebp),%eax
c010060f:	75 d3                	jne    c01005e4 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100611:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100614:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100617:	89 10                	mov    %edx,(%eax)
    }
}
c0100619:	c9                   	leave  
c010061a:	c3                   	ret    

c010061b <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c010061b:	55                   	push   %ebp
c010061c:	89 e5                	mov    %esp,%ebp
c010061e:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100621:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100624:	c7 00 38 94 10 c0    	movl   $0xc0109438,(%eax)
    info->eip_line = 0;
c010062a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010062d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100634:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100637:	c7 40 08 38 94 10 c0 	movl   $0xc0109438,0x8(%eax)
    info->eip_fn_namelen = 9;
c010063e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100641:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100648:	8b 45 0c             	mov    0xc(%ebp),%eax
c010064b:	8b 55 08             	mov    0x8(%ebp),%edx
c010064e:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100651:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100654:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c010065b:	c7 45 f4 d0 b5 10 c0 	movl   $0xc010b5d0,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100662:	c7 45 f0 70 ae 11 c0 	movl   $0xc011ae70,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100669:	c7 45 ec 71 ae 11 c0 	movl   $0xc011ae71,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100670:	c7 45 e8 a6 e8 11 c0 	movl   $0xc011e8a6,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c0100677:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010067a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010067d:	76 0d                	jbe    c010068c <debuginfo_eip+0x71>
c010067f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100682:	83 e8 01             	sub    $0x1,%eax
c0100685:	0f b6 00             	movzbl (%eax),%eax
c0100688:	84 c0                	test   %al,%al
c010068a:	74 0a                	je     c0100696 <debuginfo_eip+0x7b>
        return -1;
c010068c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100691:	e9 c0 02 00 00       	jmp    c0100956 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c0100696:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c010069d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01006a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006a3:	29 c2                	sub    %eax,%edx
c01006a5:	89 d0                	mov    %edx,%eax
c01006a7:	c1 f8 02             	sar    $0x2,%eax
c01006aa:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01006b0:	83 e8 01             	sub    $0x1,%eax
c01006b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01006b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01006b9:	89 44 24 10          	mov    %eax,0x10(%esp)
c01006bd:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01006c4:	00 
c01006c5:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01006c8:	89 44 24 08          	mov    %eax,0x8(%esp)
c01006cc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01006cf:	89 44 24 04          	mov    %eax,0x4(%esp)
c01006d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006d6:	89 04 24             	mov    %eax,(%esp)
c01006d9:	e8 e7 fd ff ff       	call   c01004c5 <stab_binsearch>
    if (lfile == 0)
c01006de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006e1:	85 c0                	test   %eax,%eax
c01006e3:	75 0a                	jne    c01006ef <debuginfo_eip+0xd4>
        return -1;
c01006e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01006ea:	e9 67 02 00 00       	jmp    c0100956 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c01006ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006f2:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01006f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006f8:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c01006fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01006fe:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100702:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100709:	00 
c010070a:	8d 45 d8             	lea    -0x28(%ebp),%eax
c010070d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100711:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100714:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100718:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010071b:	89 04 24             	mov    %eax,(%esp)
c010071e:	e8 a2 fd ff ff       	call   c01004c5 <stab_binsearch>

    if (lfun <= rfun) {
c0100723:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100726:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100729:	39 c2                	cmp    %eax,%edx
c010072b:	7f 7c                	jg     c01007a9 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c010072d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100730:	89 c2                	mov    %eax,%edx
c0100732:	89 d0                	mov    %edx,%eax
c0100734:	01 c0                	add    %eax,%eax
c0100736:	01 d0                	add    %edx,%eax
c0100738:	c1 e0 02             	shl    $0x2,%eax
c010073b:	89 c2                	mov    %eax,%edx
c010073d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100740:	01 d0                	add    %edx,%eax
c0100742:	8b 10                	mov    (%eax),%edx
c0100744:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0100747:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010074a:	29 c1                	sub    %eax,%ecx
c010074c:	89 c8                	mov    %ecx,%eax
c010074e:	39 c2                	cmp    %eax,%edx
c0100750:	73 22                	jae    c0100774 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100752:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100755:	89 c2                	mov    %eax,%edx
c0100757:	89 d0                	mov    %edx,%eax
c0100759:	01 c0                	add    %eax,%eax
c010075b:	01 d0                	add    %edx,%eax
c010075d:	c1 e0 02             	shl    $0x2,%eax
c0100760:	89 c2                	mov    %eax,%edx
c0100762:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100765:	01 d0                	add    %edx,%eax
c0100767:	8b 10                	mov    (%eax),%edx
c0100769:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010076c:	01 c2                	add    %eax,%edx
c010076e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100771:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c0100774:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100777:	89 c2                	mov    %eax,%edx
c0100779:	89 d0                	mov    %edx,%eax
c010077b:	01 c0                	add    %eax,%eax
c010077d:	01 d0                	add    %edx,%eax
c010077f:	c1 e0 02             	shl    $0x2,%eax
c0100782:	89 c2                	mov    %eax,%edx
c0100784:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100787:	01 d0                	add    %edx,%eax
c0100789:	8b 50 08             	mov    0x8(%eax),%edx
c010078c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010078f:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c0100792:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100795:	8b 40 10             	mov    0x10(%eax),%eax
c0100798:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c010079b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010079e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01007a1:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01007a4:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01007a7:	eb 15                	jmp    c01007be <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01007a9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007ac:	8b 55 08             	mov    0x8(%ebp),%edx
c01007af:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01007b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007b5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01007b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01007bb:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01007be:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007c1:	8b 40 08             	mov    0x8(%eax),%eax
c01007c4:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01007cb:	00 
c01007cc:	89 04 24             	mov    %eax,(%esp)
c01007cf:	e8 fb 80 00 00       	call   c01088cf <strfind>
c01007d4:	89 c2                	mov    %eax,%edx
c01007d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007d9:	8b 40 08             	mov    0x8(%eax),%eax
c01007dc:	29 c2                	sub    %eax,%edx
c01007de:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007e1:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01007e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01007e7:	89 44 24 10          	mov    %eax,0x10(%esp)
c01007eb:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c01007f2:	00 
c01007f3:	8d 45 d0             	lea    -0x30(%ebp),%eax
c01007f6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01007fa:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c01007fd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100801:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100804:	89 04 24             	mov    %eax,(%esp)
c0100807:	e8 b9 fc ff ff       	call   c01004c5 <stab_binsearch>
    if (lline <= rline) {
c010080c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010080f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100812:	39 c2                	cmp    %eax,%edx
c0100814:	7f 24                	jg     c010083a <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c0100816:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100819:	89 c2                	mov    %eax,%edx
c010081b:	89 d0                	mov    %edx,%eax
c010081d:	01 c0                	add    %eax,%eax
c010081f:	01 d0                	add    %edx,%eax
c0100821:	c1 e0 02             	shl    $0x2,%eax
c0100824:	89 c2                	mov    %eax,%edx
c0100826:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100829:	01 d0                	add    %edx,%eax
c010082b:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c010082f:	0f b7 d0             	movzwl %ax,%edx
c0100832:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100835:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100838:	eb 13                	jmp    c010084d <debuginfo_eip+0x232>
        return -1;
c010083a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010083f:	e9 12 01 00 00       	jmp    c0100956 <debuginfo_eip+0x33b>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c0100844:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100847:	83 e8 01             	sub    $0x1,%eax
c010084a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
c010084d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100850:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100853:	39 c2                	cmp    %eax,%edx
c0100855:	7c 56                	jl     c01008ad <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c0100857:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010085a:	89 c2                	mov    %eax,%edx
c010085c:	89 d0                	mov    %edx,%eax
c010085e:	01 c0                	add    %eax,%eax
c0100860:	01 d0                	add    %edx,%eax
c0100862:	c1 e0 02             	shl    $0x2,%eax
c0100865:	89 c2                	mov    %eax,%edx
c0100867:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010086a:	01 d0                	add    %edx,%eax
c010086c:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100870:	3c 84                	cmp    $0x84,%al
c0100872:	74 39                	je     c01008ad <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c0100874:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100877:	89 c2                	mov    %eax,%edx
c0100879:	89 d0                	mov    %edx,%eax
c010087b:	01 c0                	add    %eax,%eax
c010087d:	01 d0                	add    %edx,%eax
c010087f:	c1 e0 02             	shl    $0x2,%eax
c0100882:	89 c2                	mov    %eax,%edx
c0100884:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100887:	01 d0                	add    %edx,%eax
c0100889:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010088d:	3c 64                	cmp    $0x64,%al
c010088f:	75 b3                	jne    c0100844 <debuginfo_eip+0x229>
c0100891:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100894:	89 c2                	mov    %eax,%edx
c0100896:	89 d0                	mov    %edx,%eax
c0100898:	01 c0                	add    %eax,%eax
c010089a:	01 d0                	add    %edx,%eax
c010089c:	c1 e0 02             	shl    $0x2,%eax
c010089f:	89 c2                	mov    %eax,%edx
c01008a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008a4:	01 d0                	add    %edx,%eax
c01008a6:	8b 40 08             	mov    0x8(%eax),%eax
c01008a9:	85 c0                	test   %eax,%eax
c01008ab:	74 97                	je     c0100844 <debuginfo_eip+0x229>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01008ad:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01008b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01008b3:	39 c2                	cmp    %eax,%edx
c01008b5:	7c 46                	jl     c01008fd <debuginfo_eip+0x2e2>
c01008b7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008ba:	89 c2                	mov    %eax,%edx
c01008bc:	89 d0                	mov    %edx,%eax
c01008be:	01 c0                	add    %eax,%eax
c01008c0:	01 d0                	add    %edx,%eax
c01008c2:	c1 e0 02             	shl    $0x2,%eax
c01008c5:	89 c2                	mov    %eax,%edx
c01008c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008ca:	01 d0                	add    %edx,%eax
c01008cc:	8b 10                	mov    (%eax),%edx
c01008ce:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01008d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01008d4:	29 c1                	sub    %eax,%ecx
c01008d6:	89 c8                	mov    %ecx,%eax
c01008d8:	39 c2                	cmp    %eax,%edx
c01008da:	73 21                	jae    c01008fd <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01008dc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008df:	89 c2                	mov    %eax,%edx
c01008e1:	89 d0                	mov    %edx,%eax
c01008e3:	01 c0                	add    %eax,%eax
c01008e5:	01 d0                	add    %edx,%eax
c01008e7:	c1 e0 02             	shl    $0x2,%eax
c01008ea:	89 c2                	mov    %eax,%edx
c01008ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008ef:	01 d0                	add    %edx,%eax
c01008f1:	8b 10                	mov    (%eax),%edx
c01008f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01008f6:	01 c2                	add    %eax,%edx
c01008f8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008fb:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c01008fd:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100900:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100903:	39 c2                	cmp    %eax,%edx
c0100905:	7d 4a                	jge    c0100951 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c0100907:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010090a:	83 c0 01             	add    $0x1,%eax
c010090d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100910:	eb 18                	jmp    c010092a <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100912:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100915:	8b 40 14             	mov    0x14(%eax),%eax
c0100918:	8d 50 01             	lea    0x1(%eax),%edx
c010091b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010091e:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
c0100921:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100924:	83 c0 01             	add    $0x1,%eax
c0100927:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010092a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010092d:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
c0100930:	39 c2                	cmp    %eax,%edx
c0100932:	7d 1d                	jge    c0100951 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100934:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100937:	89 c2                	mov    %eax,%edx
c0100939:	89 d0                	mov    %edx,%eax
c010093b:	01 c0                	add    %eax,%eax
c010093d:	01 d0                	add    %edx,%eax
c010093f:	c1 e0 02             	shl    $0x2,%eax
c0100942:	89 c2                	mov    %eax,%edx
c0100944:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100947:	01 d0                	add    %edx,%eax
c0100949:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010094d:	3c a0                	cmp    $0xa0,%al
c010094f:	74 c1                	je     c0100912 <debuginfo_eip+0x2f7>
        }
    }
    return 0;
c0100951:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100956:	c9                   	leave  
c0100957:	c3                   	ret    

c0100958 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100958:	55                   	push   %ebp
c0100959:	89 e5                	mov    %esp,%ebp
c010095b:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c010095e:	c7 04 24 42 94 10 c0 	movl   $0xc0109442,(%esp)
c0100965:	e8 37 f9 ff ff       	call   c01002a1 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c010096a:	c7 44 24 04 36 00 10 	movl   $0xc0100036,0x4(%esp)
c0100971:	c0 
c0100972:	c7 04 24 5b 94 10 c0 	movl   $0xc010945b,(%esp)
c0100979:	e8 23 f9 ff ff       	call   c01002a1 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c010097e:	c7 44 24 04 3d 93 10 	movl   $0xc010933d,0x4(%esp)
c0100985:	c0 
c0100986:	c7 04 24 73 94 10 c0 	movl   $0xc0109473,(%esp)
c010098d:	e8 0f f9 ff ff       	call   c01002a1 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c0100992:	c7 44 24 04 00 40 12 	movl   $0xc0124000,0x4(%esp)
c0100999:	c0 
c010099a:	c7 04 24 8b 94 10 c0 	movl   $0xc010948b,(%esp)
c01009a1:	e8 fb f8 ff ff       	call   c01002a1 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01009a6:	c7 44 24 04 fc 50 12 	movl   $0xc01250fc,0x4(%esp)
c01009ad:	c0 
c01009ae:	c7 04 24 a3 94 10 c0 	movl   $0xc01094a3,(%esp)
c01009b5:	e8 e7 f8 ff ff       	call   c01002a1 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01009ba:	b8 fc 50 12 c0       	mov    $0xc01250fc,%eax
c01009bf:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009c5:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c01009ca:	29 c2                	sub    %eax,%edx
c01009cc:	89 d0                	mov    %edx,%eax
c01009ce:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009d4:	85 c0                	test   %eax,%eax
c01009d6:	0f 48 c2             	cmovs  %edx,%eax
c01009d9:	c1 f8 0a             	sar    $0xa,%eax
c01009dc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009e0:	c7 04 24 bc 94 10 c0 	movl   $0xc01094bc,(%esp)
c01009e7:	e8 b5 f8 ff ff       	call   c01002a1 <cprintf>
}
c01009ec:	c9                   	leave  
c01009ed:	c3                   	ret    

c01009ee <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c01009ee:	55                   	push   %ebp
c01009ef:	89 e5                	mov    %esp,%ebp
c01009f1:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c01009f7:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01009fa:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a01:	89 04 24             	mov    %eax,(%esp)
c0100a04:	e8 12 fc ff ff       	call   c010061b <debuginfo_eip>
c0100a09:	85 c0                	test   %eax,%eax
c0100a0b:	74 15                	je     c0100a22 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100a0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a10:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a14:	c7 04 24 e6 94 10 c0 	movl   $0xc01094e6,(%esp)
c0100a1b:	e8 81 f8 ff ff       	call   c01002a1 <cprintf>
c0100a20:	eb 6d                	jmp    c0100a8f <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100a29:	eb 1c                	jmp    c0100a47 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c0100a2b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a31:	01 d0                	add    %edx,%eax
c0100a33:	0f b6 00             	movzbl (%eax),%eax
c0100a36:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100a3f:	01 ca                	add    %ecx,%edx
c0100a41:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a43:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100a47:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a4a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100a4d:	7f dc                	jg     c0100a2b <print_debuginfo+0x3d>
        }
        fnname[j] = '\0';
c0100a4f:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a58:	01 d0                	add    %edx,%eax
c0100a5a:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100a5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100a60:	8b 55 08             	mov    0x8(%ebp),%edx
c0100a63:	89 d1                	mov    %edx,%ecx
c0100a65:	29 c1                	sub    %eax,%ecx
c0100a67:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100a6a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100a6d:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100a71:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a77:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100a7b:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100a7f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a83:	c7 04 24 02 95 10 c0 	movl   $0xc0109502,(%esp)
c0100a8a:	e8 12 f8 ff ff       	call   c01002a1 <cprintf>
    }
}
c0100a8f:	c9                   	leave  
c0100a90:	c3                   	ret    

c0100a91 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100a91:	55                   	push   %ebp
c0100a92:	89 e5                	mov    %esp,%ebp
c0100a94:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100a97:	8b 45 04             	mov    0x4(%ebp),%eax
c0100a9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100a9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100aa0:	c9                   	leave  
c0100aa1:	c3                   	ret    

c0100aa2 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100aa2:	55                   	push   %ebp
c0100aa3:	89 e5                	mov    %esp,%ebp
c0100aa5:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c0100aa8:	89 e8                	mov    %ebp,%eax
c0100aaa:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c0100aad:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();
c0100ab0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100ab3:	e8 d9 ff ff ff       	call   c0100a91 <read_eip>
c0100ab8:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c0100abb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0100ac2:	e9 88 00 00 00       	jmp    c0100b4f <print_stackframe+0xad>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c0100ac7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100aca:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ad1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ad5:	c7 04 24 14 95 10 c0 	movl   $0xc0109514,(%esp)
c0100adc:	e8 c0 f7 ff ff       	call   c01002a1 <cprintf>
        uint32_t *args = (uint32_t *)ebp + 2;
c0100ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ae4:	83 c0 08             	add    $0x8,%eax
c0100ae7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
c0100aea:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100af1:	eb 25                	jmp    c0100b18 <print_stackframe+0x76>
            cprintf("0x%08x ", args[j]);
c0100af3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100af6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100afd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100b00:	01 d0                	add    %edx,%eax
c0100b02:	8b 00                	mov    (%eax),%eax
c0100b04:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b08:	c7 04 24 30 95 10 c0 	movl   $0xc0109530,(%esp)
c0100b0f:	e8 8d f7 ff ff       	call   c01002a1 <cprintf>
        for (j = 0; j < 4; j ++) {
c0100b14:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100b18:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100b1c:	7e d5                	jle    c0100af3 <print_stackframe+0x51>
        }
        cprintf("\n");
c0100b1e:	c7 04 24 38 95 10 c0 	movl   $0xc0109538,(%esp)
c0100b25:	e8 77 f7 ff ff       	call   c01002a1 <cprintf>
        print_debuginfo(eip - 1);
c0100b2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100b2d:	83 e8 01             	sub    $0x1,%eax
c0100b30:	89 04 24             	mov    %eax,(%esp)
c0100b33:	e8 b6 fe ff ff       	call   c01009ee <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
c0100b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b3b:	83 c0 04             	add    $0x4,%eax
c0100b3e:	8b 00                	mov    (%eax),%eax
c0100b40:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
c0100b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b46:	8b 00                	mov    (%eax),%eax
c0100b48:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c0100b4b:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100b4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100b53:	74 0a                	je     c0100b5f <print_stackframe+0xbd>
c0100b55:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100b59:	0f 8e 68 ff ff ff    	jle    c0100ac7 <print_stackframe+0x25>
    }
}
c0100b5f:	c9                   	leave  
c0100b60:	c3                   	ret    

c0100b61 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100b61:	55                   	push   %ebp
c0100b62:	89 e5                	mov    %esp,%ebp
c0100b64:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100b67:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b6e:	eb 0c                	jmp    c0100b7c <parse+0x1b>
            *buf ++ = '\0';
c0100b70:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b73:	8d 50 01             	lea    0x1(%eax),%edx
c0100b76:	89 55 08             	mov    %edx,0x8(%ebp)
c0100b79:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b7c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b7f:	0f b6 00             	movzbl (%eax),%eax
c0100b82:	84 c0                	test   %al,%al
c0100b84:	74 1d                	je     c0100ba3 <parse+0x42>
c0100b86:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b89:	0f b6 00             	movzbl (%eax),%eax
c0100b8c:	0f be c0             	movsbl %al,%eax
c0100b8f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b93:	c7 04 24 bc 95 10 c0 	movl   $0xc01095bc,(%esp)
c0100b9a:	e8 fd 7c 00 00       	call   c010889c <strchr>
c0100b9f:	85 c0                	test   %eax,%eax
c0100ba1:	75 cd                	jne    c0100b70 <parse+0xf>
        }
        if (*buf == '\0') {
c0100ba3:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ba6:	0f b6 00             	movzbl (%eax),%eax
c0100ba9:	84 c0                	test   %al,%al
c0100bab:	75 02                	jne    c0100baf <parse+0x4e>
            break;
c0100bad:	eb 67                	jmp    c0100c16 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100baf:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100bb3:	75 14                	jne    c0100bc9 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100bb5:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100bbc:	00 
c0100bbd:	c7 04 24 c1 95 10 c0 	movl   $0xc01095c1,(%esp)
c0100bc4:	e8 d8 f6 ff ff       	call   c01002a1 <cprintf>
        }
        argv[argc ++] = buf;
c0100bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bcc:	8d 50 01             	lea    0x1(%eax),%edx
c0100bcf:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100bd2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100bd9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100bdc:	01 c2                	add    %eax,%edx
c0100bde:	8b 45 08             	mov    0x8(%ebp),%eax
c0100be1:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100be3:	eb 04                	jmp    c0100be9 <parse+0x88>
            buf ++;
c0100be5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100be9:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bec:	0f b6 00             	movzbl (%eax),%eax
c0100bef:	84 c0                	test   %al,%al
c0100bf1:	74 1d                	je     c0100c10 <parse+0xaf>
c0100bf3:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bf6:	0f b6 00             	movzbl (%eax),%eax
c0100bf9:	0f be c0             	movsbl %al,%eax
c0100bfc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c00:	c7 04 24 bc 95 10 c0 	movl   $0xc01095bc,(%esp)
c0100c07:	e8 90 7c 00 00       	call   c010889c <strchr>
c0100c0c:	85 c0                	test   %eax,%eax
c0100c0e:	74 d5                	je     c0100be5 <parse+0x84>
        }
    }
c0100c10:	90                   	nop
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100c11:	e9 66 ff ff ff       	jmp    c0100b7c <parse+0x1b>
    return argc;
c0100c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100c19:	c9                   	leave  
c0100c1a:	c3                   	ret    

c0100c1b <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100c1b:	55                   	push   %ebp
c0100c1c:	89 e5                	mov    %esp,%ebp
c0100c1e:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100c21:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100c24:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c28:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c2b:	89 04 24             	mov    %eax,(%esp)
c0100c2e:	e8 2e ff ff ff       	call   c0100b61 <parse>
c0100c33:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100c36:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100c3a:	75 0a                	jne    c0100c46 <runcmd+0x2b>
        return 0;
c0100c3c:	b8 00 00 00 00       	mov    $0x0,%eax
c0100c41:	e9 85 00 00 00       	jmp    c0100ccb <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c46:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c4d:	eb 5c                	jmp    c0100cab <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100c4f:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100c52:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c55:	89 d0                	mov    %edx,%eax
c0100c57:	01 c0                	add    %eax,%eax
c0100c59:	01 d0                	add    %edx,%eax
c0100c5b:	c1 e0 02             	shl    $0x2,%eax
c0100c5e:	05 00 10 12 c0       	add    $0xc0121000,%eax
c0100c63:	8b 00                	mov    (%eax),%eax
c0100c65:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100c69:	89 04 24             	mov    %eax,(%esp)
c0100c6c:	e8 8c 7b 00 00       	call   c01087fd <strcmp>
c0100c71:	85 c0                	test   %eax,%eax
c0100c73:	75 32                	jne    c0100ca7 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100c75:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c78:	89 d0                	mov    %edx,%eax
c0100c7a:	01 c0                	add    %eax,%eax
c0100c7c:	01 d0                	add    %edx,%eax
c0100c7e:	c1 e0 02             	shl    $0x2,%eax
c0100c81:	05 00 10 12 c0       	add    $0xc0121000,%eax
c0100c86:	8b 40 08             	mov    0x8(%eax),%eax
c0100c89:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100c8c:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100c8f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100c92:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100c96:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100c99:	83 c2 04             	add    $0x4,%edx
c0100c9c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100ca0:	89 0c 24             	mov    %ecx,(%esp)
c0100ca3:	ff d0                	call   *%eax
c0100ca5:	eb 24                	jmp    c0100ccb <runcmd+0xb0>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100ca7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cae:	83 f8 02             	cmp    $0x2,%eax
c0100cb1:	76 9c                	jbe    c0100c4f <runcmd+0x34>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100cb3:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100cb6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cba:	c7 04 24 df 95 10 c0 	movl   $0xc01095df,(%esp)
c0100cc1:	e8 db f5 ff ff       	call   c01002a1 <cprintf>
    return 0;
c0100cc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ccb:	c9                   	leave  
c0100ccc:	c3                   	ret    

c0100ccd <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100ccd:	55                   	push   %ebp
c0100cce:	89 e5                	mov    %esp,%ebp
c0100cd0:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100cd3:	c7 04 24 f8 95 10 c0 	movl   $0xc01095f8,(%esp)
c0100cda:	e8 c2 f5 ff ff       	call   c01002a1 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100cdf:	c7 04 24 20 96 10 c0 	movl   $0xc0109620,(%esp)
c0100ce6:	e8 b6 f5 ff ff       	call   c01002a1 <cprintf>

    if (tf != NULL) {
c0100ceb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100cef:	74 0b                	je     c0100cfc <kmonitor+0x2f>
        print_trapframe(tf);
c0100cf1:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cf4:	89 04 24             	mov    %eax,(%esp)
c0100cf7:	e8 90 15 00 00       	call   c010228c <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100cfc:	c7 04 24 45 96 10 c0 	movl   $0xc0109645,(%esp)
c0100d03:	e8 3a f6 ff ff       	call   c0100342 <readline>
c0100d08:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100d0b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100d0f:	74 18                	je     c0100d29 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100d11:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d14:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d1b:	89 04 24             	mov    %eax,(%esp)
c0100d1e:	e8 f8 fe ff ff       	call   c0100c1b <runcmd>
c0100d23:	85 c0                	test   %eax,%eax
c0100d25:	79 02                	jns    c0100d29 <kmonitor+0x5c>
                break;
c0100d27:	eb 02                	jmp    c0100d2b <kmonitor+0x5e>
            }
        }
    }
c0100d29:	eb d1                	jmp    c0100cfc <kmonitor+0x2f>
}
c0100d2b:	c9                   	leave  
c0100d2c:	c3                   	ret    

c0100d2d <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100d2d:	55                   	push   %ebp
c0100d2e:	89 e5                	mov    %esp,%ebp
c0100d30:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d33:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100d3a:	eb 3f                	jmp    c0100d7b <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100d3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d3f:	89 d0                	mov    %edx,%eax
c0100d41:	01 c0                	add    %eax,%eax
c0100d43:	01 d0                	add    %edx,%eax
c0100d45:	c1 e0 02             	shl    $0x2,%eax
c0100d48:	05 00 10 12 c0       	add    $0xc0121000,%eax
c0100d4d:	8b 48 04             	mov    0x4(%eax),%ecx
c0100d50:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d53:	89 d0                	mov    %edx,%eax
c0100d55:	01 c0                	add    %eax,%eax
c0100d57:	01 d0                	add    %edx,%eax
c0100d59:	c1 e0 02             	shl    $0x2,%eax
c0100d5c:	05 00 10 12 c0       	add    $0xc0121000,%eax
c0100d61:	8b 00                	mov    (%eax),%eax
c0100d63:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100d67:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d6b:	c7 04 24 49 96 10 c0 	movl   $0xc0109649,(%esp)
c0100d72:	e8 2a f5 ff ff       	call   c01002a1 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d77:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100d7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d7e:	83 f8 02             	cmp    $0x2,%eax
c0100d81:	76 b9                	jbe    c0100d3c <mon_help+0xf>
    }
    return 0;
c0100d83:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d88:	c9                   	leave  
c0100d89:	c3                   	ret    

c0100d8a <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100d8a:	55                   	push   %ebp
c0100d8b:	89 e5                	mov    %esp,%ebp
c0100d8d:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100d90:	e8 c3 fb ff ff       	call   c0100958 <print_kerninfo>
    return 0;
c0100d95:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d9a:	c9                   	leave  
c0100d9b:	c3                   	ret    

c0100d9c <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100d9c:	55                   	push   %ebp
c0100d9d:	89 e5                	mov    %esp,%ebp
c0100d9f:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100da2:	e8 fb fc ff ff       	call   c0100aa2 <print_stackframe>
    return 0;
c0100da7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100dac:	c9                   	leave  
c0100dad:	c3                   	ret    

c0100dae <ide_wait_ready>:
    unsigned int size;          // Size in Sectors
    unsigned char model[41];    // Model in String
} ide_devices[MAX_IDE];

static int
ide_wait_ready(unsigned short iobase, bool check_error) {
c0100dae:	55                   	push   %ebp
c0100daf:	89 e5                	mov    %esp,%ebp
c0100db1:	83 ec 14             	sub    $0x14,%esp
c0100db4:	8b 45 08             	mov    0x8(%ebp),%eax
c0100db7:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    int r;
    while ((r = inb(iobase + ISA_STATUS)) & IDE_BSY)
c0100dbb:	90                   	nop
c0100dbc:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0100dc0:	83 c0 07             	add    $0x7,%eax
c0100dc3:	0f b7 c0             	movzwl %ax,%eax
c0100dc6:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100dca:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100dce:	89 c2                	mov    %eax,%edx
c0100dd0:	ec                   	in     (%dx),%al
c0100dd1:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0100dd4:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0100dd8:	0f b6 c0             	movzbl %al,%eax
c0100ddb:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100dde:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100de1:	25 80 00 00 00       	and    $0x80,%eax
c0100de6:	85 c0                	test   %eax,%eax
c0100de8:	75 d2                	jne    c0100dbc <ide_wait_ready+0xe>
        /* nothing */;
    if (check_error && (r & (IDE_DF | IDE_ERR)) != 0) {
c0100dea:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0100dee:	74 11                	je     c0100e01 <ide_wait_ready+0x53>
c0100df0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100df3:	83 e0 21             	and    $0x21,%eax
c0100df6:	85 c0                	test   %eax,%eax
c0100df8:	74 07                	je     c0100e01 <ide_wait_ready+0x53>
        return -1;
c0100dfa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100dff:	eb 05                	jmp    c0100e06 <ide_wait_ready+0x58>
    }
    return 0;
c0100e01:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e06:	c9                   	leave  
c0100e07:	c3                   	ret    

c0100e08 <ide_init>:

void
ide_init(void) {
c0100e08:	55                   	push   %ebp
c0100e09:	89 e5                	mov    %esp,%ebp
c0100e0b:	57                   	push   %edi
c0100e0c:	53                   	push   %ebx
c0100e0d:	81 ec 50 02 00 00    	sub    $0x250,%esp
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c0100e13:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
c0100e19:	e9 d6 02 00 00       	jmp    c01010f4 <ide_init+0x2ec>
        /* assume that no device here */
        ide_devices[ideno].valid = 0;
c0100e1e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e22:	c1 e0 03             	shl    $0x3,%eax
c0100e25:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0100e2c:	29 c2                	sub    %eax,%edx
c0100e2e:	8d 82 40 44 12 c0    	lea    -0x3fedbbc0(%edx),%eax
c0100e34:	c6 00 00             	movb   $0x0,(%eax)

        iobase = IO_BASE(ideno);
c0100e37:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e3b:	66 d1 e8             	shr    %ax
c0100e3e:	0f b7 c0             	movzwl %ax,%eax
c0100e41:	0f b7 04 85 54 96 10 	movzwl -0x3fef69ac(,%eax,4),%eax
c0100e48:	c0 
c0100e49:	66 89 45 ea          	mov    %ax,-0x16(%ebp)

        /* wait device ready */
        ide_wait_ready(iobase, 0);
c0100e4d:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100e51:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100e58:	00 
c0100e59:	89 04 24             	mov    %eax,(%esp)
c0100e5c:	e8 4d ff ff ff       	call   c0100dae <ide_wait_ready>

        /* step1: select drive */
        outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4));
c0100e61:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e65:	83 e0 01             	and    $0x1,%eax
c0100e68:	c1 e0 04             	shl    $0x4,%eax
c0100e6b:	83 c8 e0             	or     $0xffffffe0,%eax
c0100e6e:	0f b6 c0             	movzbl %al,%eax
c0100e71:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100e75:	83 c2 06             	add    $0x6,%edx
c0100e78:	0f b7 d2             	movzwl %dx,%edx
c0100e7b:	66 89 55 d2          	mov    %dx,-0x2e(%ebp)
c0100e7f:	88 45 d1             	mov    %al,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e82:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0100e86:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0100e8a:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c0100e8b:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100e8f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100e96:	00 
c0100e97:	89 04 24             	mov    %eax,(%esp)
c0100e9a:	e8 0f ff ff ff       	call   c0100dae <ide_wait_ready>

        /* step2: send ATA identify command */
        outb(iobase + ISA_COMMAND, IDE_CMD_IDENTIFY);
c0100e9f:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100ea3:	83 c0 07             	add    $0x7,%eax
c0100ea6:	0f b7 c0             	movzwl %ax,%eax
c0100ea9:	66 89 45 ce          	mov    %ax,-0x32(%ebp)
c0100ead:	c6 45 cd ec          	movb   $0xec,-0x33(%ebp)
c0100eb1:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0100eb5:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0100eb9:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c0100eba:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100ebe:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100ec5:	00 
c0100ec6:	89 04 24             	mov    %eax,(%esp)
c0100ec9:	e8 e0 fe ff ff       	call   c0100dae <ide_wait_ready>

        /* step3: polling */
        if (inb(iobase + ISA_STATUS) == 0 || ide_wait_ready(iobase, 1) != 0) {
c0100ece:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100ed2:	83 c0 07             	add    $0x7,%eax
c0100ed5:	0f b7 c0             	movzwl %ax,%eax
c0100ed8:	66 89 45 ca          	mov    %ax,-0x36(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100edc:	0f b7 45 ca          	movzwl -0x36(%ebp),%eax
c0100ee0:	89 c2                	mov    %eax,%edx
c0100ee2:	ec                   	in     (%dx),%al
c0100ee3:	88 45 c9             	mov    %al,-0x37(%ebp)
    return data;
c0100ee6:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0100eea:	84 c0                	test   %al,%al
c0100eec:	0f 84 f7 01 00 00    	je     c01010e9 <ide_init+0x2e1>
c0100ef2:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100ef6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0100efd:	00 
c0100efe:	89 04 24             	mov    %eax,(%esp)
c0100f01:	e8 a8 fe ff ff       	call   c0100dae <ide_wait_ready>
c0100f06:	85 c0                	test   %eax,%eax
c0100f08:	0f 85 db 01 00 00    	jne    c01010e9 <ide_init+0x2e1>
            continue ;
        }

        /* device is ok */
        ide_devices[ideno].valid = 1;
c0100f0e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100f12:	c1 e0 03             	shl    $0x3,%eax
c0100f15:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0100f1c:	29 c2                	sub    %eax,%edx
c0100f1e:	8d 82 40 44 12 c0    	lea    -0x3fedbbc0(%edx),%eax
c0100f24:	c6 00 01             	movb   $0x1,(%eax)

        /* read identification space of the device */
        unsigned int buffer[128];
        insl(iobase + ISA_DATA, buffer, sizeof(buffer) / sizeof(unsigned int));
c0100f27:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100f2b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0100f2e:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c0100f34:	89 45 c0             	mov    %eax,-0x40(%ebp)
c0100f37:	c7 45 bc 80 00 00 00 	movl   $0x80,-0x44(%ebp)
    asm volatile (
c0100f3e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0100f41:	8b 4d c0             	mov    -0x40(%ebp),%ecx
c0100f44:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0100f47:	89 cb                	mov    %ecx,%ebx
c0100f49:	89 df                	mov    %ebx,%edi
c0100f4b:	89 c1                	mov    %eax,%ecx
c0100f4d:	fc                   	cld    
c0100f4e:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0100f50:	89 c8                	mov    %ecx,%eax
c0100f52:	89 fb                	mov    %edi,%ebx
c0100f54:	89 5d c0             	mov    %ebx,-0x40(%ebp)
c0100f57:	89 45 bc             	mov    %eax,-0x44(%ebp)

        unsigned char *ident = (unsigned char *)buffer;
c0100f5a:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c0100f60:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        unsigned int sectors;
        unsigned int cmdsets = *(unsigned int *)(ident + IDE_IDENT_CMDSETS);
c0100f63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100f66:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
c0100f6c:	89 45 e0             	mov    %eax,-0x20(%ebp)
        /* device use 48-bits or 28-bits addressing */
        if (cmdsets & (1 << 26)) {
c0100f6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100f72:	25 00 00 00 04       	and    $0x4000000,%eax
c0100f77:	85 c0                	test   %eax,%eax
c0100f79:	74 0e                	je     c0100f89 <ide_init+0x181>
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA_EXT);
c0100f7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100f7e:	8b 80 c8 00 00 00    	mov    0xc8(%eax),%eax
c0100f84:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0100f87:	eb 09                	jmp    c0100f92 <ide_init+0x18a>
        }
        else {
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA);
c0100f89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100f8c:	8b 40 78             	mov    0x78(%eax),%eax
c0100f8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        ide_devices[ideno].sets = cmdsets;
c0100f92:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100f96:	c1 e0 03             	shl    $0x3,%eax
c0100f99:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0100fa0:	29 c2                	sub    %eax,%edx
c0100fa2:	81 c2 40 44 12 c0    	add    $0xc0124440,%edx
c0100fa8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100fab:	89 42 04             	mov    %eax,0x4(%edx)
        ide_devices[ideno].size = sectors;
c0100fae:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100fb2:	c1 e0 03             	shl    $0x3,%eax
c0100fb5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0100fbc:	29 c2                	sub    %eax,%edx
c0100fbe:	81 c2 40 44 12 c0    	add    $0xc0124440,%edx
c0100fc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100fc7:	89 42 08             	mov    %eax,0x8(%edx)

        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);
c0100fca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100fcd:	83 c0 62             	add    $0x62,%eax
c0100fd0:	0f b7 00             	movzwl (%eax),%eax
c0100fd3:	0f b7 c0             	movzwl %ax,%eax
c0100fd6:	25 00 02 00 00       	and    $0x200,%eax
c0100fdb:	85 c0                	test   %eax,%eax
c0100fdd:	75 24                	jne    c0101003 <ide_init+0x1fb>
c0100fdf:	c7 44 24 0c 5c 96 10 	movl   $0xc010965c,0xc(%esp)
c0100fe6:	c0 
c0100fe7:	c7 44 24 08 9f 96 10 	movl   $0xc010969f,0x8(%esp)
c0100fee:	c0 
c0100fef:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c0100ff6:	00 
c0100ff7:	c7 04 24 b4 96 10 c0 	movl   $0xc01096b4,(%esp)
c0100ffe:	e8 f5 f3 ff ff       	call   c01003f8 <__panic>

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
c0101003:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101007:	c1 e0 03             	shl    $0x3,%eax
c010100a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101011:	29 c2                	sub    %eax,%edx
c0101013:	8d 82 40 44 12 c0    	lea    -0x3fedbbc0(%edx),%eax
c0101019:	83 c0 0c             	add    $0xc,%eax
c010101c:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010101f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101022:	83 c0 36             	add    $0x36,%eax
c0101025:	89 45 d8             	mov    %eax,-0x28(%ebp)
        unsigned int i, length = 40;
c0101028:	c7 45 d4 28 00 00 00 	movl   $0x28,-0x2c(%ebp)
        for (i = 0; i < length; i += 2) {
c010102f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0101036:	eb 34                	jmp    c010106c <ide_init+0x264>
            model[i] = data[i + 1], model[i + 1] = data[i];
c0101038:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010103b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010103e:	01 c2                	add    %eax,%edx
c0101040:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101043:	8d 48 01             	lea    0x1(%eax),%ecx
c0101046:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0101049:	01 c8                	add    %ecx,%eax
c010104b:	0f b6 00             	movzbl (%eax),%eax
c010104e:	88 02                	mov    %al,(%edx)
c0101050:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101053:	8d 50 01             	lea    0x1(%eax),%edx
c0101056:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0101059:	01 c2                	add    %eax,%edx
c010105b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010105e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c0101061:	01 c8                	add    %ecx,%eax
c0101063:	0f b6 00             	movzbl (%eax),%eax
c0101066:	88 02                	mov    %al,(%edx)
        for (i = 0; i < length; i += 2) {
c0101068:	83 45 ec 02          	addl   $0x2,-0x14(%ebp)
c010106c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010106f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c0101072:	72 c4                	jb     c0101038 <ide_init+0x230>
        }
        do {
            model[i] = '\0';
c0101074:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101077:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010107a:	01 d0                	add    %edx,%eax
c010107c:	c6 00 00             	movb   $0x0,(%eax)
        } while (i -- > 0 && model[i] == ' ');
c010107f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101082:	8d 50 ff             	lea    -0x1(%eax),%edx
c0101085:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0101088:	85 c0                	test   %eax,%eax
c010108a:	74 0f                	je     c010109b <ide_init+0x293>
c010108c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010108f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101092:	01 d0                	add    %edx,%eax
c0101094:	0f b6 00             	movzbl (%eax),%eax
c0101097:	3c 20                	cmp    $0x20,%al
c0101099:	74 d9                	je     c0101074 <ide_init+0x26c>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
c010109b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010109f:	c1 e0 03             	shl    $0x3,%eax
c01010a2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01010a9:	29 c2                	sub    %eax,%edx
c01010ab:	8d 82 40 44 12 c0    	lea    -0x3fedbbc0(%edx),%eax
c01010b1:	8d 48 0c             	lea    0xc(%eax),%ecx
c01010b4:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01010b8:	c1 e0 03             	shl    $0x3,%eax
c01010bb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01010c2:	29 c2                	sub    %eax,%edx
c01010c4:	8d 82 40 44 12 c0    	lea    -0x3fedbbc0(%edx),%eax
c01010ca:	8b 50 08             	mov    0x8(%eax),%edx
c01010cd:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01010d1:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01010d5:	89 54 24 08          	mov    %edx,0x8(%esp)
c01010d9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01010dd:	c7 04 24 c6 96 10 c0 	movl   $0xc01096c6,(%esp)
c01010e4:	e8 b8 f1 ff ff       	call   c01002a1 <cprintf>
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c01010e9:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01010ed:	83 c0 01             	add    $0x1,%eax
c01010f0:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
c01010f4:	66 83 7d f6 03       	cmpw   $0x3,-0xa(%ebp)
c01010f9:	0f 86 1f fd ff ff    	jbe    c0100e1e <ide_init+0x16>
    }

    // enable ide interrupt
    pic_enable(IRQ_IDE1);
c01010ff:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
c0101106:	e8 91 0e 00 00       	call   c0101f9c <pic_enable>
    pic_enable(IRQ_IDE2);
c010110b:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
c0101112:	e8 85 0e 00 00       	call   c0101f9c <pic_enable>
}
c0101117:	81 c4 50 02 00 00    	add    $0x250,%esp
c010111d:	5b                   	pop    %ebx
c010111e:	5f                   	pop    %edi
c010111f:	5d                   	pop    %ebp
c0101120:	c3                   	ret    

c0101121 <ide_device_valid>:

bool
ide_device_valid(unsigned short ideno) {
c0101121:	55                   	push   %ebp
c0101122:	89 e5                	mov    %esp,%ebp
c0101124:	83 ec 04             	sub    $0x4,%esp
c0101127:	8b 45 08             	mov    0x8(%ebp),%eax
c010112a:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    return VALID_IDE(ideno);
c010112e:	66 83 7d fc 03       	cmpw   $0x3,-0x4(%ebp)
c0101133:	77 24                	ja     c0101159 <ide_device_valid+0x38>
c0101135:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101139:	c1 e0 03             	shl    $0x3,%eax
c010113c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101143:	29 c2                	sub    %eax,%edx
c0101145:	8d 82 40 44 12 c0    	lea    -0x3fedbbc0(%edx),%eax
c010114b:	0f b6 00             	movzbl (%eax),%eax
c010114e:	84 c0                	test   %al,%al
c0101150:	74 07                	je     c0101159 <ide_device_valid+0x38>
c0101152:	b8 01 00 00 00       	mov    $0x1,%eax
c0101157:	eb 05                	jmp    c010115e <ide_device_valid+0x3d>
c0101159:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010115e:	c9                   	leave  
c010115f:	c3                   	ret    

c0101160 <ide_device_size>:

size_t
ide_device_size(unsigned short ideno) {
c0101160:	55                   	push   %ebp
c0101161:	89 e5                	mov    %esp,%ebp
c0101163:	83 ec 08             	sub    $0x8,%esp
c0101166:	8b 45 08             	mov    0x8(%ebp),%eax
c0101169:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    if (ide_device_valid(ideno)) {
c010116d:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101171:	89 04 24             	mov    %eax,(%esp)
c0101174:	e8 a8 ff ff ff       	call   c0101121 <ide_device_valid>
c0101179:	85 c0                	test   %eax,%eax
c010117b:	74 1b                	je     c0101198 <ide_device_size+0x38>
        return ide_devices[ideno].size;
c010117d:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101181:	c1 e0 03             	shl    $0x3,%eax
c0101184:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010118b:	29 c2                	sub    %eax,%edx
c010118d:	8d 82 40 44 12 c0    	lea    -0x3fedbbc0(%edx),%eax
c0101193:	8b 40 08             	mov    0x8(%eax),%eax
c0101196:	eb 05                	jmp    c010119d <ide_device_size+0x3d>
    }
    return 0;
c0101198:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010119d:	c9                   	leave  
c010119e:	c3                   	ret    

c010119f <ide_read_secs>:

int
ide_read_secs(unsigned short ideno, uint32_t secno, void *dst, size_t nsecs) {
c010119f:	55                   	push   %ebp
c01011a0:	89 e5                	mov    %esp,%ebp
c01011a2:	57                   	push   %edi
c01011a3:	53                   	push   %ebx
c01011a4:	83 ec 50             	sub    $0x50,%esp
c01011a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01011aa:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c01011ae:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c01011b5:	77 24                	ja     c01011db <ide_read_secs+0x3c>
c01011b7:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c01011bc:	77 1d                	ja     c01011db <ide_read_secs+0x3c>
c01011be:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c01011c2:	c1 e0 03             	shl    $0x3,%eax
c01011c5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01011cc:	29 c2                	sub    %eax,%edx
c01011ce:	8d 82 40 44 12 c0    	lea    -0x3fedbbc0(%edx),%eax
c01011d4:	0f b6 00             	movzbl (%eax),%eax
c01011d7:	84 c0                	test   %al,%al
c01011d9:	75 24                	jne    c01011ff <ide_read_secs+0x60>
c01011db:	c7 44 24 0c e4 96 10 	movl   $0xc01096e4,0xc(%esp)
c01011e2:	c0 
c01011e3:	c7 44 24 08 9f 96 10 	movl   $0xc010969f,0x8(%esp)
c01011ea:	c0 
c01011eb:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c01011f2:	00 
c01011f3:	c7 04 24 b4 96 10 c0 	movl   $0xc01096b4,(%esp)
c01011fa:	e8 f9 f1 ff ff       	call   c01003f8 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c01011ff:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101206:	77 0f                	ja     c0101217 <ide_read_secs+0x78>
c0101208:	8b 45 14             	mov    0x14(%ebp),%eax
c010120b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010120e:	01 d0                	add    %edx,%eax
c0101210:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101215:	76 24                	jbe    c010123b <ide_read_secs+0x9c>
c0101217:	c7 44 24 0c 0c 97 10 	movl   $0xc010970c,0xc(%esp)
c010121e:	c0 
c010121f:	c7 44 24 08 9f 96 10 	movl   $0xc010969f,0x8(%esp)
c0101226:	c0 
c0101227:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c010122e:	00 
c010122f:	c7 04 24 b4 96 10 c0 	movl   $0xc01096b4,(%esp)
c0101236:	e8 bd f1 ff ff       	call   c01003f8 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c010123b:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c010123f:	66 d1 e8             	shr    %ax
c0101242:	0f b7 c0             	movzwl %ax,%eax
c0101245:	0f b7 04 85 54 96 10 	movzwl -0x3fef69ac(,%eax,4),%eax
c010124c:	c0 
c010124d:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101251:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101255:	66 d1 e8             	shr    %ax
c0101258:	0f b7 c0             	movzwl %ax,%eax
c010125b:	0f b7 04 85 56 96 10 	movzwl -0x3fef69aa(,%eax,4),%eax
c0101262:	c0 
c0101263:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101267:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c010126b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101272:	00 
c0101273:	89 04 24             	mov    %eax,(%esp)
c0101276:	e8 33 fb ff ff       	call   c0100dae <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c010127b:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c010127f:	83 c0 02             	add    $0x2,%eax
c0101282:	0f b7 c0             	movzwl %ax,%eax
c0101285:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101289:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010128d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101291:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101295:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101296:	8b 45 14             	mov    0x14(%ebp),%eax
c0101299:	0f b6 c0             	movzbl %al,%eax
c010129c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01012a0:	83 c2 02             	add    $0x2,%edx
c01012a3:	0f b7 d2             	movzwl %dx,%edx
c01012a6:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c01012aa:	88 45 e9             	mov    %al,-0x17(%ebp)
c01012ad:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01012b1:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01012b5:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c01012b6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01012b9:	0f b6 c0             	movzbl %al,%eax
c01012bc:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01012c0:	83 c2 03             	add    $0x3,%edx
c01012c3:	0f b7 d2             	movzwl %dx,%edx
c01012c6:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012ca:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012cd:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012d1:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012d5:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c01012d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01012d9:	c1 e8 08             	shr    $0x8,%eax
c01012dc:	0f b6 c0             	movzbl %al,%eax
c01012df:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01012e3:	83 c2 04             	add    $0x4,%edx
c01012e6:	0f b7 d2             	movzwl %dx,%edx
c01012e9:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c01012ed:	88 45 e1             	mov    %al,-0x1f(%ebp)
c01012f0:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01012f4:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01012f8:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c01012f9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01012fc:	c1 e8 10             	shr    $0x10,%eax
c01012ff:	0f b6 c0             	movzbl %al,%eax
c0101302:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101306:	83 c2 05             	add    $0x5,%edx
c0101309:	0f b7 d2             	movzwl %dx,%edx
c010130c:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101310:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101313:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101317:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c010131b:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c010131c:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101320:	83 e0 01             	and    $0x1,%eax
c0101323:	c1 e0 04             	shl    $0x4,%eax
c0101326:	89 c2                	mov    %eax,%edx
c0101328:	8b 45 0c             	mov    0xc(%ebp),%eax
c010132b:	c1 e8 18             	shr    $0x18,%eax
c010132e:	83 e0 0f             	and    $0xf,%eax
c0101331:	09 d0                	or     %edx,%eax
c0101333:	83 c8 e0             	or     $0xffffffe0,%eax
c0101336:	0f b6 c0             	movzbl %al,%eax
c0101339:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010133d:	83 c2 06             	add    $0x6,%edx
c0101340:	0f b7 d2             	movzwl %dx,%edx
c0101343:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101347:	88 45 d9             	mov    %al,-0x27(%ebp)
c010134a:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c010134e:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101352:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);
c0101353:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101357:	83 c0 07             	add    $0x7,%eax
c010135a:	0f b7 c0             	movzwl %ax,%eax
c010135d:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101361:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
c0101365:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101369:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c010136d:	ee                   	out    %al,(%dx)

    int ret = 0;
c010136e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101375:	eb 5a                	jmp    c01013d1 <ide_read_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101377:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c010137b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101382:	00 
c0101383:	89 04 24             	mov    %eax,(%esp)
c0101386:	e8 23 fa ff ff       	call   c0100dae <ide_wait_ready>
c010138b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010138e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101392:	74 02                	je     c0101396 <ide_read_secs+0x1f7>
            goto out;
c0101394:	eb 41                	jmp    c01013d7 <ide_read_secs+0x238>
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
c0101396:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c010139a:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010139d:	8b 45 10             	mov    0x10(%ebp),%eax
c01013a0:	89 45 cc             	mov    %eax,-0x34(%ebp)
c01013a3:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    asm volatile (
c01013aa:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01013ad:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c01013b0:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01013b3:	89 cb                	mov    %ecx,%ebx
c01013b5:	89 df                	mov    %ebx,%edi
c01013b7:	89 c1                	mov    %eax,%ecx
c01013b9:	fc                   	cld    
c01013ba:	f2 6d                	repnz insl (%dx),%es:(%edi)
c01013bc:	89 c8                	mov    %ecx,%eax
c01013be:	89 fb                	mov    %edi,%ebx
c01013c0:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c01013c3:	89 45 c8             	mov    %eax,-0x38(%ebp)
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c01013c6:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c01013ca:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c01013d1:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c01013d5:	75 a0                	jne    c0101377 <ide_read_secs+0x1d8>
    }

out:
    return ret;
c01013d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01013da:	83 c4 50             	add    $0x50,%esp
c01013dd:	5b                   	pop    %ebx
c01013de:	5f                   	pop    %edi
c01013df:	5d                   	pop    %ebp
c01013e0:	c3                   	ret    

c01013e1 <ide_write_secs>:

int
ide_write_secs(unsigned short ideno, uint32_t secno, const void *src, size_t nsecs) {
c01013e1:	55                   	push   %ebp
c01013e2:	89 e5                	mov    %esp,%ebp
c01013e4:	56                   	push   %esi
c01013e5:	53                   	push   %ebx
c01013e6:	83 ec 50             	sub    $0x50,%esp
c01013e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01013ec:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c01013f0:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c01013f7:	77 24                	ja     c010141d <ide_write_secs+0x3c>
c01013f9:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c01013fe:	77 1d                	ja     c010141d <ide_write_secs+0x3c>
c0101400:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101404:	c1 e0 03             	shl    $0x3,%eax
c0101407:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010140e:	29 c2                	sub    %eax,%edx
c0101410:	8d 82 40 44 12 c0    	lea    -0x3fedbbc0(%edx),%eax
c0101416:	0f b6 00             	movzbl (%eax),%eax
c0101419:	84 c0                	test   %al,%al
c010141b:	75 24                	jne    c0101441 <ide_write_secs+0x60>
c010141d:	c7 44 24 0c e4 96 10 	movl   $0xc01096e4,0xc(%esp)
c0101424:	c0 
c0101425:	c7 44 24 08 9f 96 10 	movl   $0xc010969f,0x8(%esp)
c010142c:	c0 
c010142d:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0101434:	00 
c0101435:	c7 04 24 b4 96 10 c0 	movl   $0xc01096b4,(%esp)
c010143c:	e8 b7 ef ff ff       	call   c01003f8 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101441:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101448:	77 0f                	ja     c0101459 <ide_write_secs+0x78>
c010144a:	8b 45 14             	mov    0x14(%ebp),%eax
c010144d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101450:	01 d0                	add    %edx,%eax
c0101452:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101457:	76 24                	jbe    c010147d <ide_write_secs+0x9c>
c0101459:	c7 44 24 0c 0c 97 10 	movl   $0xc010970c,0xc(%esp)
c0101460:	c0 
c0101461:	c7 44 24 08 9f 96 10 	movl   $0xc010969f,0x8(%esp)
c0101468:	c0 
c0101469:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c0101470:	00 
c0101471:	c7 04 24 b4 96 10 c0 	movl   $0xc01096b4,(%esp)
c0101478:	e8 7b ef ff ff       	call   c01003f8 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c010147d:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101481:	66 d1 e8             	shr    %ax
c0101484:	0f b7 c0             	movzwl %ax,%eax
c0101487:	0f b7 04 85 54 96 10 	movzwl -0x3fef69ac(,%eax,4),%eax
c010148e:	c0 
c010148f:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101493:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101497:	66 d1 e8             	shr    %ax
c010149a:	0f b7 c0             	movzwl %ax,%eax
c010149d:	0f b7 04 85 56 96 10 	movzwl -0x3fef69aa(,%eax,4),%eax
c01014a4:	c0 
c01014a5:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c01014a9:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01014ad:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01014b4:	00 
c01014b5:	89 04 24             	mov    %eax,(%esp)
c01014b8:	e8 f1 f8 ff ff       	call   c0100dae <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c01014bd:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01014c1:	83 c0 02             	add    $0x2,%eax
c01014c4:	0f b7 c0             	movzwl %ax,%eax
c01014c7:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c01014cb:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01014cf:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01014d3:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01014d7:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c01014d8:	8b 45 14             	mov    0x14(%ebp),%eax
c01014db:	0f b6 c0             	movzbl %al,%eax
c01014de:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01014e2:	83 c2 02             	add    $0x2,%edx
c01014e5:	0f b7 d2             	movzwl %dx,%edx
c01014e8:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c01014ec:	88 45 e9             	mov    %al,-0x17(%ebp)
c01014ef:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01014f3:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01014f7:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c01014f8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01014fb:	0f b6 c0             	movzbl %al,%eax
c01014fe:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101502:	83 c2 03             	add    $0x3,%edx
c0101505:	0f b7 d2             	movzwl %dx,%edx
c0101508:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c010150c:	88 45 e5             	mov    %al,-0x1b(%ebp)
c010150f:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101513:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101517:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101518:	8b 45 0c             	mov    0xc(%ebp),%eax
c010151b:	c1 e8 08             	shr    $0x8,%eax
c010151e:	0f b6 c0             	movzbl %al,%eax
c0101521:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101525:	83 c2 04             	add    $0x4,%edx
c0101528:	0f b7 d2             	movzwl %dx,%edx
c010152b:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c010152f:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101532:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101536:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c010153a:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c010153b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010153e:	c1 e8 10             	shr    $0x10,%eax
c0101541:	0f b6 c0             	movzbl %al,%eax
c0101544:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101548:	83 c2 05             	add    $0x5,%edx
c010154b:	0f b7 d2             	movzwl %dx,%edx
c010154e:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101552:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101555:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101559:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c010155d:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c010155e:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101562:	83 e0 01             	and    $0x1,%eax
c0101565:	c1 e0 04             	shl    $0x4,%eax
c0101568:	89 c2                	mov    %eax,%edx
c010156a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010156d:	c1 e8 18             	shr    $0x18,%eax
c0101570:	83 e0 0f             	and    $0xf,%eax
c0101573:	09 d0                	or     %edx,%eax
c0101575:	83 c8 e0             	or     $0xffffffe0,%eax
c0101578:	0f b6 c0             	movzbl %al,%eax
c010157b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010157f:	83 c2 06             	add    $0x6,%edx
c0101582:	0f b7 d2             	movzwl %dx,%edx
c0101585:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101589:	88 45 d9             	mov    %al,-0x27(%ebp)
c010158c:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101590:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101594:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);
c0101595:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101599:	83 c0 07             	add    $0x7,%eax
c010159c:	0f b7 c0             	movzwl %ax,%eax
c010159f:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c01015a3:	c6 45 d5 30          	movb   $0x30,-0x2b(%ebp)
c01015a7:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c01015ab:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c01015af:	ee                   	out    %al,(%dx)

    int ret = 0;
c01015b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c01015b7:	eb 5a                	jmp    c0101613 <ide_write_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c01015b9:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01015bd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01015c4:	00 
c01015c5:	89 04 24             	mov    %eax,(%esp)
c01015c8:	e8 e1 f7 ff ff       	call   c0100dae <ide_wait_ready>
c01015cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01015d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01015d4:	74 02                	je     c01015d8 <ide_write_secs+0x1f7>
            goto out;
c01015d6:	eb 41                	jmp    c0101619 <ide_write_secs+0x238>
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
c01015d8:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01015dc:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01015df:	8b 45 10             	mov    0x10(%ebp),%eax
c01015e2:	89 45 cc             	mov    %eax,-0x34(%ebp)
c01015e5:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    asm volatile (
c01015ec:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01015ef:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c01015f2:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01015f5:	89 cb                	mov    %ecx,%ebx
c01015f7:	89 de                	mov    %ebx,%esi
c01015f9:	89 c1                	mov    %eax,%ecx
c01015fb:	fc                   	cld    
c01015fc:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
c01015fe:	89 c8                	mov    %ecx,%eax
c0101600:	89 f3                	mov    %esi,%ebx
c0101602:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0101605:	89 45 c8             	mov    %eax,-0x38(%ebp)
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101608:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c010160c:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101613:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101617:	75 a0                	jne    c01015b9 <ide_write_secs+0x1d8>
    }

out:
    return ret;
c0101619:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010161c:	83 c4 50             	add    $0x50,%esp
c010161f:	5b                   	pop    %ebx
c0101620:	5e                   	pop    %esi
c0101621:	5d                   	pop    %ebp
c0101622:	c3                   	ret    

c0101623 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0101623:	55                   	push   %ebp
c0101624:	89 e5                	mov    %esp,%ebp
c0101626:	83 ec 28             	sub    $0x28,%esp
c0101629:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c010162f:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101633:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101637:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010163b:	ee                   	out    %al,(%dx)
c010163c:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0101642:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0101646:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010164a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010164e:	ee                   	out    %al,(%dx)
c010164f:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0101655:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0101659:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010165d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101661:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0101662:	c7 05 0c 50 12 c0 00 	movl   $0x0,0xc012500c
c0101669:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c010166c:	c7 04 24 46 97 10 c0 	movl   $0xc0109746,(%esp)
c0101673:	e8 29 ec ff ff       	call   c01002a1 <cprintf>
    pic_enable(IRQ_TIMER);
c0101678:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010167f:	e8 18 09 00 00       	call   c0101f9c <pic_enable>
}
c0101684:	c9                   	leave  
c0101685:	c3                   	ret    

c0101686 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0101686:	55                   	push   %ebp
c0101687:	89 e5                	mov    %esp,%ebp
c0101689:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c010168c:	9c                   	pushf  
c010168d:	58                   	pop    %eax
c010168e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0101691:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0101694:	25 00 02 00 00       	and    $0x200,%eax
c0101699:	85 c0                	test   %eax,%eax
c010169b:	74 0c                	je     c01016a9 <__intr_save+0x23>
        intr_disable();
c010169d:	e8 69 0a 00 00       	call   c010210b <intr_disable>
        return 1;
c01016a2:	b8 01 00 00 00       	mov    $0x1,%eax
c01016a7:	eb 05                	jmp    c01016ae <__intr_save+0x28>
    }
    return 0;
c01016a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01016ae:	c9                   	leave  
c01016af:	c3                   	ret    

c01016b0 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c01016b0:	55                   	push   %ebp
c01016b1:	89 e5                	mov    %esp,%ebp
c01016b3:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c01016b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01016ba:	74 05                	je     c01016c1 <__intr_restore+0x11>
        intr_enable();
c01016bc:	e8 44 0a 00 00       	call   c0102105 <intr_enable>
    }
}
c01016c1:	c9                   	leave  
c01016c2:	c3                   	ret    

c01016c3 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c01016c3:	55                   	push   %ebp
c01016c4:	89 e5                	mov    %esp,%ebp
c01016c6:	83 ec 10             	sub    $0x10,%esp
c01016c9:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01016cf:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c01016d3:	89 c2                	mov    %eax,%edx
c01016d5:	ec                   	in     (%dx),%al
c01016d6:	88 45 fd             	mov    %al,-0x3(%ebp)
c01016d9:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c01016df:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01016e3:	89 c2                	mov    %eax,%edx
c01016e5:	ec                   	in     (%dx),%al
c01016e6:	88 45 f9             	mov    %al,-0x7(%ebp)
c01016e9:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c01016ef:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01016f3:	89 c2                	mov    %eax,%edx
c01016f5:	ec                   	in     (%dx),%al
c01016f6:	88 45 f5             	mov    %al,-0xb(%ebp)
c01016f9:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c01016ff:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101703:	89 c2                	mov    %eax,%edx
c0101705:	ec                   	in     (%dx),%al
c0101706:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0101709:	c9                   	leave  
c010170a:	c3                   	ret    

c010170b <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c010170b:	55                   	push   %ebp
c010170c:	89 e5                	mov    %esp,%ebp
c010170e:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0101711:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0101718:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010171b:	0f b7 00             	movzwl (%eax),%eax
c010171e:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0101722:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101725:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c010172a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010172d:	0f b7 00             	movzwl (%eax),%eax
c0101730:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0101734:	74 12                	je     c0101748 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0101736:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c010173d:	66 c7 05 26 45 12 c0 	movw   $0x3b4,0xc0124526
c0101744:	b4 03 
c0101746:	eb 13                	jmp    c010175b <cga_init+0x50>
    } else {
        *cp = was;
c0101748:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010174b:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010174f:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0101752:	66 c7 05 26 45 12 c0 	movw   $0x3d4,0xc0124526
c0101759:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c010175b:	0f b7 05 26 45 12 c0 	movzwl 0xc0124526,%eax
c0101762:	0f b7 c0             	movzwl %ax,%eax
c0101765:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101769:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010176d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101771:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101775:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0101776:	0f b7 05 26 45 12 c0 	movzwl 0xc0124526,%eax
c010177d:	83 c0 01             	add    $0x1,%eax
c0101780:	0f b7 c0             	movzwl %ax,%eax
c0101783:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101787:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c010178b:	89 c2                	mov    %eax,%edx
c010178d:	ec                   	in     (%dx),%al
c010178e:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0101791:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101795:	0f b6 c0             	movzbl %al,%eax
c0101798:	c1 e0 08             	shl    $0x8,%eax
c010179b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c010179e:	0f b7 05 26 45 12 c0 	movzwl 0xc0124526,%eax
c01017a5:	0f b7 c0             	movzwl %ax,%eax
c01017a8:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c01017ac:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017b0:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01017b4:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01017b8:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c01017b9:	0f b7 05 26 45 12 c0 	movzwl 0xc0124526,%eax
c01017c0:	83 c0 01             	add    $0x1,%eax
c01017c3:	0f b7 c0             	movzwl %ax,%eax
c01017c6:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01017ca:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c01017ce:	89 c2                	mov    %eax,%edx
c01017d0:	ec                   	in     (%dx),%al
c01017d1:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c01017d4:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01017d8:	0f b6 c0             	movzbl %al,%eax
c01017db:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c01017de:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01017e1:	a3 20 45 12 c0       	mov    %eax,0xc0124520
    crt_pos = pos;
c01017e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01017e9:	66 a3 24 45 12 c0    	mov    %ax,0xc0124524
}
c01017ef:	c9                   	leave  
c01017f0:	c3                   	ret    

c01017f1 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c01017f1:	55                   	push   %ebp
c01017f2:	89 e5                	mov    %esp,%ebp
c01017f4:	83 ec 48             	sub    $0x48,%esp
c01017f7:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c01017fd:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101801:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101805:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101809:	ee                   	out    %al,(%dx)
c010180a:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0101810:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0101814:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101818:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010181c:	ee                   	out    %al,(%dx)
c010181d:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0101823:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0101827:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010182b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010182f:	ee                   	out    %al,(%dx)
c0101830:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0101836:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c010183a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010183e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101842:	ee                   	out    %al,(%dx)
c0101843:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0101849:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c010184d:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101851:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101855:	ee                   	out    %al,(%dx)
c0101856:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c010185c:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0101860:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101864:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101868:	ee                   	out    %al,(%dx)
c0101869:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c010186f:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0101873:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101877:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c010187b:	ee                   	out    %al,(%dx)
c010187c:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101882:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0101886:	89 c2                	mov    %eax,%edx
c0101888:	ec                   	in     (%dx),%al
c0101889:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c010188c:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0101890:	3c ff                	cmp    $0xff,%al
c0101892:	0f 95 c0             	setne  %al
c0101895:	0f b6 c0             	movzbl %al,%eax
c0101898:	a3 28 45 12 c0       	mov    %eax,0xc0124528
c010189d:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01018a3:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c01018a7:	89 c2                	mov    %eax,%edx
c01018a9:	ec                   	in     (%dx),%al
c01018aa:	88 45 d5             	mov    %al,-0x2b(%ebp)
c01018ad:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c01018b3:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c01018b7:	89 c2                	mov    %eax,%edx
c01018b9:	ec                   	in     (%dx),%al
c01018ba:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c01018bd:	a1 28 45 12 c0       	mov    0xc0124528,%eax
c01018c2:	85 c0                	test   %eax,%eax
c01018c4:	74 0c                	je     c01018d2 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c01018c6:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c01018cd:	e8 ca 06 00 00       	call   c0101f9c <pic_enable>
    }
}
c01018d2:	c9                   	leave  
c01018d3:	c3                   	ret    

c01018d4 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c01018d4:	55                   	push   %ebp
c01018d5:	89 e5                	mov    %esp,%ebp
c01018d7:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c01018da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01018e1:	eb 09                	jmp    c01018ec <lpt_putc_sub+0x18>
        delay();
c01018e3:	e8 db fd ff ff       	call   c01016c3 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c01018e8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01018ec:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c01018f2:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01018f6:	89 c2                	mov    %eax,%edx
c01018f8:	ec                   	in     (%dx),%al
c01018f9:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01018fc:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101900:	84 c0                	test   %al,%al
c0101902:	78 09                	js     c010190d <lpt_putc_sub+0x39>
c0101904:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c010190b:	7e d6                	jle    c01018e3 <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
c010190d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101910:	0f b6 c0             	movzbl %al,%eax
c0101913:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c0101919:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010191c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101920:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101924:	ee                   	out    %al,(%dx)
c0101925:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c010192b:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c010192f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101933:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101937:	ee                   	out    %al,(%dx)
c0101938:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c010193e:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c0101942:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101946:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010194a:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c010194b:	c9                   	leave  
c010194c:	c3                   	ret    

c010194d <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c010194d:	55                   	push   %ebp
c010194e:	89 e5                	mov    %esp,%ebp
c0101950:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101953:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101957:	74 0d                	je     c0101966 <lpt_putc+0x19>
        lpt_putc_sub(c);
c0101959:	8b 45 08             	mov    0x8(%ebp),%eax
c010195c:	89 04 24             	mov    %eax,(%esp)
c010195f:	e8 70 ff ff ff       	call   c01018d4 <lpt_putc_sub>
c0101964:	eb 24                	jmp    c010198a <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c0101966:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010196d:	e8 62 ff ff ff       	call   c01018d4 <lpt_putc_sub>
        lpt_putc_sub(' ');
c0101972:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101979:	e8 56 ff ff ff       	call   c01018d4 <lpt_putc_sub>
        lpt_putc_sub('\b');
c010197e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101985:	e8 4a ff ff ff       	call   c01018d4 <lpt_putc_sub>
    }
}
c010198a:	c9                   	leave  
c010198b:	c3                   	ret    

c010198c <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c010198c:	55                   	push   %ebp
c010198d:	89 e5                	mov    %esp,%ebp
c010198f:	53                   	push   %ebx
c0101990:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c0101993:	8b 45 08             	mov    0x8(%ebp),%eax
c0101996:	b0 00                	mov    $0x0,%al
c0101998:	85 c0                	test   %eax,%eax
c010199a:	75 07                	jne    c01019a3 <cga_putc+0x17>
        c |= 0x0700;
c010199c:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c01019a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01019a6:	0f b6 c0             	movzbl %al,%eax
c01019a9:	83 f8 0a             	cmp    $0xa,%eax
c01019ac:	74 4c                	je     c01019fa <cga_putc+0x6e>
c01019ae:	83 f8 0d             	cmp    $0xd,%eax
c01019b1:	74 57                	je     c0101a0a <cga_putc+0x7e>
c01019b3:	83 f8 08             	cmp    $0x8,%eax
c01019b6:	0f 85 88 00 00 00    	jne    c0101a44 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c01019bc:	0f b7 05 24 45 12 c0 	movzwl 0xc0124524,%eax
c01019c3:	66 85 c0             	test   %ax,%ax
c01019c6:	74 30                	je     c01019f8 <cga_putc+0x6c>
            crt_pos --;
c01019c8:	0f b7 05 24 45 12 c0 	movzwl 0xc0124524,%eax
c01019cf:	83 e8 01             	sub    $0x1,%eax
c01019d2:	66 a3 24 45 12 c0    	mov    %ax,0xc0124524
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c01019d8:	a1 20 45 12 c0       	mov    0xc0124520,%eax
c01019dd:	0f b7 15 24 45 12 c0 	movzwl 0xc0124524,%edx
c01019e4:	0f b7 d2             	movzwl %dx,%edx
c01019e7:	01 d2                	add    %edx,%edx
c01019e9:	01 c2                	add    %eax,%edx
c01019eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01019ee:	b0 00                	mov    $0x0,%al
c01019f0:	83 c8 20             	or     $0x20,%eax
c01019f3:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c01019f6:	eb 72                	jmp    c0101a6a <cga_putc+0xde>
c01019f8:	eb 70                	jmp    c0101a6a <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c01019fa:	0f b7 05 24 45 12 c0 	movzwl 0xc0124524,%eax
c0101a01:	83 c0 50             	add    $0x50,%eax
c0101a04:	66 a3 24 45 12 c0    	mov    %ax,0xc0124524
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101a0a:	0f b7 1d 24 45 12 c0 	movzwl 0xc0124524,%ebx
c0101a11:	0f b7 0d 24 45 12 c0 	movzwl 0xc0124524,%ecx
c0101a18:	0f b7 c1             	movzwl %cx,%eax
c0101a1b:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c0101a21:	c1 e8 10             	shr    $0x10,%eax
c0101a24:	89 c2                	mov    %eax,%edx
c0101a26:	66 c1 ea 06          	shr    $0x6,%dx
c0101a2a:	89 d0                	mov    %edx,%eax
c0101a2c:	c1 e0 02             	shl    $0x2,%eax
c0101a2f:	01 d0                	add    %edx,%eax
c0101a31:	c1 e0 04             	shl    $0x4,%eax
c0101a34:	29 c1                	sub    %eax,%ecx
c0101a36:	89 ca                	mov    %ecx,%edx
c0101a38:	89 d8                	mov    %ebx,%eax
c0101a3a:	29 d0                	sub    %edx,%eax
c0101a3c:	66 a3 24 45 12 c0    	mov    %ax,0xc0124524
        break;
c0101a42:	eb 26                	jmp    c0101a6a <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c0101a44:	8b 0d 20 45 12 c0    	mov    0xc0124520,%ecx
c0101a4a:	0f b7 05 24 45 12 c0 	movzwl 0xc0124524,%eax
c0101a51:	8d 50 01             	lea    0x1(%eax),%edx
c0101a54:	66 89 15 24 45 12 c0 	mov    %dx,0xc0124524
c0101a5b:	0f b7 c0             	movzwl %ax,%eax
c0101a5e:	01 c0                	add    %eax,%eax
c0101a60:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c0101a63:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a66:	66 89 02             	mov    %ax,(%edx)
        break;
c0101a69:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c0101a6a:	0f b7 05 24 45 12 c0 	movzwl 0xc0124524,%eax
c0101a71:	66 3d cf 07          	cmp    $0x7cf,%ax
c0101a75:	76 5b                	jbe    c0101ad2 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c0101a77:	a1 20 45 12 c0       	mov    0xc0124520,%eax
c0101a7c:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c0101a82:	a1 20 45 12 c0       	mov    0xc0124520,%eax
c0101a87:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c0101a8e:	00 
c0101a8f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101a93:	89 04 24             	mov    %eax,(%esp)
c0101a96:	e8 ff 6f 00 00       	call   c0108a9a <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101a9b:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101aa2:	eb 15                	jmp    c0101ab9 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c0101aa4:	a1 20 45 12 c0       	mov    0xc0124520,%eax
c0101aa9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101aac:	01 d2                	add    %edx,%edx
c0101aae:	01 d0                	add    %edx,%eax
c0101ab0:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101ab5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101ab9:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101ac0:	7e e2                	jle    c0101aa4 <cga_putc+0x118>
        }
        crt_pos -= CRT_COLS;
c0101ac2:	0f b7 05 24 45 12 c0 	movzwl 0xc0124524,%eax
c0101ac9:	83 e8 50             	sub    $0x50,%eax
c0101acc:	66 a3 24 45 12 c0    	mov    %ax,0xc0124524
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101ad2:	0f b7 05 26 45 12 c0 	movzwl 0xc0124526,%eax
c0101ad9:	0f b7 c0             	movzwl %ax,%eax
c0101adc:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101ae0:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c0101ae4:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101ae8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101aec:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101aed:	0f b7 05 24 45 12 c0 	movzwl 0xc0124524,%eax
c0101af4:	66 c1 e8 08          	shr    $0x8,%ax
c0101af8:	0f b6 c0             	movzbl %al,%eax
c0101afb:	0f b7 15 26 45 12 c0 	movzwl 0xc0124526,%edx
c0101b02:	83 c2 01             	add    $0x1,%edx
c0101b05:	0f b7 d2             	movzwl %dx,%edx
c0101b08:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c0101b0c:	88 45 ed             	mov    %al,-0x13(%ebp)
c0101b0f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101b13:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101b17:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101b18:	0f b7 05 26 45 12 c0 	movzwl 0xc0124526,%eax
c0101b1f:	0f b7 c0             	movzwl %ax,%eax
c0101b22:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0101b26:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c0101b2a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101b2e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101b32:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c0101b33:	0f b7 05 24 45 12 c0 	movzwl 0xc0124524,%eax
c0101b3a:	0f b6 c0             	movzbl %al,%eax
c0101b3d:	0f b7 15 26 45 12 c0 	movzwl 0xc0124526,%edx
c0101b44:	83 c2 01             	add    $0x1,%edx
c0101b47:	0f b7 d2             	movzwl %dx,%edx
c0101b4a:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101b4e:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101b51:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101b55:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101b59:	ee                   	out    %al,(%dx)
}
c0101b5a:	83 c4 34             	add    $0x34,%esp
c0101b5d:	5b                   	pop    %ebx
c0101b5e:	5d                   	pop    %ebp
c0101b5f:	c3                   	ret    

c0101b60 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c0101b60:	55                   	push   %ebp
c0101b61:	89 e5                	mov    %esp,%ebp
c0101b63:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101b66:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101b6d:	eb 09                	jmp    c0101b78 <serial_putc_sub+0x18>
        delay();
c0101b6f:	e8 4f fb ff ff       	call   c01016c3 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101b74:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101b78:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101b7e:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101b82:	89 c2                	mov    %eax,%edx
c0101b84:	ec                   	in     (%dx),%al
c0101b85:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101b88:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101b8c:	0f b6 c0             	movzbl %al,%eax
c0101b8f:	83 e0 20             	and    $0x20,%eax
c0101b92:	85 c0                	test   %eax,%eax
c0101b94:	75 09                	jne    c0101b9f <serial_putc_sub+0x3f>
c0101b96:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101b9d:	7e d0                	jle    c0101b6f <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
c0101b9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ba2:	0f b6 c0             	movzbl %al,%eax
c0101ba5:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101bab:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101bae:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101bb2:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101bb6:	ee                   	out    %al,(%dx)
}
c0101bb7:	c9                   	leave  
c0101bb8:	c3                   	ret    

c0101bb9 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101bb9:	55                   	push   %ebp
c0101bba:	89 e5                	mov    %esp,%ebp
c0101bbc:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101bbf:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101bc3:	74 0d                	je     c0101bd2 <serial_putc+0x19>
        serial_putc_sub(c);
c0101bc5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bc8:	89 04 24             	mov    %eax,(%esp)
c0101bcb:	e8 90 ff ff ff       	call   c0101b60 <serial_putc_sub>
c0101bd0:	eb 24                	jmp    c0101bf6 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c0101bd2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101bd9:	e8 82 ff ff ff       	call   c0101b60 <serial_putc_sub>
        serial_putc_sub(' ');
c0101bde:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101be5:	e8 76 ff ff ff       	call   c0101b60 <serial_putc_sub>
        serial_putc_sub('\b');
c0101bea:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101bf1:	e8 6a ff ff ff       	call   c0101b60 <serial_putc_sub>
    }
}
c0101bf6:	c9                   	leave  
c0101bf7:	c3                   	ret    

c0101bf8 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101bf8:	55                   	push   %ebp
c0101bf9:	89 e5                	mov    %esp,%ebp
c0101bfb:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101bfe:	eb 33                	jmp    c0101c33 <cons_intr+0x3b>
        if (c != 0) {
c0101c00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101c04:	74 2d                	je     c0101c33 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101c06:	a1 44 47 12 c0       	mov    0xc0124744,%eax
c0101c0b:	8d 50 01             	lea    0x1(%eax),%edx
c0101c0e:	89 15 44 47 12 c0    	mov    %edx,0xc0124744
c0101c14:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101c17:	88 90 40 45 12 c0    	mov    %dl,-0x3fedbac0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101c1d:	a1 44 47 12 c0       	mov    0xc0124744,%eax
c0101c22:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101c27:	75 0a                	jne    c0101c33 <cons_intr+0x3b>
                cons.wpos = 0;
c0101c29:	c7 05 44 47 12 c0 00 	movl   $0x0,0xc0124744
c0101c30:	00 00 00 
    while ((c = (*proc)()) != -1) {
c0101c33:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c36:	ff d0                	call   *%eax
c0101c38:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101c3b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c0101c3f:	75 bf                	jne    c0101c00 <cons_intr+0x8>
            }
        }
    }
}
c0101c41:	c9                   	leave  
c0101c42:	c3                   	ret    

c0101c43 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c0101c43:	55                   	push   %ebp
c0101c44:	89 e5                	mov    %esp,%ebp
c0101c46:	83 ec 10             	sub    $0x10,%esp
c0101c49:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101c4f:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101c53:	89 c2                	mov    %eax,%edx
c0101c55:	ec                   	in     (%dx),%al
c0101c56:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101c59:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c0101c5d:	0f b6 c0             	movzbl %al,%eax
c0101c60:	83 e0 01             	and    $0x1,%eax
c0101c63:	85 c0                	test   %eax,%eax
c0101c65:	75 07                	jne    c0101c6e <serial_proc_data+0x2b>
        return -1;
c0101c67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101c6c:	eb 2a                	jmp    c0101c98 <serial_proc_data+0x55>
c0101c6e:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101c74:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101c78:	89 c2                	mov    %eax,%edx
c0101c7a:	ec                   	in     (%dx),%al
c0101c7b:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c0101c7e:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c0101c82:	0f b6 c0             	movzbl %al,%eax
c0101c85:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c0101c88:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101c8c:	75 07                	jne    c0101c95 <serial_proc_data+0x52>
        c = '\b';
c0101c8e:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c0101c95:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101c98:	c9                   	leave  
c0101c99:	c3                   	ret    

c0101c9a <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101c9a:	55                   	push   %ebp
c0101c9b:	89 e5                	mov    %esp,%ebp
c0101c9d:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101ca0:	a1 28 45 12 c0       	mov    0xc0124528,%eax
c0101ca5:	85 c0                	test   %eax,%eax
c0101ca7:	74 0c                	je     c0101cb5 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101ca9:	c7 04 24 43 1c 10 c0 	movl   $0xc0101c43,(%esp)
c0101cb0:	e8 43 ff ff ff       	call   c0101bf8 <cons_intr>
    }
}
c0101cb5:	c9                   	leave  
c0101cb6:	c3                   	ret    

c0101cb7 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101cb7:	55                   	push   %ebp
c0101cb8:	89 e5                	mov    %esp,%ebp
c0101cba:	83 ec 38             	sub    $0x38,%esp
c0101cbd:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101cc3:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101cc7:	89 c2                	mov    %eax,%edx
c0101cc9:	ec                   	in     (%dx),%al
c0101cca:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101ccd:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101cd1:	0f b6 c0             	movzbl %al,%eax
c0101cd4:	83 e0 01             	and    $0x1,%eax
c0101cd7:	85 c0                	test   %eax,%eax
c0101cd9:	75 0a                	jne    c0101ce5 <kbd_proc_data+0x2e>
        return -1;
c0101cdb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101ce0:	e9 59 01 00 00       	jmp    c0101e3e <kbd_proc_data+0x187>
c0101ce5:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101ceb:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101cef:	89 c2                	mov    %eax,%edx
c0101cf1:	ec                   	in     (%dx),%al
c0101cf2:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101cf5:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101cf9:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101cfc:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101d00:	75 17                	jne    c0101d19 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c0101d02:	a1 48 47 12 c0       	mov    0xc0124748,%eax
c0101d07:	83 c8 40             	or     $0x40,%eax
c0101d0a:	a3 48 47 12 c0       	mov    %eax,0xc0124748
        return 0;
c0101d0f:	b8 00 00 00 00       	mov    $0x0,%eax
c0101d14:	e9 25 01 00 00       	jmp    c0101e3e <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c0101d19:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101d1d:	84 c0                	test   %al,%al
c0101d1f:	79 47                	jns    c0101d68 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101d21:	a1 48 47 12 c0       	mov    0xc0124748,%eax
c0101d26:	83 e0 40             	and    $0x40,%eax
c0101d29:	85 c0                	test   %eax,%eax
c0101d2b:	75 09                	jne    c0101d36 <kbd_proc_data+0x7f>
c0101d2d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101d31:	83 e0 7f             	and    $0x7f,%eax
c0101d34:	eb 04                	jmp    c0101d3a <kbd_proc_data+0x83>
c0101d36:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101d3a:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c0101d3d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101d41:	0f b6 80 40 10 12 c0 	movzbl -0x3fedefc0(%eax),%eax
c0101d48:	83 c8 40             	or     $0x40,%eax
c0101d4b:	0f b6 c0             	movzbl %al,%eax
c0101d4e:	f7 d0                	not    %eax
c0101d50:	89 c2                	mov    %eax,%edx
c0101d52:	a1 48 47 12 c0       	mov    0xc0124748,%eax
c0101d57:	21 d0                	and    %edx,%eax
c0101d59:	a3 48 47 12 c0       	mov    %eax,0xc0124748
        return 0;
c0101d5e:	b8 00 00 00 00       	mov    $0x0,%eax
c0101d63:	e9 d6 00 00 00       	jmp    c0101e3e <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c0101d68:	a1 48 47 12 c0       	mov    0xc0124748,%eax
c0101d6d:	83 e0 40             	and    $0x40,%eax
c0101d70:	85 c0                	test   %eax,%eax
c0101d72:	74 11                	je     c0101d85 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c0101d74:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c0101d78:	a1 48 47 12 c0       	mov    0xc0124748,%eax
c0101d7d:	83 e0 bf             	and    $0xffffffbf,%eax
c0101d80:	a3 48 47 12 c0       	mov    %eax,0xc0124748
    }

    shift |= shiftcode[data];
c0101d85:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101d89:	0f b6 80 40 10 12 c0 	movzbl -0x3fedefc0(%eax),%eax
c0101d90:	0f b6 d0             	movzbl %al,%edx
c0101d93:	a1 48 47 12 c0       	mov    0xc0124748,%eax
c0101d98:	09 d0                	or     %edx,%eax
c0101d9a:	a3 48 47 12 c0       	mov    %eax,0xc0124748
    shift ^= togglecode[data];
c0101d9f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101da3:	0f b6 80 40 11 12 c0 	movzbl -0x3fedeec0(%eax),%eax
c0101daa:	0f b6 d0             	movzbl %al,%edx
c0101dad:	a1 48 47 12 c0       	mov    0xc0124748,%eax
c0101db2:	31 d0                	xor    %edx,%eax
c0101db4:	a3 48 47 12 c0       	mov    %eax,0xc0124748

    c = charcode[shift & (CTL | SHIFT)][data];
c0101db9:	a1 48 47 12 c0       	mov    0xc0124748,%eax
c0101dbe:	83 e0 03             	and    $0x3,%eax
c0101dc1:	8b 14 85 40 15 12 c0 	mov    -0x3fedeac0(,%eax,4),%edx
c0101dc8:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101dcc:	01 d0                	add    %edx,%eax
c0101dce:	0f b6 00             	movzbl (%eax),%eax
c0101dd1:	0f b6 c0             	movzbl %al,%eax
c0101dd4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101dd7:	a1 48 47 12 c0       	mov    0xc0124748,%eax
c0101ddc:	83 e0 08             	and    $0x8,%eax
c0101ddf:	85 c0                	test   %eax,%eax
c0101de1:	74 22                	je     c0101e05 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101de3:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101de7:	7e 0c                	jle    c0101df5 <kbd_proc_data+0x13e>
c0101de9:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101ded:	7f 06                	jg     c0101df5 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101def:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101df3:	eb 10                	jmp    c0101e05 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c0101df5:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101df9:	7e 0a                	jle    c0101e05 <kbd_proc_data+0x14e>
c0101dfb:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101dff:	7f 04                	jg     c0101e05 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101e01:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101e05:	a1 48 47 12 c0       	mov    0xc0124748,%eax
c0101e0a:	f7 d0                	not    %eax
c0101e0c:	83 e0 06             	and    $0x6,%eax
c0101e0f:	85 c0                	test   %eax,%eax
c0101e11:	75 28                	jne    c0101e3b <kbd_proc_data+0x184>
c0101e13:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101e1a:	75 1f                	jne    c0101e3b <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c0101e1c:	c7 04 24 61 97 10 c0 	movl   $0xc0109761,(%esp)
c0101e23:	e8 79 e4 ff ff       	call   c01002a1 <cprintf>
c0101e28:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c0101e2e:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101e32:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0101e36:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c0101e3a:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c0101e3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101e3e:	c9                   	leave  
c0101e3f:	c3                   	ret    

c0101e40 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c0101e40:	55                   	push   %ebp
c0101e41:	89 e5                	mov    %esp,%ebp
c0101e43:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c0101e46:	c7 04 24 b7 1c 10 c0 	movl   $0xc0101cb7,(%esp)
c0101e4d:	e8 a6 fd ff ff       	call   c0101bf8 <cons_intr>
}
c0101e52:	c9                   	leave  
c0101e53:	c3                   	ret    

c0101e54 <kbd_init>:

static void
kbd_init(void) {
c0101e54:	55                   	push   %ebp
c0101e55:	89 e5                	mov    %esp,%ebp
c0101e57:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c0101e5a:	e8 e1 ff ff ff       	call   c0101e40 <kbd_intr>
    pic_enable(IRQ_KBD);
c0101e5f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0101e66:	e8 31 01 00 00       	call   c0101f9c <pic_enable>
}
c0101e6b:	c9                   	leave  
c0101e6c:	c3                   	ret    

c0101e6d <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c0101e6d:	55                   	push   %ebp
c0101e6e:	89 e5                	mov    %esp,%ebp
c0101e70:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c0101e73:	e8 93 f8 ff ff       	call   c010170b <cga_init>
    serial_init();
c0101e78:	e8 74 f9 ff ff       	call   c01017f1 <serial_init>
    kbd_init();
c0101e7d:	e8 d2 ff ff ff       	call   c0101e54 <kbd_init>
    if (!serial_exists) {
c0101e82:	a1 28 45 12 c0       	mov    0xc0124528,%eax
c0101e87:	85 c0                	test   %eax,%eax
c0101e89:	75 0c                	jne    c0101e97 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c0101e8b:	c7 04 24 6d 97 10 c0 	movl   $0xc010976d,(%esp)
c0101e92:	e8 0a e4 ff ff       	call   c01002a1 <cprintf>
    }
}
c0101e97:	c9                   	leave  
c0101e98:	c3                   	ret    

c0101e99 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101e99:	55                   	push   %ebp
c0101e9a:	89 e5                	mov    %esp,%ebp
c0101e9c:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101e9f:	e8 e2 f7 ff ff       	call   c0101686 <__intr_save>
c0101ea4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101ea7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101eaa:	89 04 24             	mov    %eax,(%esp)
c0101ead:	e8 9b fa ff ff       	call   c010194d <lpt_putc>
        cga_putc(c);
c0101eb2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101eb5:	89 04 24             	mov    %eax,(%esp)
c0101eb8:	e8 cf fa ff ff       	call   c010198c <cga_putc>
        serial_putc(c);
c0101ebd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ec0:	89 04 24             	mov    %eax,(%esp)
c0101ec3:	e8 f1 fc ff ff       	call   c0101bb9 <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101ec8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101ecb:	89 04 24             	mov    %eax,(%esp)
c0101ece:	e8 dd f7 ff ff       	call   c01016b0 <__intr_restore>
}
c0101ed3:	c9                   	leave  
c0101ed4:	c3                   	ret    

c0101ed5 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101ed5:	55                   	push   %ebp
c0101ed6:	89 e5                	mov    %esp,%ebp
c0101ed8:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101edb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101ee2:	e8 9f f7 ff ff       	call   c0101686 <__intr_save>
c0101ee7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101eea:	e8 ab fd ff ff       	call   c0101c9a <serial_intr>
        kbd_intr();
c0101eef:	e8 4c ff ff ff       	call   c0101e40 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101ef4:	8b 15 40 47 12 c0    	mov    0xc0124740,%edx
c0101efa:	a1 44 47 12 c0       	mov    0xc0124744,%eax
c0101eff:	39 c2                	cmp    %eax,%edx
c0101f01:	74 31                	je     c0101f34 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101f03:	a1 40 47 12 c0       	mov    0xc0124740,%eax
c0101f08:	8d 50 01             	lea    0x1(%eax),%edx
c0101f0b:	89 15 40 47 12 c0    	mov    %edx,0xc0124740
c0101f11:	0f b6 80 40 45 12 c0 	movzbl -0x3fedbac0(%eax),%eax
c0101f18:	0f b6 c0             	movzbl %al,%eax
c0101f1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101f1e:	a1 40 47 12 c0       	mov    0xc0124740,%eax
c0101f23:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101f28:	75 0a                	jne    c0101f34 <cons_getc+0x5f>
                cons.rpos = 0;
c0101f2a:	c7 05 40 47 12 c0 00 	movl   $0x0,0xc0124740
c0101f31:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c0101f34:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101f37:	89 04 24             	mov    %eax,(%esp)
c0101f3a:	e8 71 f7 ff ff       	call   c01016b0 <__intr_restore>
    return c;
c0101f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101f42:	c9                   	leave  
c0101f43:	c3                   	ret    

c0101f44 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101f44:	55                   	push   %ebp
c0101f45:	89 e5                	mov    %esp,%ebp
c0101f47:	83 ec 14             	sub    $0x14,%esp
c0101f4a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f4d:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0101f51:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f55:	66 a3 50 15 12 c0    	mov    %ax,0xc0121550
    if (did_init) {
c0101f5b:	a1 4c 47 12 c0       	mov    0xc012474c,%eax
c0101f60:	85 c0                	test   %eax,%eax
c0101f62:	74 36                	je     c0101f9a <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c0101f64:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f68:	0f b6 c0             	movzbl %al,%eax
c0101f6b:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101f71:	88 45 fd             	mov    %al,-0x3(%ebp)
c0101f74:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101f78:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101f7c:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c0101f7d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f81:	66 c1 e8 08          	shr    $0x8,%ax
c0101f85:	0f b6 c0             	movzbl %al,%eax
c0101f88:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101f8e:	88 45 f9             	mov    %al,-0x7(%ebp)
c0101f91:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101f95:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101f99:	ee                   	out    %al,(%dx)
    }
}
c0101f9a:	c9                   	leave  
c0101f9b:	c3                   	ret    

c0101f9c <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101f9c:	55                   	push   %ebp
c0101f9d:	89 e5                	mov    %esp,%ebp
c0101f9f:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101fa2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fa5:	ba 01 00 00 00       	mov    $0x1,%edx
c0101faa:	89 c1                	mov    %eax,%ecx
c0101fac:	d3 e2                	shl    %cl,%edx
c0101fae:	89 d0                	mov    %edx,%eax
c0101fb0:	f7 d0                	not    %eax
c0101fb2:	89 c2                	mov    %eax,%edx
c0101fb4:	0f b7 05 50 15 12 c0 	movzwl 0xc0121550,%eax
c0101fbb:	21 d0                	and    %edx,%eax
c0101fbd:	0f b7 c0             	movzwl %ax,%eax
c0101fc0:	89 04 24             	mov    %eax,(%esp)
c0101fc3:	e8 7c ff ff ff       	call   c0101f44 <pic_setmask>
}
c0101fc8:	c9                   	leave  
c0101fc9:	c3                   	ret    

c0101fca <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101fca:	55                   	push   %ebp
c0101fcb:	89 e5                	mov    %esp,%ebp
c0101fcd:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101fd0:	c7 05 4c 47 12 c0 01 	movl   $0x1,0xc012474c
c0101fd7:	00 00 00 
c0101fda:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101fe0:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c0101fe4:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101fe8:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101fec:	ee                   	out    %al,(%dx)
c0101fed:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101ff3:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c0101ff7:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101ffb:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101fff:	ee                   	out    %al,(%dx)
c0102000:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0102006:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c010200a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010200e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0102012:	ee                   	out    %al,(%dx)
c0102013:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c0102019:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c010201d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0102021:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0102025:	ee                   	out    %al,(%dx)
c0102026:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c010202c:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c0102030:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0102034:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0102038:	ee                   	out    %al,(%dx)
c0102039:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c010203f:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c0102043:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0102047:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010204b:	ee                   	out    %al,(%dx)
c010204c:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c0102052:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c0102056:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c010205a:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010205e:	ee                   	out    %al,(%dx)
c010205f:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c0102065:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c0102069:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c010206d:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0102071:	ee                   	out    %al,(%dx)
c0102072:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c0102078:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c010207c:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0102080:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0102084:	ee                   	out    %al,(%dx)
c0102085:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c010208b:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c010208f:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0102093:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0102097:	ee                   	out    %al,(%dx)
c0102098:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c010209e:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c01020a2:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c01020a6:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c01020aa:	ee                   	out    %al,(%dx)
c01020ab:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c01020b1:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c01020b5:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c01020b9:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c01020bd:	ee                   	out    %al,(%dx)
c01020be:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c01020c4:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c01020c8:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01020cc:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01020d0:	ee                   	out    %al,(%dx)
c01020d1:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c01020d7:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c01020db:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01020df:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c01020e3:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c01020e4:	0f b7 05 50 15 12 c0 	movzwl 0xc0121550,%eax
c01020eb:	66 83 f8 ff          	cmp    $0xffff,%ax
c01020ef:	74 12                	je     c0102103 <pic_init+0x139>
        pic_setmask(irq_mask);
c01020f1:	0f b7 05 50 15 12 c0 	movzwl 0xc0121550,%eax
c01020f8:	0f b7 c0             	movzwl %ax,%eax
c01020fb:	89 04 24             	mov    %eax,(%esp)
c01020fe:	e8 41 fe ff ff       	call   c0101f44 <pic_setmask>
    }
}
c0102103:	c9                   	leave  
c0102104:	c3                   	ret    

c0102105 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0102105:	55                   	push   %ebp
c0102106:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
c0102108:	fb                   	sti    
    sti();
}
c0102109:	5d                   	pop    %ebp
c010210a:	c3                   	ret    

c010210b <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c010210b:	55                   	push   %ebp
c010210c:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
c010210e:	fa                   	cli    
    cli();
}
c010210f:	5d                   	pop    %ebp
c0102110:	c3                   	ret    

c0102111 <print_ticks>:
#include <swap.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c0102111:	55                   	push   %ebp
c0102112:	89 e5                	mov    %esp,%ebp
c0102114:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0102117:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c010211e:	00 
c010211f:	c7 04 24 a0 97 10 c0 	movl   $0xc01097a0,(%esp)
c0102126:	e8 76 e1 ff ff       	call   c01002a1 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c010212b:	c7 04 24 aa 97 10 c0 	movl   $0xc01097aa,(%esp)
c0102132:	e8 6a e1 ff ff       	call   c01002a1 <cprintf>
    panic("EOT: kernel seems ok.");
c0102137:	c7 44 24 08 b8 97 10 	movl   $0xc01097b8,0x8(%esp)
c010213e:	c0 
c010213f:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
c0102146:	00 
c0102147:	c7 04 24 ce 97 10 c0 	movl   $0xc01097ce,(%esp)
c010214e:	e8 a5 e2 ff ff       	call   c01003f8 <__panic>

c0102153 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c0102153:	55                   	push   %ebp
c0102154:	89 e5                	mov    %esp,%ebp
c0102156:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c0102159:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0102160:	e9 c3 00 00 00       	jmp    c0102228 <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c0102165:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102168:	8b 04 85 e0 15 12 c0 	mov    -0x3fedea20(,%eax,4),%eax
c010216f:	89 c2                	mov    %eax,%edx
c0102171:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102174:	66 89 14 c5 60 47 12 	mov    %dx,-0x3fedb8a0(,%eax,8)
c010217b:	c0 
c010217c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010217f:	66 c7 04 c5 62 47 12 	movw   $0x8,-0x3fedb89e(,%eax,8)
c0102186:	c0 08 00 
c0102189:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010218c:	0f b6 14 c5 64 47 12 	movzbl -0x3fedb89c(,%eax,8),%edx
c0102193:	c0 
c0102194:	83 e2 e0             	and    $0xffffffe0,%edx
c0102197:	88 14 c5 64 47 12 c0 	mov    %dl,-0x3fedb89c(,%eax,8)
c010219e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021a1:	0f b6 14 c5 64 47 12 	movzbl -0x3fedb89c(,%eax,8),%edx
c01021a8:	c0 
c01021a9:	83 e2 1f             	and    $0x1f,%edx
c01021ac:	88 14 c5 64 47 12 c0 	mov    %dl,-0x3fedb89c(,%eax,8)
c01021b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021b6:	0f b6 14 c5 65 47 12 	movzbl -0x3fedb89b(,%eax,8),%edx
c01021bd:	c0 
c01021be:	83 e2 f0             	and    $0xfffffff0,%edx
c01021c1:	83 ca 0e             	or     $0xe,%edx
c01021c4:	88 14 c5 65 47 12 c0 	mov    %dl,-0x3fedb89b(,%eax,8)
c01021cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021ce:	0f b6 14 c5 65 47 12 	movzbl -0x3fedb89b(,%eax,8),%edx
c01021d5:	c0 
c01021d6:	83 e2 ef             	and    $0xffffffef,%edx
c01021d9:	88 14 c5 65 47 12 c0 	mov    %dl,-0x3fedb89b(,%eax,8)
c01021e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021e3:	0f b6 14 c5 65 47 12 	movzbl -0x3fedb89b(,%eax,8),%edx
c01021ea:	c0 
c01021eb:	83 e2 9f             	and    $0xffffff9f,%edx
c01021ee:	88 14 c5 65 47 12 c0 	mov    %dl,-0x3fedb89b(,%eax,8)
c01021f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021f8:	0f b6 14 c5 65 47 12 	movzbl -0x3fedb89b(,%eax,8),%edx
c01021ff:	c0 
c0102200:	83 ca 80             	or     $0xffffff80,%edx
c0102203:	88 14 c5 65 47 12 c0 	mov    %dl,-0x3fedb89b(,%eax,8)
c010220a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010220d:	8b 04 85 e0 15 12 c0 	mov    -0x3fedea20(,%eax,4),%eax
c0102214:	c1 e8 10             	shr    $0x10,%eax
c0102217:	89 c2                	mov    %eax,%edx
c0102219:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010221c:	66 89 14 c5 66 47 12 	mov    %dx,-0x3fedb89a(,%eax,8)
c0102223:	c0 
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c0102224:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0102228:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010222b:	3d ff 00 00 00       	cmp    $0xff,%eax
c0102230:	0f 86 2f ff ff ff    	jbe    c0102165 <idt_init+0x12>
c0102236:	c7 45 f8 60 15 12 c0 	movl   $0xc0121560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c010223d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102240:	0f 01 18             	lidtl  (%eax)
    }
    lidt(&idt_pd);
}
c0102243:	c9                   	leave  
c0102244:	c3                   	ret    

c0102245 <trapname>:

static const char *
trapname(int trapno) {
c0102245:	55                   	push   %ebp
c0102246:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0102248:	8b 45 08             	mov    0x8(%ebp),%eax
c010224b:	83 f8 13             	cmp    $0x13,%eax
c010224e:	77 0c                	ja     c010225c <trapname+0x17>
        return excnames[trapno];
c0102250:	8b 45 08             	mov    0x8(%ebp),%eax
c0102253:	8b 04 85 a0 9b 10 c0 	mov    -0x3fef6460(,%eax,4),%eax
c010225a:	eb 18                	jmp    c0102274 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c010225c:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0102260:	7e 0d                	jle    c010226f <trapname+0x2a>
c0102262:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0102266:	7f 07                	jg     c010226f <trapname+0x2a>
        return "Hardware Interrupt";
c0102268:	b8 df 97 10 c0       	mov    $0xc01097df,%eax
c010226d:	eb 05                	jmp    c0102274 <trapname+0x2f>
    }
    return "(unknown trap)";
c010226f:	b8 f2 97 10 c0       	mov    $0xc01097f2,%eax
}
c0102274:	5d                   	pop    %ebp
c0102275:	c3                   	ret    

c0102276 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0102276:	55                   	push   %ebp
c0102277:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0102279:	8b 45 08             	mov    0x8(%ebp),%eax
c010227c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0102280:	66 83 f8 08          	cmp    $0x8,%ax
c0102284:	0f 94 c0             	sete   %al
c0102287:	0f b6 c0             	movzbl %al,%eax
}
c010228a:	5d                   	pop    %ebp
c010228b:	c3                   	ret    

c010228c <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c010228c:	55                   	push   %ebp
c010228d:	89 e5                	mov    %esp,%ebp
c010228f:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0102292:	8b 45 08             	mov    0x8(%ebp),%eax
c0102295:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102299:	c7 04 24 33 98 10 c0 	movl   $0xc0109833,(%esp)
c01022a0:	e8 fc df ff ff       	call   c01002a1 <cprintf>
    print_regs(&tf->tf_regs);
c01022a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01022a8:	89 04 24             	mov    %eax,(%esp)
c01022ab:	e8 a1 01 00 00       	call   c0102451 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c01022b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01022b3:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c01022b7:	0f b7 c0             	movzwl %ax,%eax
c01022ba:	89 44 24 04          	mov    %eax,0x4(%esp)
c01022be:	c7 04 24 44 98 10 c0 	movl   $0xc0109844,(%esp)
c01022c5:	e8 d7 df ff ff       	call   c01002a1 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c01022ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01022cd:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c01022d1:	0f b7 c0             	movzwl %ax,%eax
c01022d4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01022d8:	c7 04 24 57 98 10 c0 	movl   $0xc0109857,(%esp)
c01022df:	e8 bd df ff ff       	call   c01002a1 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c01022e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01022e7:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c01022eb:	0f b7 c0             	movzwl %ax,%eax
c01022ee:	89 44 24 04          	mov    %eax,0x4(%esp)
c01022f2:	c7 04 24 6a 98 10 c0 	movl   $0xc010986a,(%esp)
c01022f9:	e8 a3 df ff ff       	call   c01002a1 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c01022fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0102301:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0102305:	0f b7 c0             	movzwl %ax,%eax
c0102308:	89 44 24 04          	mov    %eax,0x4(%esp)
c010230c:	c7 04 24 7d 98 10 c0 	movl   $0xc010987d,(%esp)
c0102313:	e8 89 df ff ff       	call   c01002a1 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0102318:	8b 45 08             	mov    0x8(%ebp),%eax
c010231b:	8b 40 30             	mov    0x30(%eax),%eax
c010231e:	89 04 24             	mov    %eax,(%esp)
c0102321:	e8 1f ff ff ff       	call   c0102245 <trapname>
c0102326:	8b 55 08             	mov    0x8(%ebp),%edx
c0102329:	8b 52 30             	mov    0x30(%edx),%edx
c010232c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0102330:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102334:	c7 04 24 90 98 10 c0 	movl   $0xc0109890,(%esp)
c010233b:	e8 61 df ff ff       	call   c01002a1 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0102340:	8b 45 08             	mov    0x8(%ebp),%eax
c0102343:	8b 40 34             	mov    0x34(%eax),%eax
c0102346:	89 44 24 04          	mov    %eax,0x4(%esp)
c010234a:	c7 04 24 a2 98 10 c0 	movl   $0xc01098a2,(%esp)
c0102351:	e8 4b df ff ff       	call   c01002a1 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0102356:	8b 45 08             	mov    0x8(%ebp),%eax
c0102359:	8b 40 38             	mov    0x38(%eax),%eax
c010235c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102360:	c7 04 24 b1 98 10 c0 	movl   $0xc01098b1,(%esp)
c0102367:	e8 35 df ff ff       	call   c01002a1 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c010236c:	8b 45 08             	mov    0x8(%ebp),%eax
c010236f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0102373:	0f b7 c0             	movzwl %ax,%eax
c0102376:	89 44 24 04          	mov    %eax,0x4(%esp)
c010237a:	c7 04 24 c0 98 10 c0 	movl   $0xc01098c0,(%esp)
c0102381:	e8 1b df ff ff       	call   c01002a1 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0102386:	8b 45 08             	mov    0x8(%ebp),%eax
c0102389:	8b 40 40             	mov    0x40(%eax),%eax
c010238c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102390:	c7 04 24 d3 98 10 c0 	movl   $0xc01098d3,(%esp)
c0102397:	e8 05 df ff ff       	call   c01002a1 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c010239c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01023a3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c01023aa:	eb 3e                	jmp    c01023ea <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c01023ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01023af:	8b 50 40             	mov    0x40(%eax),%edx
c01023b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01023b5:	21 d0                	and    %edx,%eax
c01023b7:	85 c0                	test   %eax,%eax
c01023b9:	74 28                	je     c01023e3 <print_trapframe+0x157>
c01023bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01023be:	8b 04 85 80 15 12 c0 	mov    -0x3fedea80(,%eax,4),%eax
c01023c5:	85 c0                	test   %eax,%eax
c01023c7:	74 1a                	je     c01023e3 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c01023c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01023cc:	8b 04 85 80 15 12 c0 	mov    -0x3fedea80(,%eax,4),%eax
c01023d3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023d7:	c7 04 24 e2 98 10 c0 	movl   $0xc01098e2,(%esp)
c01023de:	e8 be de ff ff       	call   c01002a1 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c01023e3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01023e7:	d1 65 f0             	shll   -0x10(%ebp)
c01023ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01023ed:	83 f8 17             	cmp    $0x17,%eax
c01023f0:	76 ba                	jbe    c01023ac <print_trapframe+0x120>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c01023f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01023f5:	8b 40 40             	mov    0x40(%eax),%eax
c01023f8:	25 00 30 00 00       	and    $0x3000,%eax
c01023fd:	c1 e8 0c             	shr    $0xc,%eax
c0102400:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102404:	c7 04 24 e6 98 10 c0 	movl   $0xc01098e6,(%esp)
c010240b:	e8 91 de ff ff       	call   c01002a1 <cprintf>

    if (!trap_in_kernel(tf)) {
c0102410:	8b 45 08             	mov    0x8(%ebp),%eax
c0102413:	89 04 24             	mov    %eax,(%esp)
c0102416:	e8 5b fe ff ff       	call   c0102276 <trap_in_kernel>
c010241b:	85 c0                	test   %eax,%eax
c010241d:	75 30                	jne    c010244f <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c010241f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102422:	8b 40 44             	mov    0x44(%eax),%eax
c0102425:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102429:	c7 04 24 ef 98 10 c0 	movl   $0xc01098ef,(%esp)
c0102430:	e8 6c de ff ff       	call   c01002a1 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0102435:	8b 45 08             	mov    0x8(%ebp),%eax
c0102438:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c010243c:	0f b7 c0             	movzwl %ax,%eax
c010243f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102443:	c7 04 24 fe 98 10 c0 	movl   $0xc01098fe,(%esp)
c010244a:	e8 52 de ff ff       	call   c01002a1 <cprintf>
    }
}
c010244f:	c9                   	leave  
c0102450:	c3                   	ret    

c0102451 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0102451:	55                   	push   %ebp
c0102452:	89 e5                	mov    %esp,%ebp
c0102454:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0102457:	8b 45 08             	mov    0x8(%ebp),%eax
c010245a:	8b 00                	mov    (%eax),%eax
c010245c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102460:	c7 04 24 11 99 10 c0 	movl   $0xc0109911,(%esp)
c0102467:	e8 35 de ff ff       	call   c01002a1 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c010246c:	8b 45 08             	mov    0x8(%ebp),%eax
c010246f:	8b 40 04             	mov    0x4(%eax),%eax
c0102472:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102476:	c7 04 24 20 99 10 c0 	movl   $0xc0109920,(%esp)
c010247d:	e8 1f de ff ff       	call   c01002a1 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0102482:	8b 45 08             	mov    0x8(%ebp),%eax
c0102485:	8b 40 08             	mov    0x8(%eax),%eax
c0102488:	89 44 24 04          	mov    %eax,0x4(%esp)
c010248c:	c7 04 24 2f 99 10 c0 	movl   $0xc010992f,(%esp)
c0102493:	e8 09 de ff ff       	call   c01002a1 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0102498:	8b 45 08             	mov    0x8(%ebp),%eax
c010249b:	8b 40 0c             	mov    0xc(%eax),%eax
c010249e:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024a2:	c7 04 24 3e 99 10 c0 	movl   $0xc010993e,(%esp)
c01024a9:	e8 f3 dd ff ff       	call   c01002a1 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c01024ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01024b1:	8b 40 10             	mov    0x10(%eax),%eax
c01024b4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024b8:	c7 04 24 4d 99 10 c0 	movl   $0xc010994d,(%esp)
c01024bf:	e8 dd dd ff ff       	call   c01002a1 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c01024c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01024c7:	8b 40 14             	mov    0x14(%eax),%eax
c01024ca:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024ce:	c7 04 24 5c 99 10 c0 	movl   $0xc010995c,(%esp)
c01024d5:	e8 c7 dd ff ff       	call   c01002a1 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c01024da:	8b 45 08             	mov    0x8(%ebp),%eax
c01024dd:	8b 40 18             	mov    0x18(%eax),%eax
c01024e0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024e4:	c7 04 24 6b 99 10 c0 	movl   $0xc010996b,(%esp)
c01024eb:	e8 b1 dd ff ff       	call   c01002a1 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c01024f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01024f3:	8b 40 1c             	mov    0x1c(%eax),%eax
c01024f6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024fa:	c7 04 24 7a 99 10 c0 	movl   $0xc010997a,(%esp)
c0102501:	e8 9b dd ff ff       	call   c01002a1 <cprintf>
}
c0102506:	c9                   	leave  
c0102507:	c3                   	ret    

c0102508 <print_pgfault>:

static inline void
print_pgfault(struct trapframe *tf) {
c0102508:	55                   	push   %ebp
c0102509:	89 e5                	mov    %esp,%ebp
c010250b:	53                   	push   %ebx
c010250c:	83 ec 34             	sub    $0x34,%esp
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
c010250f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102512:	8b 40 34             	mov    0x34(%eax),%eax
c0102515:	83 e0 01             	and    $0x1,%eax
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102518:	85 c0                	test   %eax,%eax
c010251a:	74 07                	je     c0102523 <print_pgfault+0x1b>
c010251c:	b9 89 99 10 c0       	mov    $0xc0109989,%ecx
c0102521:	eb 05                	jmp    c0102528 <print_pgfault+0x20>
c0102523:	b9 9a 99 10 c0       	mov    $0xc010999a,%ecx
            (tf->tf_err & 2) ? 'W' : 'R',
c0102528:	8b 45 08             	mov    0x8(%ebp),%eax
c010252b:	8b 40 34             	mov    0x34(%eax),%eax
c010252e:	83 e0 02             	and    $0x2,%eax
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102531:	85 c0                	test   %eax,%eax
c0102533:	74 07                	je     c010253c <print_pgfault+0x34>
c0102535:	ba 57 00 00 00       	mov    $0x57,%edx
c010253a:	eb 05                	jmp    c0102541 <print_pgfault+0x39>
c010253c:	ba 52 00 00 00       	mov    $0x52,%edx
            (tf->tf_err & 4) ? 'U' : 'K',
c0102541:	8b 45 08             	mov    0x8(%ebp),%eax
c0102544:	8b 40 34             	mov    0x34(%eax),%eax
c0102547:	83 e0 04             	and    $0x4,%eax
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c010254a:	85 c0                	test   %eax,%eax
c010254c:	74 07                	je     c0102555 <print_pgfault+0x4d>
c010254e:	b8 55 00 00 00       	mov    $0x55,%eax
c0102553:	eb 05                	jmp    c010255a <print_pgfault+0x52>
c0102555:	b8 4b 00 00 00       	mov    $0x4b,%eax
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c010255a:	0f 20 d3             	mov    %cr2,%ebx
c010255d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return cr2;
c0102560:	8b 5d f4             	mov    -0xc(%ebp),%ebx
c0102563:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0102567:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010256b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010256f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0102573:	c7 04 24 a8 99 10 c0 	movl   $0xc01099a8,(%esp)
c010257a:	e8 22 dd ff ff       	call   c01002a1 <cprintf>
}
c010257f:	83 c4 34             	add    $0x34,%esp
c0102582:	5b                   	pop    %ebx
c0102583:	5d                   	pop    %ebp
c0102584:	c3                   	ret    

c0102585 <pgfault_handler>:

static int
pgfault_handler(struct trapframe *tf) {
c0102585:	55                   	push   %ebp
c0102586:	89 e5                	mov    %esp,%ebp
c0102588:	83 ec 28             	sub    $0x28,%esp
    extern struct mm_struct *check_mm_struct;
    print_pgfault(tf);
c010258b:	8b 45 08             	mov    0x8(%ebp),%eax
c010258e:	89 04 24             	mov    %eax,(%esp)
c0102591:	e8 72 ff ff ff       	call   c0102508 <print_pgfault>
    if (check_mm_struct != NULL) {
c0102596:	a1 1c 50 12 c0       	mov    0xc012501c,%eax
c010259b:	85 c0                	test   %eax,%eax
c010259d:	74 28                	je     c01025c7 <pgfault_handler+0x42>
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c010259f:	0f 20 d0             	mov    %cr2,%eax
c01025a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr2;
c01025a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
        return do_pgfault(check_mm_struct, tf->tf_err, rcr2());
c01025a8:	89 c1                	mov    %eax,%ecx
c01025aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01025ad:	8b 50 34             	mov    0x34(%eax),%edx
c01025b0:	a1 1c 50 12 c0       	mov    0xc012501c,%eax
c01025b5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01025b9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01025bd:	89 04 24             	mov    %eax,(%esp)
c01025c0:	e8 9c 1e 00 00       	call   c0104461 <do_pgfault>
c01025c5:	eb 1c                	jmp    c01025e3 <pgfault_handler+0x5e>
    }
    panic("unhandled page fault.\n");
c01025c7:	c7 44 24 08 cb 99 10 	movl   $0xc01099cb,0x8(%esp)
c01025ce:	c0 
c01025cf:	c7 44 24 04 a5 00 00 	movl   $0xa5,0x4(%esp)
c01025d6:	00 
c01025d7:	c7 04 24 ce 97 10 c0 	movl   $0xc01097ce,(%esp)
c01025de:	e8 15 de ff ff       	call   c01003f8 <__panic>
}
c01025e3:	c9                   	leave  
c01025e4:	c3                   	ret    

c01025e5 <trap_dispatch>:

static volatile int in_swap_tick_event = 0;
extern struct mm_struct *check_mm_struct;

static void
trap_dispatch(struct trapframe *tf) {
c01025e5:	55                   	push   %ebp
c01025e6:	89 e5                	mov    %esp,%ebp
c01025e8:	83 ec 28             	sub    $0x28,%esp
    char c;

    int ret;

    switch (tf->tf_trapno) {
c01025eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01025ee:	8b 40 30             	mov    0x30(%eax),%eax
c01025f1:	83 f8 24             	cmp    $0x24,%eax
c01025f4:	0f 84 c2 00 00 00    	je     c01026bc <trap_dispatch+0xd7>
c01025fa:	83 f8 24             	cmp    $0x24,%eax
c01025fd:	77 18                	ja     c0102617 <trap_dispatch+0x32>
c01025ff:	83 f8 20             	cmp    $0x20,%eax
c0102602:	74 7d                	je     c0102681 <trap_dispatch+0x9c>
c0102604:	83 f8 21             	cmp    $0x21,%eax
c0102607:	0f 84 d5 00 00 00    	je     c01026e2 <trap_dispatch+0xfd>
c010260d:	83 f8 0e             	cmp    $0xe,%eax
c0102610:	74 28                	je     c010263a <trap_dispatch+0x55>
c0102612:	e9 0d 01 00 00       	jmp    c0102724 <trap_dispatch+0x13f>
c0102617:	83 f8 2e             	cmp    $0x2e,%eax
c010261a:	0f 82 04 01 00 00    	jb     c0102724 <trap_dispatch+0x13f>
c0102620:	83 f8 2f             	cmp    $0x2f,%eax
c0102623:	0f 86 33 01 00 00    	jbe    c010275c <trap_dispatch+0x177>
c0102629:	83 e8 78             	sub    $0x78,%eax
c010262c:	83 f8 01             	cmp    $0x1,%eax
c010262f:	0f 87 ef 00 00 00    	ja     c0102724 <trap_dispatch+0x13f>
c0102635:	e9 ce 00 00 00       	jmp    c0102708 <trap_dispatch+0x123>
    case T_PGFLT:  //page fault
        if ((ret = pgfault_handler(tf)) != 0) {
c010263a:	8b 45 08             	mov    0x8(%ebp),%eax
c010263d:	89 04 24             	mov    %eax,(%esp)
c0102640:	e8 40 ff ff ff       	call   c0102585 <pgfault_handler>
c0102645:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102648:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010264c:	74 2e                	je     c010267c <trap_dispatch+0x97>
            print_trapframe(tf);
c010264e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102651:	89 04 24             	mov    %eax,(%esp)
c0102654:	e8 33 fc ff ff       	call   c010228c <print_trapframe>
            panic("handle pgfault failed. %e\n", ret);
c0102659:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010265c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102660:	c7 44 24 08 e2 99 10 	movl   $0xc01099e2,0x8(%esp)
c0102667:	c0 
c0102668:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
c010266f:	00 
c0102670:	c7 04 24 ce 97 10 c0 	movl   $0xc01097ce,(%esp)
c0102677:	e8 7c dd ff ff       	call   c01003f8 <__panic>
        }
        break;
c010267c:	e9 dc 00 00 00       	jmp    c010275d <trap_dispatch+0x178>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
c0102681:	a1 0c 50 12 c0       	mov    0xc012500c,%eax
c0102686:	83 c0 01             	add    $0x1,%eax
c0102689:	a3 0c 50 12 c0       	mov    %eax,0xc012500c
        if (ticks % TICK_NUM == 0) {
c010268e:	8b 0d 0c 50 12 c0    	mov    0xc012500c,%ecx
c0102694:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0102699:	89 c8                	mov    %ecx,%eax
c010269b:	f7 e2                	mul    %edx
c010269d:	89 d0                	mov    %edx,%eax
c010269f:	c1 e8 05             	shr    $0x5,%eax
c01026a2:	6b c0 64             	imul   $0x64,%eax,%eax
c01026a5:	29 c1                	sub    %eax,%ecx
c01026a7:	89 c8                	mov    %ecx,%eax
c01026a9:	85 c0                	test   %eax,%eax
c01026ab:	75 0a                	jne    c01026b7 <trap_dispatch+0xd2>
            print_ticks();
c01026ad:	e8 5f fa ff ff       	call   c0102111 <print_ticks>
        }
        break;
c01026b2:	e9 a6 00 00 00       	jmp    c010275d <trap_dispatch+0x178>
c01026b7:	e9 a1 00 00 00       	jmp    c010275d <trap_dispatch+0x178>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c01026bc:	e8 14 f8 ff ff       	call   c0101ed5 <cons_getc>
c01026c1:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c01026c4:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c01026c8:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c01026cc:	89 54 24 08          	mov    %edx,0x8(%esp)
c01026d0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01026d4:	c7 04 24 fd 99 10 c0 	movl   $0xc01099fd,(%esp)
c01026db:	e8 c1 db ff ff       	call   c01002a1 <cprintf>
        break;
c01026e0:	eb 7b                	jmp    c010275d <trap_dispatch+0x178>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c01026e2:	e8 ee f7 ff ff       	call   c0101ed5 <cons_getc>
c01026e7:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c01026ea:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c01026ee:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c01026f2:	89 54 24 08          	mov    %edx,0x8(%esp)
c01026f6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01026fa:	c7 04 24 0f 9a 10 c0 	movl   $0xc0109a0f,(%esp)
c0102701:	e8 9b db ff ff       	call   c01002a1 <cprintf>
        break;
c0102706:	eb 55                	jmp    c010275d <trap_dispatch+0x178>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0102708:	c7 44 24 08 1e 9a 10 	movl   $0xc0109a1e,0x8(%esp)
c010270f:	c0 
c0102710:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c0102717:	00 
c0102718:	c7 04 24 ce 97 10 c0 	movl   $0xc01097ce,(%esp)
c010271f:	e8 d4 dc ff ff       	call   c01003f8 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0102724:	8b 45 08             	mov    0x8(%ebp),%eax
c0102727:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c010272b:	0f b7 c0             	movzwl %ax,%eax
c010272e:	83 e0 03             	and    $0x3,%eax
c0102731:	85 c0                	test   %eax,%eax
c0102733:	75 28                	jne    c010275d <trap_dispatch+0x178>
            print_trapframe(tf);
c0102735:	8b 45 08             	mov    0x8(%ebp),%eax
c0102738:	89 04 24             	mov    %eax,(%esp)
c010273b:	e8 4c fb ff ff       	call   c010228c <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0102740:	c7 44 24 08 2e 9a 10 	movl   $0xc0109a2e,0x8(%esp)
c0102747:	c0 
c0102748:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
c010274f:	00 
c0102750:	c7 04 24 ce 97 10 c0 	movl   $0xc01097ce,(%esp)
c0102757:	e8 9c dc ff ff       	call   c01003f8 <__panic>
        break;
c010275c:	90                   	nop
        }
    }
}
c010275d:	c9                   	leave  
c010275e:	c3                   	ret    

c010275f <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c010275f:	55                   	push   %ebp
c0102760:	89 e5                	mov    %esp,%ebp
c0102762:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0102765:	8b 45 08             	mov    0x8(%ebp),%eax
c0102768:	89 04 24             	mov    %eax,(%esp)
c010276b:	e8 75 fe ff ff       	call   c01025e5 <trap_dispatch>
}
c0102770:	c9                   	leave  
c0102771:	c3                   	ret    

c0102772 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0102772:	6a 00                	push   $0x0
  pushl $0
c0102774:	6a 00                	push   $0x0
  jmp __alltraps
c0102776:	e9 67 0a 00 00       	jmp    c01031e2 <__alltraps>

c010277b <vector1>:
.globl vector1
vector1:
  pushl $0
c010277b:	6a 00                	push   $0x0
  pushl $1
c010277d:	6a 01                	push   $0x1
  jmp __alltraps
c010277f:	e9 5e 0a 00 00       	jmp    c01031e2 <__alltraps>

c0102784 <vector2>:
.globl vector2
vector2:
  pushl $0
c0102784:	6a 00                	push   $0x0
  pushl $2
c0102786:	6a 02                	push   $0x2
  jmp __alltraps
c0102788:	e9 55 0a 00 00       	jmp    c01031e2 <__alltraps>

c010278d <vector3>:
.globl vector3
vector3:
  pushl $0
c010278d:	6a 00                	push   $0x0
  pushl $3
c010278f:	6a 03                	push   $0x3
  jmp __alltraps
c0102791:	e9 4c 0a 00 00       	jmp    c01031e2 <__alltraps>

c0102796 <vector4>:
.globl vector4
vector4:
  pushl $0
c0102796:	6a 00                	push   $0x0
  pushl $4
c0102798:	6a 04                	push   $0x4
  jmp __alltraps
c010279a:	e9 43 0a 00 00       	jmp    c01031e2 <__alltraps>

c010279f <vector5>:
.globl vector5
vector5:
  pushl $0
c010279f:	6a 00                	push   $0x0
  pushl $5
c01027a1:	6a 05                	push   $0x5
  jmp __alltraps
c01027a3:	e9 3a 0a 00 00       	jmp    c01031e2 <__alltraps>

c01027a8 <vector6>:
.globl vector6
vector6:
  pushl $0
c01027a8:	6a 00                	push   $0x0
  pushl $6
c01027aa:	6a 06                	push   $0x6
  jmp __alltraps
c01027ac:	e9 31 0a 00 00       	jmp    c01031e2 <__alltraps>

c01027b1 <vector7>:
.globl vector7
vector7:
  pushl $0
c01027b1:	6a 00                	push   $0x0
  pushl $7
c01027b3:	6a 07                	push   $0x7
  jmp __alltraps
c01027b5:	e9 28 0a 00 00       	jmp    c01031e2 <__alltraps>

c01027ba <vector8>:
.globl vector8
vector8:
  pushl $8
c01027ba:	6a 08                	push   $0x8
  jmp __alltraps
c01027bc:	e9 21 0a 00 00       	jmp    c01031e2 <__alltraps>

c01027c1 <vector9>:
.globl vector9
vector9:
  pushl $9
c01027c1:	6a 09                	push   $0x9
  jmp __alltraps
c01027c3:	e9 1a 0a 00 00       	jmp    c01031e2 <__alltraps>

c01027c8 <vector10>:
.globl vector10
vector10:
  pushl $10
c01027c8:	6a 0a                	push   $0xa
  jmp __alltraps
c01027ca:	e9 13 0a 00 00       	jmp    c01031e2 <__alltraps>

c01027cf <vector11>:
.globl vector11
vector11:
  pushl $11
c01027cf:	6a 0b                	push   $0xb
  jmp __alltraps
c01027d1:	e9 0c 0a 00 00       	jmp    c01031e2 <__alltraps>

c01027d6 <vector12>:
.globl vector12
vector12:
  pushl $12
c01027d6:	6a 0c                	push   $0xc
  jmp __alltraps
c01027d8:	e9 05 0a 00 00       	jmp    c01031e2 <__alltraps>

c01027dd <vector13>:
.globl vector13
vector13:
  pushl $13
c01027dd:	6a 0d                	push   $0xd
  jmp __alltraps
c01027df:	e9 fe 09 00 00       	jmp    c01031e2 <__alltraps>

c01027e4 <vector14>:
.globl vector14
vector14:
  pushl $14
c01027e4:	6a 0e                	push   $0xe
  jmp __alltraps
c01027e6:	e9 f7 09 00 00       	jmp    c01031e2 <__alltraps>

c01027eb <vector15>:
.globl vector15
vector15:
  pushl $0
c01027eb:	6a 00                	push   $0x0
  pushl $15
c01027ed:	6a 0f                	push   $0xf
  jmp __alltraps
c01027ef:	e9 ee 09 00 00       	jmp    c01031e2 <__alltraps>

c01027f4 <vector16>:
.globl vector16
vector16:
  pushl $0
c01027f4:	6a 00                	push   $0x0
  pushl $16
c01027f6:	6a 10                	push   $0x10
  jmp __alltraps
c01027f8:	e9 e5 09 00 00       	jmp    c01031e2 <__alltraps>

c01027fd <vector17>:
.globl vector17
vector17:
  pushl $17
c01027fd:	6a 11                	push   $0x11
  jmp __alltraps
c01027ff:	e9 de 09 00 00       	jmp    c01031e2 <__alltraps>

c0102804 <vector18>:
.globl vector18
vector18:
  pushl $0
c0102804:	6a 00                	push   $0x0
  pushl $18
c0102806:	6a 12                	push   $0x12
  jmp __alltraps
c0102808:	e9 d5 09 00 00       	jmp    c01031e2 <__alltraps>

c010280d <vector19>:
.globl vector19
vector19:
  pushl $0
c010280d:	6a 00                	push   $0x0
  pushl $19
c010280f:	6a 13                	push   $0x13
  jmp __alltraps
c0102811:	e9 cc 09 00 00       	jmp    c01031e2 <__alltraps>

c0102816 <vector20>:
.globl vector20
vector20:
  pushl $0
c0102816:	6a 00                	push   $0x0
  pushl $20
c0102818:	6a 14                	push   $0x14
  jmp __alltraps
c010281a:	e9 c3 09 00 00       	jmp    c01031e2 <__alltraps>

c010281f <vector21>:
.globl vector21
vector21:
  pushl $0
c010281f:	6a 00                	push   $0x0
  pushl $21
c0102821:	6a 15                	push   $0x15
  jmp __alltraps
c0102823:	e9 ba 09 00 00       	jmp    c01031e2 <__alltraps>

c0102828 <vector22>:
.globl vector22
vector22:
  pushl $0
c0102828:	6a 00                	push   $0x0
  pushl $22
c010282a:	6a 16                	push   $0x16
  jmp __alltraps
c010282c:	e9 b1 09 00 00       	jmp    c01031e2 <__alltraps>

c0102831 <vector23>:
.globl vector23
vector23:
  pushl $0
c0102831:	6a 00                	push   $0x0
  pushl $23
c0102833:	6a 17                	push   $0x17
  jmp __alltraps
c0102835:	e9 a8 09 00 00       	jmp    c01031e2 <__alltraps>

c010283a <vector24>:
.globl vector24
vector24:
  pushl $0
c010283a:	6a 00                	push   $0x0
  pushl $24
c010283c:	6a 18                	push   $0x18
  jmp __alltraps
c010283e:	e9 9f 09 00 00       	jmp    c01031e2 <__alltraps>

c0102843 <vector25>:
.globl vector25
vector25:
  pushl $0
c0102843:	6a 00                	push   $0x0
  pushl $25
c0102845:	6a 19                	push   $0x19
  jmp __alltraps
c0102847:	e9 96 09 00 00       	jmp    c01031e2 <__alltraps>

c010284c <vector26>:
.globl vector26
vector26:
  pushl $0
c010284c:	6a 00                	push   $0x0
  pushl $26
c010284e:	6a 1a                	push   $0x1a
  jmp __alltraps
c0102850:	e9 8d 09 00 00       	jmp    c01031e2 <__alltraps>

c0102855 <vector27>:
.globl vector27
vector27:
  pushl $0
c0102855:	6a 00                	push   $0x0
  pushl $27
c0102857:	6a 1b                	push   $0x1b
  jmp __alltraps
c0102859:	e9 84 09 00 00       	jmp    c01031e2 <__alltraps>

c010285e <vector28>:
.globl vector28
vector28:
  pushl $0
c010285e:	6a 00                	push   $0x0
  pushl $28
c0102860:	6a 1c                	push   $0x1c
  jmp __alltraps
c0102862:	e9 7b 09 00 00       	jmp    c01031e2 <__alltraps>

c0102867 <vector29>:
.globl vector29
vector29:
  pushl $0
c0102867:	6a 00                	push   $0x0
  pushl $29
c0102869:	6a 1d                	push   $0x1d
  jmp __alltraps
c010286b:	e9 72 09 00 00       	jmp    c01031e2 <__alltraps>

c0102870 <vector30>:
.globl vector30
vector30:
  pushl $0
c0102870:	6a 00                	push   $0x0
  pushl $30
c0102872:	6a 1e                	push   $0x1e
  jmp __alltraps
c0102874:	e9 69 09 00 00       	jmp    c01031e2 <__alltraps>

c0102879 <vector31>:
.globl vector31
vector31:
  pushl $0
c0102879:	6a 00                	push   $0x0
  pushl $31
c010287b:	6a 1f                	push   $0x1f
  jmp __alltraps
c010287d:	e9 60 09 00 00       	jmp    c01031e2 <__alltraps>

c0102882 <vector32>:
.globl vector32
vector32:
  pushl $0
c0102882:	6a 00                	push   $0x0
  pushl $32
c0102884:	6a 20                	push   $0x20
  jmp __alltraps
c0102886:	e9 57 09 00 00       	jmp    c01031e2 <__alltraps>

c010288b <vector33>:
.globl vector33
vector33:
  pushl $0
c010288b:	6a 00                	push   $0x0
  pushl $33
c010288d:	6a 21                	push   $0x21
  jmp __alltraps
c010288f:	e9 4e 09 00 00       	jmp    c01031e2 <__alltraps>

c0102894 <vector34>:
.globl vector34
vector34:
  pushl $0
c0102894:	6a 00                	push   $0x0
  pushl $34
c0102896:	6a 22                	push   $0x22
  jmp __alltraps
c0102898:	e9 45 09 00 00       	jmp    c01031e2 <__alltraps>

c010289d <vector35>:
.globl vector35
vector35:
  pushl $0
c010289d:	6a 00                	push   $0x0
  pushl $35
c010289f:	6a 23                	push   $0x23
  jmp __alltraps
c01028a1:	e9 3c 09 00 00       	jmp    c01031e2 <__alltraps>

c01028a6 <vector36>:
.globl vector36
vector36:
  pushl $0
c01028a6:	6a 00                	push   $0x0
  pushl $36
c01028a8:	6a 24                	push   $0x24
  jmp __alltraps
c01028aa:	e9 33 09 00 00       	jmp    c01031e2 <__alltraps>

c01028af <vector37>:
.globl vector37
vector37:
  pushl $0
c01028af:	6a 00                	push   $0x0
  pushl $37
c01028b1:	6a 25                	push   $0x25
  jmp __alltraps
c01028b3:	e9 2a 09 00 00       	jmp    c01031e2 <__alltraps>

c01028b8 <vector38>:
.globl vector38
vector38:
  pushl $0
c01028b8:	6a 00                	push   $0x0
  pushl $38
c01028ba:	6a 26                	push   $0x26
  jmp __alltraps
c01028bc:	e9 21 09 00 00       	jmp    c01031e2 <__alltraps>

c01028c1 <vector39>:
.globl vector39
vector39:
  pushl $0
c01028c1:	6a 00                	push   $0x0
  pushl $39
c01028c3:	6a 27                	push   $0x27
  jmp __alltraps
c01028c5:	e9 18 09 00 00       	jmp    c01031e2 <__alltraps>

c01028ca <vector40>:
.globl vector40
vector40:
  pushl $0
c01028ca:	6a 00                	push   $0x0
  pushl $40
c01028cc:	6a 28                	push   $0x28
  jmp __alltraps
c01028ce:	e9 0f 09 00 00       	jmp    c01031e2 <__alltraps>

c01028d3 <vector41>:
.globl vector41
vector41:
  pushl $0
c01028d3:	6a 00                	push   $0x0
  pushl $41
c01028d5:	6a 29                	push   $0x29
  jmp __alltraps
c01028d7:	e9 06 09 00 00       	jmp    c01031e2 <__alltraps>

c01028dc <vector42>:
.globl vector42
vector42:
  pushl $0
c01028dc:	6a 00                	push   $0x0
  pushl $42
c01028de:	6a 2a                	push   $0x2a
  jmp __alltraps
c01028e0:	e9 fd 08 00 00       	jmp    c01031e2 <__alltraps>

c01028e5 <vector43>:
.globl vector43
vector43:
  pushl $0
c01028e5:	6a 00                	push   $0x0
  pushl $43
c01028e7:	6a 2b                	push   $0x2b
  jmp __alltraps
c01028e9:	e9 f4 08 00 00       	jmp    c01031e2 <__alltraps>

c01028ee <vector44>:
.globl vector44
vector44:
  pushl $0
c01028ee:	6a 00                	push   $0x0
  pushl $44
c01028f0:	6a 2c                	push   $0x2c
  jmp __alltraps
c01028f2:	e9 eb 08 00 00       	jmp    c01031e2 <__alltraps>

c01028f7 <vector45>:
.globl vector45
vector45:
  pushl $0
c01028f7:	6a 00                	push   $0x0
  pushl $45
c01028f9:	6a 2d                	push   $0x2d
  jmp __alltraps
c01028fb:	e9 e2 08 00 00       	jmp    c01031e2 <__alltraps>

c0102900 <vector46>:
.globl vector46
vector46:
  pushl $0
c0102900:	6a 00                	push   $0x0
  pushl $46
c0102902:	6a 2e                	push   $0x2e
  jmp __alltraps
c0102904:	e9 d9 08 00 00       	jmp    c01031e2 <__alltraps>

c0102909 <vector47>:
.globl vector47
vector47:
  pushl $0
c0102909:	6a 00                	push   $0x0
  pushl $47
c010290b:	6a 2f                	push   $0x2f
  jmp __alltraps
c010290d:	e9 d0 08 00 00       	jmp    c01031e2 <__alltraps>

c0102912 <vector48>:
.globl vector48
vector48:
  pushl $0
c0102912:	6a 00                	push   $0x0
  pushl $48
c0102914:	6a 30                	push   $0x30
  jmp __alltraps
c0102916:	e9 c7 08 00 00       	jmp    c01031e2 <__alltraps>

c010291b <vector49>:
.globl vector49
vector49:
  pushl $0
c010291b:	6a 00                	push   $0x0
  pushl $49
c010291d:	6a 31                	push   $0x31
  jmp __alltraps
c010291f:	e9 be 08 00 00       	jmp    c01031e2 <__alltraps>

c0102924 <vector50>:
.globl vector50
vector50:
  pushl $0
c0102924:	6a 00                	push   $0x0
  pushl $50
c0102926:	6a 32                	push   $0x32
  jmp __alltraps
c0102928:	e9 b5 08 00 00       	jmp    c01031e2 <__alltraps>

c010292d <vector51>:
.globl vector51
vector51:
  pushl $0
c010292d:	6a 00                	push   $0x0
  pushl $51
c010292f:	6a 33                	push   $0x33
  jmp __alltraps
c0102931:	e9 ac 08 00 00       	jmp    c01031e2 <__alltraps>

c0102936 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102936:	6a 00                	push   $0x0
  pushl $52
c0102938:	6a 34                	push   $0x34
  jmp __alltraps
c010293a:	e9 a3 08 00 00       	jmp    c01031e2 <__alltraps>

c010293f <vector53>:
.globl vector53
vector53:
  pushl $0
c010293f:	6a 00                	push   $0x0
  pushl $53
c0102941:	6a 35                	push   $0x35
  jmp __alltraps
c0102943:	e9 9a 08 00 00       	jmp    c01031e2 <__alltraps>

c0102948 <vector54>:
.globl vector54
vector54:
  pushl $0
c0102948:	6a 00                	push   $0x0
  pushl $54
c010294a:	6a 36                	push   $0x36
  jmp __alltraps
c010294c:	e9 91 08 00 00       	jmp    c01031e2 <__alltraps>

c0102951 <vector55>:
.globl vector55
vector55:
  pushl $0
c0102951:	6a 00                	push   $0x0
  pushl $55
c0102953:	6a 37                	push   $0x37
  jmp __alltraps
c0102955:	e9 88 08 00 00       	jmp    c01031e2 <__alltraps>

c010295a <vector56>:
.globl vector56
vector56:
  pushl $0
c010295a:	6a 00                	push   $0x0
  pushl $56
c010295c:	6a 38                	push   $0x38
  jmp __alltraps
c010295e:	e9 7f 08 00 00       	jmp    c01031e2 <__alltraps>

c0102963 <vector57>:
.globl vector57
vector57:
  pushl $0
c0102963:	6a 00                	push   $0x0
  pushl $57
c0102965:	6a 39                	push   $0x39
  jmp __alltraps
c0102967:	e9 76 08 00 00       	jmp    c01031e2 <__alltraps>

c010296c <vector58>:
.globl vector58
vector58:
  pushl $0
c010296c:	6a 00                	push   $0x0
  pushl $58
c010296e:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102970:	e9 6d 08 00 00       	jmp    c01031e2 <__alltraps>

c0102975 <vector59>:
.globl vector59
vector59:
  pushl $0
c0102975:	6a 00                	push   $0x0
  pushl $59
c0102977:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102979:	e9 64 08 00 00       	jmp    c01031e2 <__alltraps>

c010297e <vector60>:
.globl vector60
vector60:
  pushl $0
c010297e:	6a 00                	push   $0x0
  pushl $60
c0102980:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102982:	e9 5b 08 00 00       	jmp    c01031e2 <__alltraps>

c0102987 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102987:	6a 00                	push   $0x0
  pushl $61
c0102989:	6a 3d                	push   $0x3d
  jmp __alltraps
c010298b:	e9 52 08 00 00       	jmp    c01031e2 <__alltraps>

c0102990 <vector62>:
.globl vector62
vector62:
  pushl $0
c0102990:	6a 00                	push   $0x0
  pushl $62
c0102992:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102994:	e9 49 08 00 00       	jmp    c01031e2 <__alltraps>

c0102999 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102999:	6a 00                	push   $0x0
  pushl $63
c010299b:	6a 3f                	push   $0x3f
  jmp __alltraps
c010299d:	e9 40 08 00 00       	jmp    c01031e2 <__alltraps>

c01029a2 <vector64>:
.globl vector64
vector64:
  pushl $0
c01029a2:	6a 00                	push   $0x0
  pushl $64
c01029a4:	6a 40                	push   $0x40
  jmp __alltraps
c01029a6:	e9 37 08 00 00       	jmp    c01031e2 <__alltraps>

c01029ab <vector65>:
.globl vector65
vector65:
  pushl $0
c01029ab:	6a 00                	push   $0x0
  pushl $65
c01029ad:	6a 41                	push   $0x41
  jmp __alltraps
c01029af:	e9 2e 08 00 00       	jmp    c01031e2 <__alltraps>

c01029b4 <vector66>:
.globl vector66
vector66:
  pushl $0
c01029b4:	6a 00                	push   $0x0
  pushl $66
c01029b6:	6a 42                	push   $0x42
  jmp __alltraps
c01029b8:	e9 25 08 00 00       	jmp    c01031e2 <__alltraps>

c01029bd <vector67>:
.globl vector67
vector67:
  pushl $0
c01029bd:	6a 00                	push   $0x0
  pushl $67
c01029bf:	6a 43                	push   $0x43
  jmp __alltraps
c01029c1:	e9 1c 08 00 00       	jmp    c01031e2 <__alltraps>

c01029c6 <vector68>:
.globl vector68
vector68:
  pushl $0
c01029c6:	6a 00                	push   $0x0
  pushl $68
c01029c8:	6a 44                	push   $0x44
  jmp __alltraps
c01029ca:	e9 13 08 00 00       	jmp    c01031e2 <__alltraps>

c01029cf <vector69>:
.globl vector69
vector69:
  pushl $0
c01029cf:	6a 00                	push   $0x0
  pushl $69
c01029d1:	6a 45                	push   $0x45
  jmp __alltraps
c01029d3:	e9 0a 08 00 00       	jmp    c01031e2 <__alltraps>

c01029d8 <vector70>:
.globl vector70
vector70:
  pushl $0
c01029d8:	6a 00                	push   $0x0
  pushl $70
c01029da:	6a 46                	push   $0x46
  jmp __alltraps
c01029dc:	e9 01 08 00 00       	jmp    c01031e2 <__alltraps>

c01029e1 <vector71>:
.globl vector71
vector71:
  pushl $0
c01029e1:	6a 00                	push   $0x0
  pushl $71
c01029e3:	6a 47                	push   $0x47
  jmp __alltraps
c01029e5:	e9 f8 07 00 00       	jmp    c01031e2 <__alltraps>

c01029ea <vector72>:
.globl vector72
vector72:
  pushl $0
c01029ea:	6a 00                	push   $0x0
  pushl $72
c01029ec:	6a 48                	push   $0x48
  jmp __alltraps
c01029ee:	e9 ef 07 00 00       	jmp    c01031e2 <__alltraps>

c01029f3 <vector73>:
.globl vector73
vector73:
  pushl $0
c01029f3:	6a 00                	push   $0x0
  pushl $73
c01029f5:	6a 49                	push   $0x49
  jmp __alltraps
c01029f7:	e9 e6 07 00 00       	jmp    c01031e2 <__alltraps>

c01029fc <vector74>:
.globl vector74
vector74:
  pushl $0
c01029fc:	6a 00                	push   $0x0
  pushl $74
c01029fe:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102a00:	e9 dd 07 00 00       	jmp    c01031e2 <__alltraps>

c0102a05 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102a05:	6a 00                	push   $0x0
  pushl $75
c0102a07:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102a09:	e9 d4 07 00 00       	jmp    c01031e2 <__alltraps>

c0102a0e <vector76>:
.globl vector76
vector76:
  pushl $0
c0102a0e:	6a 00                	push   $0x0
  pushl $76
c0102a10:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102a12:	e9 cb 07 00 00       	jmp    c01031e2 <__alltraps>

c0102a17 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102a17:	6a 00                	push   $0x0
  pushl $77
c0102a19:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102a1b:	e9 c2 07 00 00       	jmp    c01031e2 <__alltraps>

c0102a20 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102a20:	6a 00                	push   $0x0
  pushl $78
c0102a22:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102a24:	e9 b9 07 00 00       	jmp    c01031e2 <__alltraps>

c0102a29 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102a29:	6a 00                	push   $0x0
  pushl $79
c0102a2b:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102a2d:	e9 b0 07 00 00       	jmp    c01031e2 <__alltraps>

c0102a32 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102a32:	6a 00                	push   $0x0
  pushl $80
c0102a34:	6a 50                	push   $0x50
  jmp __alltraps
c0102a36:	e9 a7 07 00 00       	jmp    c01031e2 <__alltraps>

c0102a3b <vector81>:
.globl vector81
vector81:
  pushl $0
c0102a3b:	6a 00                	push   $0x0
  pushl $81
c0102a3d:	6a 51                	push   $0x51
  jmp __alltraps
c0102a3f:	e9 9e 07 00 00       	jmp    c01031e2 <__alltraps>

c0102a44 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102a44:	6a 00                	push   $0x0
  pushl $82
c0102a46:	6a 52                	push   $0x52
  jmp __alltraps
c0102a48:	e9 95 07 00 00       	jmp    c01031e2 <__alltraps>

c0102a4d <vector83>:
.globl vector83
vector83:
  pushl $0
c0102a4d:	6a 00                	push   $0x0
  pushl $83
c0102a4f:	6a 53                	push   $0x53
  jmp __alltraps
c0102a51:	e9 8c 07 00 00       	jmp    c01031e2 <__alltraps>

c0102a56 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102a56:	6a 00                	push   $0x0
  pushl $84
c0102a58:	6a 54                	push   $0x54
  jmp __alltraps
c0102a5a:	e9 83 07 00 00       	jmp    c01031e2 <__alltraps>

c0102a5f <vector85>:
.globl vector85
vector85:
  pushl $0
c0102a5f:	6a 00                	push   $0x0
  pushl $85
c0102a61:	6a 55                	push   $0x55
  jmp __alltraps
c0102a63:	e9 7a 07 00 00       	jmp    c01031e2 <__alltraps>

c0102a68 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102a68:	6a 00                	push   $0x0
  pushl $86
c0102a6a:	6a 56                	push   $0x56
  jmp __alltraps
c0102a6c:	e9 71 07 00 00       	jmp    c01031e2 <__alltraps>

c0102a71 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102a71:	6a 00                	push   $0x0
  pushl $87
c0102a73:	6a 57                	push   $0x57
  jmp __alltraps
c0102a75:	e9 68 07 00 00       	jmp    c01031e2 <__alltraps>

c0102a7a <vector88>:
.globl vector88
vector88:
  pushl $0
c0102a7a:	6a 00                	push   $0x0
  pushl $88
c0102a7c:	6a 58                	push   $0x58
  jmp __alltraps
c0102a7e:	e9 5f 07 00 00       	jmp    c01031e2 <__alltraps>

c0102a83 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102a83:	6a 00                	push   $0x0
  pushl $89
c0102a85:	6a 59                	push   $0x59
  jmp __alltraps
c0102a87:	e9 56 07 00 00       	jmp    c01031e2 <__alltraps>

c0102a8c <vector90>:
.globl vector90
vector90:
  pushl $0
c0102a8c:	6a 00                	push   $0x0
  pushl $90
c0102a8e:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102a90:	e9 4d 07 00 00       	jmp    c01031e2 <__alltraps>

c0102a95 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102a95:	6a 00                	push   $0x0
  pushl $91
c0102a97:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102a99:	e9 44 07 00 00       	jmp    c01031e2 <__alltraps>

c0102a9e <vector92>:
.globl vector92
vector92:
  pushl $0
c0102a9e:	6a 00                	push   $0x0
  pushl $92
c0102aa0:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102aa2:	e9 3b 07 00 00       	jmp    c01031e2 <__alltraps>

c0102aa7 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102aa7:	6a 00                	push   $0x0
  pushl $93
c0102aa9:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102aab:	e9 32 07 00 00       	jmp    c01031e2 <__alltraps>

c0102ab0 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102ab0:	6a 00                	push   $0x0
  pushl $94
c0102ab2:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102ab4:	e9 29 07 00 00       	jmp    c01031e2 <__alltraps>

c0102ab9 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102ab9:	6a 00                	push   $0x0
  pushl $95
c0102abb:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102abd:	e9 20 07 00 00       	jmp    c01031e2 <__alltraps>

c0102ac2 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102ac2:	6a 00                	push   $0x0
  pushl $96
c0102ac4:	6a 60                	push   $0x60
  jmp __alltraps
c0102ac6:	e9 17 07 00 00       	jmp    c01031e2 <__alltraps>

c0102acb <vector97>:
.globl vector97
vector97:
  pushl $0
c0102acb:	6a 00                	push   $0x0
  pushl $97
c0102acd:	6a 61                	push   $0x61
  jmp __alltraps
c0102acf:	e9 0e 07 00 00       	jmp    c01031e2 <__alltraps>

c0102ad4 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102ad4:	6a 00                	push   $0x0
  pushl $98
c0102ad6:	6a 62                	push   $0x62
  jmp __alltraps
c0102ad8:	e9 05 07 00 00       	jmp    c01031e2 <__alltraps>

c0102add <vector99>:
.globl vector99
vector99:
  pushl $0
c0102add:	6a 00                	push   $0x0
  pushl $99
c0102adf:	6a 63                	push   $0x63
  jmp __alltraps
c0102ae1:	e9 fc 06 00 00       	jmp    c01031e2 <__alltraps>

c0102ae6 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102ae6:	6a 00                	push   $0x0
  pushl $100
c0102ae8:	6a 64                	push   $0x64
  jmp __alltraps
c0102aea:	e9 f3 06 00 00       	jmp    c01031e2 <__alltraps>

c0102aef <vector101>:
.globl vector101
vector101:
  pushl $0
c0102aef:	6a 00                	push   $0x0
  pushl $101
c0102af1:	6a 65                	push   $0x65
  jmp __alltraps
c0102af3:	e9 ea 06 00 00       	jmp    c01031e2 <__alltraps>

c0102af8 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102af8:	6a 00                	push   $0x0
  pushl $102
c0102afa:	6a 66                	push   $0x66
  jmp __alltraps
c0102afc:	e9 e1 06 00 00       	jmp    c01031e2 <__alltraps>

c0102b01 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102b01:	6a 00                	push   $0x0
  pushl $103
c0102b03:	6a 67                	push   $0x67
  jmp __alltraps
c0102b05:	e9 d8 06 00 00       	jmp    c01031e2 <__alltraps>

c0102b0a <vector104>:
.globl vector104
vector104:
  pushl $0
c0102b0a:	6a 00                	push   $0x0
  pushl $104
c0102b0c:	6a 68                	push   $0x68
  jmp __alltraps
c0102b0e:	e9 cf 06 00 00       	jmp    c01031e2 <__alltraps>

c0102b13 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102b13:	6a 00                	push   $0x0
  pushl $105
c0102b15:	6a 69                	push   $0x69
  jmp __alltraps
c0102b17:	e9 c6 06 00 00       	jmp    c01031e2 <__alltraps>

c0102b1c <vector106>:
.globl vector106
vector106:
  pushl $0
c0102b1c:	6a 00                	push   $0x0
  pushl $106
c0102b1e:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102b20:	e9 bd 06 00 00       	jmp    c01031e2 <__alltraps>

c0102b25 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102b25:	6a 00                	push   $0x0
  pushl $107
c0102b27:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102b29:	e9 b4 06 00 00       	jmp    c01031e2 <__alltraps>

c0102b2e <vector108>:
.globl vector108
vector108:
  pushl $0
c0102b2e:	6a 00                	push   $0x0
  pushl $108
c0102b30:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102b32:	e9 ab 06 00 00       	jmp    c01031e2 <__alltraps>

c0102b37 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102b37:	6a 00                	push   $0x0
  pushl $109
c0102b39:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102b3b:	e9 a2 06 00 00       	jmp    c01031e2 <__alltraps>

c0102b40 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102b40:	6a 00                	push   $0x0
  pushl $110
c0102b42:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102b44:	e9 99 06 00 00       	jmp    c01031e2 <__alltraps>

c0102b49 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102b49:	6a 00                	push   $0x0
  pushl $111
c0102b4b:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102b4d:	e9 90 06 00 00       	jmp    c01031e2 <__alltraps>

c0102b52 <vector112>:
.globl vector112
vector112:
  pushl $0
c0102b52:	6a 00                	push   $0x0
  pushl $112
c0102b54:	6a 70                	push   $0x70
  jmp __alltraps
c0102b56:	e9 87 06 00 00       	jmp    c01031e2 <__alltraps>

c0102b5b <vector113>:
.globl vector113
vector113:
  pushl $0
c0102b5b:	6a 00                	push   $0x0
  pushl $113
c0102b5d:	6a 71                	push   $0x71
  jmp __alltraps
c0102b5f:	e9 7e 06 00 00       	jmp    c01031e2 <__alltraps>

c0102b64 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102b64:	6a 00                	push   $0x0
  pushl $114
c0102b66:	6a 72                	push   $0x72
  jmp __alltraps
c0102b68:	e9 75 06 00 00       	jmp    c01031e2 <__alltraps>

c0102b6d <vector115>:
.globl vector115
vector115:
  pushl $0
c0102b6d:	6a 00                	push   $0x0
  pushl $115
c0102b6f:	6a 73                	push   $0x73
  jmp __alltraps
c0102b71:	e9 6c 06 00 00       	jmp    c01031e2 <__alltraps>

c0102b76 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102b76:	6a 00                	push   $0x0
  pushl $116
c0102b78:	6a 74                	push   $0x74
  jmp __alltraps
c0102b7a:	e9 63 06 00 00       	jmp    c01031e2 <__alltraps>

c0102b7f <vector117>:
.globl vector117
vector117:
  pushl $0
c0102b7f:	6a 00                	push   $0x0
  pushl $117
c0102b81:	6a 75                	push   $0x75
  jmp __alltraps
c0102b83:	e9 5a 06 00 00       	jmp    c01031e2 <__alltraps>

c0102b88 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102b88:	6a 00                	push   $0x0
  pushl $118
c0102b8a:	6a 76                	push   $0x76
  jmp __alltraps
c0102b8c:	e9 51 06 00 00       	jmp    c01031e2 <__alltraps>

c0102b91 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102b91:	6a 00                	push   $0x0
  pushl $119
c0102b93:	6a 77                	push   $0x77
  jmp __alltraps
c0102b95:	e9 48 06 00 00       	jmp    c01031e2 <__alltraps>

c0102b9a <vector120>:
.globl vector120
vector120:
  pushl $0
c0102b9a:	6a 00                	push   $0x0
  pushl $120
c0102b9c:	6a 78                	push   $0x78
  jmp __alltraps
c0102b9e:	e9 3f 06 00 00       	jmp    c01031e2 <__alltraps>

c0102ba3 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102ba3:	6a 00                	push   $0x0
  pushl $121
c0102ba5:	6a 79                	push   $0x79
  jmp __alltraps
c0102ba7:	e9 36 06 00 00       	jmp    c01031e2 <__alltraps>

c0102bac <vector122>:
.globl vector122
vector122:
  pushl $0
c0102bac:	6a 00                	push   $0x0
  pushl $122
c0102bae:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102bb0:	e9 2d 06 00 00       	jmp    c01031e2 <__alltraps>

c0102bb5 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102bb5:	6a 00                	push   $0x0
  pushl $123
c0102bb7:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102bb9:	e9 24 06 00 00       	jmp    c01031e2 <__alltraps>

c0102bbe <vector124>:
.globl vector124
vector124:
  pushl $0
c0102bbe:	6a 00                	push   $0x0
  pushl $124
c0102bc0:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102bc2:	e9 1b 06 00 00       	jmp    c01031e2 <__alltraps>

c0102bc7 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102bc7:	6a 00                	push   $0x0
  pushl $125
c0102bc9:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102bcb:	e9 12 06 00 00       	jmp    c01031e2 <__alltraps>

c0102bd0 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102bd0:	6a 00                	push   $0x0
  pushl $126
c0102bd2:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102bd4:	e9 09 06 00 00       	jmp    c01031e2 <__alltraps>

c0102bd9 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102bd9:	6a 00                	push   $0x0
  pushl $127
c0102bdb:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102bdd:	e9 00 06 00 00       	jmp    c01031e2 <__alltraps>

c0102be2 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102be2:	6a 00                	push   $0x0
  pushl $128
c0102be4:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102be9:	e9 f4 05 00 00       	jmp    c01031e2 <__alltraps>

c0102bee <vector129>:
.globl vector129
vector129:
  pushl $0
c0102bee:	6a 00                	push   $0x0
  pushl $129
c0102bf0:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102bf5:	e9 e8 05 00 00       	jmp    c01031e2 <__alltraps>

c0102bfa <vector130>:
.globl vector130
vector130:
  pushl $0
c0102bfa:	6a 00                	push   $0x0
  pushl $130
c0102bfc:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102c01:	e9 dc 05 00 00       	jmp    c01031e2 <__alltraps>

c0102c06 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102c06:	6a 00                	push   $0x0
  pushl $131
c0102c08:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102c0d:	e9 d0 05 00 00       	jmp    c01031e2 <__alltraps>

c0102c12 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102c12:	6a 00                	push   $0x0
  pushl $132
c0102c14:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102c19:	e9 c4 05 00 00       	jmp    c01031e2 <__alltraps>

c0102c1e <vector133>:
.globl vector133
vector133:
  pushl $0
c0102c1e:	6a 00                	push   $0x0
  pushl $133
c0102c20:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102c25:	e9 b8 05 00 00       	jmp    c01031e2 <__alltraps>

c0102c2a <vector134>:
.globl vector134
vector134:
  pushl $0
c0102c2a:	6a 00                	push   $0x0
  pushl $134
c0102c2c:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102c31:	e9 ac 05 00 00       	jmp    c01031e2 <__alltraps>

c0102c36 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102c36:	6a 00                	push   $0x0
  pushl $135
c0102c38:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102c3d:	e9 a0 05 00 00       	jmp    c01031e2 <__alltraps>

c0102c42 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102c42:	6a 00                	push   $0x0
  pushl $136
c0102c44:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102c49:	e9 94 05 00 00       	jmp    c01031e2 <__alltraps>

c0102c4e <vector137>:
.globl vector137
vector137:
  pushl $0
c0102c4e:	6a 00                	push   $0x0
  pushl $137
c0102c50:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102c55:	e9 88 05 00 00       	jmp    c01031e2 <__alltraps>

c0102c5a <vector138>:
.globl vector138
vector138:
  pushl $0
c0102c5a:	6a 00                	push   $0x0
  pushl $138
c0102c5c:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102c61:	e9 7c 05 00 00       	jmp    c01031e2 <__alltraps>

c0102c66 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102c66:	6a 00                	push   $0x0
  pushl $139
c0102c68:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102c6d:	e9 70 05 00 00       	jmp    c01031e2 <__alltraps>

c0102c72 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102c72:	6a 00                	push   $0x0
  pushl $140
c0102c74:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102c79:	e9 64 05 00 00       	jmp    c01031e2 <__alltraps>

c0102c7e <vector141>:
.globl vector141
vector141:
  pushl $0
c0102c7e:	6a 00                	push   $0x0
  pushl $141
c0102c80:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102c85:	e9 58 05 00 00       	jmp    c01031e2 <__alltraps>

c0102c8a <vector142>:
.globl vector142
vector142:
  pushl $0
c0102c8a:	6a 00                	push   $0x0
  pushl $142
c0102c8c:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102c91:	e9 4c 05 00 00       	jmp    c01031e2 <__alltraps>

c0102c96 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102c96:	6a 00                	push   $0x0
  pushl $143
c0102c98:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102c9d:	e9 40 05 00 00       	jmp    c01031e2 <__alltraps>

c0102ca2 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102ca2:	6a 00                	push   $0x0
  pushl $144
c0102ca4:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102ca9:	e9 34 05 00 00       	jmp    c01031e2 <__alltraps>

c0102cae <vector145>:
.globl vector145
vector145:
  pushl $0
c0102cae:	6a 00                	push   $0x0
  pushl $145
c0102cb0:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102cb5:	e9 28 05 00 00       	jmp    c01031e2 <__alltraps>

c0102cba <vector146>:
.globl vector146
vector146:
  pushl $0
c0102cba:	6a 00                	push   $0x0
  pushl $146
c0102cbc:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102cc1:	e9 1c 05 00 00       	jmp    c01031e2 <__alltraps>

c0102cc6 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102cc6:	6a 00                	push   $0x0
  pushl $147
c0102cc8:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102ccd:	e9 10 05 00 00       	jmp    c01031e2 <__alltraps>

c0102cd2 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102cd2:	6a 00                	push   $0x0
  pushl $148
c0102cd4:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102cd9:	e9 04 05 00 00       	jmp    c01031e2 <__alltraps>

c0102cde <vector149>:
.globl vector149
vector149:
  pushl $0
c0102cde:	6a 00                	push   $0x0
  pushl $149
c0102ce0:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102ce5:	e9 f8 04 00 00       	jmp    c01031e2 <__alltraps>

c0102cea <vector150>:
.globl vector150
vector150:
  pushl $0
c0102cea:	6a 00                	push   $0x0
  pushl $150
c0102cec:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102cf1:	e9 ec 04 00 00       	jmp    c01031e2 <__alltraps>

c0102cf6 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102cf6:	6a 00                	push   $0x0
  pushl $151
c0102cf8:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102cfd:	e9 e0 04 00 00       	jmp    c01031e2 <__alltraps>

c0102d02 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102d02:	6a 00                	push   $0x0
  pushl $152
c0102d04:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102d09:	e9 d4 04 00 00       	jmp    c01031e2 <__alltraps>

c0102d0e <vector153>:
.globl vector153
vector153:
  pushl $0
c0102d0e:	6a 00                	push   $0x0
  pushl $153
c0102d10:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102d15:	e9 c8 04 00 00       	jmp    c01031e2 <__alltraps>

c0102d1a <vector154>:
.globl vector154
vector154:
  pushl $0
c0102d1a:	6a 00                	push   $0x0
  pushl $154
c0102d1c:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102d21:	e9 bc 04 00 00       	jmp    c01031e2 <__alltraps>

c0102d26 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102d26:	6a 00                	push   $0x0
  pushl $155
c0102d28:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102d2d:	e9 b0 04 00 00       	jmp    c01031e2 <__alltraps>

c0102d32 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102d32:	6a 00                	push   $0x0
  pushl $156
c0102d34:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102d39:	e9 a4 04 00 00       	jmp    c01031e2 <__alltraps>

c0102d3e <vector157>:
.globl vector157
vector157:
  pushl $0
c0102d3e:	6a 00                	push   $0x0
  pushl $157
c0102d40:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102d45:	e9 98 04 00 00       	jmp    c01031e2 <__alltraps>

c0102d4a <vector158>:
.globl vector158
vector158:
  pushl $0
c0102d4a:	6a 00                	push   $0x0
  pushl $158
c0102d4c:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102d51:	e9 8c 04 00 00       	jmp    c01031e2 <__alltraps>

c0102d56 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102d56:	6a 00                	push   $0x0
  pushl $159
c0102d58:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102d5d:	e9 80 04 00 00       	jmp    c01031e2 <__alltraps>

c0102d62 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102d62:	6a 00                	push   $0x0
  pushl $160
c0102d64:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102d69:	e9 74 04 00 00       	jmp    c01031e2 <__alltraps>

c0102d6e <vector161>:
.globl vector161
vector161:
  pushl $0
c0102d6e:	6a 00                	push   $0x0
  pushl $161
c0102d70:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102d75:	e9 68 04 00 00       	jmp    c01031e2 <__alltraps>

c0102d7a <vector162>:
.globl vector162
vector162:
  pushl $0
c0102d7a:	6a 00                	push   $0x0
  pushl $162
c0102d7c:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102d81:	e9 5c 04 00 00       	jmp    c01031e2 <__alltraps>

c0102d86 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102d86:	6a 00                	push   $0x0
  pushl $163
c0102d88:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102d8d:	e9 50 04 00 00       	jmp    c01031e2 <__alltraps>

c0102d92 <vector164>:
.globl vector164
vector164:
  pushl $0
c0102d92:	6a 00                	push   $0x0
  pushl $164
c0102d94:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102d99:	e9 44 04 00 00       	jmp    c01031e2 <__alltraps>

c0102d9e <vector165>:
.globl vector165
vector165:
  pushl $0
c0102d9e:	6a 00                	push   $0x0
  pushl $165
c0102da0:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102da5:	e9 38 04 00 00       	jmp    c01031e2 <__alltraps>

c0102daa <vector166>:
.globl vector166
vector166:
  pushl $0
c0102daa:	6a 00                	push   $0x0
  pushl $166
c0102dac:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102db1:	e9 2c 04 00 00       	jmp    c01031e2 <__alltraps>

c0102db6 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102db6:	6a 00                	push   $0x0
  pushl $167
c0102db8:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102dbd:	e9 20 04 00 00       	jmp    c01031e2 <__alltraps>

c0102dc2 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102dc2:	6a 00                	push   $0x0
  pushl $168
c0102dc4:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102dc9:	e9 14 04 00 00       	jmp    c01031e2 <__alltraps>

c0102dce <vector169>:
.globl vector169
vector169:
  pushl $0
c0102dce:	6a 00                	push   $0x0
  pushl $169
c0102dd0:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102dd5:	e9 08 04 00 00       	jmp    c01031e2 <__alltraps>

c0102dda <vector170>:
.globl vector170
vector170:
  pushl $0
c0102dda:	6a 00                	push   $0x0
  pushl $170
c0102ddc:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102de1:	e9 fc 03 00 00       	jmp    c01031e2 <__alltraps>

c0102de6 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102de6:	6a 00                	push   $0x0
  pushl $171
c0102de8:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102ded:	e9 f0 03 00 00       	jmp    c01031e2 <__alltraps>

c0102df2 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102df2:	6a 00                	push   $0x0
  pushl $172
c0102df4:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102df9:	e9 e4 03 00 00       	jmp    c01031e2 <__alltraps>

c0102dfe <vector173>:
.globl vector173
vector173:
  pushl $0
c0102dfe:	6a 00                	push   $0x0
  pushl $173
c0102e00:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102e05:	e9 d8 03 00 00       	jmp    c01031e2 <__alltraps>

c0102e0a <vector174>:
.globl vector174
vector174:
  pushl $0
c0102e0a:	6a 00                	push   $0x0
  pushl $174
c0102e0c:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102e11:	e9 cc 03 00 00       	jmp    c01031e2 <__alltraps>

c0102e16 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102e16:	6a 00                	push   $0x0
  pushl $175
c0102e18:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102e1d:	e9 c0 03 00 00       	jmp    c01031e2 <__alltraps>

c0102e22 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102e22:	6a 00                	push   $0x0
  pushl $176
c0102e24:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102e29:	e9 b4 03 00 00       	jmp    c01031e2 <__alltraps>

c0102e2e <vector177>:
.globl vector177
vector177:
  pushl $0
c0102e2e:	6a 00                	push   $0x0
  pushl $177
c0102e30:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102e35:	e9 a8 03 00 00       	jmp    c01031e2 <__alltraps>

c0102e3a <vector178>:
.globl vector178
vector178:
  pushl $0
c0102e3a:	6a 00                	push   $0x0
  pushl $178
c0102e3c:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102e41:	e9 9c 03 00 00       	jmp    c01031e2 <__alltraps>

c0102e46 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102e46:	6a 00                	push   $0x0
  pushl $179
c0102e48:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102e4d:	e9 90 03 00 00       	jmp    c01031e2 <__alltraps>

c0102e52 <vector180>:
.globl vector180
vector180:
  pushl $0
c0102e52:	6a 00                	push   $0x0
  pushl $180
c0102e54:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102e59:	e9 84 03 00 00       	jmp    c01031e2 <__alltraps>

c0102e5e <vector181>:
.globl vector181
vector181:
  pushl $0
c0102e5e:	6a 00                	push   $0x0
  pushl $181
c0102e60:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102e65:	e9 78 03 00 00       	jmp    c01031e2 <__alltraps>

c0102e6a <vector182>:
.globl vector182
vector182:
  pushl $0
c0102e6a:	6a 00                	push   $0x0
  pushl $182
c0102e6c:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102e71:	e9 6c 03 00 00       	jmp    c01031e2 <__alltraps>

c0102e76 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102e76:	6a 00                	push   $0x0
  pushl $183
c0102e78:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102e7d:	e9 60 03 00 00       	jmp    c01031e2 <__alltraps>

c0102e82 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102e82:	6a 00                	push   $0x0
  pushl $184
c0102e84:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102e89:	e9 54 03 00 00       	jmp    c01031e2 <__alltraps>

c0102e8e <vector185>:
.globl vector185
vector185:
  pushl $0
c0102e8e:	6a 00                	push   $0x0
  pushl $185
c0102e90:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102e95:	e9 48 03 00 00       	jmp    c01031e2 <__alltraps>

c0102e9a <vector186>:
.globl vector186
vector186:
  pushl $0
c0102e9a:	6a 00                	push   $0x0
  pushl $186
c0102e9c:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102ea1:	e9 3c 03 00 00       	jmp    c01031e2 <__alltraps>

c0102ea6 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102ea6:	6a 00                	push   $0x0
  pushl $187
c0102ea8:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102ead:	e9 30 03 00 00       	jmp    c01031e2 <__alltraps>

c0102eb2 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102eb2:	6a 00                	push   $0x0
  pushl $188
c0102eb4:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102eb9:	e9 24 03 00 00       	jmp    c01031e2 <__alltraps>

c0102ebe <vector189>:
.globl vector189
vector189:
  pushl $0
c0102ebe:	6a 00                	push   $0x0
  pushl $189
c0102ec0:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102ec5:	e9 18 03 00 00       	jmp    c01031e2 <__alltraps>

c0102eca <vector190>:
.globl vector190
vector190:
  pushl $0
c0102eca:	6a 00                	push   $0x0
  pushl $190
c0102ecc:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102ed1:	e9 0c 03 00 00       	jmp    c01031e2 <__alltraps>

c0102ed6 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102ed6:	6a 00                	push   $0x0
  pushl $191
c0102ed8:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102edd:	e9 00 03 00 00       	jmp    c01031e2 <__alltraps>

c0102ee2 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102ee2:	6a 00                	push   $0x0
  pushl $192
c0102ee4:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102ee9:	e9 f4 02 00 00       	jmp    c01031e2 <__alltraps>

c0102eee <vector193>:
.globl vector193
vector193:
  pushl $0
c0102eee:	6a 00                	push   $0x0
  pushl $193
c0102ef0:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102ef5:	e9 e8 02 00 00       	jmp    c01031e2 <__alltraps>

c0102efa <vector194>:
.globl vector194
vector194:
  pushl $0
c0102efa:	6a 00                	push   $0x0
  pushl $194
c0102efc:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102f01:	e9 dc 02 00 00       	jmp    c01031e2 <__alltraps>

c0102f06 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102f06:	6a 00                	push   $0x0
  pushl $195
c0102f08:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102f0d:	e9 d0 02 00 00       	jmp    c01031e2 <__alltraps>

c0102f12 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102f12:	6a 00                	push   $0x0
  pushl $196
c0102f14:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102f19:	e9 c4 02 00 00       	jmp    c01031e2 <__alltraps>

c0102f1e <vector197>:
.globl vector197
vector197:
  pushl $0
c0102f1e:	6a 00                	push   $0x0
  pushl $197
c0102f20:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102f25:	e9 b8 02 00 00       	jmp    c01031e2 <__alltraps>

c0102f2a <vector198>:
.globl vector198
vector198:
  pushl $0
c0102f2a:	6a 00                	push   $0x0
  pushl $198
c0102f2c:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102f31:	e9 ac 02 00 00       	jmp    c01031e2 <__alltraps>

c0102f36 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102f36:	6a 00                	push   $0x0
  pushl $199
c0102f38:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102f3d:	e9 a0 02 00 00       	jmp    c01031e2 <__alltraps>

c0102f42 <vector200>:
.globl vector200
vector200:
  pushl $0
c0102f42:	6a 00                	push   $0x0
  pushl $200
c0102f44:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102f49:	e9 94 02 00 00       	jmp    c01031e2 <__alltraps>

c0102f4e <vector201>:
.globl vector201
vector201:
  pushl $0
c0102f4e:	6a 00                	push   $0x0
  pushl $201
c0102f50:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102f55:	e9 88 02 00 00       	jmp    c01031e2 <__alltraps>

c0102f5a <vector202>:
.globl vector202
vector202:
  pushl $0
c0102f5a:	6a 00                	push   $0x0
  pushl $202
c0102f5c:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102f61:	e9 7c 02 00 00       	jmp    c01031e2 <__alltraps>

c0102f66 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102f66:	6a 00                	push   $0x0
  pushl $203
c0102f68:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102f6d:	e9 70 02 00 00       	jmp    c01031e2 <__alltraps>

c0102f72 <vector204>:
.globl vector204
vector204:
  pushl $0
c0102f72:	6a 00                	push   $0x0
  pushl $204
c0102f74:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102f79:	e9 64 02 00 00       	jmp    c01031e2 <__alltraps>

c0102f7e <vector205>:
.globl vector205
vector205:
  pushl $0
c0102f7e:	6a 00                	push   $0x0
  pushl $205
c0102f80:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102f85:	e9 58 02 00 00       	jmp    c01031e2 <__alltraps>

c0102f8a <vector206>:
.globl vector206
vector206:
  pushl $0
c0102f8a:	6a 00                	push   $0x0
  pushl $206
c0102f8c:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0102f91:	e9 4c 02 00 00       	jmp    c01031e2 <__alltraps>

c0102f96 <vector207>:
.globl vector207
vector207:
  pushl $0
c0102f96:	6a 00                	push   $0x0
  pushl $207
c0102f98:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102f9d:	e9 40 02 00 00       	jmp    c01031e2 <__alltraps>

c0102fa2 <vector208>:
.globl vector208
vector208:
  pushl $0
c0102fa2:	6a 00                	push   $0x0
  pushl $208
c0102fa4:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0102fa9:	e9 34 02 00 00       	jmp    c01031e2 <__alltraps>

c0102fae <vector209>:
.globl vector209
vector209:
  pushl $0
c0102fae:	6a 00                	push   $0x0
  pushl $209
c0102fb0:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102fb5:	e9 28 02 00 00       	jmp    c01031e2 <__alltraps>

c0102fba <vector210>:
.globl vector210
vector210:
  pushl $0
c0102fba:	6a 00                	push   $0x0
  pushl $210
c0102fbc:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102fc1:	e9 1c 02 00 00       	jmp    c01031e2 <__alltraps>

c0102fc6 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102fc6:	6a 00                	push   $0x0
  pushl $211
c0102fc8:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0102fcd:	e9 10 02 00 00       	jmp    c01031e2 <__alltraps>

c0102fd2 <vector212>:
.globl vector212
vector212:
  pushl $0
c0102fd2:	6a 00                	push   $0x0
  pushl $212
c0102fd4:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0102fd9:	e9 04 02 00 00       	jmp    c01031e2 <__alltraps>

c0102fde <vector213>:
.globl vector213
vector213:
  pushl $0
c0102fde:	6a 00                	push   $0x0
  pushl $213
c0102fe0:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102fe5:	e9 f8 01 00 00       	jmp    c01031e2 <__alltraps>

c0102fea <vector214>:
.globl vector214
vector214:
  pushl $0
c0102fea:	6a 00                	push   $0x0
  pushl $214
c0102fec:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102ff1:	e9 ec 01 00 00       	jmp    c01031e2 <__alltraps>

c0102ff6 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102ff6:	6a 00                	push   $0x0
  pushl $215
c0102ff8:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0102ffd:	e9 e0 01 00 00       	jmp    c01031e2 <__alltraps>

c0103002 <vector216>:
.globl vector216
vector216:
  pushl $0
c0103002:	6a 00                	push   $0x0
  pushl $216
c0103004:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0103009:	e9 d4 01 00 00       	jmp    c01031e2 <__alltraps>

c010300e <vector217>:
.globl vector217
vector217:
  pushl $0
c010300e:	6a 00                	push   $0x0
  pushl $217
c0103010:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0103015:	e9 c8 01 00 00       	jmp    c01031e2 <__alltraps>

c010301a <vector218>:
.globl vector218
vector218:
  pushl $0
c010301a:	6a 00                	push   $0x0
  pushl $218
c010301c:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0103021:	e9 bc 01 00 00       	jmp    c01031e2 <__alltraps>

c0103026 <vector219>:
.globl vector219
vector219:
  pushl $0
c0103026:	6a 00                	push   $0x0
  pushl $219
c0103028:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c010302d:	e9 b0 01 00 00       	jmp    c01031e2 <__alltraps>

c0103032 <vector220>:
.globl vector220
vector220:
  pushl $0
c0103032:	6a 00                	push   $0x0
  pushl $220
c0103034:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0103039:	e9 a4 01 00 00       	jmp    c01031e2 <__alltraps>

c010303e <vector221>:
.globl vector221
vector221:
  pushl $0
c010303e:	6a 00                	push   $0x0
  pushl $221
c0103040:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0103045:	e9 98 01 00 00       	jmp    c01031e2 <__alltraps>

c010304a <vector222>:
.globl vector222
vector222:
  pushl $0
c010304a:	6a 00                	push   $0x0
  pushl $222
c010304c:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0103051:	e9 8c 01 00 00       	jmp    c01031e2 <__alltraps>

c0103056 <vector223>:
.globl vector223
vector223:
  pushl $0
c0103056:	6a 00                	push   $0x0
  pushl $223
c0103058:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c010305d:	e9 80 01 00 00       	jmp    c01031e2 <__alltraps>

c0103062 <vector224>:
.globl vector224
vector224:
  pushl $0
c0103062:	6a 00                	push   $0x0
  pushl $224
c0103064:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0103069:	e9 74 01 00 00       	jmp    c01031e2 <__alltraps>

c010306e <vector225>:
.globl vector225
vector225:
  pushl $0
c010306e:	6a 00                	push   $0x0
  pushl $225
c0103070:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0103075:	e9 68 01 00 00       	jmp    c01031e2 <__alltraps>

c010307a <vector226>:
.globl vector226
vector226:
  pushl $0
c010307a:	6a 00                	push   $0x0
  pushl $226
c010307c:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0103081:	e9 5c 01 00 00       	jmp    c01031e2 <__alltraps>

c0103086 <vector227>:
.globl vector227
vector227:
  pushl $0
c0103086:	6a 00                	push   $0x0
  pushl $227
c0103088:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c010308d:	e9 50 01 00 00       	jmp    c01031e2 <__alltraps>

c0103092 <vector228>:
.globl vector228
vector228:
  pushl $0
c0103092:	6a 00                	push   $0x0
  pushl $228
c0103094:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0103099:	e9 44 01 00 00       	jmp    c01031e2 <__alltraps>

c010309e <vector229>:
.globl vector229
vector229:
  pushl $0
c010309e:	6a 00                	push   $0x0
  pushl $229
c01030a0:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01030a5:	e9 38 01 00 00       	jmp    c01031e2 <__alltraps>

c01030aa <vector230>:
.globl vector230
vector230:
  pushl $0
c01030aa:	6a 00                	push   $0x0
  pushl $230
c01030ac:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c01030b1:	e9 2c 01 00 00       	jmp    c01031e2 <__alltraps>

c01030b6 <vector231>:
.globl vector231
vector231:
  pushl $0
c01030b6:	6a 00                	push   $0x0
  pushl $231
c01030b8:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c01030bd:	e9 20 01 00 00       	jmp    c01031e2 <__alltraps>

c01030c2 <vector232>:
.globl vector232
vector232:
  pushl $0
c01030c2:	6a 00                	push   $0x0
  pushl $232
c01030c4:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c01030c9:	e9 14 01 00 00       	jmp    c01031e2 <__alltraps>

c01030ce <vector233>:
.globl vector233
vector233:
  pushl $0
c01030ce:	6a 00                	push   $0x0
  pushl $233
c01030d0:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c01030d5:	e9 08 01 00 00       	jmp    c01031e2 <__alltraps>

c01030da <vector234>:
.globl vector234
vector234:
  pushl $0
c01030da:	6a 00                	push   $0x0
  pushl $234
c01030dc:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c01030e1:	e9 fc 00 00 00       	jmp    c01031e2 <__alltraps>

c01030e6 <vector235>:
.globl vector235
vector235:
  pushl $0
c01030e6:	6a 00                	push   $0x0
  pushl $235
c01030e8:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c01030ed:	e9 f0 00 00 00       	jmp    c01031e2 <__alltraps>

c01030f2 <vector236>:
.globl vector236
vector236:
  pushl $0
c01030f2:	6a 00                	push   $0x0
  pushl $236
c01030f4:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c01030f9:	e9 e4 00 00 00       	jmp    c01031e2 <__alltraps>

c01030fe <vector237>:
.globl vector237
vector237:
  pushl $0
c01030fe:	6a 00                	push   $0x0
  pushl $237
c0103100:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0103105:	e9 d8 00 00 00       	jmp    c01031e2 <__alltraps>

c010310a <vector238>:
.globl vector238
vector238:
  pushl $0
c010310a:	6a 00                	push   $0x0
  pushl $238
c010310c:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0103111:	e9 cc 00 00 00       	jmp    c01031e2 <__alltraps>

c0103116 <vector239>:
.globl vector239
vector239:
  pushl $0
c0103116:	6a 00                	push   $0x0
  pushl $239
c0103118:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c010311d:	e9 c0 00 00 00       	jmp    c01031e2 <__alltraps>

c0103122 <vector240>:
.globl vector240
vector240:
  pushl $0
c0103122:	6a 00                	push   $0x0
  pushl $240
c0103124:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0103129:	e9 b4 00 00 00       	jmp    c01031e2 <__alltraps>

c010312e <vector241>:
.globl vector241
vector241:
  pushl $0
c010312e:	6a 00                	push   $0x0
  pushl $241
c0103130:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0103135:	e9 a8 00 00 00       	jmp    c01031e2 <__alltraps>

c010313a <vector242>:
.globl vector242
vector242:
  pushl $0
c010313a:	6a 00                	push   $0x0
  pushl $242
c010313c:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0103141:	e9 9c 00 00 00       	jmp    c01031e2 <__alltraps>

c0103146 <vector243>:
.globl vector243
vector243:
  pushl $0
c0103146:	6a 00                	push   $0x0
  pushl $243
c0103148:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c010314d:	e9 90 00 00 00       	jmp    c01031e2 <__alltraps>

c0103152 <vector244>:
.globl vector244
vector244:
  pushl $0
c0103152:	6a 00                	push   $0x0
  pushl $244
c0103154:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0103159:	e9 84 00 00 00       	jmp    c01031e2 <__alltraps>

c010315e <vector245>:
.globl vector245
vector245:
  pushl $0
c010315e:	6a 00                	push   $0x0
  pushl $245
c0103160:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0103165:	e9 78 00 00 00       	jmp    c01031e2 <__alltraps>

c010316a <vector246>:
.globl vector246
vector246:
  pushl $0
c010316a:	6a 00                	push   $0x0
  pushl $246
c010316c:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0103171:	e9 6c 00 00 00       	jmp    c01031e2 <__alltraps>

c0103176 <vector247>:
.globl vector247
vector247:
  pushl $0
c0103176:	6a 00                	push   $0x0
  pushl $247
c0103178:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c010317d:	e9 60 00 00 00       	jmp    c01031e2 <__alltraps>

c0103182 <vector248>:
.globl vector248
vector248:
  pushl $0
c0103182:	6a 00                	push   $0x0
  pushl $248
c0103184:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0103189:	e9 54 00 00 00       	jmp    c01031e2 <__alltraps>

c010318e <vector249>:
.globl vector249
vector249:
  pushl $0
c010318e:	6a 00                	push   $0x0
  pushl $249
c0103190:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0103195:	e9 48 00 00 00       	jmp    c01031e2 <__alltraps>

c010319a <vector250>:
.globl vector250
vector250:
  pushl $0
c010319a:	6a 00                	push   $0x0
  pushl $250
c010319c:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c01031a1:	e9 3c 00 00 00       	jmp    c01031e2 <__alltraps>

c01031a6 <vector251>:
.globl vector251
vector251:
  pushl $0
c01031a6:	6a 00                	push   $0x0
  pushl $251
c01031a8:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01031ad:	e9 30 00 00 00       	jmp    c01031e2 <__alltraps>

c01031b2 <vector252>:
.globl vector252
vector252:
  pushl $0
c01031b2:	6a 00                	push   $0x0
  pushl $252
c01031b4:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c01031b9:	e9 24 00 00 00       	jmp    c01031e2 <__alltraps>

c01031be <vector253>:
.globl vector253
vector253:
  pushl $0
c01031be:	6a 00                	push   $0x0
  pushl $253
c01031c0:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c01031c5:	e9 18 00 00 00       	jmp    c01031e2 <__alltraps>

c01031ca <vector254>:
.globl vector254
vector254:
  pushl $0
c01031ca:	6a 00                	push   $0x0
  pushl $254
c01031cc:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c01031d1:	e9 0c 00 00 00       	jmp    c01031e2 <__alltraps>

c01031d6 <vector255>:
.globl vector255
vector255:
  pushl $0
c01031d6:	6a 00                	push   $0x0
  pushl $255
c01031d8:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c01031dd:	e9 00 00 00 00       	jmp    c01031e2 <__alltraps>

c01031e2 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c01031e2:	1e                   	push   %ds
    pushl %es
c01031e3:	06                   	push   %es
    pushl %fs
c01031e4:	0f a0                	push   %fs
    pushl %gs
c01031e6:	0f a8                	push   %gs
    pushal
c01031e8:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c01031e9:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c01031ee:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c01031f0:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c01031f2:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c01031f3:	e8 67 f5 ff ff       	call   c010275f <trap>

    # pop the pushed stack pointer
    popl %esp
c01031f8:	5c                   	pop    %esp

c01031f9 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c01031f9:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c01031fa:	0f a9                	pop    %gs
    popl %fs
c01031fc:	0f a1                	pop    %fs
    popl %es
c01031fe:	07                   	pop    %es
    popl %ds
c01031ff:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0103200:	83 c4 08             	add    $0x8,%esp
    iret
c0103203:	cf                   	iret   

c0103204 <_extended_clock_init_mm>:
//当访问页时，相应的A位和D位都会被CPU修改
//不用操作系统进行专门修改，所以只要对发生缺页时的情况进行处理即可。

static int
_extended_clock_init_mm(struct mm_struct *mm)
{     
c0103204:	55                   	push   %ebp
c0103205:	89 e5                	mov    %esp,%ebp
c0103207:	83 ec 10             	sub    $0x10,%esp
c010320a:	c7 45 fc 10 50 12 c0 	movl   $0xc0125010,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103211:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103214:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103217:	89 50 04             	mov    %edx,0x4(%eax)
c010321a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010321d:	8b 50 04             	mov    0x4(%eax),%edx
c0103220:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103223:	89 10                	mov    %edx,(%eax)
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
c0103225:	8b 45 08             	mov    0x8(%ebp),%eax
c0103228:	c7 40 14 10 50 12 c0 	movl   $0xc0125010,0x14(%eax)
     // 将头指针指向pra_list_head的起始地址
     clock_p = (list_entry_t*)&pra_list_head;
c010322f:	c7 05 18 50 12 c0 10 	movl   $0xc0125010,0xc0125018
c0103236:	50 12 c0 
     //cprintf(" mm->sm_priv %x in extended_clock_init_mm\n",mm->sm_priv);
     return 0;
c0103239:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010323e:	c9                   	leave  
c010323f:	c3                   	ret    

c0103240 <_extended_clock_map_swappable>:
/*
 * (3)_extended_clock_map_swappable: According extended_clock PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static int
_extended_clock_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0103240:	55                   	push   %ebp
c0103241:	89 e5                	mov    %esp,%ebp
c0103243:	83 ec 38             	sub    $0x38,%esp
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0103246:	8b 45 08             	mov    0x8(%ebp),%eax
c0103249:	8b 40 14             	mov    0x14(%eax),%eax
c010324c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *entry=&(page->pra_page_link);
c010324f:	8b 45 10             	mov    0x10(%ebp),%eax
c0103252:	83 c0 14             	add    $0x14,%eax
c0103255:	89 45 f0             	mov    %eax,-0x10(%ebp)
 
    assert(entry != NULL && head != NULL);
c0103258:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010325c:	74 06                	je     c0103264 <_extended_clock_map_swappable+0x24>
c010325e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103262:	75 24                	jne    c0103288 <_extended_clock_map_swappable+0x48>
c0103264:	c7 44 24 0c f0 9b 10 	movl   $0xc0109bf0,0xc(%esp)
c010326b:	c0 
c010326c:	c7 44 24 08 0e 9c 10 	movl   $0xc0109c0e,0x8(%esp)
c0103273:	c0 
c0103274:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
c010327b:	00 
c010327c:	c7 04 24 23 9c 10 c0 	movl   $0xc0109c23,(%esp)
c0103283:	e8 70 d1 ff ff       	call   c01003f8 <__panic>
    //将换进的页加入链表
    list_add_before(clock_p, entry);
c0103288:	a1 18 50 12 c0       	mov    0xc0125018,%eax
c010328d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103290:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103293:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0103296:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103299:	8b 00                	mov    (%eax),%eax
c010329b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010329e:	89 55 e0             	mov    %edx,-0x20(%ebp)
c01032a1:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01032a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01032a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01032aa:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01032ad:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01032b0:	89 10                	mov    %edx,(%eax)
c01032b2:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01032b5:	8b 10                	mov    (%eax),%edx
c01032b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01032ba:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01032bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01032c0:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01032c3:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01032c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01032c9:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01032cc:	89 10                	mov    %edx,(%eax)
    //pte_t *pte = get_pte(mm->pgdir, page2kva(page), 0);
	pte_t *pte = get_pte(mm->pgdir, addr, 0);
c01032ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01032d1:	8b 40 0c             	mov    0xc(%eax),%eax
c01032d4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01032db:	00 
c01032dc:	8b 55 0c             	mov    0xc(%ebp),%edx
c01032df:	89 54 24 04          	mov    %edx,0x4(%esp)
c01032e3:	89 04 24             	mov    %eax,(%esp)
c01032e6:	e8 92 40 00 00       	call   c010737d <get_pte>
c01032eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    //int access = (*pte)&(PTE_A)?1:0;
    //int dirty = (*pte)&(PTE_D)?1:0;
    return 0;
c01032ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01032f3:	c9                   	leave  
c01032f4:	c3                   	ret    

c01032f5 <_extended_clock_swap_out_victim>:
	(0,0) 置换        
当找到（0，0）时置换此页，并将指针下移。
*/
static int
_extended_clock_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
c01032f5:	55                   	push   %ebp
c01032f6:	89 e5                	mov    %esp,%ebp
c01032f8:	83 ec 68             	sub    $0x68,%esp
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
c01032fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01032fe:	8b 40 14             	mov    0x14(%eax),%eax
c0103301:	89 45 f0             	mov    %eax,-0x10(%ebp)
         assert(head != NULL);
c0103304:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103308:	75 24                	jne    c010332e <_extended_clock_swap_out_victim+0x39>
c010330a:	c7 44 24 0c 41 9c 10 	movl   $0xc0109c41,0xc(%esp)
c0103311:	c0 
c0103312:	c7 44 24 08 0e 9c 10 	movl   $0xc0109c0e,0x8(%esp)
c0103319:	c0 
c010331a:	c7 44 24 04 3c 00 00 	movl   $0x3c,0x4(%esp)
c0103321:	00 
c0103322:	c7 04 24 23 9c 10 c0 	movl   $0xc0109c23,(%esp)
c0103329:	e8 ca d0 ff ff       	call   c01003f8 <__panic>
     assert(in_tick==0);
c010332e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0103332:	74 24                	je     c0103358 <_extended_clock_swap_out_victim+0x63>
c0103334:	c7 44 24 0c 4e 9c 10 	movl   $0xc0109c4e,0xc(%esp)
c010333b:	c0 
c010333c:	c7 44 24 08 0e 9c 10 	movl   $0xc0109c0e,0x8(%esp)
c0103343:	c0 
c0103344:	c7 44 24 04 3d 00 00 	movl   $0x3d,0x4(%esp)
c010334b:	00 
c010334c:	c7 04 24 23 9c 10 c0 	movl   $0xc0109c23,(%esp)
c0103353:	e8 a0 d0 ff ff       	call   c01003f8 <__panic>
     list_entry_t *le = clock_p;
c0103358:	a1 18 50 12 c0       	mov    0xc0125018,%eax
c010335d:	89 45 f4             	mov    %eax,-0xc(%ebp)
     le = head->next;
c0103360:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103363:	8b 40 04             	mov    0x4(%eax),%eax
c0103366:	89 45 f4             	mov    %eax,-0xc(%ebp)
     cprintf("\n---start---\n");
c0103369:	c7 04 24 59 9c 10 c0 	movl   $0xc0109c59,(%esp)
c0103370:	e8 2c cf ff ff       	call   c01002a1 <cprintf>
     while (1) {
    	 struct Page *page = le2page(le, pra_page_link);
c0103375:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103378:	83 e8 14             	sub    $0x14,%eax
c010337b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    	 pte_t * pte = get_pte(mm->pgdir, page->pra_vaddr, 0);
c010337e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103381:	8b 50 1c             	mov    0x1c(%eax),%edx
c0103384:	8b 45 08             	mov    0x8(%ebp),%eax
c0103387:	8b 40 0c             	mov    0xc(%eax),%eax
c010338a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103391:	00 
c0103392:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103396:	89 04 24             	mov    %eax,(%esp)
c0103399:	e8 df 3f 00 00       	call   c010737d <get_pte>
c010339e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    	 int accessed = (*pte)&(PTE_A)?1:0;
c01033a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01033a4:	8b 00                	mov    (%eax),%eax
c01033a6:	83 e0 20             	and    $0x20,%eax
c01033a9:	85 c0                	test   %eax,%eax
c01033ab:	0f 95 c0             	setne  %al
c01033ae:	0f b6 c0             	movzbl %al,%eax
c01033b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    	 int dirty = (*pte)&(PTE_D)?1:0;
c01033b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01033b7:	8b 00                	mov    (%eax),%eax
c01033b9:	83 e0 40             	and    $0x40,%eax
c01033bc:	85 c0                	test   %eax,%eax
c01033be:	0f 95 c0             	setne  %al
c01033c1:	0f b6 c0             	movzbl %al,%eax
c01033c4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		 if (le==clock_p)
c01033c7:	a1 18 50 12 c0       	mov    0xc0125018,%eax
c01033cc:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01033cf:	75 0e                	jne    c01033df <_extended_clock_swap_out_victim+0xea>
			 cprintf("->");
c01033d1:	c7 04 24 67 9c 10 c0 	movl   $0xc0109c67,(%esp)
c01033d8:	e8 c4 ce ff ff       	call   c01002a1 <cprintf>
c01033dd:	eb 0c                	jmp    c01033eb <_extended_clock_swap_out_victim+0xf6>
		 else
			 cprintf("  ");
c01033df:	c7 04 24 6a 9c 10 c0 	movl   $0xc0109c6a,(%esp)
c01033e6:	e8 b6 ce ff ff       	call   c01002a1 <cprintf>
    	 cprintf("clock state: 0x%4x: A:%x, D:%x\n", page->pra_vaddr, accessed, dirty);
c01033eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01033ee:	8b 40 1c             	mov    0x1c(%eax),%eax
c01033f1:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01033f4:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01033f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01033fb:	89 54 24 08          	mov    %edx,0x8(%esp)
c01033ff:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103403:	c7 04 24 70 9c 10 c0 	movl   $0xc0109c70,(%esp)
c010340a:	e8 92 ce ff ff       	call   c01002a1 <cprintf>
    	 le = le->next;
c010340f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103412:	8b 40 04             	mov    0x4(%eax),%eax
c0103415:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	 if (le == head) {
c0103418:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010341b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010341e:	75 17                	jne    c0103437 <_extended_clock_swap_out_victim+0x142>
    		 break;
c0103420:	90                   	nop
    	 }
     }
     cprintf("----end----\n");
c0103421:	c7 04 24 90 9c 10 c0 	movl   $0xc0109c90,(%esp)
c0103428:	e8 74 ce ff ff       	call   c01002a1 <cprintf>

     le = clock_p;
c010342d:	a1 18 50 12 c0       	mov    0xc0125018,%eax
c0103432:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103435:	eb 05                	jmp    c010343c <_extended_clock_swap_out_victim+0x147>
     }
c0103437:	e9 39 ff ff ff       	jmp    c0103375 <_extended_clock_swap_out_victim+0x80>
     while (1) {
    	 if (le == head) {
c010343c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010343f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103442:	75 16                	jne    c010345a <_extended_clock_swap_out_victim+0x165>
    		 le = le->next;
c0103444:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103447:	8b 40 04             	mov    0x4(%eax),%eax
c010344a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    		 clock_p = clock_p -> next;
c010344d:	a1 18 50 12 c0       	mov    0xc0125018,%eax
c0103452:	8b 40 04             	mov    0x4(%eax),%eax
c0103455:	a3 18 50 12 c0       	mov    %eax,0xc0125018
    	 }
    	 struct Page *page = le2page(le, pra_page_link);
c010345a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010345d:	83 e8 14             	sub    $0x14,%eax
c0103460:	89 45 dc             	mov    %eax,-0x24(%ebp)
    	 pte_t * pte = get_pte(mm->pgdir, page->pra_vaddr, 0);
c0103463:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103466:	8b 50 1c             	mov    0x1c(%eax),%edx
c0103469:	8b 45 08             	mov    0x8(%ebp),%eax
c010346c:	8b 40 0c             	mov    0xc(%eax),%eax
c010346f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103476:	00 
c0103477:	89 54 24 04          	mov    %edx,0x4(%esp)
c010347b:	89 04 24             	mov    %eax,(%esp)
c010347e:	e8 fa 3e 00 00       	call   c010737d <get_pte>
c0103483:	89 45 d8             	mov    %eax,-0x28(%ebp)
    	 int accessed = (*pte)&(PTE_A)?1:0;
c0103486:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103489:	8b 00                	mov    (%eax),%eax
c010348b:	83 e0 20             	and    $0x20,%eax
c010348e:	85 c0                	test   %eax,%eax
c0103490:	0f 95 c0             	setne  %al
c0103493:	0f b6 c0             	movzbl %al,%eax
c0103496:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    	 int dirty = (*pte)&(PTE_D)?1:0;
c0103499:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010349c:	8b 00                	mov    (%eax),%eax
c010349e:	83 e0 40             	and    $0x40,%eax
c01034a1:	85 c0                	test   %eax,%eax
c01034a3:	0f 95 c0             	setne  %al
c01034a6:	0f b6 c0             	movzbl %al,%eax
c01034a9:	89 45 d0             	mov    %eax,-0x30(%ebp)
    	 if (accessed) {//如果A为1，则将其变为0；
c01034ac:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c01034b0:	74 76                	je     c0103528 <_extended_clock_swap_out_victim+0x233>
    		 cprintf("clock state: 0x%4x: A:%x, D:%x\n", page->pra_vaddr, accessed, dirty);
c01034b2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01034b5:	8b 40 1c             	mov    0x1c(%eax),%eax
c01034b8:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01034bb:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01034bf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01034c2:	89 54 24 08          	mov    %edx,0x8(%esp)
c01034c6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01034ca:	c7 04 24 70 9c 10 c0 	movl   $0xc0109c70,(%esp)
c01034d1:	e8 cb cd ff ff       	call   c01002a1 <cprintf>
    		 (*pte) = (*pte) & (~PTE_A);
c01034d6:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01034d9:	8b 00                	mov    (%eax),%eax
c01034db:	83 e0 df             	and    $0xffffffdf,%eax
c01034de:	89 c2                	mov    %eax,%edx
c01034e0:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01034e3:	89 10                	mov    %edx,(%eax)
    		 cprintf("\tclock state: 0x%4x: A:%x, D:%x\n",page->pra_vaddr, (*pte)&(PTE_A)?1:0, (*pte)&(PTE_D)?1:0);
c01034e5:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01034e8:	8b 00                	mov    (%eax),%eax
c01034ea:	83 e0 40             	and    $0x40,%eax
c01034ed:	85 c0                	test   %eax,%eax
c01034ef:	0f 95 c0             	setne  %al
c01034f2:	0f b6 c8             	movzbl %al,%ecx
c01034f5:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01034f8:	8b 00                	mov    (%eax),%eax
c01034fa:	83 e0 20             	and    $0x20,%eax
c01034fd:	85 c0                	test   %eax,%eax
c01034ff:	0f 95 c0             	setne  %al
c0103502:	0f b6 d0             	movzbl %al,%edx
c0103505:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103508:	8b 40 1c             	mov    0x1c(%eax),%eax
c010350b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c010350f:	89 54 24 08          	mov    %edx,0x8(%esp)
c0103513:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103517:	c7 04 24 a0 9c 10 c0 	movl   $0xc0109ca0,(%esp)
c010351e:	e8 7e cd ff ff       	call   c01002a1 <cprintf>
c0103523:	e9 df 01 00 00       	jmp    c0103707 <_extended_clock_swap_out_victim+0x412>
    	 }
    	 else if (!accessed && dirty) {//如果A为0，D为1 ，则D变为0；
c0103528:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c010352c:	75 7c                	jne    c01035aa <_extended_clock_swap_out_victim+0x2b5>
c010352e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0103532:	74 76                	je     c01035aa <_extended_clock_swap_out_victim+0x2b5>
    		 cprintf("clock state: 0x%4x: A:%x, D:%x\n", page->pra_vaddr, accessed, dirty);
c0103534:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103537:	8b 40 1c             	mov    0x1c(%eax),%eax
c010353a:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010353d:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0103541:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103544:	89 54 24 08          	mov    %edx,0x8(%esp)
c0103548:	89 44 24 04          	mov    %eax,0x4(%esp)
c010354c:	c7 04 24 70 9c 10 c0 	movl   $0xc0109c70,(%esp)
c0103553:	e8 49 cd ff ff       	call   c01002a1 <cprintf>
    		 (*pte) = (*pte) & (~PTE_D);
c0103558:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010355b:	8b 00                	mov    (%eax),%eax
c010355d:	83 e0 bf             	and    $0xffffffbf,%eax
c0103560:	89 c2                	mov    %eax,%edx
c0103562:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103565:	89 10                	mov    %edx,(%eax)
    		 cprintf("\tclock state: 0x%4x: A:%x, D:%x\n", page->pra_vaddr, (*pte)&(PTE_A)?1:0, (*pte)&(PTE_D)?1:0);
c0103567:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010356a:	8b 00                	mov    (%eax),%eax
c010356c:	83 e0 40             	and    $0x40,%eax
c010356f:	85 c0                	test   %eax,%eax
c0103571:	0f 95 c0             	setne  %al
c0103574:	0f b6 c8             	movzbl %al,%ecx
c0103577:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010357a:	8b 00                	mov    (%eax),%eax
c010357c:	83 e0 20             	and    $0x20,%eax
c010357f:	85 c0                	test   %eax,%eax
c0103581:	0f 95 c0             	setne  %al
c0103584:	0f b6 d0             	movzbl %al,%edx
c0103587:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010358a:	8b 40 1c             	mov    0x1c(%eax),%eax
c010358d:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0103591:	89 54 24 08          	mov    %edx,0x8(%esp)
c0103595:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103599:	c7 04 24 a0 9c 10 c0 	movl   $0xc0109ca0,(%esp)
c01035a0:	e8 fc cc ff ff       	call   c01002a1 <cprintf>
c01035a5:	e9 5d 01 00 00       	jmp    c0103707 <_extended_clock_swap_out_victim+0x412>
    	 } else if (!accessed && !dirty){//如果都为0，则置换此页，且clock_p指针下移一位；
c01035aa:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c01035ae:	0f 85 53 01 00 00    	jne    c0103707 <_extended_clock_swap_out_victim+0x412>
c01035b4:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c01035b8:	0f 85 49 01 00 00    	jne    c0103707 <_extended_clock_swap_out_victim+0x412>
    	     struct Page *p = le2page(le, pra_page_link);
c01035be:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035c1:	83 e8 14             	sub    $0x14,%eax
c01035c4:	89 45 cc             	mov    %eax,-0x34(%ebp)
c01035c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035ca:	89 45 b8             	mov    %eax,-0x48(%ebp)
    __list_del(listelm->prev, listelm->next);
c01035cd:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01035d0:	8b 40 04             	mov    0x4(%eax),%eax
c01035d3:	8b 55 b8             	mov    -0x48(%ebp),%edx
c01035d6:	8b 12                	mov    (%edx),%edx
c01035d8:	89 55 b4             	mov    %edx,-0x4c(%ebp)
c01035db:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01035de:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01035e1:	8b 55 b0             	mov    -0x50(%ebp),%edx
c01035e4:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01035e7:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01035ea:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01035ed:	89 10                	mov    %edx,(%eax)
    	     list_del(le);
    	     clock_p = clock_p->next;
c01035ef:	a1 18 50 12 c0       	mov    0xc0125018,%eax
c01035f4:	8b 40 04             	mov    0x4(%eax),%eax
c01035f7:	a3 18 50 12 c0       	mov    %eax,0xc0125018
    	     assert(p !=NULL);
c01035fc:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0103600:	75 24                	jne    c0103626 <_extended_clock_swap_out_victim+0x331>
c0103602:	c7 44 24 0c c1 9c 10 	movl   $0xc0109cc1,0xc(%esp)
c0103609:	c0 
c010360a:	c7 44 24 08 0e 9c 10 	movl   $0xc0109c0e,0x8(%esp)
c0103611:	c0 
c0103612:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
c0103619:	00 
c010361a:	c7 04 24 23 9c 10 c0 	movl   $0xc0109c23,(%esp)
c0103621:	e8 d2 cd ff ff       	call   c01003f8 <__panic>
    	     *ptr_page = p;
c0103626:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103629:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010362c:	89 10                	mov    %edx,(%eax)

			 le = head->next;
c010362e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103631:	8b 40 04             	mov    0x4(%eax),%eax
c0103634:	89 45 f4             	mov    %eax,-0xc(%ebp)
			 cprintf("\n--after--start---\n");
c0103637:	c7 04 24 ca 9c 10 c0 	movl   $0xc0109cca,(%esp)
c010363e:	e8 5e cc ff ff       	call   c01002a1 <cprintf>
			 while (1) {
				 struct Page *page = le2page(le, pra_page_link);
c0103643:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103646:	83 e8 14             	sub    $0x14,%eax
c0103649:	89 45 c8             	mov    %eax,-0x38(%ebp)
				 pte_t * pte = get_pte(mm->pgdir, page->pra_vaddr, 0);
c010364c:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010364f:	8b 50 1c             	mov    0x1c(%eax),%edx
c0103652:	8b 45 08             	mov    0x8(%ebp),%eax
c0103655:	8b 40 0c             	mov    0xc(%eax),%eax
c0103658:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010365f:	00 
c0103660:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103664:	89 04 24             	mov    %eax,(%esp)
c0103667:	e8 11 3d 00 00       	call   c010737d <get_pte>
c010366c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
				 int accessed = (*pte)&(PTE_A)?1:0;
c010366f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103672:	8b 00                	mov    (%eax),%eax
c0103674:	83 e0 20             	and    $0x20,%eax
c0103677:	85 c0                	test   %eax,%eax
c0103679:	0f 95 c0             	setne  %al
c010367c:	0f b6 c0             	movzbl %al,%eax
c010367f:	89 45 c0             	mov    %eax,-0x40(%ebp)
				 int dirty = (*pte)&(PTE_D)?1:0;
c0103682:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103685:	8b 00                	mov    (%eax),%eax
c0103687:	83 e0 40             	and    $0x40,%eax
c010368a:	85 c0                	test   %eax,%eax
c010368c:	0f 95 c0             	setne  %al
c010368f:	0f b6 c0             	movzbl %al,%eax
c0103692:	89 45 bc             	mov    %eax,-0x44(%ebp)
				 if (le==clock_p)
c0103695:	a1 18 50 12 c0       	mov    0xc0125018,%eax
c010369a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010369d:	75 0e                	jne    c01036ad <_extended_clock_swap_out_victim+0x3b8>
					 cprintf("->");
c010369f:	c7 04 24 67 9c 10 c0 	movl   $0xc0109c67,(%esp)
c01036a6:	e8 f6 cb ff ff       	call   c01002a1 <cprintf>
c01036ab:	eb 0c                	jmp    c01036b9 <_extended_clock_swap_out_victim+0x3c4>
				 else
					 cprintf("  ");
c01036ad:	c7 04 24 6a 9c 10 c0 	movl   $0xc0109c6a,(%esp)
c01036b4:	e8 e8 cb ff ff       	call   c01002a1 <cprintf>
				 cprintf("clock state: 0x%4x: A:%x, D:%x\n", page->pra_vaddr, accessed, dirty);
c01036b9:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01036bc:	8b 40 1c             	mov    0x1c(%eax),%eax
c01036bf:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01036c2:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01036c6:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01036c9:	89 54 24 08          	mov    %edx,0x8(%esp)
c01036cd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01036d1:	c7 04 24 70 9c 10 c0 	movl   $0xc0109c70,(%esp)
c01036d8:	e8 c4 cb ff ff       	call   c01002a1 <cprintf>
				 le = le->next;
c01036dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036e0:	8b 40 04             	mov    0x4(%eax),%eax
c01036e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
				 if (le == head) {
c01036e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036e9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01036ec:	75 14                	jne    c0103702 <_extended_clock_swap_out_victim+0x40d>
					 break;
c01036ee:	90                   	nop
				 }
			 }
			 cprintf("--after--end----\n");
c01036ef:	c7 04 24 de 9c 10 c0 	movl   $0xc0109cde,(%esp)
c01036f6:	e8 a6 cb ff ff       	call   c01002a1 <cprintf>
    	     return 0;
c01036fb:	b8 00 00 00 00       	mov    $0x0,%eax
c0103700:	eb 20                	jmp    c0103722 <_extended_clock_swap_out_victim+0x42d>
			 }
c0103702:	e9 3c ff ff ff       	jmp    c0103643 <_extended_clock_swap_out_victim+0x34e>
    	 }
    	 le = le->next;
c0103707:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010370a:	8b 40 04             	mov    0x4(%eax),%eax
c010370d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	 clock_p = clock_p->next;
c0103710:	a1 18 50 12 c0       	mov    0xc0125018,%eax
c0103715:	8b 40 04             	mov    0x4(%eax),%eax
c0103718:	a3 18 50 12 c0       	mov    %eax,0xc0125018
     }
c010371d:	e9 1a fd ff ff       	jmp    c010343c <_extended_clock_swap_out_victim+0x147>

}
c0103722:	c9                   	leave  
c0103723:	c3                   	ret    

c0103724 <_extended_clock_check_swap>:

static int
_extended_clock_check_swap(void) {
c0103724:	55                   	push   %ebp
c0103725:	89 e5                	mov    %esp,%ebp
c0103727:	83 ec 28             	sub    $0x28,%esp
    //初始状态置入了abcd四页，然后进行了写e，读c，写d，读a，写b，
    //写e，写c，写e，读c，写e，写a，写a，读b，读c，读d，写e，读a，写b，写e 这些操作
	unsigned char tmp;
	cprintf("write Virt Page e in extended_clock_check_swap\n");
c010372a:	c7 04 24 f0 9c 10 c0 	movl   $0xc0109cf0,(%esp)
c0103731:	e8 6b cb ff ff       	call   c01002a1 <cprintf>
    *(unsigned char *)0x5000 = 0x1e;
c0103736:	b8 00 50 00 00       	mov    $0x5000,%eax
c010373b:	c6 00 1e             	movb   $0x1e,(%eax)
	
	
    cprintf("read Virt Page c in extended_clock_check_swap\n");
c010373e:	c7 04 24 20 9d 10 c0 	movl   $0xc0109d20,(%esp)
c0103745:	e8 57 cb ff ff       	call   c01002a1 <cprintf>
    tmp = *(unsigned char *)0x3000;
c010374a:	b8 00 30 00 00       	mov    $0x3000,%eax
c010374f:	0f b6 00             	movzbl (%eax),%eax
c0103752:	88 45 f7             	mov    %al,-0x9(%ebp)
    //cprintf("tmp = 0x%4x\n", tmp);
	
    cprintf("write Virt Page d in extended_clock_check_swap\n");
c0103755:	c7 04 24 50 9d 10 c0 	movl   $0xc0109d50,(%esp)
c010375c:	e8 40 cb ff ff       	call   c01002a1 <cprintf>
    *(unsigned char *)0x4000 = 0x0a;
c0103761:	b8 00 40 00 00       	mov    $0x4000,%eax
c0103766:	c6 00 0a             	movb   $0xa,(%eax)

    cprintf("read Virt Page a in extended_clock_check_swap\n");
c0103769:	c7 04 24 80 9d 10 c0 	movl   $0xc0109d80,(%esp)
c0103770:	e8 2c cb ff ff       	call   c01002a1 <cprintf>
    tmp = *(unsigned char *)0x1000;
c0103775:	b8 00 10 00 00       	mov    $0x1000,%eax
c010377a:	0f b6 00             	movzbl (%eax),%eax
c010377d:	88 45 f7             	mov    %al,-0x9(%ebp)
    //cprintf("tmp = 0x%4x\n", tmp);

	
    cprintf("write Virt Page b in extended_clock_check_swap\n");
c0103780:	c7 04 24 b0 9d 10 c0 	movl   $0xc0109db0,(%esp)
c0103787:	e8 15 cb ff ff       	call   c01002a1 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c010378c:	b8 00 20 00 00       	mov    $0x2000,%eax
c0103791:	c6 00 0b             	movb   $0xb,(%eax)

    cprintf("write Virt Page e in extended_clock_check_swap\n");
c0103794:	c7 04 24 f0 9c 10 c0 	movl   $0xc0109cf0,(%esp)
c010379b:	e8 01 cb ff ff       	call   c01002a1 <cprintf>
    *(unsigned char *)0x5000 = 0x1e;
c01037a0:	b8 00 50 00 00       	mov    $0x5000,%eax
c01037a5:	c6 00 1e             	movb   $0x1e,(%eax)
	
	cprintf("write Virt Page c in extended_clock_check_swap\n");
c01037a8:	c7 04 24 e0 9d 10 c0 	movl   $0xc0109de0,(%esp)
c01037af:	e8 ed ca ff ff       	call   c01002a1 <cprintf>
    *(unsigned char *)0x3000 = 0x0e;
c01037b4:	b8 00 30 00 00       	mov    $0x3000,%eax
c01037b9:	c6 00 0e             	movb   $0xe,(%eax)
	
	cprintf("write Virt Page e in extended_clock_check_swap\n");
c01037bc:	c7 04 24 f0 9c 10 c0 	movl   $0xc0109cf0,(%esp)
c01037c3:	e8 d9 ca ff ff       	call   c01002a1 <cprintf>
    *(unsigned char *)0x5000 = 0x2e;
c01037c8:	b8 00 50 00 00       	mov    $0x5000,%eax
c01037cd:	c6 00 2e             	movb   $0x2e,(%eax)
	
	cprintf("read Virt Page c in extended_clock_check_swap\n");
c01037d0:	c7 04 24 20 9d 10 c0 	movl   $0xc0109d20,(%esp)
c01037d7:	e8 c5 ca ff ff       	call   c01002a1 <cprintf>
    tmp = *(unsigned char *)0x3000;
c01037dc:	b8 00 30 00 00       	mov    $0x3000,%eax
c01037e1:	0f b6 00             	movzbl (%eax),%eax
c01037e4:	88 45 f7             	mov    %al,-0x9(%ebp)
	
	cprintf("write Virt Page e in extended_clock_check_swap\n");
c01037e7:	c7 04 24 f0 9c 10 c0 	movl   $0xc0109cf0,(%esp)
c01037ee:	e8 ae ca ff ff       	call   c01002a1 <cprintf>
    *(unsigned char *)0x5000 = 0x2e;
c01037f3:	b8 00 50 00 00       	mov    $0x5000,%eax
c01037f8:	c6 00 2e             	movb   $0x2e,(%eax)
	//cprintf("--------\n");
	cprintf("write Virt Page a in extended_clock_check_swap\n");
c01037fb:	c7 04 24 10 9e 10 c0 	movl   $0xc0109e10,(%esp)
c0103802:	e8 9a ca ff ff       	call   c01002a1 <cprintf>
    *(unsigned char *)0x1000 = 0x1a;
c0103807:	b8 00 10 00 00       	mov    $0x1000,%eax
c010380c:	c6 00 1a             	movb   $0x1a,(%eax)
	cprintf("write Virt Page a in extended_clock_check_swap\n");
c010380f:	c7 04 24 10 9e 10 c0 	movl   $0xc0109e10,(%esp)
c0103816:	e8 86 ca ff ff       	call   c01002a1 <cprintf>
    *(unsigned char *)0x1000 = 0x1a;
c010381b:	b8 00 10 00 00       	mov    $0x1000,%eax
c0103820:	c6 00 1a             	movb   $0x1a,(%eax)
    
	//cprintf("--------\n");
    cprintf("read Virt Page b in extended_clock_check_swap\n");
c0103823:	c7 04 24 40 9e 10 c0 	movl   $0xc0109e40,(%esp)
c010382a:	e8 72 ca ff ff       	call   c01002a1 <cprintf>
    tmp = *(unsigned char *)0x2000;
c010382f:	b8 00 20 00 00       	mov    $0x2000,%eax
c0103834:	0f b6 00             	movzbl (%eax),%eax
c0103837:	88 45 f7             	mov    %al,-0x9(%ebp)
    //cprintf("tmp = 0x%4x\n", tmp);
	//cprintf("--------\n");

    cprintf("read Virt Page c in extended_clock_check_swap\n");
c010383a:	c7 04 24 20 9d 10 c0 	movl   $0xc0109d20,(%esp)
c0103841:	e8 5b ca ff ff       	call   c01002a1 <cprintf>
    tmp = *(unsigned char *)0x3000;
c0103846:	b8 00 30 00 00       	mov    $0x3000,%eax
c010384b:	0f b6 00             	movzbl (%eax),%eax
c010384e:	88 45 f7             	mov    %al,-0x9(%ebp)
    //cprintf("tmp = 0x%4x\n", tmp);

    cprintf("read Virt Page d in extended_clock_check_swap\n");
c0103851:	c7 04 24 70 9e 10 c0 	movl   $0xc0109e70,(%esp)
c0103858:	e8 44 ca ff ff       	call   c01002a1 <cprintf>
    tmp = *(unsigned char *)0x4000;
c010385d:	b8 00 40 00 00       	mov    $0x4000,%eax
c0103862:	0f b6 00             	movzbl (%eax),%eax
c0103865:	88 45 f7             	mov    %al,-0x9(%ebp)
    //cprintf("tmp = 0x%4x\n", tmp);

    cprintf("write Virt Page e in extended_clock_check_swap\n");
c0103868:	c7 04 24 f0 9c 10 c0 	movl   $0xc0109cf0,(%esp)
c010386f:	e8 2d ca ff ff       	call   c01002a1 <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c0103874:	b8 00 50 00 00       	mov    $0x5000,%eax
c0103879:	c6 00 0e             	movb   $0xe,(%eax)

    cprintf("read Virt Page a in extended_clock_check_swap\n");
c010387c:	c7 04 24 80 9d 10 c0 	movl   $0xc0109d80,(%esp)
c0103883:	e8 19 ca ff ff       	call   c01002a1 <cprintf>
    tmp = *(unsigned char *)0x1000;
c0103888:	b8 00 10 00 00       	mov    $0x1000,%eax
c010388d:	0f b6 00             	movzbl (%eax),%eax
c0103890:	88 45 f7             	mov    %al,-0x9(%ebp)
    //cprintf("tmp = 0x%4x\n", tmp);

    cprintf("write Virt Page b in extended_clock_check_swap\n");
c0103893:	c7 04 24 b0 9d 10 c0 	movl   $0xc0109db0,(%esp)
c010389a:	e8 02 ca ff ff       	call   c01002a1 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c010389f:	b8 00 20 00 00       	mov    $0x2000,%eax
c01038a4:	c6 00 0b             	movb   $0xb,(%eax)

    cprintf("write Virt Page e in extended_clock_check_swap\n");
c01038a7:	c7 04 24 f0 9c 10 c0 	movl   $0xc0109cf0,(%esp)
c01038ae:	e8 ee c9 ff ff       	call   c01002a1 <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c01038b3:	b8 00 50 00 00       	mov    $0x5000,%eax
c01038b8:	c6 00 0e             	movb   $0xe,(%eax)


    return 0;
c01038bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01038c0:	c9                   	leave  
c01038c1:	c3                   	ret    

c01038c2 <_extended_clock_init>:


static int
_extended_clock_init(void)
{
c01038c2:	55                   	push   %ebp
c01038c3:	89 e5                	mov    %esp,%ebp
    return 0;
c01038c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01038ca:	5d                   	pop    %ebp
c01038cb:	c3                   	ret    

c01038cc <_extended_clock_set_unswappable>:

static int
_extended_clock_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c01038cc:	55                   	push   %ebp
c01038cd:	89 e5                	mov    %esp,%ebp
    return 0;
c01038cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01038d4:	5d                   	pop    %ebp
c01038d5:	c3                   	ret    

c01038d6 <_extended_clock_tick_event>:

static int
_extended_clock_tick_event(struct mm_struct *mm)
{ return 0; }
c01038d6:	55                   	push   %ebp
c01038d7:	89 e5                	mov    %esp,%ebp
c01038d9:	b8 00 00 00 00       	mov    $0x0,%eax
c01038de:	5d                   	pop    %ebp
c01038df:	c3                   	ret    

c01038e0 <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c01038e0:	55                   	push   %ebp
c01038e1:	89 e5                	mov    %esp,%ebp
c01038e3:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c01038e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01038e9:	c1 e8 0c             	shr    $0xc,%eax
c01038ec:	89 c2                	mov    %eax,%edx
c01038ee:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c01038f3:	39 c2                	cmp    %eax,%edx
c01038f5:	72 1c                	jb     c0103913 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c01038f7:	c7 44 24 08 bc 9e 10 	movl   $0xc0109ebc,0x8(%esp)
c01038fe:	c0 
c01038ff:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c0103906:	00 
c0103907:	c7 04 24 db 9e 10 c0 	movl   $0xc0109edb,(%esp)
c010390e:	e8 e5 ca ff ff       	call   c01003f8 <__panic>
    }
    return &pages[PPN(pa)];
c0103913:	a1 f8 50 12 c0       	mov    0xc01250f8,%eax
c0103918:	8b 55 08             	mov    0x8(%ebp),%edx
c010391b:	c1 ea 0c             	shr    $0xc,%edx
c010391e:	c1 e2 05             	shl    $0x5,%edx
c0103921:	01 d0                	add    %edx,%eax
}
c0103923:	c9                   	leave  
c0103924:	c3                   	ret    

c0103925 <pde2page>:
    }
    return pa2page(PTE_ADDR(pte));
}

static inline struct Page *
pde2page(pde_t pde) {
c0103925:	55                   	push   %ebp
c0103926:	89 e5                	mov    %esp,%ebp
c0103928:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c010392b:	8b 45 08             	mov    0x8(%ebp),%eax
c010392e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103933:	89 04 24             	mov    %eax,(%esp)
c0103936:	e8 a5 ff ff ff       	call   c01038e0 <pa2page>
}
c010393b:	c9                   	leave  
c010393c:	c3                   	ret    

c010393d <mm_create>:
static void check_vma_struct(void);
static void check_pgfault(void);

// mm_create -  alloc a mm_struct & initialize it.
struct mm_struct *
mm_create(void) {
c010393d:	55                   	push   %ebp
c010393e:	89 e5                	mov    %esp,%ebp
c0103940:	83 ec 28             	sub    $0x28,%esp
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
c0103943:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c010394a:	e8 f9 4a 00 00       	call   c0108448 <kmalloc>
c010394f:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (mm != NULL) {
c0103952:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103956:	74 58                	je     c01039b0 <mm_create+0x73>
        list_init(&(mm->mmap_list));
c0103958:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010395b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    elm->prev = elm->next = elm;
c010395e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103961:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103964:	89 50 04             	mov    %edx,0x4(%eax)
c0103967:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010396a:	8b 50 04             	mov    0x4(%eax),%edx
c010396d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103970:	89 10                	mov    %edx,(%eax)
        mm->mmap_cache = NULL;
c0103972:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103975:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        mm->pgdir = NULL;
c010397c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010397f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        mm->map_count = 0;
c0103986:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103989:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

        if (swap_init_ok) swap_init_mm(mm);
c0103990:	a1 68 4f 12 c0       	mov    0xc0124f68,%eax
c0103995:	85 c0                	test   %eax,%eax
c0103997:	74 0d                	je     c01039a6 <mm_create+0x69>
c0103999:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010399c:	89 04 24             	mov    %eax,(%esp)
c010399f:	e8 c5 0d 00 00       	call   c0104769 <swap_init_mm>
c01039a4:	eb 0a                	jmp    c01039b0 <mm_create+0x73>
        else mm->sm_priv = NULL;
c01039a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039a9:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    }
    return mm;
c01039b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01039b3:	c9                   	leave  
c01039b4:	c3                   	ret    

c01039b5 <vma_create>:

// vma_create - alloc a vma_struct & initialize it. (addr range: vm_start~vm_end)
struct vma_struct *
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
c01039b5:	55                   	push   %ebp
c01039b6:	89 e5                	mov    %esp,%ebp
c01039b8:	83 ec 28             	sub    $0x28,%esp
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
c01039bb:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c01039c2:	e8 81 4a 00 00       	call   c0108448 <kmalloc>
c01039c7:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (vma != NULL) {
c01039ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01039ce:	74 1b                	je     c01039eb <vma_create+0x36>
        vma->vm_start = vm_start;
c01039d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039d3:	8b 55 08             	mov    0x8(%ebp),%edx
c01039d6:	89 50 04             	mov    %edx,0x4(%eax)
        vma->vm_end = vm_end;
c01039d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039dc:	8b 55 0c             	mov    0xc(%ebp),%edx
c01039df:	89 50 08             	mov    %edx,0x8(%eax)
        vma->vm_flags = vm_flags;
c01039e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039e5:	8b 55 10             	mov    0x10(%ebp),%edx
c01039e8:	89 50 0c             	mov    %edx,0xc(%eax)
    }
    return vma;
c01039eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01039ee:	c9                   	leave  
c01039ef:	c3                   	ret    

c01039f0 <find_vma>:


// find_vma - find a vma  (vma->vm_start <= addr <= vma_vm_end)
struct vma_struct *
find_vma(struct mm_struct *mm, uintptr_t addr) {
c01039f0:	55                   	push   %ebp
c01039f1:	89 e5                	mov    %esp,%ebp
c01039f3:	83 ec 20             	sub    $0x20,%esp
    struct vma_struct *vma = NULL;
c01039f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    if (mm != NULL) {
c01039fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103a01:	0f 84 95 00 00 00    	je     c0103a9c <find_vma+0xac>
        vma = mm->mmap_cache;
c0103a07:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a0a:	8b 40 08             	mov    0x8(%eax),%eax
c0103a0d:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
c0103a10:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0103a14:	74 16                	je     c0103a2c <find_vma+0x3c>
c0103a16:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103a19:	8b 40 04             	mov    0x4(%eax),%eax
c0103a1c:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103a1f:	77 0b                	ja     c0103a2c <find_vma+0x3c>
c0103a21:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103a24:	8b 40 08             	mov    0x8(%eax),%eax
c0103a27:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103a2a:	77 61                	ja     c0103a8d <find_vma+0x9d>
                bool found = 0;
c0103a2c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
                list_entry_t *list = &(mm->mmap_list), *le = list;
c0103a33:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a36:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103a39:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
                while ((le = list_next(le)) != list) {
c0103a3f:	eb 28                	jmp    c0103a69 <find_vma+0x79>
                    vma = le2vma(le, list_link);
c0103a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a44:	83 e8 10             	sub    $0x10,%eax
c0103a47:	89 45 fc             	mov    %eax,-0x4(%ebp)
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
c0103a4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103a4d:	8b 40 04             	mov    0x4(%eax),%eax
c0103a50:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103a53:	77 14                	ja     c0103a69 <find_vma+0x79>
c0103a55:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103a58:	8b 40 08             	mov    0x8(%eax),%eax
c0103a5b:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103a5e:	76 09                	jbe    c0103a69 <find_vma+0x79>
                        found = 1;
c0103a60:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
                        break;
c0103a67:	eb 17                	jmp    c0103a80 <find_vma+0x90>
c0103a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a6c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    return listelm->next;
c0103a6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103a72:	8b 40 04             	mov    0x4(%eax),%eax
                while ((le = list_next(le)) != list) {
c0103a75:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a7b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103a7e:	75 c1                	jne    c0103a41 <find_vma+0x51>
                    }
                }
                if (!found) {
c0103a80:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c0103a84:	75 07                	jne    c0103a8d <find_vma+0x9d>
                    vma = NULL;
c0103a86:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
                }
        }
        if (vma != NULL) {
c0103a8d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0103a91:	74 09                	je     c0103a9c <find_vma+0xac>
            mm->mmap_cache = vma;
c0103a93:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a96:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103a99:	89 50 08             	mov    %edx,0x8(%eax)
        }
    }
    return vma;
c0103a9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0103a9f:	c9                   	leave  
c0103aa0:	c3                   	ret    

c0103aa1 <check_vma_overlap>:


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
c0103aa1:	55                   	push   %ebp
c0103aa2:	89 e5                	mov    %esp,%ebp
c0103aa4:	83 ec 18             	sub    $0x18,%esp
    assert(prev->vm_start < prev->vm_end);
c0103aa7:	8b 45 08             	mov    0x8(%ebp),%eax
c0103aaa:	8b 50 04             	mov    0x4(%eax),%edx
c0103aad:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ab0:	8b 40 08             	mov    0x8(%eax),%eax
c0103ab3:	39 c2                	cmp    %eax,%edx
c0103ab5:	72 24                	jb     c0103adb <check_vma_overlap+0x3a>
c0103ab7:	c7 44 24 0c e9 9e 10 	movl   $0xc0109ee9,0xc(%esp)
c0103abe:	c0 
c0103abf:	c7 44 24 08 07 9f 10 	movl   $0xc0109f07,0x8(%esp)
c0103ac6:	c0 
c0103ac7:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c0103ace:	00 
c0103acf:	c7 04 24 1c 9f 10 c0 	movl   $0xc0109f1c,(%esp)
c0103ad6:	e8 1d c9 ff ff       	call   c01003f8 <__panic>
    assert(prev->vm_end <= next->vm_start);
c0103adb:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ade:	8b 50 08             	mov    0x8(%eax),%edx
c0103ae1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103ae4:	8b 40 04             	mov    0x4(%eax),%eax
c0103ae7:	39 c2                	cmp    %eax,%edx
c0103ae9:	76 24                	jbe    c0103b0f <check_vma_overlap+0x6e>
c0103aeb:	c7 44 24 0c 2c 9f 10 	movl   $0xc0109f2c,0xc(%esp)
c0103af2:	c0 
c0103af3:	c7 44 24 08 07 9f 10 	movl   $0xc0109f07,0x8(%esp)
c0103afa:	c0 
c0103afb:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
c0103b02:	00 
c0103b03:	c7 04 24 1c 9f 10 c0 	movl   $0xc0109f1c,(%esp)
c0103b0a:	e8 e9 c8 ff ff       	call   c01003f8 <__panic>
    assert(next->vm_start < next->vm_end);
c0103b0f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103b12:	8b 50 04             	mov    0x4(%eax),%edx
c0103b15:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103b18:	8b 40 08             	mov    0x8(%eax),%eax
c0103b1b:	39 c2                	cmp    %eax,%edx
c0103b1d:	72 24                	jb     c0103b43 <check_vma_overlap+0xa2>
c0103b1f:	c7 44 24 0c 4b 9f 10 	movl   $0xc0109f4b,0xc(%esp)
c0103b26:	c0 
c0103b27:	c7 44 24 08 07 9f 10 	movl   $0xc0109f07,0x8(%esp)
c0103b2e:	c0 
c0103b2f:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
c0103b36:	00 
c0103b37:	c7 04 24 1c 9f 10 c0 	movl   $0xc0109f1c,(%esp)
c0103b3e:	e8 b5 c8 ff ff       	call   c01003f8 <__panic>
}
c0103b43:	c9                   	leave  
c0103b44:	c3                   	ret    

c0103b45 <insert_vma_struct>:


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
c0103b45:	55                   	push   %ebp
c0103b46:	89 e5                	mov    %esp,%ebp
c0103b48:	83 ec 48             	sub    $0x48,%esp
    assert(vma->vm_start < vma->vm_end);
c0103b4b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103b4e:	8b 50 04             	mov    0x4(%eax),%edx
c0103b51:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103b54:	8b 40 08             	mov    0x8(%eax),%eax
c0103b57:	39 c2                	cmp    %eax,%edx
c0103b59:	72 24                	jb     c0103b7f <insert_vma_struct+0x3a>
c0103b5b:	c7 44 24 0c 69 9f 10 	movl   $0xc0109f69,0xc(%esp)
c0103b62:	c0 
c0103b63:	c7 44 24 08 07 9f 10 	movl   $0xc0109f07,0x8(%esp)
c0103b6a:	c0 
c0103b6b:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c0103b72:	00 
c0103b73:	c7 04 24 1c 9f 10 c0 	movl   $0xc0109f1c,(%esp)
c0103b7a:	e8 79 c8 ff ff       	call   c01003f8 <__panic>
    list_entry_t *list = &(mm->mmap_list);
c0103b7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b82:	89 45 ec             	mov    %eax,-0x14(%ebp)
    list_entry_t *le_prev = list, *le_next;
c0103b85:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b88:	89 45 f4             	mov    %eax,-0xc(%ebp)

        list_entry_t *le = list;
c0103b8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        while ((le = list_next(le)) != list) {
c0103b91:	eb 21                	jmp    c0103bb4 <insert_vma_struct+0x6f>
            struct vma_struct *mmap_prev = le2vma(le, list_link);
c0103b93:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103b96:	83 e8 10             	sub    $0x10,%eax
c0103b99:	89 45 e8             	mov    %eax,-0x18(%ebp)
            if (mmap_prev->vm_start > vma->vm_start) {
c0103b9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103b9f:	8b 50 04             	mov    0x4(%eax),%edx
c0103ba2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103ba5:	8b 40 04             	mov    0x4(%eax),%eax
c0103ba8:	39 c2                	cmp    %eax,%edx
c0103baa:	76 02                	jbe    c0103bae <insert_vma_struct+0x69>
                break;
c0103bac:	eb 1d                	jmp    c0103bcb <insert_vma_struct+0x86>
            }
            le_prev = le;
c0103bae:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103bb1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103bb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103bb7:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103bba:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103bbd:	8b 40 04             	mov    0x4(%eax),%eax
        while ((le = list_next(le)) != list) {
c0103bc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103bc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103bc6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103bc9:	75 c8                	jne    c0103b93 <insert_vma_struct+0x4e>
c0103bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103bce:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103bd1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103bd4:	8b 40 04             	mov    0x4(%eax),%eax
        }

    le_next = list_next(le_prev);
c0103bd7:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    /* check overlap */
    if (le_prev != list) {
c0103bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103bdd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103be0:	74 15                	je     c0103bf7 <insert_vma_struct+0xb2>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
c0103be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103be5:	8d 50 f0             	lea    -0x10(%eax),%edx
c0103be8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103beb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103bef:	89 14 24             	mov    %edx,(%esp)
c0103bf2:	e8 aa fe ff ff       	call   c0103aa1 <check_vma_overlap>
    }
    if (le_next != list) {
c0103bf7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103bfa:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103bfd:	74 15                	je     c0103c14 <insert_vma_struct+0xcf>
        check_vma_overlap(vma, le2vma(le_next, list_link));
c0103bff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103c02:	83 e8 10             	sub    $0x10,%eax
c0103c05:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103c09:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103c0c:	89 04 24             	mov    %eax,(%esp)
c0103c0f:	e8 8d fe ff ff       	call   c0103aa1 <check_vma_overlap>
    }

    vma->vm_mm = mm;
c0103c14:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103c17:	8b 55 08             	mov    0x8(%ebp),%edx
c0103c1a:	89 10                	mov    %edx,(%eax)
    list_add_after(le_prev, &(vma->list_link));
c0103c1c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103c1f:	8d 50 10             	lea    0x10(%eax),%edx
c0103c22:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c25:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0103c28:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    __list_add(elm, listelm, listelm->next);
c0103c2b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103c2e:	8b 40 04             	mov    0x4(%eax),%eax
c0103c31:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103c34:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0103c37:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0103c3a:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0103c3d:	89 45 c8             	mov    %eax,-0x38(%ebp)
    prev->next = next->prev = elm;
c0103c40:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103c43:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103c46:	89 10                	mov    %edx,(%eax)
c0103c48:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103c4b:	8b 10                	mov    (%eax),%edx
c0103c4d:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103c50:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103c53:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103c56:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0103c59:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103c5c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103c5f:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103c62:	89 10                	mov    %edx,(%eax)

    mm->map_count ++;
c0103c64:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c67:	8b 40 10             	mov    0x10(%eax),%eax
c0103c6a:	8d 50 01             	lea    0x1(%eax),%edx
c0103c6d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c70:	89 50 10             	mov    %edx,0x10(%eax)
}
c0103c73:	c9                   	leave  
c0103c74:	c3                   	ret    

c0103c75 <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
c0103c75:	55                   	push   %ebp
c0103c76:	89 e5                	mov    %esp,%ebp
c0103c78:	83 ec 38             	sub    $0x38,%esp

    list_entry_t *list = &(mm->mmap_list), *le;
c0103c7b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(list)) != list) {
c0103c81:	eb 3e                	jmp    c0103cc1 <mm_destroy+0x4c>
c0103c83:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c86:	89 45 ec             	mov    %eax,-0x14(%ebp)
    __list_del(listelm->prev, listelm->next);
c0103c89:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103c8c:	8b 40 04             	mov    0x4(%eax),%eax
c0103c8f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0103c92:	8b 12                	mov    (%edx),%edx
c0103c94:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0103c97:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    prev->next = next;
c0103c9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103c9d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103ca0:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0103ca3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103ca6:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0103ca9:	89 10                	mov    %edx,(%eax)
        list_del(le);
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
c0103cab:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103cae:	83 e8 10             	sub    $0x10,%eax
c0103cb1:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
c0103cb8:	00 
c0103cb9:	89 04 24             	mov    %eax,(%esp)
c0103cbc:	e8 27 48 00 00       	call   c01084e8 <kfree>
c0103cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103cc4:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return listelm->next;
c0103cc7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103cca:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(list)) != list) {
c0103ccd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103cd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103cd3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103cd6:	75 ab                	jne    c0103c83 <mm_destroy+0xe>
    }
    kfree(mm, sizeof(struct mm_struct)); //kfree mm
c0103cd8:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
c0103cdf:	00 
c0103ce0:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ce3:	89 04 24             	mov    %eax,(%esp)
c0103ce6:	e8 fd 47 00 00       	call   c01084e8 <kfree>
    mm=NULL;
c0103ceb:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
}
c0103cf2:	c9                   	leave  
c0103cf3:	c3                   	ret    

c0103cf4 <vmm_init>:

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
c0103cf4:	55                   	push   %ebp
c0103cf5:	89 e5                	mov    %esp,%ebp
c0103cf7:	83 ec 08             	sub    $0x8,%esp
    check_vmm();
c0103cfa:	e8 02 00 00 00       	call   c0103d01 <check_vmm>
}
c0103cff:	c9                   	leave  
c0103d00:	c3                   	ret    

c0103d01 <check_vmm>:

// check_vmm - check correctness of vmm
static void
check_vmm(void) {
c0103d01:	55                   	push   %ebp
c0103d02:	89 e5                	mov    %esp,%ebp
c0103d04:	83 ec 28             	sub    $0x28,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0103d07:	e8 2f 30 00 00       	call   c0106d3b <nr_free_pages>
c0103d0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    check_vma_struct();
c0103d0f:	e8 41 00 00 00       	call   c0103d55 <check_vma_struct>
    check_pgfault();
c0103d14:	e8 03 05 00 00       	call   c010421c <check_pgfault>

    assert(nr_free_pages_store == nr_free_pages());
c0103d19:	e8 1d 30 00 00       	call   c0106d3b <nr_free_pages>
c0103d1e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103d21:	74 24                	je     c0103d47 <check_vmm+0x46>
c0103d23:	c7 44 24 0c 88 9f 10 	movl   $0xc0109f88,0xc(%esp)
c0103d2a:	c0 
c0103d2b:	c7 44 24 08 07 9f 10 	movl   $0xc0109f07,0x8(%esp)
c0103d32:	c0 
c0103d33:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
c0103d3a:	00 
c0103d3b:	c7 04 24 1c 9f 10 c0 	movl   $0xc0109f1c,(%esp)
c0103d42:	e8 b1 c6 ff ff       	call   c01003f8 <__panic>

    cprintf("check_vmm() succeeded.\n");
c0103d47:	c7 04 24 af 9f 10 c0 	movl   $0xc0109faf,(%esp)
c0103d4e:	e8 4e c5 ff ff       	call   c01002a1 <cprintf>
}
c0103d53:	c9                   	leave  
c0103d54:	c3                   	ret    

c0103d55 <check_vma_struct>:

static void
check_vma_struct(void) {
c0103d55:	55                   	push   %ebp
c0103d56:	89 e5                	mov    %esp,%ebp
c0103d58:	83 ec 68             	sub    $0x68,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0103d5b:	e8 db 2f 00 00       	call   c0106d3b <nr_free_pages>
c0103d60:	89 45 ec             	mov    %eax,-0x14(%ebp)

    struct mm_struct *mm = mm_create();
c0103d63:	e8 d5 fb ff ff       	call   c010393d <mm_create>
c0103d68:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(mm != NULL);
c0103d6b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103d6f:	75 24                	jne    c0103d95 <check_vma_struct+0x40>
c0103d71:	c7 44 24 0c c7 9f 10 	movl   $0xc0109fc7,0xc(%esp)
c0103d78:	c0 
c0103d79:	c7 44 24 08 07 9f 10 	movl   $0xc0109f07,0x8(%esp)
c0103d80:	c0 
c0103d81:	c7 44 24 04 b3 00 00 	movl   $0xb3,0x4(%esp)
c0103d88:	00 
c0103d89:	c7 04 24 1c 9f 10 c0 	movl   $0xc0109f1c,(%esp)
c0103d90:	e8 63 c6 ff ff       	call   c01003f8 <__panic>

    int step1 = 10, step2 = step1 * 10;
c0103d95:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%ebp)
c0103d9c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103d9f:	89 d0                	mov    %edx,%eax
c0103da1:	c1 e0 02             	shl    $0x2,%eax
c0103da4:	01 d0                	add    %edx,%eax
c0103da6:	01 c0                	add    %eax,%eax
c0103da8:	89 45 e0             	mov    %eax,-0x20(%ebp)

    int i;
    for (i = step1; i >= 1; i --) {
c0103dab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103dae:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103db1:	eb 70                	jmp    c0103e23 <check_vma_struct+0xce>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0103db3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103db6:	89 d0                	mov    %edx,%eax
c0103db8:	c1 e0 02             	shl    $0x2,%eax
c0103dbb:	01 d0                	add    %edx,%eax
c0103dbd:	83 c0 02             	add    $0x2,%eax
c0103dc0:	89 c1                	mov    %eax,%ecx
c0103dc2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103dc5:	89 d0                	mov    %edx,%eax
c0103dc7:	c1 e0 02             	shl    $0x2,%eax
c0103dca:	01 d0                	add    %edx,%eax
c0103dcc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103dd3:	00 
c0103dd4:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0103dd8:	89 04 24             	mov    %eax,(%esp)
c0103ddb:	e8 d5 fb ff ff       	call   c01039b5 <vma_create>
c0103de0:	89 45 dc             	mov    %eax,-0x24(%ebp)
        assert(vma != NULL);
c0103de3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103de7:	75 24                	jne    c0103e0d <check_vma_struct+0xb8>
c0103de9:	c7 44 24 0c d2 9f 10 	movl   $0xc0109fd2,0xc(%esp)
c0103df0:	c0 
c0103df1:	c7 44 24 08 07 9f 10 	movl   $0xc0109f07,0x8(%esp)
c0103df8:	c0 
c0103df9:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
c0103e00:	00 
c0103e01:	c7 04 24 1c 9f 10 c0 	movl   $0xc0109f1c,(%esp)
c0103e08:	e8 eb c5 ff ff       	call   c01003f8 <__panic>
        insert_vma_struct(mm, vma);
c0103e0d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103e10:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103e14:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103e17:	89 04 24             	mov    %eax,(%esp)
c0103e1a:	e8 26 fd ff ff       	call   c0103b45 <insert_vma_struct>
    for (i = step1; i >= 1; i --) {
c0103e1f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0103e23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103e27:	7f 8a                	jg     c0103db3 <check_vma_struct+0x5e>
    }

    for (i = step1 + 1; i <= step2; i ++) {
c0103e29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103e2c:	83 c0 01             	add    $0x1,%eax
c0103e2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103e32:	eb 70                	jmp    c0103ea4 <check_vma_struct+0x14f>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0103e34:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103e37:	89 d0                	mov    %edx,%eax
c0103e39:	c1 e0 02             	shl    $0x2,%eax
c0103e3c:	01 d0                	add    %edx,%eax
c0103e3e:	83 c0 02             	add    $0x2,%eax
c0103e41:	89 c1                	mov    %eax,%ecx
c0103e43:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103e46:	89 d0                	mov    %edx,%eax
c0103e48:	c1 e0 02             	shl    $0x2,%eax
c0103e4b:	01 d0                	add    %edx,%eax
c0103e4d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103e54:	00 
c0103e55:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0103e59:	89 04 24             	mov    %eax,(%esp)
c0103e5c:	e8 54 fb ff ff       	call   c01039b5 <vma_create>
c0103e61:	89 45 d8             	mov    %eax,-0x28(%ebp)
        assert(vma != NULL);
c0103e64:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0103e68:	75 24                	jne    c0103e8e <check_vma_struct+0x139>
c0103e6a:	c7 44 24 0c d2 9f 10 	movl   $0xc0109fd2,0xc(%esp)
c0103e71:	c0 
c0103e72:	c7 44 24 08 07 9f 10 	movl   $0xc0109f07,0x8(%esp)
c0103e79:	c0 
c0103e7a:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c0103e81:	00 
c0103e82:	c7 04 24 1c 9f 10 c0 	movl   $0xc0109f1c,(%esp)
c0103e89:	e8 6a c5 ff ff       	call   c01003f8 <__panic>
        insert_vma_struct(mm, vma);
c0103e8e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103e91:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103e95:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103e98:	89 04 24             	mov    %eax,(%esp)
c0103e9b:	e8 a5 fc ff ff       	call   c0103b45 <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i ++) {
c0103ea0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103ea4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ea7:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0103eaa:	7e 88                	jle    c0103e34 <check_vma_struct+0xdf>
    }

    list_entry_t *le = list_next(&(mm->mmap_list));
c0103eac:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103eaf:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0103eb2:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103eb5:	8b 40 04             	mov    0x4(%eax),%eax
c0103eb8:	89 45 f0             	mov    %eax,-0x10(%ebp)

    for (i = 1; i <= step2; i ++) {
c0103ebb:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
c0103ec2:	e9 97 00 00 00       	jmp    c0103f5e <check_vma_struct+0x209>
        assert(le != &(mm->mmap_list));
c0103ec7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103eca:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103ecd:	75 24                	jne    c0103ef3 <check_vma_struct+0x19e>
c0103ecf:	c7 44 24 0c de 9f 10 	movl   $0xc0109fde,0xc(%esp)
c0103ed6:	c0 
c0103ed7:	c7 44 24 08 07 9f 10 	movl   $0xc0109f07,0x8(%esp)
c0103ede:	c0 
c0103edf:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c0103ee6:	00 
c0103ee7:	c7 04 24 1c 9f 10 c0 	movl   $0xc0109f1c,(%esp)
c0103eee:	e8 05 c5 ff ff       	call   c01003f8 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
c0103ef3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ef6:	83 e8 10             	sub    $0x10,%eax
c0103ef9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
c0103efc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103eff:	8b 48 04             	mov    0x4(%eax),%ecx
c0103f02:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103f05:	89 d0                	mov    %edx,%eax
c0103f07:	c1 e0 02             	shl    $0x2,%eax
c0103f0a:	01 d0                	add    %edx,%eax
c0103f0c:	39 c1                	cmp    %eax,%ecx
c0103f0e:	75 17                	jne    c0103f27 <check_vma_struct+0x1d2>
c0103f10:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103f13:	8b 48 08             	mov    0x8(%eax),%ecx
c0103f16:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103f19:	89 d0                	mov    %edx,%eax
c0103f1b:	c1 e0 02             	shl    $0x2,%eax
c0103f1e:	01 d0                	add    %edx,%eax
c0103f20:	83 c0 02             	add    $0x2,%eax
c0103f23:	39 c1                	cmp    %eax,%ecx
c0103f25:	74 24                	je     c0103f4b <check_vma_struct+0x1f6>
c0103f27:	c7 44 24 0c f8 9f 10 	movl   $0xc0109ff8,0xc(%esp)
c0103f2e:	c0 
c0103f2f:	c7 44 24 08 07 9f 10 	movl   $0xc0109f07,0x8(%esp)
c0103f36:	c0 
c0103f37:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c0103f3e:	00 
c0103f3f:	c7 04 24 1c 9f 10 c0 	movl   $0xc0109f1c,(%esp)
c0103f46:	e8 ad c4 ff ff       	call   c01003f8 <__panic>
c0103f4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103f4e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c0103f51:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103f54:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0103f57:	89 45 f0             	mov    %eax,-0x10(%ebp)
    for (i = 1; i <= step2; i ++) {
c0103f5a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103f5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103f61:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0103f64:	0f 8e 5d ff ff ff    	jle    c0103ec7 <check_vma_struct+0x172>
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c0103f6a:	c7 45 f4 05 00 00 00 	movl   $0x5,-0xc(%ebp)
c0103f71:	e9 cd 01 00 00       	jmp    c0104143 <check_vma_struct+0x3ee>
        struct vma_struct *vma1 = find_vma(mm, i);
c0103f76:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103f79:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103f7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103f80:	89 04 24             	mov    %eax,(%esp)
c0103f83:	e8 68 fa ff ff       	call   c01039f0 <find_vma>
c0103f88:	89 45 d0             	mov    %eax,-0x30(%ebp)
        assert(vma1 != NULL);
c0103f8b:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0103f8f:	75 24                	jne    c0103fb5 <check_vma_struct+0x260>
c0103f91:	c7 44 24 0c 2d a0 10 	movl   $0xc010a02d,0xc(%esp)
c0103f98:	c0 
c0103f99:	c7 44 24 08 07 9f 10 	movl   $0xc0109f07,0x8(%esp)
c0103fa0:	c0 
c0103fa1:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
c0103fa8:	00 
c0103fa9:	c7 04 24 1c 9f 10 c0 	movl   $0xc0109f1c,(%esp)
c0103fb0:	e8 43 c4 ff ff       	call   c01003f8 <__panic>
        struct vma_struct *vma2 = find_vma(mm, i+1);
c0103fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103fb8:	83 c0 01             	add    $0x1,%eax
c0103fbb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103fbf:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103fc2:	89 04 24             	mov    %eax,(%esp)
c0103fc5:	e8 26 fa ff ff       	call   c01039f0 <find_vma>
c0103fca:	89 45 cc             	mov    %eax,-0x34(%ebp)
        assert(vma2 != NULL);
c0103fcd:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0103fd1:	75 24                	jne    c0103ff7 <check_vma_struct+0x2a2>
c0103fd3:	c7 44 24 0c 3a a0 10 	movl   $0xc010a03a,0xc(%esp)
c0103fda:	c0 
c0103fdb:	c7 44 24 08 07 9f 10 	movl   $0xc0109f07,0x8(%esp)
c0103fe2:	c0 
c0103fe3:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c0103fea:	00 
c0103feb:	c7 04 24 1c 9f 10 c0 	movl   $0xc0109f1c,(%esp)
c0103ff2:	e8 01 c4 ff ff       	call   c01003f8 <__panic>
        struct vma_struct *vma3 = find_vma(mm, i+2);
c0103ff7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ffa:	83 c0 02             	add    $0x2,%eax
c0103ffd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104001:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104004:	89 04 24             	mov    %eax,(%esp)
c0104007:	e8 e4 f9 ff ff       	call   c01039f0 <find_vma>
c010400c:	89 45 c8             	mov    %eax,-0x38(%ebp)
        assert(vma3 == NULL);
c010400f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0104013:	74 24                	je     c0104039 <check_vma_struct+0x2e4>
c0104015:	c7 44 24 0c 47 a0 10 	movl   $0xc010a047,0xc(%esp)
c010401c:	c0 
c010401d:	c7 44 24 08 07 9f 10 	movl   $0xc0109f07,0x8(%esp)
c0104024:	c0 
c0104025:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c010402c:	00 
c010402d:	c7 04 24 1c 9f 10 c0 	movl   $0xc0109f1c,(%esp)
c0104034:	e8 bf c3 ff ff       	call   c01003f8 <__panic>
        struct vma_struct *vma4 = find_vma(mm, i+3);
c0104039:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010403c:	83 c0 03             	add    $0x3,%eax
c010403f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104043:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104046:	89 04 24             	mov    %eax,(%esp)
c0104049:	e8 a2 f9 ff ff       	call   c01039f0 <find_vma>
c010404e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        assert(vma4 == NULL);
c0104051:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c0104055:	74 24                	je     c010407b <check_vma_struct+0x326>
c0104057:	c7 44 24 0c 54 a0 10 	movl   $0xc010a054,0xc(%esp)
c010405e:	c0 
c010405f:	c7 44 24 08 07 9f 10 	movl   $0xc0109f07,0x8(%esp)
c0104066:	c0 
c0104067:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
c010406e:	00 
c010406f:	c7 04 24 1c 9f 10 c0 	movl   $0xc0109f1c,(%esp)
c0104076:	e8 7d c3 ff ff       	call   c01003f8 <__panic>
        struct vma_struct *vma5 = find_vma(mm, i+4);
c010407b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010407e:	83 c0 04             	add    $0x4,%eax
c0104081:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104085:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104088:	89 04 24             	mov    %eax,(%esp)
c010408b:	e8 60 f9 ff ff       	call   c01039f0 <find_vma>
c0104090:	89 45 c0             	mov    %eax,-0x40(%ebp)
        assert(vma5 == NULL);
c0104093:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c0104097:	74 24                	je     c01040bd <check_vma_struct+0x368>
c0104099:	c7 44 24 0c 61 a0 10 	movl   $0xc010a061,0xc(%esp)
c01040a0:	c0 
c01040a1:	c7 44 24 08 07 9f 10 	movl   $0xc0109f07,0x8(%esp)
c01040a8:	c0 
c01040a9:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c01040b0:	00 
c01040b1:	c7 04 24 1c 9f 10 c0 	movl   $0xc0109f1c,(%esp)
c01040b8:	e8 3b c3 ff ff       	call   c01003f8 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
c01040bd:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01040c0:	8b 50 04             	mov    0x4(%eax),%edx
c01040c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01040c6:	39 c2                	cmp    %eax,%edx
c01040c8:	75 10                	jne    c01040da <check_vma_struct+0x385>
c01040ca:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01040cd:	8b 50 08             	mov    0x8(%eax),%edx
c01040d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01040d3:	83 c0 02             	add    $0x2,%eax
c01040d6:	39 c2                	cmp    %eax,%edx
c01040d8:	74 24                	je     c01040fe <check_vma_struct+0x3a9>
c01040da:	c7 44 24 0c 70 a0 10 	movl   $0xc010a070,0xc(%esp)
c01040e1:	c0 
c01040e2:	c7 44 24 08 07 9f 10 	movl   $0xc0109f07,0x8(%esp)
c01040e9:	c0 
c01040ea:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c01040f1:	00 
c01040f2:	c7 04 24 1c 9f 10 c0 	movl   $0xc0109f1c,(%esp)
c01040f9:	e8 fa c2 ff ff       	call   c01003f8 <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
c01040fe:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104101:	8b 50 04             	mov    0x4(%eax),%edx
c0104104:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104107:	39 c2                	cmp    %eax,%edx
c0104109:	75 10                	jne    c010411b <check_vma_struct+0x3c6>
c010410b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010410e:	8b 50 08             	mov    0x8(%eax),%edx
c0104111:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104114:	83 c0 02             	add    $0x2,%eax
c0104117:	39 c2                	cmp    %eax,%edx
c0104119:	74 24                	je     c010413f <check_vma_struct+0x3ea>
c010411b:	c7 44 24 0c a0 a0 10 	movl   $0xc010a0a0,0xc(%esp)
c0104122:	c0 
c0104123:	c7 44 24 08 07 9f 10 	movl   $0xc0109f07,0x8(%esp)
c010412a:	c0 
c010412b:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c0104132:	00 
c0104133:	c7 04 24 1c 9f 10 c0 	movl   $0xc0109f1c,(%esp)
c010413a:	e8 b9 c2 ff ff       	call   c01003f8 <__panic>
    for (i = 5; i <= 5 * step2; i +=5) {
c010413f:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
c0104143:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104146:	89 d0                	mov    %edx,%eax
c0104148:	c1 e0 02             	shl    $0x2,%eax
c010414b:	01 d0                	add    %edx,%eax
c010414d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104150:	0f 8d 20 fe ff ff    	jge    c0103f76 <check_vma_struct+0x221>
    }

    for (i =4; i>=0; i--) {
c0104156:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%ebp)
c010415d:	eb 70                	jmp    c01041cf <check_vma_struct+0x47a>
        struct vma_struct *vma_below_5= find_vma(mm,i);
c010415f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104162:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104166:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104169:	89 04 24             	mov    %eax,(%esp)
c010416c:	e8 7f f8 ff ff       	call   c01039f0 <find_vma>
c0104171:	89 45 bc             	mov    %eax,-0x44(%ebp)
        if (vma_below_5 != NULL ) {
c0104174:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0104178:	74 27                	je     c01041a1 <check_vma_struct+0x44c>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
c010417a:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010417d:	8b 50 08             	mov    0x8(%eax),%edx
c0104180:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104183:	8b 40 04             	mov    0x4(%eax),%eax
c0104186:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010418a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010418e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104191:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104195:	c7 04 24 d0 a0 10 c0 	movl   $0xc010a0d0,(%esp)
c010419c:	e8 00 c1 ff ff       	call   c01002a1 <cprintf>
        }
        assert(vma_below_5 == NULL);
c01041a1:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01041a5:	74 24                	je     c01041cb <check_vma_struct+0x476>
c01041a7:	c7 44 24 0c f5 a0 10 	movl   $0xc010a0f5,0xc(%esp)
c01041ae:	c0 
c01041af:	c7 44 24 08 07 9f 10 	movl   $0xc0109f07,0x8(%esp)
c01041b6:	c0 
c01041b7:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c01041be:	00 
c01041bf:	c7 04 24 1c 9f 10 c0 	movl   $0xc0109f1c,(%esp)
c01041c6:	e8 2d c2 ff ff       	call   c01003f8 <__panic>
    for (i =4; i>=0; i--) {
c01041cb:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01041cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01041d3:	79 8a                	jns    c010415f <check_vma_struct+0x40a>
    }

    mm_destroy(mm);
c01041d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01041d8:	89 04 24             	mov    %eax,(%esp)
c01041db:	e8 95 fa ff ff       	call   c0103c75 <mm_destroy>

    assert(nr_free_pages_store == nr_free_pages());
c01041e0:	e8 56 2b 00 00       	call   c0106d3b <nr_free_pages>
c01041e5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01041e8:	74 24                	je     c010420e <check_vma_struct+0x4b9>
c01041ea:	c7 44 24 0c 88 9f 10 	movl   $0xc0109f88,0xc(%esp)
c01041f1:	c0 
c01041f2:	c7 44 24 08 07 9f 10 	movl   $0xc0109f07,0x8(%esp)
c01041f9:	c0 
c01041fa:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c0104201:	00 
c0104202:	c7 04 24 1c 9f 10 c0 	movl   $0xc0109f1c,(%esp)
c0104209:	e8 ea c1 ff ff       	call   c01003f8 <__panic>

    cprintf("check_vma_struct() succeeded!\n");
c010420e:	c7 04 24 0c a1 10 c0 	movl   $0xc010a10c,(%esp)
c0104215:	e8 87 c0 ff ff       	call   c01002a1 <cprintf>
}
c010421a:	c9                   	leave  
c010421b:	c3                   	ret    

c010421c <check_pgfault>:

struct mm_struct *check_mm_struct;

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
c010421c:	55                   	push   %ebp
c010421d:	89 e5                	mov    %esp,%ebp
c010421f:	83 ec 38             	sub    $0x38,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0104222:	e8 14 2b 00 00       	call   c0106d3b <nr_free_pages>
c0104227:	89 45 ec             	mov    %eax,-0x14(%ebp)

    check_mm_struct = mm_create();
c010422a:	e8 0e f7 ff ff       	call   c010393d <mm_create>
c010422f:	a3 1c 50 12 c0       	mov    %eax,0xc012501c
    assert(check_mm_struct != NULL);
c0104234:	a1 1c 50 12 c0       	mov    0xc012501c,%eax
c0104239:	85 c0                	test   %eax,%eax
c010423b:	75 24                	jne    c0104261 <check_pgfault+0x45>
c010423d:	c7 44 24 0c 2b a1 10 	movl   $0xc010a12b,0xc(%esp)
c0104244:	c0 
c0104245:	c7 44 24 08 07 9f 10 	movl   $0xc0109f07,0x8(%esp)
c010424c:	c0 
c010424d:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
c0104254:	00 
c0104255:	c7 04 24 1c 9f 10 c0 	movl   $0xc0109f1c,(%esp)
c010425c:	e8 97 c1 ff ff       	call   c01003f8 <__panic>

    struct mm_struct *mm = check_mm_struct;
c0104261:	a1 1c 50 12 c0       	mov    0xc012501c,%eax
c0104266:	89 45 e8             	mov    %eax,-0x18(%ebp)
    pde_t *pgdir = mm->pgdir = boot_pgdir;
c0104269:	8b 15 20 1a 12 c0    	mov    0xc0121a20,%edx
c010426f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104272:	89 50 0c             	mov    %edx,0xc(%eax)
c0104275:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104278:	8b 40 0c             	mov    0xc(%eax),%eax
c010427b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(pgdir[0] == 0);
c010427e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104281:	8b 00                	mov    (%eax),%eax
c0104283:	85 c0                	test   %eax,%eax
c0104285:	74 24                	je     c01042ab <check_pgfault+0x8f>
c0104287:	c7 44 24 0c 43 a1 10 	movl   $0xc010a143,0xc(%esp)
c010428e:	c0 
c010428f:	c7 44 24 08 07 9f 10 	movl   $0xc0109f07,0x8(%esp)
c0104296:	c0 
c0104297:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c010429e:	00 
c010429f:	c7 04 24 1c 9f 10 c0 	movl   $0xc0109f1c,(%esp)
c01042a6:	e8 4d c1 ff ff       	call   c01003f8 <__panic>

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
c01042ab:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
c01042b2:	00 
c01042b3:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
c01042ba:	00 
c01042bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01042c2:	e8 ee f6 ff ff       	call   c01039b5 <vma_create>
c01042c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(vma != NULL);
c01042ca:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01042ce:	75 24                	jne    c01042f4 <check_pgfault+0xd8>
c01042d0:	c7 44 24 0c d2 9f 10 	movl   $0xc0109fd2,0xc(%esp)
c01042d7:	c0 
c01042d8:	c7 44 24 08 07 9f 10 	movl   $0xc0109f07,0x8(%esp)
c01042df:	c0 
c01042e0:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c01042e7:	00 
c01042e8:	c7 04 24 1c 9f 10 c0 	movl   $0xc0109f1c,(%esp)
c01042ef:	e8 04 c1 ff ff       	call   c01003f8 <__panic>

    insert_vma_struct(mm, vma);
c01042f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01042f7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01042fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01042fe:	89 04 24             	mov    %eax,(%esp)
c0104301:	e8 3f f8 ff ff       	call   c0103b45 <insert_vma_struct>

    uintptr_t addr = 0x100;
c0104306:	c7 45 dc 00 01 00 00 	movl   $0x100,-0x24(%ebp)
    assert(find_vma(mm, addr) == vma);
c010430d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104310:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104314:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104317:	89 04 24             	mov    %eax,(%esp)
c010431a:	e8 d1 f6 ff ff       	call   c01039f0 <find_vma>
c010431f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0104322:	74 24                	je     c0104348 <check_pgfault+0x12c>
c0104324:	c7 44 24 0c 51 a1 10 	movl   $0xc010a151,0xc(%esp)
c010432b:	c0 
c010432c:	c7 44 24 08 07 9f 10 	movl   $0xc0109f07,0x8(%esp)
c0104333:	c0 
c0104334:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c010433b:	00 
c010433c:	c7 04 24 1c 9f 10 c0 	movl   $0xc0109f1c,(%esp)
c0104343:	e8 b0 c0 ff ff       	call   c01003f8 <__panic>

    int i, sum = 0;
c0104348:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c010434f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104356:	eb 17                	jmp    c010436f <check_pgfault+0x153>
        *(char *)(addr + i) = i;
c0104358:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010435b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010435e:	01 d0                	add    %edx,%eax
c0104360:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104363:	88 10                	mov    %dl,(%eax)
        sum += i;
c0104365:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104368:	01 45 f0             	add    %eax,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c010436b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010436f:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0104373:	7e e3                	jle    c0104358 <check_pgfault+0x13c>
    }
    for (i = 0; i < 100; i ++) {
c0104375:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010437c:	eb 15                	jmp    c0104393 <check_pgfault+0x177>
        sum -= *(char *)(addr + i);
c010437e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104381:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104384:	01 d0                	add    %edx,%eax
c0104386:	0f b6 00             	movzbl (%eax),%eax
c0104389:	0f be c0             	movsbl %al,%eax
c010438c:	29 45 f0             	sub    %eax,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c010438f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0104393:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0104397:	7e e5                	jle    c010437e <check_pgfault+0x162>
    }
    assert(sum == 0);
c0104399:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010439d:	74 24                	je     c01043c3 <check_pgfault+0x1a7>
c010439f:	c7 44 24 0c 6b a1 10 	movl   $0xc010a16b,0xc(%esp)
c01043a6:	c0 
c01043a7:	c7 44 24 08 07 9f 10 	movl   $0xc0109f07,0x8(%esp)
c01043ae:	c0 
c01043af:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c01043b6:	00 
c01043b7:	c7 04 24 1c 9f 10 c0 	movl   $0xc0109f1c,(%esp)
c01043be:	e8 35 c0 ff ff       	call   c01003f8 <__panic>

    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
c01043c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01043c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01043c9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01043cc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01043d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01043d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01043d8:	89 04 24             	mov    %eax,(%esp)
c01043db:	e8 8f 31 00 00       	call   c010756f <page_remove>
    free_page(pde2page(pgdir[0]));
c01043e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01043e3:	8b 00                	mov    (%eax),%eax
c01043e5:	89 04 24             	mov    %eax,(%esp)
c01043e8:	e8 38 f5 ff ff       	call   c0103925 <pde2page>
c01043ed:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01043f4:	00 
c01043f5:	89 04 24             	mov    %eax,(%esp)
c01043f8:	e8 0c 29 00 00       	call   c0106d09 <free_pages>
    pgdir[0] = 0;
c01043fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104400:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    mm->pgdir = NULL;
c0104406:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104409:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    mm_destroy(mm);
c0104410:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104413:	89 04 24             	mov    %eax,(%esp)
c0104416:	e8 5a f8 ff ff       	call   c0103c75 <mm_destroy>
    check_mm_struct = NULL;
c010441b:	c7 05 1c 50 12 c0 00 	movl   $0x0,0xc012501c
c0104422:	00 00 00 

    assert(nr_free_pages_store == nr_free_pages());
c0104425:	e8 11 29 00 00       	call   c0106d3b <nr_free_pages>
c010442a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010442d:	74 24                	je     c0104453 <check_pgfault+0x237>
c010442f:	c7 44 24 0c 88 9f 10 	movl   $0xc0109f88,0xc(%esp)
c0104436:	c0 
c0104437:	c7 44 24 08 07 9f 10 	movl   $0xc0109f07,0x8(%esp)
c010443e:	c0 
c010443f:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
c0104446:	00 
c0104447:	c7 04 24 1c 9f 10 c0 	movl   $0xc0109f1c,(%esp)
c010444e:	e8 a5 bf ff ff       	call   c01003f8 <__panic>

    cprintf("check_pgfault() succeeded!\n");
c0104453:	c7 04 24 74 a1 10 c0 	movl   $0xc010a174,(%esp)
c010445a:	e8 42 be ff ff       	call   c01002a1 <cprintf>
}
c010445f:	c9                   	leave  
c0104460:	c3                   	ret    

c0104461 <do_pgfault>:
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
int
do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
c0104461:	55                   	push   %ebp
c0104462:	89 e5                	mov    %esp,%ebp
c0104464:	83 ec 38             	sub    $0x38,%esp
    int ret = -E_INVAL;
c0104467:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
c010446e:	8b 45 10             	mov    0x10(%ebp),%eax
c0104471:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104475:	8b 45 08             	mov    0x8(%ebp),%eax
c0104478:	89 04 24             	mov    %eax,(%esp)
c010447b:	e8 70 f5 ff ff       	call   c01039f0 <find_vma>
c0104480:	89 45 ec             	mov    %eax,-0x14(%ebp)

    pgfault_num++;
c0104483:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0104488:	83 c0 01             	add    $0x1,%eax
c010448b:	a3 64 4f 12 c0       	mov    %eax,0xc0124f64
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
c0104490:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104494:	74 0b                	je     c01044a1 <do_pgfault+0x40>
c0104496:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104499:	8b 40 04             	mov    0x4(%eax),%eax
c010449c:	3b 45 10             	cmp    0x10(%ebp),%eax
c010449f:	76 18                	jbe    c01044b9 <do_pgfault+0x58>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
c01044a1:	8b 45 10             	mov    0x10(%ebp),%eax
c01044a4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01044a8:	c7 04 24 90 a1 10 c0 	movl   $0xc010a190,(%esp)
c01044af:	e8 ed bd ff ff       	call   c01002a1 <cprintf>
        goto failed;
c01044b4:	e9 98 01 00 00       	jmp    c0104651 <do_pgfault+0x1f0>
    }
    //check the error_code
    switch (error_code & 3) {
c01044b9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01044bc:	83 e0 03             	and    $0x3,%eax
c01044bf:	85 c0                	test   %eax,%eax
c01044c1:	74 36                	je     c01044f9 <do_pgfault+0x98>
c01044c3:	83 f8 01             	cmp    $0x1,%eax
c01044c6:	74 20                	je     c01044e8 <do_pgfault+0x87>
    default:
            /* error code flag : default is 3 ( W/R=1, P=1): write, present */
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
c01044c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01044cb:	8b 40 0c             	mov    0xc(%eax),%eax
c01044ce:	83 e0 02             	and    $0x2,%eax
c01044d1:	85 c0                	test   %eax,%eax
c01044d3:	75 11                	jne    c01044e6 <do_pgfault+0x85>
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
c01044d5:	c7 04 24 c0 a1 10 c0 	movl   $0xc010a1c0,(%esp)
c01044dc:	e8 c0 bd ff ff       	call   c01002a1 <cprintf>
            goto failed;
c01044e1:	e9 6b 01 00 00       	jmp    c0104651 <do_pgfault+0x1f0>
        }
        break;
c01044e6:	eb 2f                	jmp    c0104517 <do_pgfault+0xb6>
    case 1: /* error code flag : (W/R=0, P=1): read, present */
        cprintf("do_pgfault failed: error code flag = read AND present\n");
c01044e8:	c7 04 24 20 a2 10 c0 	movl   $0xc010a220,(%esp)
c01044ef:	e8 ad bd ff ff       	call   c01002a1 <cprintf>
        goto failed;
c01044f4:	e9 58 01 00 00       	jmp    c0104651 <do_pgfault+0x1f0>
    case 0: /* error code flag : (W/R=0, P=0): read, not present */
        if (!(vma->vm_flags & (VM_READ | VM_EXEC))) {
c01044f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01044fc:	8b 40 0c             	mov    0xc(%eax),%eax
c01044ff:	83 e0 05             	and    $0x5,%eax
c0104502:	85 c0                	test   %eax,%eax
c0104504:	75 11                	jne    c0104517 <do_pgfault+0xb6>
            cprintf("do_pgfault failed: error code flag = read AND not present, but the addr's vma cannot read or exec\n");
c0104506:	c7 04 24 58 a2 10 c0 	movl   $0xc010a258,(%esp)
c010450d:	e8 8f bd ff ff       	call   c01002a1 <cprintf>
            goto failed;
c0104512:	e9 3a 01 00 00       	jmp    c0104651 <do_pgfault+0x1f0>
     *    (write an non_existed addr && addr is writable) OR
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    uint32_t perm = PTE_U;
c0104517:	c7 45 f0 04 00 00 00 	movl   $0x4,-0x10(%ebp)
    if (vma->vm_flags & VM_WRITE) {
c010451e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104521:	8b 40 0c             	mov    0xc(%eax),%eax
c0104524:	83 e0 02             	and    $0x2,%eax
c0104527:	85 c0                	test   %eax,%eax
c0104529:	74 04                	je     c010452f <do_pgfault+0xce>
        perm |= PTE_W;
c010452b:	83 4d f0 02          	orl    $0x2,-0x10(%ebp)
    }
    addr = ROUNDDOWN(addr, PGSIZE);
c010452f:	8b 45 10             	mov    0x10(%ebp),%eax
c0104532:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104535:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104538:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010453d:	89 45 10             	mov    %eax,0x10(%ebp)

    ret = -E_NO_MEM;
c0104540:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

    pte_t *ptep=NULL;
c0104547:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    * VARIABLES:
    *   mm->pgdir : the PDT of these vma
    *
    */
    /*LAB3 EXERCISE 1: YOUR CODE*/
ptep = get_pte(mm->pgdir,addr,1);//(1) 根据引发缺页异常的地址 去找到 地址所对应的 PTE 如果找不到 则创建一页表
c010454e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104551:	8b 40 0c             	mov    0xc(%eax),%eax
c0104554:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010455b:	00 
c010455c:	8b 55 10             	mov    0x10(%ebp),%edx
c010455f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104563:	89 04 24             	mov    %eax,(%esp)
c0104566:	e8 12 2e 00 00       	call   c010737d <get_pte>
c010456b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (*ptep == 0) {//(2) PTE 所指向的 物理页表地址 若不存在 则分配一物理页并将逻辑地址和物理地址作映射 (就是让 PTE 指向 物理页帧)
c010456e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104571:	8b 00                	mov    (%eax),%eax
c0104573:	85 c0                	test   %eax,%eax
c0104575:	75 29                	jne    c01045a0 <do_pgfault+0x13f>
        if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL) {
c0104577:	8b 45 08             	mov    0x8(%ebp),%eax
c010457a:	8b 40 0c             	mov    0xc(%eax),%eax
c010457d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104580:	89 54 24 08          	mov    %edx,0x8(%esp)
c0104584:	8b 55 10             	mov    0x10(%ebp),%edx
c0104587:	89 54 24 04          	mov    %edx,0x4(%esp)
c010458b:	89 04 24             	mov    %eax,(%esp)
c010458e:	e8 36 31 00 00       	call   c01076c9 <pgdir_alloc_page>
c0104593:	85 c0                	test   %eax,%eax
c0104595:	0f 85 af 00 00 00    	jne    c010464a <do_pgfault+0x1e9>
            goto failed;
c010459b:	e9 b1 00 00 00       	jmp    c0104651 <do_pgfault+0x1f0>
    *    swap_in(mm, addr, &page) : alloc a memory page, then according to the swap entry in PTE for addr,
    *                               find the addr of disk page, read the content of disk page into this memroy page
    *    page_insert ： build the map of phy addr of an Page with the linear addr la
    *    swap_map_swappable ： set the page swappable
    */
        if(swap_init_ok) {// 是否可以换入页面
c01045a0:	a1 68 4f 12 c0       	mov    0xc0124f68,%eax
c01045a5:	85 c0                	test   %eax,%eax
c01045a7:	0f 84 86 00 00 00    	je     c0104633 <do_pgfault+0x1d2>
            struct Page *page=NULL;
c01045ad:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
            ret = swap_in(mm, addr, &page); //(1）根据 PTE 找到 换出那页所在的硬盘地址 并将其从外存中换入
c01045b4:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01045b7:	89 44 24 08          	mov    %eax,0x8(%esp)
c01045bb:	8b 45 10             	mov    0x10(%ebp),%eax
c01045be:	89 44 24 04          	mov    %eax,0x4(%esp)
c01045c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01045c5:	89 04 24             	mov    %eax,(%esp)
c01045c8:	e8 95 03 00 00       	call   c0104962 <swap_in>
c01045cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (ret != 0) {
c01045d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01045d4:	74 0e                	je     c01045e4 <do_pgfault+0x183>
                cprintf("swap_in in do_pgfault failed\n");
c01045d6:	c7 04 24 bb a2 10 c0 	movl   $0xc010a2bb,(%esp)
c01045dd:	e8 bf bc ff ff       	call   c01002a1 <cprintf>
c01045e2:	eb 6d                	jmp    c0104651 <do_pgfault+0x1f0>
                goto failed;
            }
            page_insert(mm->pgdir, page, addr, perm); //(2) According to the mm, addr AND page, setup the map of phy addr <---> logical addr
c01045e4:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01045e7:	8b 45 08             	mov    0x8(%ebp),%eax
c01045ea:	8b 40 0c             	mov    0xc(%eax),%eax
c01045ed:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c01045f0:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01045f4:	8b 4d 10             	mov    0x10(%ebp),%ecx
c01045f7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01045fb:	89 54 24 04          	mov    %edx,0x4(%esp)
c01045ff:	89 04 24             	mov    %eax,(%esp)
c0104602:	e8 ac 2f 00 00       	call   c01075b3 <page_insert>
            
            swap_map_swappable(mm, addr, page, 0); //(3)使这一页可以置换
c0104607:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010460a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104611:	00 
c0104612:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104616:	8b 45 10             	mov    0x10(%ebp),%eax
c0104619:	89 44 24 04          	mov    %eax,0x4(%esp)
c010461d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104620:	89 04 24             	mov    %eax,(%esp)
c0104623:	e8 71 01 00 00       	call   c0104799 <swap_map_swappable>
            page->pra_vaddr = addr; //设置 这一页的虚拟地址
c0104628:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010462b:	8b 55 10             	mov    0x10(%ebp),%edx
c010462e:	89 50 1c             	mov    %edx,0x1c(%eax)
c0104631:	eb 17                	jmp    c010464a <do_pgfault+0x1e9>
        }
        else {
            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
c0104633:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104636:	8b 00                	mov    (%eax),%eax
c0104638:	89 44 24 04          	mov    %eax,0x4(%esp)
c010463c:	c7 04 24 dc a2 10 c0 	movl   $0xc010a2dc,(%esp)
c0104643:	e8 59 bc ff ff       	call   c01002a1 <cprintf>
            goto failed;
c0104648:	eb 07                	jmp    c0104651 <do_pgfault+0x1f0>
        }
   }
   ret = 0;
c010464a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
failed:
    return ret;
c0104651:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104654:	c9                   	leave  
c0104655:	c3                   	ret    

c0104656 <pa2page>:
pa2page(uintptr_t pa) {
c0104656:	55                   	push   %ebp
c0104657:	89 e5                	mov    %esp,%ebp
c0104659:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c010465c:	8b 45 08             	mov    0x8(%ebp),%eax
c010465f:	c1 e8 0c             	shr    $0xc,%eax
c0104662:	89 c2                	mov    %eax,%edx
c0104664:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0104669:	39 c2                	cmp    %eax,%edx
c010466b:	72 1c                	jb     c0104689 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c010466d:	c7 44 24 08 04 a3 10 	movl   $0xc010a304,0x8(%esp)
c0104674:	c0 
c0104675:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c010467c:	00 
c010467d:	c7 04 24 23 a3 10 c0 	movl   $0xc010a323,(%esp)
c0104684:	e8 6f bd ff ff       	call   c01003f8 <__panic>
    return &pages[PPN(pa)];
c0104689:	a1 f8 50 12 c0       	mov    0xc01250f8,%eax
c010468e:	8b 55 08             	mov    0x8(%ebp),%edx
c0104691:	c1 ea 0c             	shr    $0xc,%edx
c0104694:	c1 e2 05             	shl    $0x5,%edx
c0104697:	01 d0                	add    %edx,%eax
}
c0104699:	c9                   	leave  
c010469a:	c3                   	ret    

c010469b <pte2page>:
pte2page(pte_t pte) {
c010469b:	55                   	push   %ebp
c010469c:	89 e5                	mov    %esp,%ebp
c010469e:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c01046a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01046a4:	83 e0 01             	and    $0x1,%eax
c01046a7:	85 c0                	test   %eax,%eax
c01046a9:	75 1c                	jne    c01046c7 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c01046ab:	c7 44 24 08 34 a3 10 	movl   $0xc010a334,0x8(%esp)
c01046b2:	c0 
c01046b3:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c01046ba:	00 
c01046bb:	c7 04 24 23 a3 10 c0 	movl   $0xc010a323,(%esp)
c01046c2:	e8 31 bd ff ff       	call   c01003f8 <__panic>
    return pa2page(PTE_ADDR(pte));
c01046c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01046ca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01046cf:	89 04 24             	mov    %eax,(%esp)
c01046d2:	e8 7f ff ff ff       	call   c0104656 <pa2page>
}
c01046d7:	c9                   	leave  
c01046d8:	c3                   	ret    

c01046d9 <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
c01046d9:	55                   	push   %ebp
c01046da:	89 e5                	mov    %esp,%ebp
c01046dc:	83 ec 28             	sub    $0x28,%esp
     swapfs_init();
c01046df:	e8 1c 3f 00 00       	call   c0108600 <swapfs_init>

     if (!(1024 <= max_swap_offset && max_swap_offset < MAX_SWAP_OFFSET_LIMIT))
c01046e4:	a1 bc 50 12 c0       	mov    0xc01250bc,%eax
c01046e9:	3d ff 03 00 00       	cmp    $0x3ff,%eax
c01046ee:	76 0c                	jbe    c01046fc <swap_init+0x23>
c01046f0:	a1 bc 50 12 c0       	mov    0xc01250bc,%eax
c01046f5:	3d ff ff ff 00       	cmp    $0xffffff,%eax
c01046fa:	76 25                	jbe    c0104721 <swap_init+0x48>
     {
          panic("bad max_swap_offset %08x.\n", max_swap_offset);
c01046fc:	a1 bc 50 12 c0       	mov    0xc01250bc,%eax
c0104701:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104705:	c7 44 24 08 55 a3 10 	movl   $0xc010a355,0x8(%esp)
c010470c:	c0 
c010470d:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
c0104714:	00 
c0104715:	c7 04 24 70 a3 10 c0 	movl   $0xc010a370,(%esp)
c010471c:	e8 d7 bc ff ff       	call   c01003f8 <__panic>
     }
     

     //sm = &swap_manager_fifo;
     sm = &swap_manager_extended_clock;
c0104721:	c7 05 70 4f 12 c0 e0 	movl   $0xc01219e0,0xc0124f70
c0104728:	19 12 c0 
     
     int r = sm->init();
c010472b:	a1 70 4f 12 c0       	mov    0xc0124f70,%eax
c0104730:	8b 40 04             	mov    0x4(%eax),%eax
c0104733:	ff d0                	call   *%eax
c0104735:	89 45 f4             	mov    %eax,-0xc(%ebp)
     
     if (r == 0)
c0104738:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010473c:	75 26                	jne    c0104764 <swap_init+0x8b>
     {
          swap_init_ok = 1;
c010473e:	c7 05 68 4f 12 c0 01 	movl   $0x1,0xc0124f68
c0104745:	00 00 00 
          cprintf("SWAP: manager = %s\n", sm->name);
c0104748:	a1 70 4f 12 c0       	mov    0xc0124f70,%eax
c010474d:	8b 00                	mov    (%eax),%eax
c010474f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104753:	c7 04 24 7f a3 10 c0 	movl   $0xc010a37f,(%esp)
c010475a:	e8 42 bb ff ff       	call   c01002a1 <cprintf>
          check_swap();
c010475f:	e8 a4 04 00 00       	call   c0104c08 <check_swap>
     }

     return r;
c0104764:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104767:	c9                   	leave  
c0104768:	c3                   	ret    

c0104769 <swap_init_mm>:

int
swap_init_mm(struct mm_struct *mm)
{
c0104769:	55                   	push   %ebp
c010476a:	89 e5                	mov    %esp,%ebp
c010476c:	83 ec 18             	sub    $0x18,%esp
     return sm->init_mm(mm);
c010476f:	a1 70 4f 12 c0       	mov    0xc0124f70,%eax
c0104774:	8b 40 08             	mov    0x8(%eax),%eax
c0104777:	8b 55 08             	mov    0x8(%ebp),%edx
c010477a:	89 14 24             	mov    %edx,(%esp)
c010477d:	ff d0                	call   *%eax
}
c010477f:	c9                   	leave  
c0104780:	c3                   	ret    

c0104781 <swap_tick_event>:

int
swap_tick_event(struct mm_struct *mm)
{
c0104781:	55                   	push   %ebp
c0104782:	89 e5                	mov    %esp,%ebp
c0104784:	83 ec 18             	sub    $0x18,%esp
     return sm->tick_event(mm);
c0104787:	a1 70 4f 12 c0       	mov    0xc0124f70,%eax
c010478c:	8b 40 0c             	mov    0xc(%eax),%eax
c010478f:	8b 55 08             	mov    0x8(%ebp),%edx
c0104792:	89 14 24             	mov    %edx,(%esp)
c0104795:	ff d0                	call   *%eax
}
c0104797:	c9                   	leave  
c0104798:	c3                   	ret    

c0104799 <swap_map_swappable>:

int
swap_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0104799:	55                   	push   %ebp
c010479a:	89 e5                	mov    %esp,%ebp
c010479c:	83 ec 18             	sub    $0x18,%esp
     return sm->map_swappable(mm, addr, page, swap_in);
c010479f:	a1 70 4f 12 c0       	mov    0xc0124f70,%eax
c01047a4:	8b 40 10             	mov    0x10(%eax),%eax
c01047a7:	8b 55 14             	mov    0x14(%ebp),%edx
c01047aa:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01047ae:	8b 55 10             	mov    0x10(%ebp),%edx
c01047b1:	89 54 24 08          	mov    %edx,0x8(%esp)
c01047b5:	8b 55 0c             	mov    0xc(%ebp),%edx
c01047b8:	89 54 24 04          	mov    %edx,0x4(%esp)
c01047bc:	8b 55 08             	mov    0x8(%ebp),%edx
c01047bf:	89 14 24             	mov    %edx,(%esp)
c01047c2:	ff d0                	call   *%eax
}
c01047c4:	c9                   	leave  
c01047c5:	c3                   	ret    

c01047c6 <swap_set_unswappable>:

int
swap_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c01047c6:	55                   	push   %ebp
c01047c7:	89 e5                	mov    %esp,%ebp
c01047c9:	83 ec 18             	sub    $0x18,%esp
     return sm->set_unswappable(mm, addr);
c01047cc:	a1 70 4f 12 c0       	mov    0xc0124f70,%eax
c01047d1:	8b 40 14             	mov    0x14(%eax),%eax
c01047d4:	8b 55 0c             	mov    0xc(%ebp),%edx
c01047d7:	89 54 24 04          	mov    %edx,0x4(%esp)
c01047db:	8b 55 08             	mov    0x8(%ebp),%edx
c01047de:	89 14 24             	mov    %edx,(%esp)
c01047e1:	ff d0                	call   *%eax
}
c01047e3:	c9                   	leave  
c01047e4:	c3                   	ret    

c01047e5 <swap_out>:

volatile unsigned int swap_out_num=0;

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
c01047e5:	55                   	push   %ebp
c01047e6:	89 e5                	mov    %esp,%ebp
c01047e8:	83 ec 38             	sub    $0x38,%esp
     int i;
     for (i = 0; i != n; ++ i)
c01047eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01047f2:	e9 5a 01 00 00       	jmp    c0104951 <swap_out+0x16c>
     {
          uintptr_t v;
          //struct Page **ptr_page=NULL;
          struct Page *page;
          // cprintf("i %d, SWAP: call swap_out_victim\n",i);
          int r = sm->swap_out_victim(mm, &page, in_tick);
c01047f7:	a1 70 4f 12 c0       	mov    0xc0124f70,%eax
c01047fc:	8b 40 18             	mov    0x18(%eax),%eax
c01047ff:	8b 55 10             	mov    0x10(%ebp),%edx
c0104802:	89 54 24 08          	mov    %edx,0x8(%esp)
c0104806:	8d 55 e4             	lea    -0x1c(%ebp),%edx
c0104809:	89 54 24 04          	mov    %edx,0x4(%esp)
c010480d:	8b 55 08             	mov    0x8(%ebp),%edx
c0104810:	89 14 24             	mov    %edx,(%esp)
c0104813:	ff d0                	call   *%eax
c0104815:	89 45 f0             	mov    %eax,-0x10(%ebp)
          if (r != 0) {
c0104818:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010481c:	74 18                	je     c0104836 <swap_out+0x51>
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
c010481e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104821:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104825:	c7 04 24 94 a3 10 c0 	movl   $0xc010a394,(%esp)
c010482c:	e8 70 ba ff ff       	call   c01002a1 <cprintf>
c0104831:	e9 27 01 00 00       	jmp    c010495d <swap_out+0x178>
          }          
          //assert(!PageReserved(page));

          //cprintf("SWAP: choose victim page 0x%08x\n", page);
          
          v=page->pra_vaddr; 
c0104836:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104839:	8b 40 1c             	mov    0x1c(%eax),%eax
c010483c:	89 45 ec             	mov    %eax,-0x14(%ebp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
c010483f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104842:	8b 40 0c             	mov    0xc(%eax),%eax
c0104845:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010484c:	00 
c010484d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104850:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104854:	89 04 24             	mov    %eax,(%esp)
c0104857:	e8 21 2b 00 00       	call   c010737d <get_pte>
c010485c:	89 45 e8             	mov    %eax,-0x18(%ebp)
          assert((*ptep & PTE_P) != 0);
c010485f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104862:	8b 00                	mov    (%eax),%eax
c0104864:	83 e0 01             	and    $0x1,%eax
c0104867:	85 c0                	test   %eax,%eax
c0104869:	75 24                	jne    c010488f <swap_out+0xaa>
c010486b:	c7 44 24 0c c1 a3 10 	movl   $0xc010a3c1,0xc(%esp)
c0104872:	c0 
c0104873:	c7 44 24 08 d6 a3 10 	movl   $0xc010a3d6,0x8(%esp)
c010487a:	c0 
c010487b:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
c0104882:	00 
c0104883:	c7 04 24 70 a3 10 c0 	movl   $0xc010a370,(%esp)
c010488a:	e8 69 bb ff ff       	call   c01003f8 <__panic>

          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
c010488f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104892:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104895:	8b 52 1c             	mov    0x1c(%edx),%edx
c0104898:	c1 ea 0c             	shr    $0xc,%edx
c010489b:	83 c2 01             	add    $0x1,%edx
c010489e:	c1 e2 08             	shl    $0x8,%edx
c01048a1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01048a5:	89 14 24             	mov    %edx,(%esp)
c01048a8:	e8 0d 3e 00 00       	call   c01086ba <swapfs_write>
c01048ad:	85 c0                	test   %eax,%eax
c01048af:	74 34                	je     c01048e5 <swap_out+0x100>
                    cprintf("SWAP: failed to save\n");
c01048b1:	c7 04 24 eb a3 10 c0 	movl   $0xc010a3eb,(%esp)
c01048b8:	e8 e4 b9 ff ff       	call   c01002a1 <cprintf>
                    sm->map_swappable(mm, v, page, 0);
c01048bd:	a1 70 4f 12 c0       	mov    0xc0124f70,%eax
c01048c2:	8b 40 10             	mov    0x10(%eax),%eax
c01048c5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01048c8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01048cf:	00 
c01048d0:	89 54 24 08          	mov    %edx,0x8(%esp)
c01048d4:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01048d7:	89 54 24 04          	mov    %edx,0x4(%esp)
c01048db:	8b 55 08             	mov    0x8(%ebp),%edx
c01048de:	89 14 24             	mov    %edx,(%esp)
c01048e1:	ff d0                	call   *%eax
c01048e3:	eb 68                	jmp    c010494d <swap_out+0x168>
                    continue;
          }
          else {
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
c01048e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01048e8:	8b 40 1c             	mov    0x1c(%eax),%eax
c01048eb:	c1 e8 0c             	shr    $0xc,%eax
c01048ee:	83 c0 01             	add    $0x1,%eax
c01048f1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01048f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01048f8:	89 44 24 08          	mov    %eax,0x8(%esp)
c01048fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048ff:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104903:	c7 04 24 04 a4 10 c0 	movl   $0xc010a404,(%esp)
c010490a:	e8 92 b9 ff ff       	call   c01002a1 <cprintf>
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
c010490f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104912:	8b 40 1c             	mov    0x1c(%eax),%eax
c0104915:	c1 e8 0c             	shr    $0xc,%eax
c0104918:	83 c0 01             	add    $0x1,%eax
c010491b:	c1 e0 08             	shl    $0x8,%eax
c010491e:	89 c2                	mov    %eax,%edx
c0104920:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104923:	89 10                	mov    %edx,(%eax)
                    free_page(page);
c0104925:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104928:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010492f:	00 
c0104930:	89 04 24             	mov    %eax,(%esp)
c0104933:	e8 d1 23 00 00       	call   c0106d09 <free_pages>
          }
          
          tlb_invalidate(mm->pgdir, v);
c0104938:	8b 45 08             	mov    0x8(%ebp),%eax
c010493b:	8b 40 0c             	mov    0xc(%eax),%eax
c010493e:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104941:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104945:	89 04 24             	mov    %eax,(%esp)
c0104948:	e8 1f 2d 00 00       	call   c010766c <tlb_invalidate>
     for (i = 0; i != n; ++ i)
c010494d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0104951:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104954:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104957:	0f 85 9a fe ff ff    	jne    c01047f7 <swap_out+0x12>
     }
     return i;
c010495d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104960:	c9                   	leave  
c0104961:	c3                   	ret    

c0104962 <swap_in>:

int
swap_in(struct mm_struct *mm, uintptr_t addr, struct Page **ptr_result)
{
c0104962:	55                   	push   %ebp
c0104963:	89 e5                	mov    %esp,%ebp
c0104965:	83 ec 28             	sub    $0x28,%esp
     struct Page *result = alloc_page();
c0104968:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010496f:	e8 2a 23 00 00       	call   c0106c9e <alloc_pages>
c0104974:	89 45 f4             	mov    %eax,-0xc(%ebp)
     assert(result!=NULL);
c0104977:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010497b:	75 24                	jne    c01049a1 <swap_in+0x3f>
c010497d:	c7 44 24 0c 44 a4 10 	movl   $0xc010a444,0xc(%esp)
c0104984:	c0 
c0104985:	c7 44 24 08 d6 a3 10 	movl   $0xc010a3d6,0x8(%esp)
c010498c:	c0 
c010498d:	c7 44 24 04 7e 00 00 	movl   $0x7e,0x4(%esp)
c0104994:	00 
c0104995:	c7 04 24 70 a3 10 c0 	movl   $0xc010a370,(%esp)
c010499c:	e8 57 ba ff ff       	call   c01003f8 <__panic>

     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
c01049a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01049a4:	8b 40 0c             	mov    0xc(%eax),%eax
c01049a7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01049ae:	00 
c01049af:	8b 55 0c             	mov    0xc(%ebp),%edx
c01049b2:	89 54 24 04          	mov    %edx,0x4(%esp)
c01049b6:	89 04 24             	mov    %eax,(%esp)
c01049b9:	e8 bf 29 00 00       	call   c010737d <get_pte>
c01049be:	89 45 f0             	mov    %eax,-0x10(%ebp)
     // cprintf("SWAP: load ptep %x swap entry %d to vaddr 0x%08x, page %x, No %d\n", ptep, (*ptep)>>8, addr, result, (result-pages));
    
     int r;
     if ((r = swapfs_read((*ptep), result)) != 0)
c01049c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049c4:	8b 00                	mov    (%eax),%eax
c01049c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01049c9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01049cd:	89 04 24             	mov    %eax,(%esp)
c01049d0:	e8 73 3c 00 00       	call   c0108648 <swapfs_read>
c01049d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01049d8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01049dc:	74 2a                	je     c0104a08 <swap_in+0xa6>
     {
        assert(r!=0);
c01049de:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01049e2:	75 24                	jne    c0104a08 <swap_in+0xa6>
c01049e4:	c7 44 24 0c 51 a4 10 	movl   $0xc010a451,0xc(%esp)
c01049eb:	c0 
c01049ec:	c7 44 24 08 d6 a3 10 	movl   $0xc010a3d6,0x8(%esp)
c01049f3:	c0 
c01049f4:	c7 44 24 04 86 00 00 	movl   $0x86,0x4(%esp)
c01049fb:	00 
c01049fc:	c7 04 24 70 a3 10 c0 	movl   $0xc010a370,(%esp)
c0104a03:	e8 f0 b9 ff ff       	call   c01003f8 <__panic>
     }
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
c0104a08:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a0b:	8b 00                	mov    (%eax),%eax
c0104a0d:	c1 e8 08             	shr    $0x8,%eax
c0104a10:	89 c2                	mov    %eax,%edx
c0104a12:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104a15:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104a19:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104a1d:	c7 04 24 58 a4 10 c0 	movl   $0xc010a458,(%esp)
c0104a24:	e8 78 b8 ff ff       	call   c01002a1 <cprintf>
     *ptr_result=result;
c0104a29:	8b 45 10             	mov    0x10(%ebp),%eax
c0104a2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104a2f:	89 10                	mov    %edx,(%eax)
     return 0;
c0104a31:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104a36:	c9                   	leave  
c0104a37:	c3                   	ret    

c0104a38 <check_content_set>:



static inline void
check_content_set(void)
{
c0104a38:	55                   	push   %ebp
c0104a39:	89 e5                	mov    %esp,%ebp
c0104a3b:	83 ec 18             	sub    $0x18,%esp
     *(unsigned char *)0x1000 = 0x0a;
c0104a3e:	b8 00 10 00 00       	mov    $0x1000,%eax
c0104a43:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c0104a46:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0104a4b:	83 f8 01             	cmp    $0x1,%eax
c0104a4e:	74 24                	je     c0104a74 <check_content_set+0x3c>
c0104a50:	c7 44 24 0c 96 a4 10 	movl   $0xc010a496,0xc(%esp)
c0104a57:	c0 
c0104a58:	c7 44 24 08 d6 a3 10 	movl   $0xc010a3d6,0x8(%esp)
c0104a5f:	c0 
c0104a60:	c7 44 24 04 93 00 00 	movl   $0x93,0x4(%esp)
c0104a67:	00 
c0104a68:	c7 04 24 70 a3 10 c0 	movl   $0xc010a370,(%esp)
c0104a6f:	e8 84 b9 ff ff       	call   c01003f8 <__panic>
     *(unsigned char *)0x1010 = 0x0a;
c0104a74:	b8 10 10 00 00       	mov    $0x1010,%eax
c0104a79:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c0104a7c:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0104a81:	83 f8 01             	cmp    $0x1,%eax
c0104a84:	74 24                	je     c0104aaa <check_content_set+0x72>
c0104a86:	c7 44 24 0c 96 a4 10 	movl   $0xc010a496,0xc(%esp)
c0104a8d:	c0 
c0104a8e:	c7 44 24 08 d6 a3 10 	movl   $0xc010a3d6,0x8(%esp)
c0104a95:	c0 
c0104a96:	c7 44 24 04 95 00 00 	movl   $0x95,0x4(%esp)
c0104a9d:	00 
c0104a9e:	c7 04 24 70 a3 10 c0 	movl   $0xc010a370,(%esp)
c0104aa5:	e8 4e b9 ff ff       	call   c01003f8 <__panic>
     *(unsigned char *)0x2000 = 0x0b;
c0104aaa:	b8 00 20 00 00       	mov    $0x2000,%eax
c0104aaf:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c0104ab2:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0104ab7:	83 f8 02             	cmp    $0x2,%eax
c0104aba:	74 24                	je     c0104ae0 <check_content_set+0xa8>
c0104abc:	c7 44 24 0c a5 a4 10 	movl   $0xc010a4a5,0xc(%esp)
c0104ac3:	c0 
c0104ac4:	c7 44 24 08 d6 a3 10 	movl   $0xc010a3d6,0x8(%esp)
c0104acb:	c0 
c0104acc:	c7 44 24 04 97 00 00 	movl   $0x97,0x4(%esp)
c0104ad3:	00 
c0104ad4:	c7 04 24 70 a3 10 c0 	movl   $0xc010a370,(%esp)
c0104adb:	e8 18 b9 ff ff       	call   c01003f8 <__panic>
     *(unsigned char *)0x2010 = 0x0b;
c0104ae0:	b8 10 20 00 00       	mov    $0x2010,%eax
c0104ae5:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c0104ae8:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0104aed:	83 f8 02             	cmp    $0x2,%eax
c0104af0:	74 24                	je     c0104b16 <check_content_set+0xde>
c0104af2:	c7 44 24 0c a5 a4 10 	movl   $0xc010a4a5,0xc(%esp)
c0104af9:	c0 
c0104afa:	c7 44 24 08 d6 a3 10 	movl   $0xc010a3d6,0x8(%esp)
c0104b01:	c0 
c0104b02:	c7 44 24 04 99 00 00 	movl   $0x99,0x4(%esp)
c0104b09:	00 
c0104b0a:	c7 04 24 70 a3 10 c0 	movl   $0xc010a370,(%esp)
c0104b11:	e8 e2 b8 ff ff       	call   c01003f8 <__panic>
     *(unsigned char *)0x3000 = 0x0c;
c0104b16:	b8 00 30 00 00       	mov    $0x3000,%eax
c0104b1b:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c0104b1e:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0104b23:	83 f8 03             	cmp    $0x3,%eax
c0104b26:	74 24                	je     c0104b4c <check_content_set+0x114>
c0104b28:	c7 44 24 0c b4 a4 10 	movl   $0xc010a4b4,0xc(%esp)
c0104b2f:	c0 
c0104b30:	c7 44 24 08 d6 a3 10 	movl   $0xc010a3d6,0x8(%esp)
c0104b37:	c0 
c0104b38:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
c0104b3f:	00 
c0104b40:	c7 04 24 70 a3 10 c0 	movl   $0xc010a370,(%esp)
c0104b47:	e8 ac b8 ff ff       	call   c01003f8 <__panic>
     *(unsigned char *)0x3010 = 0x0c;
c0104b4c:	b8 10 30 00 00       	mov    $0x3010,%eax
c0104b51:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c0104b54:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0104b59:	83 f8 03             	cmp    $0x3,%eax
c0104b5c:	74 24                	je     c0104b82 <check_content_set+0x14a>
c0104b5e:	c7 44 24 0c b4 a4 10 	movl   $0xc010a4b4,0xc(%esp)
c0104b65:	c0 
c0104b66:	c7 44 24 08 d6 a3 10 	movl   $0xc010a3d6,0x8(%esp)
c0104b6d:	c0 
c0104b6e:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
c0104b75:	00 
c0104b76:	c7 04 24 70 a3 10 c0 	movl   $0xc010a370,(%esp)
c0104b7d:	e8 76 b8 ff ff       	call   c01003f8 <__panic>
     *(unsigned char *)0x4000 = 0x0d;
c0104b82:	b8 00 40 00 00       	mov    $0x4000,%eax
c0104b87:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c0104b8a:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0104b8f:	83 f8 04             	cmp    $0x4,%eax
c0104b92:	74 24                	je     c0104bb8 <check_content_set+0x180>
c0104b94:	c7 44 24 0c c3 a4 10 	movl   $0xc010a4c3,0xc(%esp)
c0104b9b:	c0 
c0104b9c:	c7 44 24 08 d6 a3 10 	movl   $0xc010a3d6,0x8(%esp)
c0104ba3:	c0 
c0104ba4:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c0104bab:	00 
c0104bac:	c7 04 24 70 a3 10 c0 	movl   $0xc010a370,(%esp)
c0104bb3:	e8 40 b8 ff ff       	call   c01003f8 <__panic>
     *(unsigned char *)0x4010 = 0x0d;
c0104bb8:	b8 10 40 00 00       	mov    $0x4010,%eax
c0104bbd:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c0104bc0:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0104bc5:	83 f8 04             	cmp    $0x4,%eax
c0104bc8:	74 24                	je     c0104bee <check_content_set+0x1b6>
c0104bca:	c7 44 24 0c c3 a4 10 	movl   $0xc010a4c3,0xc(%esp)
c0104bd1:	c0 
c0104bd2:	c7 44 24 08 d6 a3 10 	movl   $0xc010a3d6,0x8(%esp)
c0104bd9:	c0 
c0104bda:	c7 44 24 04 a1 00 00 	movl   $0xa1,0x4(%esp)
c0104be1:	00 
c0104be2:	c7 04 24 70 a3 10 c0 	movl   $0xc010a370,(%esp)
c0104be9:	e8 0a b8 ff ff       	call   c01003f8 <__panic>
}
c0104bee:	c9                   	leave  
c0104bef:	c3                   	ret    

c0104bf0 <check_content_access>:

static inline int
check_content_access(void)
{
c0104bf0:	55                   	push   %ebp
c0104bf1:	89 e5                	mov    %esp,%ebp
c0104bf3:	83 ec 18             	sub    $0x18,%esp
    int ret = sm->check_swap();
c0104bf6:	a1 70 4f 12 c0       	mov    0xc0124f70,%eax
c0104bfb:	8b 40 1c             	mov    0x1c(%eax),%eax
c0104bfe:	ff d0                	call   *%eax
c0104c00:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ret;
c0104c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104c06:	c9                   	leave  
c0104c07:	c3                   	ret    

c0104c08 <check_swap>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
check_swap(void)
{
c0104c08:	55                   	push   %ebp
c0104c09:	89 e5                	mov    %esp,%ebp
c0104c0b:	53                   	push   %ebx
c0104c0c:	83 ec 74             	sub    $0x74,%esp
    //backup mem env
     int ret, count = 0, total = 0, i;
c0104c0f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104c16:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     list_entry_t *le = &free_list;
c0104c1d:	c7 45 e8 e4 50 12 c0 	movl   $0xc01250e4,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c0104c24:	eb 6b                	jmp    c0104c91 <check_swap+0x89>
        struct Page *p = le2page(le, page_link);
c0104c26:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104c29:	83 e8 0c             	sub    $0xc,%eax
c0104c2c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
c0104c2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c32:	83 c0 04             	add    $0x4,%eax
c0104c35:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0104c3c:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104c3f:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104c42:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0104c45:	0f a3 10             	bt     %edx,(%eax)
c0104c48:	19 c0                	sbb    %eax,%eax
c0104c4a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    return oldbit != 0;
c0104c4d:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0104c51:	0f 95 c0             	setne  %al
c0104c54:	0f b6 c0             	movzbl %al,%eax
c0104c57:	85 c0                	test   %eax,%eax
c0104c59:	75 24                	jne    c0104c7f <check_swap+0x77>
c0104c5b:	c7 44 24 0c d2 a4 10 	movl   $0xc010a4d2,0xc(%esp)
c0104c62:	c0 
c0104c63:	c7 44 24 08 d6 a3 10 	movl   $0xc010a3d6,0x8(%esp)
c0104c6a:	c0 
c0104c6b:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0104c72:	00 
c0104c73:	c7 04 24 70 a3 10 c0 	movl   $0xc010a370,(%esp)
c0104c7a:	e8 79 b7 ff ff       	call   c01003f8 <__panic>
        count ++, total += p->property;
c0104c7f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0104c83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c86:	8b 50 08             	mov    0x8(%eax),%edx
c0104c89:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c8c:	01 d0                	add    %edx,%eax
c0104c8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104c91:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104c94:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0104c97:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104c9a:	8b 40 04             	mov    0x4(%eax),%eax
     while ((le = list_next(le)) != &free_list) {
c0104c9d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104ca0:	81 7d e8 e4 50 12 c0 	cmpl   $0xc01250e4,-0x18(%ebp)
c0104ca7:	0f 85 79 ff ff ff    	jne    c0104c26 <check_swap+0x1e>
     }
     assert(total == nr_free_pages());
c0104cad:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0104cb0:	e8 86 20 00 00       	call   c0106d3b <nr_free_pages>
c0104cb5:	39 c3                	cmp    %eax,%ebx
c0104cb7:	74 24                	je     c0104cdd <check_swap+0xd5>
c0104cb9:	c7 44 24 0c e2 a4 10 	movl   $0xc010a4e2,0xc(%esp)
c0104cc0:	c0 
c0104cc1:	c7 44 24 08 d6 a3 10 	movl   $0xc010a3d6,0x8(%esp)
c0104cc8:	c0 
c0104cc9:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
c0104cd0:	00 
c0104cd1:	c7 04 24 70 a3 10 c0 	movl   $0xc010a370,(%esp)
c0104cd8:	e8 1b b7 ff ff       	call   c01003f8 <__panic>
     cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
c0104cdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ce0:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ce7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104ceb:	c7 04 24 fc a4 10 c0 	movl   $0xc010a4fc,(%esp)
c0104cf2:	e8 aa b5 ff ff       	call   c01002a1 <cprintf>
     
     //now we set the phy pages env     
     struct mm_struct *mm = mm_create();
c0104cf7:	e8 41 ec ff ff       	call   c010393d <mm_create>
c0104cfc:	89 45 e0             	mov    %eax,-0x20(%ebp)
     assert(mm != NULL);
c0104cff:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104d03:	75 24                	jne    c0104d29 <check_swap+0x121>
c0104d05:	c7 44 24 0c 22 a5 10 	movl   $0xc010a522,0xc(%esp)
c0104d0c:	c0 
c0104d0d:	c7 44 24 08 d6 a3 10 	movl   $0xc010a3d6,0x8(%esp)
c0104d14:	c0 
c0104d15:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
c0104d1c:	00 
c0104d1d:	c7 04 24 70 a3 10 c0 	movl   $0xc010a370,(%esp)
c0104d24:	e8 cf b6 ff ff       	call   c01003f8 <__panic>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
c0104d29:	a1 1c 50 12 c0       	mov    0xc012501c,%eax
c0104d2e:	85 c0                	test   %eax,%eax
c0104d30:	74 24                	je     c0104d56 <check_swap+0x14e>
c0104d32:	c7 44 24 0c 2d a5 10 	movl   $0xc010a52d,0xc(%esp)
c0104d39:	c0 
c0104d3a:	c7 44 24 08 d6 a3 10 	movl   $0xc010a3d6,0x8(%esp)
c0104d41:	c0 
c0104d42:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c0104d49:	00 
c0104d4a:	c7 04 24 70 a3 10 c0 	movl   $0xc010a370,(%esp)
c0104d51:	e8 a2 b6 ff ff       	call   c01003f8 <__panic>

     check_mm_struct = mm;
c0104d56:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104d59:	a3 1c 50 12 c0       	mov    %eax,0xc012501c

     pde_t *pgdir = mm->pgdir = boot_pgdir;
c0104d5e:	8b 15 20 1a 12 c0    	mov    0xc0121a20,%edx
c0104d64:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104d67:	89 50 0c             	mov    %edx,0xc(%eax)
c0104d6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104d6d:	8b 40 0c             	mov    0xc(%eax),%eax
c0104d70:	89 45 dc             	mov    %eax,-0x24(%ebp)
     assert(pgdir[0] == 0);
c0104d73:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104d76:	8b 00                	mov    (%eax),%eax
c0104d78:	85 c0                	test   %eax,%eax
c0104d7a:	74 24                	je     c0104da0 <check_swap+0x198>
c0104d7c:	c7 44 24 0c 45 a5 10 	movl   $0xc010a545,0xc(%esp)
c0104d83:	c0 
c0104d84:	c7 44 24 08 d6 a3 10 	movl   $0xc010a3d6,0x8(%esp)
c0104d8b:	c0 
c0104d8c:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c0104d93:	00 
c0104d94:	c7 04 24 70 a3 10 c0 	movl   $0xc010a370,(%esp)
c0104d9b:	e8 58 b6 ff ff       	call   c01003f8 <__panic>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
c0104da0:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
c0104da7:	00 
c0104da8:	c7 44 24 04 00 60 00 	movl   $0x6000,0x4(%esp)
c0104daf:	00 
c0104db0:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
c0104db7:	e8 f9 eb ff ff       	call   c01039b5 <vma_create>
c0104dbc:	89 45 d8             	mov    %eax,-0x28(%ebp)
     assert(vma != NULL);
c0104dbf:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0104dc3:	75 24                	jne    c0104de9 <check_swap+0x1e1>
c0104dc5:	c7 44 24 0c 53 a5 10 	movl   $0xc010a553,0xc(%esp)
c0104dcc:	c0 
c0104dcd:	c7 44 24 08 d6 a3 10 	movl   $0xc010a3d6,0x8(%esp)
c0104dd4:	c0 
c0104dd5:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
c0104ddc:	00 
c0104ddd:	c7 04 24 70 a3 10 c0 	movl   $0xc010a370,(%esp)
c0104de4:	e8 0f b6 ff ff       	call   c01003f8 <__panic>

     insert_vma_struct(mm, vma);
c0104de9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104dec:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104df0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104df3:	89 04 24             	mov    %eax,(%esp)
c0104df6:	e8 4a ed ff ff       	call   c0103b45 <insert_vma_struct>

     //setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
c0104dfb:	c7 04 24 60 a5 10 c0 	movl   $0xc010a560,(%esp)
c0104e02:	e8 9a b4 ff ff       	call   c01002a1 <cprintf>
     pte_t *temp_ptep=NULL;
c0104e07:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
c0104e0e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104e11:	8b 40 0c             	mov    0xc(%eax),%eax
c0104e14:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104e1b:	00 
c0104e1c:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104e23:	00 
c0104e24:	89 04 24             	mov    %eax,(%esp)
c0104e27:	e8 51 25 00 00       	call   c010737d <get_pte>
c0104e2c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     assert(temp_ptep!= NULL);
c0104e2f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0104e33:	75 24                	jne    c0104e59 <check_swap+0x251>
c0104e35:	c7 44 24 0c 94 a5 10 	movl   $0xc010a594,0xc(%esp)
c0104e3c:	c0 
c0104e3d:	c7 44 24 08 d6 a3 10 	movl   $0xc010a3d6,0x8(%esp)
c0104e44:	c0 
c0104e45:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c0104e4c:	00 
c0104e4d:	c7 04 24 70 a3 10 c0 	movl   $0xc010a370,(%esp)
c0104e54:	e8 9f b5 ff ff       	call   c01003f8 <__panic>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
c0104e59:	c7 04 24 a8 a5 10 c0 	movl   $0xc010a5a8,(%esp)
c0104e60:	e8 3c b4 ff ff       	call   c01002a1 <cprintf>
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0104e65:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0104e6c:	e9 a3 00 00 00       	jmp    c0104f14 <check_swap+0x30c>
          check_rp[i] = alloc_page();
c0104e71:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104e78:	e8 21 1e 00 00       	call   c0106c9e <alloc_pages>
c0104e7d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104e80:	89 04 95 20 50 12 c0 	mov    %eax,-0x3fedafe0(,%edx,4)
          assert(check_rp[i] != NULL );
c0104e87:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104e8a:	8b 04 85 20 50 12 c0 	mov    -0x3fedafe0(,%eax,4),%eax
c0104e91:	85 c0                	test   %eax,%eax
c0104e93:	75 24                	jne    c0104eb9 <check_swap+0x2b1>
c0104e95:	c7 44 24 0c cc a5 10 	movl   $0xc010a5cc,0xc(%esp)
c0104e9c:	c0 
c0104e9d:	c7 44 24 08 d6 a3 10 	movl   $0xc010a3d6,0x8(%esp)
c0104ea4:	c0 
c0104ea5:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0104eac:	00 
c0104ead:	c7 04 24 70 a3 10 c0 	movl   $0xc010a370,(%esp)
c0104eb4:	e8 3f b5 ff ff       	call   c01003f8 <__panic>
          assert(!PageProperty(check_rp[i]));
c0104eb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104ebc:	8b 04 85 20 50 12 c0 	mov    -0x3fedafe0(,%eax,4),%eax
c0104ec3:	83 c0 04             	add    $0x4,%eax
c0104ec6:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
c0104ecd:	89 45 b0             	mov    %eax,-0x50(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104ed0:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104ed3:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0104ed6:	0f a3 10             	bt     %edx,(%eax)
c0104ed9:	19 c0                	sbb    %eax,%eax
c0104edb:	89 45 ac             	mov    %eax,-0x54(%ebp)
    return oldbit != 0;
c0104ede:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
c0104ee2:	0f 95 c0             	setne  %al
c0104ee5:	0f b6 c0             	movzbl %al,%eax
c0104ee8:	85 c0                	test   %eax,%eax
c0104eea:	74 24                	je     c0104f10 <check_swap+0x308>
c0104eec:	c7 44 24 0c e0 a5 10 	movl   $0xc010a5e0,0xc(%esp)
c0104ef3:	c0 
c0104ef4:	c7 44 24 08 d6 a3 10 	movl   $0xc010a3d6,0x8(%esp)
c0104efb:	c0 
c0104efc:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
c0104f03:	00 
c0104f04:	c7 04 24 70 a3 10 c0 	movl   $0xc010a370,(%esp)
c0104f0b:	e8 e8 b4 ff ff       	call   c01003f8 <__panic>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0104f10:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0104f14:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0104f18:	0f 8e 53 ff ff ff    	jle    c0104e71 <check_swap+0x269>
     }
     list_entry_t free_list_store = free_list;
c0104f1e:	a1 e4 50 12 c0       	mov    0xc01250e4,%eax
c0104f23:	8b 15 e8 50 12 c0    	mov    0xc01250e8,%edx
c0104f29:	89 45 98             	mov    %eax,-0x68(%ebp)
c0104f2c:	89 55 9c             	mov    %edx,-0x64(%ebp)
c0104f2f:	c7 45 a8 e4 50 12 c0 	movl   $0xc01250e4,-0x58(%ebp)
    elm->prev = elm->next = elm;
c0104f36:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104f39:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0104f3c:	89 50 04             	mov    %edx,0x4(%eax)
c0104f3f:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104f42:	8b 50 04             	mov    0x4(%eax),%edx
c0104f45:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104f48:	89 10                	mov    %edx,(%eax)
c0104f4a:	c7 45 a4 e4 50 12 c0 	movl   $0xc01250e4,-0x5c(%ebp)
    return list->next == list;
c0104f51:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104f54:	8b 40 04             	mov    0x4(%eax),%eax
c0104f57:	39 45 a4             	cmp    %eax,-0x5c(%ebp)
c0104f5a:	0f 94 c0             	sete   %al
c0104f5d:	0f b6 c0             	movzbl %al,%eax
     list_init(&free_list);
     assert(list_empty(&free_list));
c0104f60:	85 c0                	test   %eax,%eax
c0104f62:	75 24                	jne    c0104f88 <check_swap+0x380>
c0104f64:	c7 44 24 0c fb a5 10 	movl   $0xc010a5fb,0xc(%esp)
c0104f6b:	c0 
c0104f6c:	c7 44 24 08 d6 a3 10 	movl   $0xc010a3d6,0x8(%esp)
c0104f73:	c0 
c0104f74:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c0104f7b:	00 
c0104f7c:	c7 04 24 70 a3 10 c0 	movl   $0xc010a370,(%esp)
c0104f83:	e8 70 b4 ff ff       	call   c01003f8 <__panic>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
c0104f88:	a1 ec 50 12 c0       	mov    0xc01250ec,%eax
c0104f8d:	89 45 d0             	mov    %eax,-0x30(%ebp)
     nr_free = 0;
c0104f90:	c7 05 ec 50 12 c0 00 	movl   $0x0,0xc01250ec
c0104f97:	00 00 00 
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0104f9a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0104fa1:	eb 1e                	jmp    c0104fc1 <check_swap+0x3b9>
        free_pages(check_rp[i],1);
c0104fa3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104fa6:	8b 04 85 20 50 12 c0 	mov    -0x3fedafe0(,%eax,4),%eax
c0104fad:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104fb4:	00 
c0104fb5:	89 04 24             	mov    %eax,(%esp)
c0104fb8:	e8 4c 1d 00 00       	call   c0106d09 <free_pages>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0104fbd:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0104fc1:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0104fc5:	7e dc                	jle    c0104fa3 <check_swap+0x39b>
     }
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
c0104fc7:	a1 ec 50 12 c0       	mov    0xc01250ec,%eax
c0104fcc:	83 f8 04             	cmp    $0x4,%eax
c0104fcf:	74 24                	je     c0104ff5 <check_swap+0x3ed>
c0104fd1:	c7 44 24 0c 14 a6 10 	movl   $0xc010a614,0xc(%esp)
c0104fd8:	c0 
c0104fd9:	c7 44 24 08 d6 a3 10 	movl   $0xc010a3d6,0x8(%esp)
c0104fe0:	c0 
c0104fe1:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
c0104fe8:	00 
c0104fe9:	c7 04 24 70 a3 10 c0 	movl   $0xc010a370,(%esp)
c0104ff0:	e8 03 b4 ff ff       	call   c01003f8 <__panic>
     
     cprintf("set up init env for check_swap begin!\n");
c0104ff5:	c7 04 24 38 a6 10 c0 	movl   $0xc010a638,(%esp)
c0104ffc:	e8 a0 b2 ff ff       	call   c01002a1 <cprintf>
     //setup initial vir_page<->phy_page environment for page relpacement algorithm 

     
     pgfault_num=0;
c0105001:	c7 05 64 4f 12 c0 00 	movl   $0x0,0xc0124f64
c0105008:	00 00 00 
     
     check_content_set();
c010500b:	e8 28 fa ff ff       	call   c0104a38 <check_content_set>
     assert( nr_free == 0);         
c0105010:	a1 ec 50 12 c0       	mov    0xc01250ec,%eax
c0105015:	85 c0                	test   %eax,%eax
c0105017:	74 24                	je     c010503d <check_swap+0x435>
c0105019:	c7 44 24 0c 5f a6 10 	movl   $0xc010a65f,0xc(%esp)
c0105020:	c0 
c0105021:	c7 44 24 08 d6 a3 10 	movl   $0xc010a3d6,0x8(%esp)
c0105028:	c0 
c0105029:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
c0105030:	00 
c0105031:	c7 04 24 70 a3 10 c0 	movl   $0xc010a370,(%esp)
c0105038:	e8 bb b3 ff ff       	call   c01003f8 <__panic>
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c010503d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0105044:	eb 26                	jmp    c010506c <check_swap+0x464>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
c0105046:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105049:	c7 04 85 40 50 12 c0 	movl   $0xffffffff,-0x3fedafc0(,%eax,4)
c0105050:	ff ff ff ff 
c0105054:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105057:	8b 14 85 40 50 12 c0 	mov    -0x3fedafc0(,%eax,4),%edx
c010505e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105061:	89 14 85 80 50 12 c0 	mov    %edx,-0x3fedaf80(,%eax,4)
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c0105068:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c010506c:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
c0105070:	7e d4                	jle    c0105046 <check_swap+0x43e>
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0105072:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0105079:	e9 eb 00 00 00       	jmp    c0105169 <check_swap+0x561>
         check_ptep[i]=0;
c010507e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105081:	c7 04 85 d4 50 12 c0 	movl   $0x0,-0x3fedaf2c(,%eax,4)
c0105088:	00 00 00 00 
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
c010508c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010508f:	83 c0 01             	add    $0x1,%eax
c0105092:	c1 e0 0c             	shl    $0xc,%eax
c0105095:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010509c:	00 
c010509d:	89 44 24 04          	mov    %eax,0x4(%esp)
c01050a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01050a4:	89 04 24             	mov    %eax,(%esp)
c01050a7:	e8 d1 22 00 00       	call   c010737d <get_pte>
c01050ac:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01050af:	89 04 95 d4 50 12 c0 	mov    %eax,-0x3fedaf2c(,%edx,4)
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
c01050b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01050b9:	8b 04 85 d4 50 12 c0 	mov    -0x3fedaf2c(,%eax,4),%eax
c01050c0:	85 c0                	test   %eax,%eax
c01050c2:	75 24                	jne    c01050e8 <check_swap+0x4e0>
c01050c4:	c7 44 24 0c 6c a6 10 	movl   $0xc010a66c,0xc(%esp)
c01050cb:	c0 
c01050cc:	c7 44 24 08 d6 a3 10 	movl   $0xc010a3d6,0x8(%esp)
c01050d3:	c0 
c01050d4:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c01050db:	00 
c01050dc:	c7 04 24 70 a3 10 c0 	movl   $0xc010a370,(%esp)
c01050e3:	e8 10 b3 ff ff       	call   c01003f8 <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
c01050e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01050eb:	8b 04 85 d4 50 12 c0 	mov    -0x3fedaf2c(,%eax,4),%eax
c01050f2:	8b 00                	mov    (%eax),%eax
c01050f4:	89 04 24             	mov    %eax,(%esp)
c01050f7:	e8 9f f5 ff ff       	call   c010469b <pte2page>
c01050fc:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01050ff:	8b 14 95 20 50 12 c0 	mov    -0x3fedafe0(,%edx,4),%edx
c0105106:	39 d0                	cmp    %edx,%eax
c0105108:	74 24                	je     c010512e <check_swap+0x526>
c010510a:	c7 44 24 0c 84 a6 10 	movl   $0xc010a684,0xc(%esp)
c0105111:	c0 
c0105112:	c7 44 24 08 d6 a3 10 	movl   $0xc010a3d6,0x8(%esp)
c0105119:	c0 
c010511a:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c0105121:	00 
c0105122:	c7 04 24 70 a3 10 c0 	movl   $0xc010a370,(%esp)
c0105129:	e8 ca b2 ff ff       	call   c01003f8 <__panic>
         assert((*check_ptep[i] & PTE_P));          
c010512e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105131:	8b 04 85 d4 50 12 c0 	mov    -0x3fedaf2c(,%eax,4),%eax
c0105138:	8b 00                	mov    (%eax),%eax
c010513a:	83 e0 01             	and    $0x1,%eax
c010513d:	85 c0                	test   %eax,%eax
c010513f:	75 24                	jne    c0105165 <check_swap+0x55d>
c0105141:	c7 44 24 0c ac a6 10 	movl   $0xc010a6ac,0xc(%esp)
c0105148:	c0 
c0105149:	c7 44 24 08 d6 a3 10 	movl   $0xc010a3d6,0x8(%esp)
c0105150:	c0 
c0105151:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c0105158:	00 
c0105159:	c7 04 24 70 a3 10 c0 	movl   $0xc010a370,(%esp)
c0105160:	e8 93 b2 ff ff       	call   c01003f8 <__panic>
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0105165:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0105169:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c010516d:	0f 8e 0b ff ff ff    	jle    c010507e <check_swap+0x476>
     }
     cprintf("set up init env for check_swap over!\n");
c0105173:	c7 04 24 c8 a6 10 c0 	movl   $0xc010a6c8,(%esp)
c010517a:	e8 22 b1 ff ff       	call   c01002a1 <cprintf>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
c010517f:	e8 6c fa ff ff       	call   c0104bf0 <check_content_access>
c0105184:	89 45 cc             	mov    %eax,-0x34(%ebp)
     assert(ret==0);
c0105187:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010518b:	74 24                	je     c01051b1 <check_swap+0x5a9>
c010518d:	c7 44 24 0c ee a6 10 	movl   $0xc010a6ee,0xc(%esp)
c0105194:	c0 
c0105195:	c7 44 24 08 d6 a3 10 	movl   $0xc010a3d6,0x8(%esp)
c010519c:	c0 
c010519d:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c01051a4:	00 
c01051a5:	c7 04 24 70 a3 10 c0 	movl   $0xc010a370,(%esp)
c01051ac:	e8 47 b2 ff ff       	call   c01003f8 <__panic>
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01051b1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01051b8:	eb 1e                	jmp    c01051d8 <check_swap+0x5d0>
         free_pages(check_rp[i],1);
c01051ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01051bd:	8b 04 85 20 50 12 c0 	mov    -0x3fedafe0(,%eax,4),%eax
c01051c4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01051cb:	00 
c01051cc:	89 04 24             	mov    %eax,(%esp)
c01051cf:	e8 35 1b 00 00       	call   c0106d09 <free_pages>
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01051d4:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c01051d8:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c01051dc:	7e dc                	jle    c01051ba <check_swap+0x5b2>
     } 

     //free_page(pte2page(*temp_ptep));
     
     mm_destroy(mm);
c01051de:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01051e1:	89 04 24             	mov    %eax,(%esp)
c01051e4:	e8 8c ea ff ff       	call   c0103c75 <mm_destroy>
         
     nr_free = nr_free_store;
c01051e9:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01051ec:	a3 ec 50 12 c0       	mov    %eax,0xc01250ec
     free_list = free_list_store;
c01051f1:	8b 45 98             	mov    -0x68(%ebp),%eax
c01051f4:	8b 55 9c             	mov    -0x64(%ebp),%edx
c01051f7:	a3 e4 50 12 c0       	mov    %eax,0xc01250e4
c01051fc:	89 15 e8 50 12 c0    	mov    %edx,0xc01250e8

     
     le = &free_list;
c0105202:	c7 45 e8 e4 50 12 c0 	movl   $0xc01250e4,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c0105209:	eb 1d                	jmp    c0105228 <check_swap+0x620>
         struct Page *p = le2page(le, page_link);
c010520b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010520e:	83 e8 0c             	sub    $0xc,%eax
c0105211:	89 45 c8             	mov    %eax,-0x38(%ebp)
         count --, total -= p->property;
c0105214:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0105218:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010521b:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010521e:	8b 40 08             	mov    0x8(%eax),%eax
c0105221:	29 c2                	sub    %eax,%edx
c0105223:	89 d0                	mov    %edx,%eax
c0105225:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105228:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010522b:	89 45 a0             	mov    %eax,-0x60(%ebp)
    return listelm->next;
c010522e:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0105231:	8b 40 04             	mov    0x4(%eax),%eax
     while ((le = list_next(le)) != &free_list) {
c0105234:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105237:	81 7d e8 e4 50 12 c0 	cmpl   $0xc01250e4,-0x18(%ebp)
c010523e:	75 cb                	jne    c010520b <check_swap+0x603>
     }
     cprintf("count is %d, total is %d\n",count,total);
c0105240:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105243:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105247:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010524a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010524e:	c7 04 24 f5 a6 10 c0 	movl   $0xc010a6f5,(%esp)
c0105255:	e8 47 b0 ff ff       	call   c01002a1 <cprintf>
     //assert(count == 0);
     
     cprintf("check_swap() succeeded!\n");
c010525a:	c7 04 24 0f a7 10 c0 	movl   $0xc010a70f,(%esp)
c0105261:	e8 3b b0 ff ff       	call   c01002a1 <cprintf>
}
c0105266:	83 c4 74             	add    $0x74,%esp
c0105269:	5b                   	pop    %ebx
c010526a:	5d                   	pop    %ebp
c010526b:	c3                   	ret    

c010526c <_fifo_init_mm>:
 * (2) _fifo_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */
static int
_fifo_init_mm(struct mm_struct *mm)
{     
c010526c:	55                   	push   %ebp
c010526d:	89 e5                	mov    %esp,%ebp
c010526f:	83 ec 10             	sub    $0x10,%esp
c0105272:	c7 45 fc 10 50 12 c0 	movl   $0xc0125010,-0x4(%ebp)
    elm->prev = elm->next = elm;
c0105279:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010527c:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010527f:	89 50 04             	mov    %edx,0x4(%eax)
c0105282:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105285:	8b 50 04             	mov    0x4(%eax),%edx
c0105288:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010528b:	89 10                	mov    %edx,(%eax)
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
c010528d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105290:	c7 40 14 10 50 12 c0 	movl   $0xc0125010,0x14(%eax)
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
c0105297:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010529c:	c9                   	leave  
c010529d:	c3                   	ret    

c010529e <_fifo_map_swappable>:
/*
 * (3)_fifo_map_swappable: According FIFO PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static int
_fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c010529e:	55                   	push   %ebp
c010529f:	89 e5                	mov    %esp,%ebp
c01052a1:	83 ec 48             	sub    $0x48,%esp
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
c01052a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01052a7:	8b 40 14             	mov    0x14(%eax),%eax
c01052aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *entry=&(page->pra_page_link);
c01052ad:	8b 45 10             	mov    0x10(%ebp),%eax
c01052b0:	83 c0 14             	add    $0x14,%eax
c01052b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
 
    assert(entry != NULL && head != NULL);
c01052b6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01052ba:	74 06                	je     c01052c2 <_fifo_map_swappable+0x24>
c01052bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01052c0:	75 24                	jne    c01052e6 <_fifo_map_swappable+0x48>
c01052c2:	c7 44 24 0c 28 a7 10 	movl   $0xc010a728,0xc(%esp)
c01052c9:	c0 
c01052ca:	c7 44 24 08 46 a7 10 	movl   $0xc010a746,0x8(%esp)
c01052d1:	c0 
c01052d2:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
c01052d9:	00 
c01052da:	c7 04 24 5b a7 10 c0 	movl   $0xc010a75b,(%esp)
c01052e1:	e8 12 b1 ff ff       	call   c01003f8 <__panic>
c01052e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01052e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01052ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01052ef:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01052f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01052f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01052f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01052fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    __list_add(elm, listelm, listelm->next);
c01052fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105301:	8b 40 04             	mov    0x4(%eax),%eax
c0105304:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105307:	89 55 dc             	mov    %edx,-0x24(%ebp)
c010530a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010530d:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0105310:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    prev->next = next->prev = elm;
c0105313:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105316:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105319:	89 10                	mov    %edx,(%eax)
c010531b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010531e:	8b 10                	mov    (%eax),%edx
c0105320:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105323:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0105326:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105329:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010532c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010532f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105332:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105335:	89 10                	mov    %edx,(%eax)
    //record the page access situlation
    /*LAB3 EXERCISE 2: YOUR CODE*/ 
    list_add(head, entry); // (1) 将这一页加入到链表头中(最近访问过的放前面) 使其可以被置换算法使用到
    return 0;
c0105337:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010533c:	c9                   	leave  
c010533d:	c3                   	ret    

c010533e <_fifo_swap_out_victim>:
 *  (4)_fifo_swap_out_victim: According FIFO PRA, we should unlink the  earliest arrival page in front of pra_list_head qeueue,
 *                            then assign the value of *ptr_page to the addr of this page.
 */
static int
_fifo_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
c010533e:	55                   	push   %ebp
c010533f:	89 e5                	mov    %esp,%ebp
c0105341:	83 ec 38             	sub    $0x38,%esp
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0105344:	8b 45 08             	mov    0x8(%ebp),%eax
c0105347:	8b 40 14             	mov    0x14(%eax),%eax
c010534a:	89 45 f4             	mov    %eax,-0xc(%ebp)
         assert(head != NULL);
c010534d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105351:	75 24                	jne    c0105377 <_fifo_swap_out_victim+0x39>
c0105353:	c7 44 24 0c 6f a7 10 	movl   $0xc010a76f,0xc(%esp)
c010535a:	c0 
c010535b:	c7 44 24 08 46 a7 10 	movl   $0xc010a746,0x8(%esp)
c0105362:	c0 
c0105363:	c7 44 24 04 40 00 00 	movl   $0x40,0x4(%esp)
c010536a:	00 
c010536b:	c7 04 24 5b a7 10 c0 	movl   $0xc010a75b,(%esp)
c0105372:	e8 81 b0 ff ff       	call   c01003f8 <__panic>
     assert(in_tick==0);
c0105377:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010537b:	74 24                	je     c01053a1 <_fifo_swap_out_victim+0x63>
c010537d:	c7 44 24 0c 7c a7 10 	movl   $0xc010a77c,0xc(%esp)
c0105384:	c0 
c0105385:	c7 44 24 08 46 a7 10 	movl   $0xc010a746,0x8(%esp)
c010538c:	c0 
c010538d:	c7 44 24 04 41 00 00 	movl   $0x41,0x4(%esp)
c0105394:	00 
c0105395:	c7 04 24 5b a7 10 c0 	movl   $0xc010a75b,(%esp)
c010539c:	e8 57 b0 ff ff       	call   c01003f8 <__panic>
     /* Select the victim */
     /*LAB3 EXERCISE 2: YOUR CODE*/ 
     //(1)  unlink the  earliest arrival page in front of pra_list_head qeueue
     //(2)  assign the value of *ptr_page to the addr of this page
     /* Select the tail */
     list_entry_t *le = head->prev;//(1) 换出最先进来的页 (因为每次访问一个页 都是插入到头节点的后面 因此 头节点的前面就是最先访问的页)
c01053a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01053a4:	8b 00                	mov    (%eax),%eax
c01053a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
     struct Page* page = le2page(le, pra_page_link); // 通过 le 这个链表节点的地址 减去 pra_page_link 在 Page 结构体中的 Offset 得到 Page 的地址
c01053a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01053ac:	83 e8 14             	sub    $0x14,%eax
c01053af:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01053b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01053b5:	89 45 e8             	mov    %eax,-0x18(%ebp)
    __list_del(listelm->prev, listelm->next);
c01053b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01053bb:	8b 40 04             	mov    0x4(%eax),%eax
c01053be:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01053c1:	8b 12                	mov    (%edx),%edx
c01053c3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c01053c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    prev->next = next;
c01053c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01053cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01053cf:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01053d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01053d5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01053d8:	89 10                	mov    %edx,(%eax)
     list_del(le); // 删掉这个节点
     *ptr_page = page; //(2) 将这一页地址存到 ptr_page 中 给 调用本函数的函数使用
c01053da:	8b 45 0c             	mov    0xc(%ebp),%eax
c01053dd:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01053e0:	89 10                	mov    %edx,(%eax)
     return 0;
c01053e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01053e7:	c9                   	leave  
c01053e8:	c3                   	ret    

c01053e9 <_fifo_check_swap>:

static int
_fifo_check_swap(void) {
c01053e9:	55                   	push   %ebp
c01053ea:	89 e5                	mov    %esp,%ebp
c01053ec:	83 ec 18             	sub    $0x18,%esp
    cprintf("write Virt Page c in fifo_check_swap\n");
c01053ef:	c7 04 24 88 a7 10 c0 	movl   $0xc010a788,(%esp)
c01053f6:	e8 a6 ae ff ff       	call   c01002a1 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c01053fb:	b8 00 30 00 00       	mov    $0x3000,%eax
c0105400:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==4);
c0105403:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0105408:	83 f8 04             	cmp    $0x4,%eax
c010540b:	74 24                	je     c0105431 <_fifo_check_swap+0x48>
c010540d:	c7 44 24 0c ae a7 10 	movl   $0xc010a7ae,0xc(%esp)
c0105414:	c0 
c0105415:	c7 44 24 08 46 a7 10 	movl   $0xc010a746,0x8(%esp)
c010541c:	c0 
c010541d:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
c0105424:	00 
c0105425:	c7 04 24 5b a7 10 c0 	movl   $0xc010a75b,(%esp)
c010542c:	e8 c7 af ff ff       	call   c01003f8 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0105431:	c7 04 24 c0 a7 10 c0 	movl   $0xc010a7c0,(%esp)
c0105438:	e8 64 ae ff ff       	call   c01002a1 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c010543d:	b8 00 10 00 00       	mov    $0x1000,%eax
c0105442:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==4);
c0105445:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c010544a:	83 f8 04             	cmp    $0x4,%eax
c010544d:	74 24                	je     c0105473 <_fifo_check_swap+0x8a>
c010544f:	c7 44 24 0c ae a7 10 	movl   $0xc010a7ae,0xc(%esp)
c0105456:	c0 
c0105457:	c7 44 24 08 46 a7 10 	movl   $0xc010a746,0x8(%esp)
c010545e:	c0 
c010545f:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
c0105466:	00 
c0105467:	c7 04 24 5b a7 10 c0 	movl   $0xc010a75b,(%esp)
c010546e:	e8 85 af ff ff       	call   c01003f8 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0105473:	c7 04 24 e8 a7 10 c0 	movl   $0xc010a7e8,(%esp)
c010547a:	e8 22 ae ff ff       	call   c01002a1 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c010547f:	b8 00 40 00 00       	mov    $0x4000,%eax
c0105484:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==4);
c0105487:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c010548c:	83 f8 04             	cmp    $0x4,%eax
c010548f:	74 24                	je     c01054b5 <_fifo_check_swap+0xcc>
c0105491:	c7 44 24 0c ae a7 10 	movl   $0xc010a7ae,0xc(%esp)
c0105498:	c0 
c0105499:	c7 44 24 08 46 a7 10 	movl   $0xc010a746,0x8(%esp)
c01054a0:	c0 
c01054a1:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
c01054a8:	00 
c01054a9:	c7 04 24 5b a7 10 c0 	movl   $0xc010a75b,(%esp)
c01054b0:	e8 43 af ff ff       	call   c01003f8 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c01054b5:	c7 04 24 10 a8 10 c0 	movl   $0xc010a810,(%esp)
c01054bc:	e8 e0 ad ff ff       	call   c01002a1 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c01054c1:	b8 00 20 00 00       	mov    $0x2000,%eax
c01054c6:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==4);
c01054c9:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c01054ce:	83 f8 04             	cmp    $0x4,%eax
c01054d1:	74 24                	je     c01054f7 <_fifo_check_swap+0x10e>
c01054d3:	c7 44 24 0c ae a7 10 	movl   $0xc010a7ae,0xc(%esp)
c01054da:	c0 
c01054db:	c7 44 24 08 46 a7 10 	movl   $0xc010a746,0x8(%esp)
c01054e2:	c0 
c01054e3:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c01054ea:	00 
c01054eb:	c7 04 24 5b a7 10 c0 	movl   $0xc010a75b,(%esp)
c01054f2:	e8 01 af ff ff       	call   c01003f8 <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c01054f7:	c7 04 24 38 a8 10 c0 	movl   $0xc010a838,(%esp)
c01054fe:	e8 9e ad ff ff       	call   c01002a1 <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c0105503:	b8 00 50 00 00       	mov    $0x5000,%eax
c0105508:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==5);
c010550b:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0105510:	83 f8 05             	cmp    $0x5,%eax
c0105513:	74 24                	je     c0105539 <_fifo_check_swap+0x150>
c0105515:	c7 44 24 0c 5e a8 10 	movl   $0xc010a85e,0xc(%esp)
c010551c:	c0 
c010551d:	c7 44 24 08 46 a7 10 	movl   $0xc010a746,0x8(%esp)
c0105524:	c0 
c0105525:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c010552c:	00 
c010552d:	c7 04 24 5b a7 10 c0 	movl   $0xc010a75b,(%esp)
c0105534:	e8 bf ae ff ff       	call   c01003f8 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0105539:	c7 04 24 10 a8 10 c0 	movl   $0xc010a810,(%esp)
c0105540:	e8 5c ad ff ff       	call   c01002a1 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0105545:	b8 00 20 00 00       	mov    $0x2000,%eax
c010554a:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==5);
c010554d:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0105552:	83 f8 05             	cmp    $0x5,%eax
c0105555:	74 24                	je     c010557b <_fifo_check_swap+0x192>
c0105557:	c7 44 24 0c 5e a8 10 	movl   $0xc010a85e,0xc(%esp)
c010555e:	c0 
c010555f:	c7 44 24 08 46 a7 10 	movl   $0xc010a746,0x8(%esp)
c0105566:	c0 
c0105567:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c010556e:	00 
c010556f:	c7 04 24 5b a7 10 c0 	movl   $0xc010a75b,(%esp)
c0105576:	e8 7d ae ff ff       	call   c01003f8 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c010557b:	c7 04 24 c0 a7 10 c0 	movl   $0xc010a7c0,(%esp)
c0105582:	e8 1a ad ff ff       	call   c01002a1 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0105587:	b8 00 10 00 00       	mov    $0x1000,%eax
c010558c:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==6);
c010558f:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0105594:	83 f8 06             	cmp    $0x6,%eax
c0105597:	74 24                	je     c01055bd <_fifo_check_swap+0x1d4>
c0105599:	c7 44 24 0c 6d a8 10 	movl   $0xc010a86d,0xc(%esp)
c01055a0:	c0 
c01055a1:	c7 44 24 08 46 a7 10 	movl   $0xc010a746,0x8(%esp)
c01055a8:	c0 
c01055a9:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c01055b0:	00 
c01055b1:	c7 04 24 5b a7 10 c0 	movl   $0xc010a75b,(%esp)
c01055b8:	e8 3b ae ff ff       	call   c01003f8 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c01055bd:	c7 04 24 10 a8 10 c0 	movl   $0xc010a810,(%esp)
c01055c4:	e8 d8 ac ff ff       	call   c01002a1 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c01055c9:	b8 00 20 00 00       	mov    $0x2000,%eax
c01055ce:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==7);
c01055d1:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c01055d6:	83 f8 07             	cmp    $0x7,%eax
c01055d9:	74 24                	je     c01055ff <_fifo_check_swap+0x216>
c01055db:	c7 44 24 0c 7c a8 10 	movl   $0xc010a87c,0xc(%esp)
c01055e2:	c0 
c01055e3:	c7 44 24 08 46 a7 10 	movl   $0xc010a746,0x8(%esp)
c01055ea:	c0 
c01055eb:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c01055f2:	00 
c01055f3:	c7 04 24 5b a7 10 c0 	movl   $0xc010a75b,(%esp)
c01055fa:	e8 f9 ad ff ff       	call   c01003f8 <__panic>
    cprintf("write Virt Page c in fifo_check_swap\n");
c01055ff:	c7 04 24 88 a7 10 c0 	movl   $0xc010a788,(%esp)
c0105606:	e8 96 ac ff ff       	call   c01002a1 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c010560b:	b8 00 30 00 00       	mov    $0x3000,%eax
c0105610:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==8);
c0105613:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c0105618:	83 f8 08             	cmp    $0x8,%eax
c010561b:	74 24                	je     c0105641 <_fifo_check_swap+0x258>
c010561d:	c7 44 24 0c 8b a8 10 	movl   $0xc010a88b,0xc(%esp)
c0105624:	c0 
c0105625:	c7 44 24 08 46 a7 10 	movl   $0xc010a746,0x8(%esp)
c010562c:	c0 
c010562d:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
c0105634:	00 
c0105635:	c7 04 24 5b a7 10 c0 	movl   $0xc010a75b,(%esp)
c010563c:	e8 b7 ad ff ff       	call   c01003f8 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0105641:	c7 04 24 e8 a7 10 c0 	movl   $0xc010a7e8,(%esp)
c0105648:	e8 54 ac ff ff       	call   c01002a1 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c010564d:	b8 00 40 00 00       	mov    $0x4000,%eax
c0105652:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==9);
c0105655:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c010565a:	83 f8 09             	cmp    $0x9,%eax
c010565d:	74 24                	je     c0105683 <_fifo_check_swap+0x29a>
c010565f:	c7 44 24 0c 9a a8 10 	movl   $0xc010a89a,0xc(%esp)
c0105666:	c0 
c0105667:	c7 44 24 08 46 a7 10 	movl   $0xc010a746,0x8(%esp)
c010566e:	c0 
c010566f:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0105676:	00 
c0105677:	c7 04 24 5b a7 10 c0 	movl   $0xc010a75b,(%esp)
c010567e:	e8 75 ad ff ff       	call   c01003f8 <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c0105683:	c7 04 24 38 a8 10 c0 	movl   $0xc010a838,(%esp)
c010568a:	e8 12 ac ff ff       	call   c01002a1 <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c010568f:	b8 00 50 00 00       	mov    $0x5000,%eax
c0105694:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==10);
c0105697:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c010569c:	83 f8 0a             	cmp    $0xa,%eax
c010569f:	74 24                	je     c01056c5 <_fifo_check_swap+0x2dc>
c01056a1:	c7 44 24 0c a9 a8 10 	movl   $0xc010a8a9,0xc(%esp)
c01056a8:	c0 
c01056a9:	c7 44 24 08 46 a7 10 	movl   $0xc010a746,0x8(%esp)
c01056b0:	c0 
c01056b1:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c01056b8:	00 
c01056b9:	c7 04 24 5b a7 10 c0 	movl   $0xc010a75b,(%esp)
c01056c0:	e8 33 ad ff ff       	call   c01003f8 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c01056c5:	c7 04 24 c0 a7 10 c0 	movl   $0xc010a7c0,(%esp)
c01056cc:	e8 d0 ab ff ff       	call   c01002a1 <cprintf>
    assert(*(unsigned char *)0x1000 == 0x0a);
c01056d1:	b8 00 10 00 00       	mov    $0x1000,%eax
c01056d6:	0f b6 00             	movzbl (%eax),%eax
c01056d9:	3c 0a                	cmp    $0xa,%al
c01056db:	74 24                	je     c0105701 <_fifo_check_swap+0x318>
c01056dd:	c7 44 24 0c bc a8 10 	movl   $0xc010a8bc,0xc(%esp)
c01056e4:	c0 
c01056e5:	c7 44 24 08 46 a7 10 	movl   $0xc010a746,0x8(%esp)
c01056ec:	c0 
c01056ed:	c7 44 24 04 72 00 00 	movl   $0x72,0x4(%esp)
c01056f4:	00 
c01056f5:	c7 04 24 5b a7 10 c0 	movl   $0xc010a75b,(%esp)
c01056fc:	e8 f7 ac ff ff       	call   c01003f8 <__panic>
    *(unsigned char *)0x1000 = 0x0a;
c0105701:	b8 00 10 00 00       	mov    $0x1000,%eax
c0105706:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==11);
c0105709:	a1 64 4f 12 c0       	mov    0xc0124f64,%eax
c010570e:	83 f8 0b             	cmp    $0xb,%eax
c0105711:	74 24                	je     c0105737 <_fifo_check_swap+0x34e>
c0105713:	c7 44 24 0c dd a8 10 	movl   $0xc010a8dd,0xc(%esp)
c010571a:	c0 
c010571b:	c7 44 24 08 46 a7 10 	movl   $0xc010a746,0x8(%esp)
c0105722:	c0 
c0105723:	c7 44 24 04 74 00 00 	movl   $0x74,0x4(%esp)
c010572a:	00 
c010572b:	c7 04 24 5b a7 10 c0 	movl   $0xc010a75b,(%esp)
c0105732:	e8 c1 ac ff ff       	call   c01003f8 <__panic>
    return 0;
c0105737:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010573c:	c9                   	leave  
c010573d:	c3                   	ret    

c010573e <_fifo_init>:


static int
_fifo_init(void)
{
c010573e:	55                   	push   %ebp
c010573f:	89 e5                	mov    %esp,%ebp
    return 0;
c0105741:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105746:	5d                   	pop    %ebp
c0105747:	c3                   	ret    

c0105748 <_fifo_set_unswappable>:

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0105748:	55                   	push   %ebp
c0105749:	89 e5                	mov    %esp,%ebp
    return 0;
c010574b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105750:	5d                   	pop    %ebp
c0105751:	c3                   	ret    

c0105752 <_fifo_tick_event>:

static int
_fifo_tick_event(struct mm_struct *mm)
{ return 0; }
c0105752:	55                   	push   %ebp
c0105753:	89 e5                	mov    %esp,%ebp
c0105755:	b8 00 00 00 00       	mov    $0x0,%eax
c010575a:	5d                   	pop    %ebp
c010575b:	c3                   	ret    

c010575c <page2ppn>:
page2ppn(struct Page *page) {
c010575c:	55                   	push   %ebp
c010575d:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010575f:	8b 55 08             	mov    0x8(%ebp),%edx
c0105762:	a1 f8 50 12 c0       	mov    0xc01250f8,%eax
c0105767:	29 c2                	sub    %eax,%edx
c0105769:	89 d0                	mov    %edx,%eax
c010576b:	c1 f8 05             	sar    $0x5,%eax
}
c010576e:	5d                   	pop    %ebp
c010576f:	c3                   	ret    

c0105770 <page2pa>:
page2pa(struct Page *page) {
c0105770:	55                   	push   %ebp
c0105771:	89 e5                	mov    %esp,%ebp
c0105773:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0105776:	8b 45 08             	mov    0x8(%ebp),%eax
c0105779:	89 04 24             	mov    %eax,(%esp)
c010577c:	e8 db ff ff ff       	call   c010575c <page2ppn>
c0105781:	c1 e0 0c             	shl    $0xc,%eax
}
c0105784:	c9                   	leave  
c0105785:	c3                   	ret    

c0105786 <page_ref>:

static inline int
page_ref(struct Page *page) {
c0105786:	55                   	push   %ebp
c0105787:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0105789:	8b 45 08             	mov    0x8(%ebp),%eax
c010578c:	8b 00                	mov    (%eax),%eax
}
c010578e:	5d                   	pop    %ebp
c010578f:	c3                   	ret    

c0105790 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0105790:	55                   	push   %ebp
c0105791:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0105793:	8b 45 08             	mov    0x8(%ebp),%eax
c0105796:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105799:	89 10                	mov    %edx,(%eax)
}
c010579b:	5d                   	pop    %ebp
c010579c:	c3                   	ret    

c010579d <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c010579d:	55                   	push   %ebp
c010579e:	89 e5                	mov    %esp,%ebp
c01057a0:	83 ec 10             	sub    $0x10,%esp
c01057a3:	c7 45 fc e4 50 12 c0 	movl   $0xc01250e4,-0x4(%ebp)
    elm->prev = elm->next = elm;
c01057aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01057ad:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01057b0:	89 50 04             	mov    %edx,0x4(%eax)
c01057b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01057b6:	8b 50 04             	mov    0x4(%eax),%edx
c01057b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01057bc:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c01057be:	c7 05 ec 50 12 c0 00 	movl   $0x0,0xc01250ec
c01057c5:	00 00 00 
}
c01057c8:	c9                   	leave  
c01057c9:	c3                   	ret    

c01057ca <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c01057ca:	55                   	push   %ebp
c01057cb:	89 e5                	mov    %esp,%ebp
c01057cd:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c01057d0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01057d4:	75 24                	jne    c01057fa <default_init_memmap+0x30>
c01057d6:	c7 44 24 0c 00 a9 10 	movl   $0xc010a900,0xc(%esp)
c01057dd:	c0 
c01057de:	c7 44 24 08 06 a9 10 	movl   $0xc010a906,0x8(%esp)
c01057e5:	c0 
c01057e6:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c01057ed:	00 
c01057ee:	c7 04 24 1b a9 10 c0 	movl   $0xc010a91b,(%esp)
c01057f5:	e8 fe ab ff ff       	call   c01003f8 <__panic>
    struct Page *p = base;
c01057fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01057fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0105800:	eb 7d                	jmp    c010587f <default_init_memmap+0xb5>
        assert(PageReserved(p));
c0105802:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105805:	83 c0 04             	add    $0x4,%eax
c0105808:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c010580f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105812:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105815:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105818:	0f a3 10             	bt     %edx,(%eax)
c010581b:	19 c0                	sbb    %eax,%eax
c010581d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0105820:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105824:	0f 95 c0             	setne  %al
c0105827:	0f b6 c0             	movzbl %al,%eax
c010582a:	85 c0                	test   %eax,%eax
c010582c:	75 24                	jne    c0105852 <default_init_memmap+0x88>
c010582e:	c7 44 24 0c 31 a9 10 	movl   $0xc010a931,0xc(%esp)
c0105835:	c0 
c0105836:	c7 44 24 08 06 a9 10 	movl   $0xc010a906,0x8(%esp)
c010583d:	c0 
c010583e:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c0105845:	00 
c0105846:	c7 04 24 1b a9 10 c0 	movl   $0xc010a91b,(%esp)
c010584d:	e8 a6 ab ff ff       	call   c01003f8 <__panic>
        p->flags = p->property = 0;
c0105852:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105855:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c010585c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010585f:	8b 50 08             	mov    0x8(%eax),%edx
c0105862:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105865:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c0105868:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010586f:	00 
c0105870:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105873:	89 04 24             	mov    %eax,(%esp)
c0105876:	e8 15 ff ff ff       	call   c0105790 <set_page_ref>
    for (; p != base + n; p ++) {
c010587b:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c010587f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105882:	c1 e0 05             	shl    $0x5,%eax
c0105885:	89 c2                	mov    %eax,%edx
c0105887:	8b 45 08             	mov    0x8(%ebp),%eax
c010588a:	01 d0                	add    %edx,%eax
c010588c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010588f:	0f 85 6d ff ff ff    	jne    c0105802 <default_init_memmap+0x38>
    }
    base->property = n;
c0105895:	8b 45 08             	mov    0x8(%ebp),%eax
c0105898:	8b 55 0c             	mov    0xc(%ebp),%edx
c010589b:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c010589e:	8b 45 08             	mov    0x8(%ebp),%eax
c01058a1:	83 c0 04             	add    $0x4,%eax
c01058a4:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c01058ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01058ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01058b1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01058b4:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c01058b7:	8b 15 ec 50 12 c0    	mov    0xc01250ec,%edx
c01058bd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058c0:	01 d0                	add    %edx,%eax
c01058c2:	a3 ec 50 12 c0       	mov    %eax,0xc01250ec
    list_add_before(&free_list, &(base->page_link));
c01058c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01058ca:	83 c0 0c             	add    $0xc,%eax
c01058cd:	c7 45 dc e4 50 12 c0 	movl   $0xc01250e4,-0x24(%ebp)
c01058d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
    __list_add(elm, listelm->prev, listelm);
c01058d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01058da:	8b 00                	mov    (%eax),%eax
c01058dc:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01058df:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01058e2:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01058e5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01058e8:	89 45 cc             	mov    %eax,-0x34(%ebp)
    prev->next = next->prev = elm;
c01058eb:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01058ee:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01058f1:	89 10                	mov    %edx,(%eax)
c01058f3:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01058f6:	8b 10                	mov    (%eax),%edx
c01058f8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01058fb:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01058fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105901:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0105904:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0105907:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010590a:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010590d:	89 10                	mov    %edx,(%eax)
}
c010590f:	c9                   	leave  
c0105910:	c3                   	ret    

c0105911 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0105911:	55                   	push   %ebp
c0105912:	89 e5                	mov    %esp,%ebp
c0105914:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0105917:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010591b:	75 24                	jne    c0105941 <default_alloc_pages+0x30>
c010591d:	c7 44 24 0c 00 a9 10 	movl   $0xc010a900,0xc(%esp)
c0105924:	c0 
c0105925:	c7 44 24 08 06 a9 10 	movl   $0xc010a906,0x8(%esp)
c010592c:	c0 
c010592d:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
c0105934:	00 
c0105935:	c7 04 24 1b a9 10 c0 	movl   $0xc010a91b,(%esp)
c010593c:	e8 b7 aa ff ff       	call   c01003f8 <__panic>
    if (n > nr_free) {
c0105941:	a1 ec 50 12 c0       	mov    0xc01250ec,%eax
c0105946:	3b 45 08             	cmp    0x8(%ebp),%eax
c0105949:	73 0a                	jae    c0105955 <default_alloc_pages+0x44>
        return NULL;
c010594b:	b8 00 00 00 00       	mov    $0x0,%eax
c0105950:	e9 36 01 00 00       	jmp    c0105a8b <default_alloc_pages+0x17a>
    }
    struct Page *page = NULL;
c0105955:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c010595c:	c7 45 f0 e4 50 12 c0 	movl   $0xc01250e4,-0x10(%ebp)
    // TODO: optimize (next-fit)
    while ((le = list_next(le)) != &free_list) {
c0105963:	eb 1c                	jmp    c0105981 <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
c0105965:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105968:	83 e8 0c             	sub    $0xc,%eax
c010596b:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c010596e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105971:	8b 40 08             	mov    0x8(%eax),%eax
c0105974:	3b 45 08             	cmp    0x8(%ebp),%eax
c0105977:	72 08                	jb     c0105981 <default_alloc_pages+0x70>
            page = p;
c0105979:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010597c:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c010597f:	eb 18                	jmp    c0105999 <default_alloc_pages+0x88>
c0105981:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105984:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
c0105987:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010598a:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c010598d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105990:	81 7d f0 e4 50 12 c0 	cmpl   $0xc01250e4,-0x10(%ebp)
c0105997:	75 cc                	jne    c0105965 <default_alloc_pages+0x54>
        }
    }
    if (page != NULL) {
c0105999:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010599d:	0f 84 e5 00 00 00    	je     c0105a88 <default_alloc_pages+0x177>
        if (page->property > n) {
c01059a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01059a6:	8b 40 08             	mov    0x8(%eax),%eax
c01059a9:	3b 45 08             	cmp    0x8(%ebp),%eax
c01059ac:	0f 86 85 00 00 00    	jbe    c0105a37 <default_alloc_pages+0x126>
            struct Page *p = page + n;
c01059b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01059b5:	c1 e0 05             	shl    $0x5,%eax
c01059b8:	89 c2                	mov    %eax,%edx
c01059ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01059bd:	01 d0                	add    %edx,%eax
c01059bf:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c01059c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01059c5:	8b 40 08             	mov    0x8(%eax),%eax
c01059c8:	2b 45 08             	sub    0x8(%ebp),%eax
c01059cb:	89 c2                	mov    %eax,%edx
c01059cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01059d0:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
c01059d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01059d6:	83 c0 04             	add    $0x4,%eax
c01059d9:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c01059e0:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01059e3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01059e6:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01059e9:	0f ab 10             	bts    %edx,(%eax)
            list_add_after(&(page->page_link), &(p->page_link));
c01059ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01059ef:	83 c0 0c             	add    $0xc,%eax
c01059f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01059f5:	83 c2 0c             	add    $0xc,%edx
c01059f8:	89 55 d8             	mov    %edx,-0x28(%ebp)
c01059fb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    __list_add(elm, listelm, listelm->next);
c01059fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105a01:	8b 40 04             	mov    0x4(%eax),%eax
c0105a04:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105a07:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0105a0a:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105a0d:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0105a10:	89 45 c8             	mov    %eax,-0x38(%ebp)
    prev->next = next->prev = elm;
c0105a13:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105a16:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0105a19:	89 10                	mov    %edx,(%eax)
c0105a1b:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105a1e:	8b 10                	mov    (%eax),%edx
c0105a20:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0105a23:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0105a26:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105a29:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0105a2c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0105a2f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105a32:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0105a35:	89 10                	mov    %edx,(%eax)
        }
        list_del(&(page->page_link));
c0105a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a3a:	83 c0 0c             	add    $0xc,%eax
c0105a3d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
c0105a40:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105a43:	8b 40 04             	mov    0x4(%eax),%eax
c0105a46:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0105a49:	8b 12                	mov    (%edx),%edx
c0105a4b:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0105a4e:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
c0105a51:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0105a54:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0105a57:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0105a5a:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0105a5d:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0105a60:	89 10                	mov    %edx,(%eax)
        nr_free -= n;
c0105a62:	a1 ec 50 12 c0       	mov    0xc01250ec,%eax
c0105a67:	2b 45 08             	sub    0x8(%ebp),%eax
c0105a6a:	a3 ec 50 12 c0       	mov    %eax,0xc01250ec
        ClearPageProperty(page);
c0105a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a72:	83 c0 04             	add    $0x4,%eax
c0105a75:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0105a7c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0105a7f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0105a82:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0105a85:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c0105a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105a8b:	c9                   	leave  
c0105a8c:	c3                   	ret    

c0105a8d <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0105a8d:	55                   	push   %ebp
c0105a8e:	89 e5                	mov    %esp,%ebp
c0105a90:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
c0105a96:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105a9a:	75 24                	jne    c0105ac0 <default_free_pages+0x33>
c0105a9c:	c7 44 24 0c 00 a9 10 	movl   $0xc010a900,0xc(%esp)
c0105aa3:	c0 
c0105aa4:	c7 44 24 08 06 a9 10 	movl   $0xc010a906,0x8(%esp)
c0105aab:	c0 
c0105aac:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
c0105ab3:	00 
c0105ab4:	c7 04 24 1b a9 10 c0 	movl   $0xc010a91b,(%esp)
c0105abb:	e8 38 a9 ff ff       	call   c01003f8 <__panic>
    struct Page *p = base;
c0105ac0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ac3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0105ac6:	e9 9d 00 00 00       	jmp    c0105b68 <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
c0105acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ace:	83 c0 04             	add    $0x4,%eax
c0105ad1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0105ad8:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105adb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105ade:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105ae1:	0f a3 10             	bt     %edx,(%eax)
c0105ae4:	19 c0                	sbb    %eax,%eax
c0105ae6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0105ae9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105aed:	0f 95 c0             	setne  %al
c0105af0:	0f b6 c0             	movzbl %al,%eax
c0105af3:	85 c0                	test   %eax,%eax
c0105af5:	75 2c                	jne    c0105b23 <default_free_pages+0x96>
c0105af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105afa:	83 c0 04             	add    $0x4,%eax
c0105afd:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0105b04:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105b07:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105b0a:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105b0d:	0f a3 10             	bt     %edx,(%eax)
c0105b10:	19 c0                	sbb    %eax,%eax
c0105b12:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c0105b15:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0105b19:	0f 95 c0             	setne  %al
c0105b1c:	0f b6 c0             	movzbl %al,%eax
c0105b1f:	85 c0                	test   %eax,%eax
c0105b21:	74 24                	je     c0105b47 <default_free_pages+0xba>
c0105b23:	c7 44 24 0c 44 a9 10 	movl   $0xc010a944,0xc(%esp)
c0105b2a:	c0 
c0105b2b:	c7 44 24 08 06 a9 10 	movl   $0xc010a906,0x8(%esp)
c0105b32:	c0 
c0105b33:	c7 44 24 04 9d 00 00 	movl   $0x9d,0x4(%esp)
c0105b3a:	00 
c0105b3b:	c7 04 24 1b a9 10 c0 	movl   $0xc010a91b,(%esp)
c0105b42:	e8 b1 a8 ff ff       	call   c01003f8 <__panic>
        p->flags = 0;
c0105b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b4a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0105b51:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105b58:	00 
c0105b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b5c:	89 04 24             	mov    %eax,(%esp)
c0105b5f:	e8 2c fc ff ff       	call   c0105790 <set_page_ref>
    for (; p != base + n; p ++) {
c0105b64:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c0105b68:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b6b:	c1 e0 05             	shl    $0x5,%eax
c0105b6e:	89 c2                	mov    %eax,%edx
c0105b70:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b73:	01 d0                	add    %edx,%eax
c0105b75:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105b78:	0f 85 4d ff ff ff    	jne    c0105acb <default_free_pages+0x3e>
    }
    base->property = n;
c0105b7e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b81:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105b84:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0105b87:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b8a:	83 c0 04             	add    $0x4,%eax
c0105b8d:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0105b94:	89 45 d0             	mov    %eax,-0x30(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0105b97:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105b9a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105b9d:	0f ab 10             	bts    %edx,(%eax)
c0105ba0:	c7 45 cc e4 50 12 c0 	movl   $0xc01250e4,-0x34(%ebp)
    return listelm->next;
c0105ba7:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0105baa:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0105bad:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0105bb0:	e9 fa 00 00 00       	jmp    c0105caf <default_free_pages+0x222>
        p = le2page(le, page_link);
c0105bb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105bb8:	83 e8 0c             	sub    $0xc,%eax
c0105bbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105bbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105bc1:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0105bc4:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105bc7:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0105bca:	89 45 f0             	mov    %eax,-0x10(%ebp)
        // TODO: optimize
        if (base + base->property == p) {
c0105bcd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bd0:	8b 40 08             	mov    0x8(%eax),%eax
c0105bd3:	c1 e0 05             	shl    $0x5,%eax
c0105bd6:	89 c2                	mov    %eax,%edx
c0105bd8:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bdb:	01 d0                	add    %edx,%eax
c0105bdd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105be0:	75 5a                	jne    c0105c3c <default_free_pages+0x1af>
            base->property += p->property;
c0105be2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105be5:	8b 50 08             	mov    0x8(%eax),%edx
c0105be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105beb:	8b 40 08             	mov    0x8(%eax),%eax
c0105bee:	01 c2                	add    %eax,%edx
c0105bf0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bf3:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c0105bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105bf9:	83 c0 04             	add    $0x4,%eax
c0105bfc:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0105c03:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0105c06:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0105c09:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0105c0c:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
c0105c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c12:	83 c0 0c             	add    $0xc,%eax
c0105c15:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_del(listelm->prev, listelm->next);
c0105c18:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0105c1b:	8b 40 04             	mov    0x4(%eax),%eax
c0105c1e:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0105c21:	8b 12                	mov    (%edx),%edx
c0105c23:	89 55 b8             	mov    %edx,-0x48(%ebp)
c0105c26:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    prev->next = next;
c0105c29:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0105c2c:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0105c2f:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0105c32:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0105c35:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0105c38:	89 10                	mov    %edx,(%eax)
c0105c3a:	eb 73                	jmp    c0105caf <default_free_pages+0x222>
        }
        else if (p + p->property == base) {
c0105c3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c3f:	8b 40 08             	mov    0x8(%eax),%eax
c0105c42:	c1 e0 05             	shl    $0x5,%eax
c0105c45:	89 c2                	mov    %eax,%edx
c0105c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c4a:	01 d0                	add    %edx,%eax
c0105c4c:	3b 45 08             	cmp    0x8(%ebp),%eax
c0105c4f:	75 5e                	jne    c0105caf <default_free_pages+0x222>
            p->property += base->property;
c0105c51:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c54:	8b 50 08             	mov    0x8(%eax),%edx
c0105c57:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c5a:	8b 40 08             	mov    0x8(%eax),%eax
c0105c5d:	01 c2                	add    %eax,%edx
c0105c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c62:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c0105c65:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c68:	83 c0 04             	add    $0x4,%eax
c0105c6b:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c0105c72:	89 45 ac             	mov    %eax,-0x54(%ebp)
c0105c75:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0105c78:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0105c7b:	0f b3 10             	btr    %edx,(%eax)
            base = p;
c0105c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c81:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c0105c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c87:	83 c0 0c             	add    $0xc,%eax
c0105c8a:	89 45 a8             	mov    %eax,-0x58(%ebp)
    __list_del(listelm->prev, listelm->next);
c0105c8d:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0105c90:	8b 40 04             	mov    0x4(%eax),%eax
c0105c93:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0105c96:	8b 12                	mov    (%edx),%edx
c0105c98:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0105c9b:	89 45 a0             	mov    %eax,-0x60(%ebp)
    prev->next = next;
c0105c9e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0105ca1:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0105ca4:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0105ca7:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0105caa:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0105cad:	89 10                	mov    %edx,(%eax)
    while (le != &free_list) {
c0105caf:	81 7d f0 e4 50 12 c0 	cmpl   $0xc01250e4,-0x10(%ebp)
c0105cb6:	0f 85 f9 fe ff ff    	jne    c0105bb5 <default_free_pages+0x128>
        }
    }
    nr_free += n;
c0105cbc:	8b 15 ec 50 12 c0    	mov    0xc01250ec,%edx
c0105cc2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cc5:	01 d0                	add    %edx,%eax
c0105cc7:	a3 ec 50 12 c0       	mov    %eax,0xc01250ec
c0105ccc:	c7 45 9c e4 50 12 c0 	movl   $0xc01250e4,-0x64(%ebp)
    return listelm->next;
c0105cd3:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0105cd6:	8b 40 04             	mov    0x4(%eax),%eax
    le = list_next(&free_list);
c0105cd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0105cdc:	eb 68                	jmp    c0105d46 <default_free_pages+0x2b9>
        p = le2page(le, page_link);
c0105cde:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ce1:	83 e8 0c             	sub    $0xc,%eax
c0105ce4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property <= p) {
c0105ce7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cea:	8b 40 08             	mov    0x8(%eax),%eax
c0105ced:	c1 e0 05             	shl    $0x5,%eax
c0105cf0:	89 c2                	mov    %eax,%edx
c0105cf2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cf5:	01 d0                	add    %edx,%eax
c0105cf7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105cfa:	77 3b                	ja     c0105d37 <default_free_pages+0x2aa>
            assert(base + base->property != p);
c0105cfc:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cff:	8b 40 08             	mov    0x8(%eax),%eax
c0105d02:	c1 e0 05             	shl    $0x5,%eax
c0105d05:	89 c2                	mov    %eax,%edx
c0105d07:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d0a:	01 d0                	add    %edx,%eax
c0105d0c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105d0f:	75 24                	jne    c0105d35 <default_free_pages+0x2a8>
c0105d11:	c7 44 24 0c 69 a9 10 	movl   $0xc010a969,0xc(%esp)
c0105d18:	c0 
c0105d19:	c7 44 24 08 06 a9 10 	movl   $0xc010a906,0x8(%esp)
c0105d20:	c0 
c0105d21:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c0105d28:	00 
c0105d29:	c7 04 24 1b a9 10 c0 	movl   $0xc010a91b,(%esp)
c0105d30:	e8 c3 a6 ff ff       	call   c01003f8 <__panic>
            break;
c0105d35:	eb 18                	jmp    c0105d4f <default_free_pages+0x2c2>
c0105d37:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d3a:	89 45 98             	mov    %eax,-0x68(%ebp)
c0105d3d:	8b 45 98             	mov    -0x68(%ebp),%eax
c0105d40:	8b 40 04             	mov    0x4(%eax),%eax
        }
        le = list_next(le);
c0105d43:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0105d46:	81 7d f0 e4 50 12 c0 	cmpl   $0xc01250e4,-0x10(%ebp)
c0105d4d:	75 8f                	jne    c0105cde <default_free_pages+0x251>
    }
    list_add_before(le, &(base->page_link));
c0105d4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d52:	8d 50 0c             	lea    0xc(%eax),%edx
c0105d55:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d58:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0105d5b:	89 55 90             	mov    %edx,-0x70(%ebp)
    __list_add(elm, listelm->prev, listelm);
c0105d5e:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0105d61:	8b 00                	mov    (%eax),%eax
c0105d63:	8b 55 90             	mov    -0x70(%ebp),%edx
c0105d66:	89 55 8c             	mov    %edx,-0x74(%ebp)
c0105d69:	89 45 88             	mov    %eax,-0x78(%ebp)
c0105d6c:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0105d6f:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
c0105d72:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0105d75:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0105d78:	89 10                	mov    %edx,(%eax)
c0105d7a:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0105d7d:	8b 10                	mov    (%eax),%edx
c0105d7f:	8b 45 88             	mov    -0x78(%ebp),%eax
c0105d82:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0105d85:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0105d88:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0105d8b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0105d8e:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0105d91:	8b 55 88             	mov    -0x78(%ebp),%edx
c0105d94:	89 10                	mov    %edx,(%eax)
}
c0105d96:	c9                   	leave  
c0105d97:	c3                   	ret    

c0105d98 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0105d98:	55                   	push   %ebp
c0105d99:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0105d9b:	a1 ec 50 12 c0       	mov    0xc01250ec,%eax
}
c0105da0:	5d                   	pop    %ebp
c0105da1:	c3                   	ret    

c0105da2 <basic_check>:

static void
basic_check(void) {
c0105da2:	55                   	push   %ebp
c0105da3:	89 e5                	mov    %esp,%ebp
c0105da5:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0105da8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0105daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105db2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105db5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105db8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0105dbb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105dc2:	e8 d7 0e 00 00       	call   c0106c9e <alloc_pages>
c0105dc7:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105dca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0105dce:	75 24                	jne    c0105df4 <basic_check+0x52>
c0105dd0:	c7 44 24 0c 84 a9 10 	movl   $0xc010a984,0xc(%esp)
c0105dd7:	c0 
c0105dd8:	c7 44 24 08 06 a9 10 	movl   $0xc010a906,0x8(%esp)
c0105ddf:	c0 
c0105de0:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
c0105de7:	00 
c0105de8:	c7 04 24 1b a9 10 c0 	movl   $0xc010a91b,(%esp)
c0105def:	e8 04 a6 ff ff       	call   c01003f8 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0105df4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105dfb:	e8 9e 0e 00 00       	call   c0106c9e <alloc_pages>
c0105e00:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105e03:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105e07:	75 24                	jne    c0105e2d <basic_check+0x8b>
c0105e09:	c7 44 24 0c a0 a9 10 	movl   $0xc010a9a0,0xc(%esp)
c0105e10:	c0 
c0105e11:	c7 44 24 08 06 a9 10 	movl   $0xc010a906,0x8(%esp)
c0105e18:	c0 
c0105e19:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
c0105e20:	00 
c0105e21:	c7 04 24 1b a9 10 c0 	movl   $0xc010a91b,(%esp)
c0105e28:	e8 cb a5 ff ff       	call   c01003f8 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0105e2d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105e34:	e8 65 0e 00 00       	call   c0106c9e <alloc_pages>
c0105e39:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105e3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105e40:	75 24                	jne    c0105e66 <basic_check+0xc4>
c0105e42:	c7 44 24 0c bc a9 10 	movl   $0xc010a9bc,0xc(%esp)
c0105e49:	c0 
c0105e4a:	c7 44 24 08 06 a9 10 	movl   $0xc010a906,0x8(%esp)
c0105e51:	c0 
c0105e52:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c0105e59:	00 
c0105e5a:	c7 04 24 1b a9 10 c0 	movl   $0xc010a91b,(%esp)
c0105e61:	e8 92 a5 ff ff       	call   c01003f8 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0105e66:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e69:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0105e6c:	74 10                	je     c0105e7e <basic_check+0xdc>
c0105e6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e71:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105e74:	74 08                	je     c0105e7e <basic_check+0xdc>
c0105e76:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e79:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105e7c:	75 24                	jne    c0105ea2 <basic_check+0x100>
c0105e7e:	c7 44 24 0c d8 a9 10 	movl   $0xc010a9d8,0xc(%esp)
c0105e85:	c0 
c0105e86:	c7 44 24 08 06 a9 10 	movl   $0xc010a906,0x8(%esp)
c0105e8d:	c0 
c0105e8e:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c0105e95:	00 
c0105e96:	c7 04 24 1b a9 10 c0 	movl   $0xc010a91b,(%esp)
c0105e9d:	e8 56 a5 ff ff       	call   c01003f8 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0105ea2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105ea5:	89 04 24             	mov    %eax,(%esp)
c0105ea8:	e8 d9 f8 ff ff       	call   c0105786 <page_ref>
c0105ead:	85 c0                	test   %eax,%eax
c0105eaf:	75 1e                	jne    c0105ecf <basic_check+0x12d>
c0105eb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105eb4:	89 04 24             	mov    %eax,(%esp)
c0105eb7:	e8 ca f8 ff ff       	call   c0105786 <page_ref>
c0105ebc:	85 c0                	test   %eax,%eax
c0105ebe:	75 0f                	jne    c0105ecf <basic_check+0x12d>
c0105ec0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ec3:	89 04 24             	mov    %eax,(%esp)
c0105ec6:	e8 bb f8 ff ff       	call   c0105786 <page_ref>
c0105ecb:	85 c0                	test   %eax,%eax
c0105ecd:	74 24                	je     c0105ef3 <basic_check+0x151>
c0105ecf:	c7 44 24 0c fc a9 10 	movl   $0xc010a9fc,0xc(%esp)
c0105ed6:	c0 
c0105ed7:	c7 44 24 08 06 a9 10 	movl   $0xc010a906,0x8(%esp)
c0105ede:	c0 
c0105edf:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
c0105ee6:	00 
c0105ee7:	c7 04 24 1b a9 10 c0 	movl   $0xc010a91b,(%esp)
c0105eee:	e8 05 a5 ff ff       	call   c01003f8 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0105ef3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105ef6:	89 04 24             	mov    %eax,(%esp)
c0105ef9:	e8 72 f8 ff ff       	call   c0105770 <page2pa>
c0105efe:	8b 15 80 4f 12 c0    	mov    0xc0124f80,%edx
c0105f04:	c1 e2 0c             	shl    $0xc,%edx
c0105f07:	39 d0                	cmp    %edx,%eax
c0105f09:	72 24                	jb     c0105f2f <basic_check+0x18d>
c0105f0b:	c7 44 24 0c 38 aa 10 	movl   $0xc010aa38,0xc(%esp)
c0105f12:	c0 
c0105f13:	c7 44 24 08 06 a9 10 	movl   $0xc010a906,0x8(%esp)
c0105f1a:	c0 
c0105f1b:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c0105f22:	00 
c0105f23:	c7 04 24 1b a9 10 c0 	movl   $0xc010a91b,(%esp)
c0105f2a:	e8 c9 a4 ff ff       	call   c01003f8 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0105f2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f32:	89 04 24             	mov    %eax,(%esp)
c0105f35:	e8 36 f8 ff ff       	call   c0105770 <page2pa>
c0105f3a:	8b 15 80 4f 12 c0    	mov    0xc0124f80,%edx
c0105f40:	c1 e2 0c             	shl    $0xc,%edx
c0105f43:	39 d0                	cmp    %edx,%eax
c0105f45:	72 24                	jb     c0105f6b <basic_check+0x1c9>
c0105f47:	c7 44 24 0c 55 aa 10 	movl   $0xc010aa55,0xc(%esp)
c0105f4e:	c0 
c0105f4f:	c7 44 24 08 06 a9 10 	movl   $0xc010a906,0x8(%esp)
c0105f56:	c0 
c0105f57:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
c0105f5e:	00 
c0105f5f:	c7 04 24 1b a9 10 c0 	movl   $0xc010a91b,(%esp)
c0105f66:	e8 8d a4 ff ff       	call   c01003f8 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0105f6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f6e:	89 04 24             	mov    %eax,(%esp)
c0105f71:	e8 fa f7 ff ff       	call   c0105770 <page2pa>
c0105f76:	8b 15 80 4f 12 c0    	mov    0xc0124f80,%edx
c0105f7c:	c1 e2 0c             	shl    $0xc,%edx
c0105f7f:	39 d0                	cmp    %edx,%eax
c0105f81:	72 24                	jb     c0105fa7 <basic_check+0x205>
c0105f83:	c7 44 24 0c 72 aa 10 	movl   $0xc010aa72,0xc(%esp)
c0105f8a:	c0 
c0105f8b:	c7 44 24 08 06 a9 10 	movl   $0xc010a906,0x8(%esp)
c0105f92:	c0 
c0105f93:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c0105f9a:	00 
c0105f9b:	c7 04 24 1b a9 10 c0 	movl   $0xc010a91b,(%esp)
c0105fa2:	e8 51 a4 ff ff       	call   c01003f8 <__panic>

    list_entry_t free_list_store = free_list;
c0105fa7:	a1 e4 50 12 c0       	mov    0xc01250e4,%eax
c0105fac:	8b 15 e8 50 12 c0    	mov    0xc01250e8,%edx
c0105fb2:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105fb5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105fb8:	c7 45 e0 e4 50 12 c0 	movl   $0xc01250e4,-0x20(%ebp)
    elm->prev = elm->next = elm;
c0105fbf:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105fc2:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105fc5:	89 50 04             	mov    %edx,0x4(%eax)
c0105fc8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105fcb:	8b 50 04             	mov    0x4(%eax),%edx
c0105fce:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105fd1:	89 10                	mov    %edx,(%eax)
c0105fd3:	c7 45 dc e4 50 12 c0 	movl   $0xc01250e4,-0x24(%ebp)
    return list->next == list;
c0105fda:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105fdd:	8b 40 04             	mov    0x4(%eax),%eax
c0105fe0:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0105fe3:	0f 94 c0             	sete   %al
c0105fe6:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0105fe9:	85 c0                	test   %eax,%eax
c0105feb:	75 24                	jne    c0106011 <basic_check+0x26f>
c0105fed:	c7 44 24 0c 8f aa 10 	movl   $0xc010aa8f,0xc(%esp)
c0105ff4:	c0 
c0105ff5:	c7 44 24 08 06 a9 10 	movl   $0xc010a906,0x8(%esp)
c0105ffc:	c0 
c0105ffd:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c0106004:	00 
c0106005:	c7 04 24 1b a9 10 c0 	movl   $0xc010a91b,(%esp)
c010600c:	e8 e7 a3 ff ff       	call   c01003f8 <__panic>

    unsigned int nr_free_store = nr_free;
c0106011:	a1 ec 50 12 c0       	mov    0xc01250ec,%eax
c0106016:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0106019:	c7 05 ec 50 12 c0 00 	movl   $0x0,0xc01250ec
c0106020:	00 00 00 

    assert(alloc_page() == NULL);
c0106023:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010602a:	e8 6f 0c 00 00       	call   c0106c9e <alloc_pages>
c010602f:	85 c0                	test   %eax,%eax
c0106031:	74 24                	je     c0106057 <basic_check+0x2b5>
c0106033:	c7 44 24 0c a6 aa 10 	movl   $0xc010aaa6,0xc(%esp)
c010603a:	c0 
c010603b:	c7 44 24 08 06 a9 10 	movl   $0xc010a906,0x8(%esp)
c0106042:	c0 
c0106043:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c010604a:	00 
c010604b:	c7 04 24 1b a9 10 c0 	movl   $0xc010a91b,(%esp)
c0106052:	e8 a1 a3 ff ff       	call   c01003f8 <__panic>

    free_page(p0);
c0106057:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010605e:	00 
c010605f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106062:	89 04 24             	mov    %eax,(%esp)
c0106065:	e8 9f 0c 00 00       	call   c0106d09 <free_pages>
    free_page(p1);
c010606a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106071:	00 
c0106072:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106075:	89 04 24             	mov    %eax,(%esp)
c0106078:	e8 8c 0c 00 00       	call   c0106d09 <free_pages>
    free_page(p2);
c010607d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106084:	00 
c0106085:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106088:	89 04 24             	mov    %eax,(%esp)
c010608b:	e8 79 0c 00 00       	call   c0106d09 <free_pages>
    assert(nr_free == 3);
c0106090:	a1 ec 50 12 c0       	mov    0xc01250ec,%eax
c0106095:	83 f8 03             	cmp    $0x3,%eax
c0106098:	74 24                	je     c01060be <basic_check+0x31c>
c010609a:	c7 44 24 0c bb aa 10 	movl   $0xc010aabb,0xc(%esp)
c01060a1:	c0 
c01060a2:	c7 44 24 08 06 a9 10 	movl   $0xc010a906,0x8(%esp)
c01060a9:	c0 
c01060aa:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c01060b1:	00 
c01060b2:	c7 04 24 1b a9 10 c0 	movl   $0xc010a91b,(%esp)
c01060b9:	e8 3a a3 ff ff       	call   c01003f8 <__panic>

    assert((p0 = alloc_page()) != NULL);
c01060be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01060c5:	e8 d4 0b 00 00       	call   c0106c9e <alloc_pages>
c01060ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01060cd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01060d1:	75 24                	jne    c01060f7 <basic_check+0x355>
c01060d3:	c7 44 24 0c 84 a9 10 	movl   $0xc010a984,0xc(%esp)
c01060da:	c0 
c01060db:	c7 44 24 08 06 a9 10 	movl   $0xc010a906,0x8(%esp)
c01060e2:	c0 
c01060e3:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
c01060ea:	00 
c01060eb:	c7 04 24 1b a9 10 c0 	movl   $0xc010a91b,(%esp)
c01060f2:	e8 01 a3 ff ff       	call   c01003f8 <__panic>
    assert((p1 = alloc_page()) != NULL);
c01060f7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01060fe:	e8 9b 0b 00 00       	call   c0106c9e <alloc_pages>
c0106103:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106106:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010610a:	75 24                	jne    c0106130 <basic_check+0x38e>
c010610c:	c7 44 24 0c a0 a9 10 	movl   $0xc010a9a0,0xc(%esp)
c0106113:	c0 
c0106114:	c7 44 24 08 06 a9 10 	movl   $0xc010a906,0x8(%esp)
c010611b:	c0 
c010611c:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c0106123:	00 
c0106124:	c7 04 24 1b a9 10 c0 	movl   $0xc010a91b,(%esp)
c010612b:	e8 c8 a2 ff ff       	call   c01003f8 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0106130:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106137:	e8 62 0b 00 00       	call   c0106c9e <alloc_pages>
c010613c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010613f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106143:	75 24                	jne    c0106169 <basic_check+0x3c7>
c0106145:	c7 44 24 0c bc a9 10 	movl   $0xc010a9bc,0xc(%esp)
c010614c:	c0 
c010614d:	c7 44 24 08 06 a9 10 	movl   $0xc010a906,0x8(%esp)
c0106154:	c0 
c0106155:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
c010615c:	00 
c010615d:	c7 04 24 1b a9 10 c0 	movl   $0xc010a91b,(%esp)
c0106164:	e8 8f a2 ff ff       	call   c01003f8 <__panic>

    assert(alloc_page() == NULL);
c0106169:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106170:	e8 29 0b 00 00       	call   c0106c9e <alloc_pages>
c0106175:	85 c0                	test   %eax,%eax
c0106177:	74 24                	je     c010619d <basic_check+0x3fb>
c0106179:	c7 44 24 0c a6 aa 10 	movl   $0xc010aaa6,0xc(%esp)
c0106180:	c0 
c0106181:	c7 44 24 08 06 a9 10 	movl   $0xc010a906,0x8(%esp)
c0106188:	c0 
c0106189:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c0106190:	00 
c0106191:	c7 04 24 1b a9 10 c0 	movl   $0xc010a91b,(%esp)
c0106198:	e8 5b a2 ff ff       	call   c01003f8 <__panic>

    free_page(p0);
c010619d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01061a4:	00 
c01061a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01061a8:	89 04 24             	mov    %eax,(%esp)
c01061ab:	e8 59 0b 00 00       	call   c0106d09 <free_pages>
c01061b0:	c7 45 d8 e4 50 12 c0 	movl   $0xc01250e4,-0x28(%ebp)
c01061b7:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01061ba:	8b 40 04             	mov    0x4(%eax),%eax
c01061bd:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c01061c0:	0f 94 c0             	sete   %al
c01061c3:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c01061c6:	85 c0                	test   %eax,%eax
c01061c8:	74 24                	je     c01061ee <basic_check+0x44c>
c01061ca:	c7 44 24 0c c8 aa 10 	movl   $0xc010aac8,0xc(%esp)
c01061d1:	c0 
c01061d2:	c7 44 24 08 06 a9 10 	movl   $0xc010a906,0x8(%esp)
c01061d9:	c0 
c01061da:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
c01061e1:	00 
c01061e2:	c7 04 24 1b a9 10 c0 	movl   $0xc010a91b,(%esp)
c01061e9:	e8 0a a2 ff ff       	call   c01003f8 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c01061ee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01061f5:	e8 a4 0a 00 00       	call   c0106c9e <alloc_pages>
c01061fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01061fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106200:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0106203:	74 24                	je     c0106229 <basic_check+0x487>
c0106205:	c7 44 24 0c e0 aa 10 	movl   $0xc010aae0,0xc(%esp)
c010620c:	c0 
c010620d:	c7 44 24 08 06 a9 10 	movl   $0xc010a906,0x8(%esp)
c0106214:	c0 
c0106215:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
c010621c:	00 
c010621d:	c7 04 24 1b a9 10 c0 	movl   $0xc010a91b,(%esp)
c0106224:	e8 cf a1 ff ff       	call   c01003f8 <__panic>
    assert(alloc_page() == NULL);
c0106229:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106230:	e8 69 0a 00 00       	call   c0106c9e <alloc_pages>
c0106235:	85 c0                	test   %eax,%eax
c0106237:	74 24                	je     c010625d <basic_check+0x4bb>
c0106239:	c7 44 24 0c a6 aa 10 	movl   $0xc010aaa6,0xc(%esp)
c0106240:	c0 
c0106241:	c7 44 24 08 06 a9 10 	movl   $0xc010a906,0x8(%esp)
c0106248:	c0 
c0106249:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c0106250:	00 
c0106251:	c7 04 24 1b a9 10 c0 	movl   $0xc010a91b,(%esp)
c0106258:	e8 9b a1 ff ff       	call   c01003f8 <__panic>

    assert(nr_free == 0);
c010625d:	a1 ec 50 12 c0       	mov    0xc01250ec,%eax
c0106262:	85 c0                	test   %eax,%eax
c0106264:	74 24                	je     c010628a <basic_check+0x4e8>
c0106266:	c7 44 24 0c f9 aa 10 	movl   $0xc010aaf9,0xc(%esp)
c010626d:	c0 
c010626e:	c7 44 24 08 06 a9 10 	movl   $0xc010a906,0x8(%esp)
c0106275:	c0 
c0106276:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c010627d:	00 
c010627e:	c7 04 24 1b a9 10 c0 	movl   $0xc010a91b,(%esp)
c0106285:	e8 6e a1 ff ff       	call   c01003f8 <__panic>
    free_list = free_list_store;
c010628a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010628d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106290:	a3 e4 50 12 c0       	mov    %eax,0xc01250e4
c0106295:	89 15 e8 50 12 c0    	mov    %edx,0xc01250e8
    nr_free = nr_free_store;
c010629b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010629e:	a3 ec 50 12 c0       	mov    %eax,0xc01250ec

    free_page(p);
c01062a3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01062aa:	00 
c01062ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01062ae:	89 04 24             	mov    %eax,(%esp)
c01062b1:	e8 53 0a 00 00       	call   c0106d09 <free_pages>
    free_page(p1);
c01062b6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01062bd:	00 
c01062be:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01062c1:	89 04 24             	mov    %eax,(%esp)
c01062c4:	e8 40 0a 00 00       	call   c0106d09 <free_pages>
    free_page(p2);
c01062c9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01062d0:	00 
c01062d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01062d4:	89 04 24             	mov    %eax,(%esp)
c01062d7:	e8 2d 0a 00 00       	call   c0106d09 <free_pages>
}
c01062dc:	c9                   	leave  
c01062dd:	c3                   	ret    

c01062de <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c01062de:	55                   	push   %ebp
c01062df:	89 e5                	mov    %esp,%ebp
c01062e1:	53                   	push   %ebx
c01062e2:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c01062e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01062ef:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c01062f6:	c7 45 ec e4 50 12 c0 	movl   $0xc01250e4,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01062fd:	eb 6b                	jmp    c010636a <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c01062ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106302:	83 e8 0c             	sub    $0xc,%eax
c0106305:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c0106308:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010630b:	83 c0 04             	add    $0x4,%eax
c010630e:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0106315:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106318:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010631b:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010631e:	0f a3 10             	bt     %edx,(%eax)
c0106321:	19 c0                	sbb    %eax,%eax
c0106323:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0106326:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c010632a:	0f 95 c0             	setne  %al
c010632d:	0f b6 c0             	movzbl %al,%eax
c0106330:	85 c0                	test   %eax,%eax
c0106332:	75 24                	jne    c0106358 <default_check+0x7a>
c0106334:	c7 44 24 0c 06 ab 10 	movl   $0xc010ab06,0xc(%esp)
c010633b:	c0 
c010633c:	c7 44 24 08 06 a9 10 	movl   $0xc010a906,0x8(%esp)
c0106343:	c0 
c0106344:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
c010634b:	00 
c010634c:	c7 04 24 1b a9 10 c0 	movl   $0xc010a91b,(%esp)
c0106353:	e8 a0 a0 ff ff       	call   c01003f8 <__panic>
        count ++, total += p->property;
c0106358:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010635c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010635f:	8b 50 08             	mov    0x8(%eax),%edx
c0106362:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106365:	01 d0                	add    %edx,%eax
c0106367:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010636a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010636d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
c0106370:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0106373:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0106376:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106379:	81 7d ec e4 50 12 c0 	cmpl   $0xc01250e4,-0x14(%ebp)
c0106380:	0f 85 79 ff ff ff    	jne    c01062ff <default_check+0x21>
    }
    assert(total == nr_free_pages());
c0106386:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0106389:	e8 ad 09 00 00       	call   c0106d3b <nr_free_pages>
c010638e:	39 c3                	cmp    %eax,%ebx
c0106390:	74 24                	je     c01063b6 <default_check+0xd8>
c0106392:	c7 44 24 0c 16 ab 10 	movl   $0xc010ab16,0xc(%esp)
c0106399:	c0 
c010639a:	c7 44 24 08 06 a9 10 	movl   $0xc010a906,0x8(%esp)
c01063a1:	c0 
c01063a2:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c01063a9:	00 
c01063aa:	c7 04 24 1b a9 10 c0 	movl   $0xc010a91b,(%esp)
c01063b1:	e8 42 a0 ff ff       	call   c01003f8 <__panic>

    basic_check();
c01063b6:	e8 e7 f9 ff ff       	call   c0105da2 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c01063bb:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01063c2:	e8 d7 08 00 00       	call   c0106c9e <alloc_pages>
c01063c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c01063ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01063ce:	75 24                	jne    c01063f4 <default_check+0x116>
c01063d0:	c7 44 24 0c 2f ab 10 	movl   $0xc010ab2f,0xc(%esp)
c01063d7:	c0 
c01063d8:	c7 44 24 08 06 a9 10 	movl   $0xc010a906,0x8(%esp)
c01063df:	c0 
c01063e0:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
c01063e7:	00 
c01063e8:	c7 04 24 1b a9 10 c0 	movl   $0xc010a91b,(%esp)
c01063ef:	e8 04 a0 ff ff       	call   c01003f8 <__panic>
    assert(!PageProperty(p0));
c01063f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01063f7:	83 c0 04             	add    $0x4,%eax
c01063fa:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0106401:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106404:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0106407:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010640a:	0f a3 10             	bt     %edx,(%eax)
c010640d:	19 c0                	sbb    %eax,%eax
c010640f:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0106412:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0106416:	0f 95 c0             	setne  %al
c0106419:	0f b6 c0             	movzbl %al,%eax
c010641c:	85 c0                	test   %eax,%eax
c010641e:	74 24                	je     c0106444 <default_check+0x166>
c0106420:	c7 44 24 0c 3a ab 10 	movl   $0xc010ab3a,0xc(%esp)
c0106427:	c0 
c0106428:	c7 44 24 08 06 a9 10 	movl   $0xc010a906,0x8(%esp)
c010642f:	c0 
c0106430:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c0106437:	00 
c0106438:	c7 04 24 1b a9 10 c0 	movl   $0xc010a91b,(%esp)
c010643f:	e8 b4 9f ff ff       	call   c01003f8 <__panic>

    list_entry_t free_list_store = free_list;
c0106444:	a1 e4 50 12 c0       	mov    0xc01250e4,%eax
c0106449:	8b 15 e8 50 12 c0    	mov    0xc01250e8,%edx
c010644f:	89 45 80             	mov    %eax,-0x80(%ebp)
c0106452:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0106455:	c7 45 b4 e4 50 12 c0 	movl   $0xc01250e4,-0x4c(%ebp)
    elm->prev = elm->next = elm;
c010645c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010645f:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0106462:	89 50 04             	mov    %edx,0x4(%eax)
c0106465:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0106468:	8b 50 04             	mov    0x4(%eax),%edx
c010646b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010646e:	89 10                	mov    %edx,(%eax)
c0106470:	c7 45 b0 e4 50 12 c0 	movl   $0xc01250e4,-0x50(%ebp)
    return list->next == list;
c0106477:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010647a:	8b 40 04             	mov    0x4(%eax),%eax
c010647d:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c0106480:	0f 94 c0             	sete   %al
c0106483:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0106486:	85 c0                	test   %eax,%eax
c0106488:	75 24                	jne    c01064ae <default_check+0x1d0>
c010648a:	c7 44 24 0c 8f aa 10 	movl   $0xc010aa8f,0xc(%esp)
c0106491:	c0 
c0106492:	c7 44 24 08 06 a9 10 	movl   $0xc010a906,0x8(%esp)
c0106499:	c0 
c010649a:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c01064a1:	00 
c01064a2:	c7 04 24 1b a9 10 c0 	movl   $0xc010a91b,(%esp)
c01064a9:	e8 4a 9f ff ff       	call   c01003f8 <__panic>
    assert(alloc_page() == NULL);
c01064ae:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01064b5:	e8 e4 07 00 00       	call   c0106c9e <alloc_pages>
c01064ba:	85 c0                	test   %eax,%eax
c01064bc:	74 24                	je     c01064e2 <default_check+0x204>
c01064be:	c7 44 24 0c a6 aa 10 	movl   $0xc010aaa6,0xc(%esp)
c01064c5:	c0 
c01064c6:	c7 44 24 08 06 a9 10 	movl   $0xc010a906,0x8(%esp)
c01064cd:	c0 
c01064ce:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
c01064d5:	00 
c01064d6:	c7 04 24 1b a9 10 c0 	movl   $0xc010a91b,(%esp)
c01064dd:	e8 16 9f ff ff       	call   c01003f8 <__panic>

    unsigned int nr_free_store = nr_free;
c01064e2:	a1 ec 50 12 c0       	mov    0xc01250ec,%eax
c01064e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c01064ea:	c7 05 ec 50 12 c0 00 	movl   $0x0,0xc01250ec
c01064f1:	00 00 00 

    free_pages(p0 + 2, 3);
c01064f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01064f7:	83 c0 40             	add    $0x40,%eax
c01064fa:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0106501:	00 
c0106502:	89 04 24             	mov    %eax,(%esp)
c0106505:	e8 ff 07 00 00       	call   c0106d09 <free_pages>
    assert(alloc_pages(4) == NULL);
c010650a:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0106511:	e8 88 07 00 00       	call   c0106c9e <alloc_pages>
c0106516:	85 c0                	test   %eax,%eax
c0106518:	74 24                	je     c010653e <default_check+0x260>
c010651a:	c7 44 24 0c 4c ab 10 	movl   $0xc010ab4c,0xc(%esp)
c0106521:	c0 
c0106522:	c7 44 24 08 06 a9 10 	movl   $0xc010a906,0x8(%esp)
c0106529:	c0 
c010652a:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
c0106531:	00 
c0106532:	c7 04 24 1b a9 10 c0 	movl   $0xc010a91b,(%esp)
c0106539:	e8 ba 9e ff ff       	call   c01003f8 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c010653e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106541:	83 c0 40             	add    $0x40,%eax
c0106544:	83 c0 04             	add    $0x4,%eax
c0106547:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c010654e:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106551:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106554:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0106557:	0f a3 10             	bt     %edx,(%eax)
c010655a:	19 c0                	sbb    %eax,%eax
c010655c:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c010655f:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0106563:	0f 95 c0             	setne  %al
c0106566:	0f b6 c0             	movzbl %al,%eax
c0106569:	85 c0                	test   %eax,%eax
c010656b:	74 0e                	je     c010657b <default_check+0x29d>
c010656d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106570:	83 c0 40             	add    $0x40,%eax
c0106573:	8b 40 08             	mov    0x8(%eax),%eax
c0106576:	83 f8 03             	cmp    $0x3,%eax
c0106579:	74 24                	je     c010659f <default_check+0x2c1>
c010657b:	c7 44 24 0c 64 ab 10 	movl   $0xc010ab64,0xc(%esp)
c0106582:	c0 
c0106583:	c7 44 24 08 06 a9 10 	movl   $0xc010a906,0x8(%esp)
c010658a:	c0 
c010658b:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c0106592:	00 
c0106593:	c7 04 24 1b a9 10 c0 	movl   $0xc010a91b,(%esp)
c010659a:	e8 59 9e ff ff       	call   c01003f8 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c010659f:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c01065a6:	e8 f3 06 00 00       	call   c0106c9e <alloc_pages>
c01065ab:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01065ae:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01065b2:	75 24                	jne    c01065d8 <default_check+0x2fa>
c01065b4:	c7 44 24 0c 90 ab 10 	movl   $0xc010ab90,0xc(%esp)
c01065bb:	c0 
c01065bc:	c7 44 24 08 06 a9 10 	movl   $0xc010a906,0x8(%esp)
c01065c3:	c0 
c01065c4:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
c01065cb:	00 
c01065cc:	c7 04 24 1b a9 10 c0 	movl   $0xc010a91b,(%esp)
c01065d3:	e8 20 9e ff ff       	call   c01003f8 <__panic>
    assert(alloc_page() == NULL);
c01065d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01065df:	e8 ba 06 00 00       	call   c0106c9e <alloc_pages>
c01065e4:	85 c0                	test   %eax,%eax
c01065e6:	74 24                	je     c010660c <default_check+0x32e>
c01065e8:	c7 44 24 0c a6 aa 10 	movl   $0xc010aaa6,0xc(%esp)
c01065ef:	c0 
c01065f0:	c7 44 24 08 06 a9 10 	movl   $0xc010a906,0x8(%esp)
c01065f7:	c0 
c01065f8:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c01065ff:	00 
c0106600:	c7 04 24 1b a9 10 c0 	movl   $0xc010a91b,(%esp)
c0106607:	e8 ec 9d ff ff       	call   c01003f8 <__panic>
    assert(p0 + 2 == p1);
c010660c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010660f:	83 c0 40             	add    $0x40,%eax
c0106612:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0106615:	74 24                	je     c010663b <default_check+0x35d>
c0106617:	c7 44 24 0c ae ab 10 	movl   $0xc010abae,0xc(%esp)
c010661e:	c0 
c010661f:	c7 44 24 08 06 a9 10 	movl   $0xc010a906,0x8(%esp)
c0106626:	c0 
c0106627:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
c010662e:	00 
c010662f:	c7 04 24 1b a9 10 c0 	movl   $0xc010a91b,(%esp)
c0106636:	e8 bd 9d ff ff       	call   c01003f8 <__panic>

    p2 = p0 + 1;
c010663b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010663e:	83 c0 20             	add    $0x20,%eax
c0106641:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c0106644:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010664b:	00 
c010664c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010664f:	89 04 24             	mov    %eax,(%esp)
c0106652:	e8 b2 06 00 00       	call   c0106d09 <free_pages>
    free_pages(p1, 3);
c0106657:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c010665e:	00 
c010665f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106662:	89 04 24             	mov    %eax,(%esp)
c0106665:	e8 9f 06 00 00       	call   c0106d09 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c010666a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010666d:	83 c0 04             	add    $0x4,%eax
c0106670:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0106677:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010667a:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010667d:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0106680:	0f a3 10             	bt     %edx,(%eax)
c0106683:	19 c0                	sbb    %eax,%eax
c0106685:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0106688:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c010668c:	0f 95 c0             	setne  %al
c010668f:	0f b6 c0             	movzbl %al,%eax
c0106692:	85 c0                	test   %eax,%eax
c0106694:	74 0b                	je     c01066a1 <default_check+0x3c3>
c0106696:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106699:	8b 40 08             	mov    0x8(%eax),%eax
c010669c:	83 f8 01             	cmp    $0x1,%eax
c010669f:	74 24                	je     c01066c5 <default_check+0x3e7>
c01066a1:	c7 44 24 0c bc ab 10 	movl   $0xc010abbc,0xc(%esp)
c01066a8:	c0 
c01066a9:	c7 44 24 08 06 a9 10 	movl   $0xc010a906,0x8(%esp)
c01066b0:	c0 
c01066b1:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
c01066b8:	00 
c01066b9:	c7 04 24 1b a9 10 c0 	movl   $0xc010a91b,(%esp)
c01066c0:	e8 33 9d ff ff       	call   c01003f8 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c01066c5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01066c8:	83 c0 04             	add    $0x4,%eax
c01066cb:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c01066d2:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01066d5:	8b 45 90             	mov    -0x70(%ebp),%eax
c01066d8:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01066db:	0f a3 10             	bt     %edx,(%eax)
c01066de:	19 c0                	sbb    %eax,%eax
c01066e0:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c01066e3:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c01066e7:	0f 95 c0             	setne  %al
c01066ea:	0f b6 c0             	movzbl %al,%eax
c01066ed:	85 c0                	test   %eax,%eax
c01066ef:	74 0b                	je     c01066fc <default_check+0x41e>
c01066f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01066f4:	8b 40 08             	mov    0x8(%eax),%eax
c01066f7:	83 f8 03             	cmp    $0x3,%eax
c01066fa:	74 24                	je     c0106720 <default_check+0x442>
c01066fc:	c7 44 24 0c e4 ab 10 	movl   $0xc010abe4,0xc(%esp)
c0106703:	c0 
c0106704:	c7 44 24 08 06 a9 10 	movl   $0xc010a906,0x8(%esp)
c010670b:	c0 
c010670c:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
c0106713:	00 
c0106714:	c7 04 24 1b a9 10 c0 	movl   $0xc010a91b,(%esp)
c010671b:	e8 d8 9c ff ff       	call   c01003f8 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0106720:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106727:	e8 72 05 00 00       	call   c0106c9e <alloc_pages>
c010672c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010672f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0106732:	83 e8 20             	sub    $0x20,%eax
c0106735:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0106738:	74 24                	je     c010675e <default_check+0x480>
c010673a:	c7 44 24 0c 0a ac 10 	movl   $0xc010ac0a,0xc(%esp)
c0106741:	c0 
c0106742:	c7 44 24 08 06 a9 10 	movl   $0xc010a906,0x8(%esp)
c0106749:	c0 
c010674a:	c7 44 24 04 21 01 00 	movl   $0x121,0x4(%esp)
c0106751:	00 
c0106752:	c7 04 24 1b a9 10 c0 	movl   $0xc010a91b,(%esp)
c0106759:	e8 9a 9c ff ff       	call   c01003f8 <__panic>
    free_page(p0);
c010675e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106765:	00 
c0106766:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106769:	89 04 24             	mov    %eax,(%esp)
c010676c:	e8 98 05 00 00       	call   c0106d09 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0106771:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0106778:	e8 21 05 00 00       	call   c0106c9e <alloc_pages>
c010677d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106780:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0106783:	83 c0 20             	add    $0x20,%eax
c0106786:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0106789:	74 24                	je     c01067af <default_check+0x4d1>
c010678b:	c7 44 24 0c 28 ac 10 	movl   $0xc010ac28,0xc(%esp)
c0106792:	c0 
c0106793:	c7 44 24 08 06 a9 10 	movl   $0xc010a906,0x8(%esp)
c010679a:	c0 
c010679b:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c01067a2:	00 
c01067a3:	c7 04 24 1b a9 10 c0 	movl   $0xc010a91b,(%esp)
c01067aa:	e8 49 9c ff ff       	call   c01003f8 <__panic>

    free_pages(p0, 2);
c01067af:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c01067b6:	00 
c01067b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01067ba:	89 04 24             	mov    %eax,(%esp)
c01067bd:	e8 47 05 00 00       	call   c0106d09 <free_pages>
    free_page(p2);
c01067c2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01067c9:	00 
c01067ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01067cd:	89 04 24             	mov    %eax,(%esp)
c01067d0:	e8 34 05 00 00       	call   c0106d09 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c01067d5:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01067dc:	e8 bd 04 00 00       	call   c0106c9e <alloc_pages>
c01067e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01067e4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01067e8:	75 24                	jne    c010680e <default_check+0x530>
c01067ea:	c7 44 24 0c 48 ac 10 	movl   $0xc010ac48,0xc(%esp)
c01067f1:	c0 
c01067f2:	c7 44 24 08 06 a9 10 	movl   $0xc010a906,0x8(%esp)
c01067f9:	c0 
c01067fa:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
c0106801:	00 
c0106802:	c7 04 24 1b a9 10 c0 	movl   $0xc010a91b,(%esp)
c0106809:	e8 ea 9b ff ff       	call   c01003f8 <__panic>
    assert(alloc_page() == NULL);
c010680e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106815:	e8 84 04 00 00       	call   c0106c9e <alloc_pages>
c010681a:	85 c0                	test   %eax,%eax
c010681c:	74 24                	je     c0106842 <default_check+0x564>
c010681e:	c7 44 24 0c a6 aa 10 	movl   $0xc010aaa6,0xc(%esp)
c0106825:	c0 
c0106826:	c7 44 24 08 06 a9 10 	movl   $0xc010a906,0x8(%esp)
c010682d:	c0 
c010682e:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
c0106835:	00 
c0106836:	c7 04 24 1b a9 10 c0 	movl   $0xc010a91b,(%esp)
c010683d:	e8 b6 9b ff ff       	call   c01003f8 <__panic>

    assert(nr_free == 0);
c0106842:	a1 ec 50 12 c0       	mov    0xc01250ec,%eax
c0106847:	85 c0                	test   %eax,%eax
c0106849:	74 24                	je     c010686f <default_check+0x591>
c010684b:	c7 44 24 0c f9 aa 10 	movl   $0xc010aaf9,0xc(%esp)
c0106852:	c0 
c0106853:	c7 44 24 08 06 a9 10 	movl   $0xc010a906,0x8(%esp)
c010685a:	c0 
c010685b:	c7 44 24 04 2b 01 00 	movl   $0x12b,0x4(%esp)
c0106862:	00 
c0106863:	c7 04 24 1b a9 10 c0 	movl   $0xc010a91b,(%esp)
c010686a:	e8 89 9b ff ff       	call   c01003f8 <__panic>
    nr_free = nr_free_store;
c010686f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106872:	a3 ec 50 12 c0       	mov    %eax,0xc01250ec

    free_list = free_list_store;
c0106877:	8b 45 80             	mov    -0x80(%ebp),%eax
c010687a:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010687d:	a3 e4 50 12 c0       	mov    %eax,0xc01250e4
c0106882:	89 15 e8 50 12 c0    	mov    %edx,0xc01250e8
    free_pages(p0, 5);
c0106888:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c010688f:	00 
c0106890:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106893:	89 04 24             	mov    %eax,(%esp)
c0106896:	e8 6e 04 00 00       	call   c0106d09 <free_pages>

    le = &free_list;
c010689b:	c7 45 ec e4 50 12 c0 	movl   $0xc01250e4,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01068a2:	eb 1d                	jmp    c01068c1 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c01068a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01068a7:	83 e8 0c             	sub    $0xc,%eax
c01068aa:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c01068ad:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01068b1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01068b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01068b7:	8b 40 08             	mov    0x8(%eax),%eax
c01068ba:	29 c2                	sub    %eax,%edx
c01068bc:	89 d0                	mov    %edx,%eax
c01068be:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01068c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01068c4:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
c01068c7:	8b 45 88             	mov    -0x78(%ebp),%eax
c01068ca:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c01068cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01068d0:	81 7d ec e4 50 12 c0 	cmpl   $0xc01250e4,-0x14(%ebp)
c01068d7:	75 cb                	jne    c01068a4 <default_check+0x5c6>
    }
    assert(count == 0);
c01068d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01068dd:	74 24                	je     c0106903 <default_check+0x625>
c01068df:	c7 44 24 0c 66 ac 10 	movl   $0xc010ac66,0xc(%esp)
c01068e6:	c0 
c01068e7:	c7 44 24 08 06 a9 10 	movl   $0xc010a906,0x8(%esp)
c01068ee:	c0 
c01068ef:	c7 44 24 04 36 01 00 	movl   $0x136,0x4(%esp)
c01068f6:	00 
c01068f7:	c7 04 24 1b a9 10 c0 	movl   $0xc010a91b,(%esp)
c01068fe:	e8 f5 9a ff ff       	call   c01003f8 <__panic>
    assert(total == 0);
c0106903:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106907:	74 24                	je     c010692d <default_check+0x64f>
c0106909:	c7 44 24 0c 71 ac 10 	movl   $0xc010ac71,0xc(%esp)
c0106910:	c0 
c0106911:	c7 44 24 08 06 a9 10 	movl   $0xc010a906,0x8(%esp)
c0106918:	c0 
c0106919:	c7 44 24 04 37 01 00 	movl   $0x137,0x4(%esp)
c0106920:	00 
c0106921:	c7 04 24 1b a9 10 c0 	movl   $0xc010a91b,(%esp)
c0106928:	e8 cb 9a ff ff       	call   c01003f8 <__panic>
}
c010692d:	81 c4 94 00 00 00    	add    $0x94,%esp
c0106933:	5b                   	pop    %ebx
c0106934:	5d                   	pop    %ebp
c0106935:	c3                   	ret    

c0106936 <page2ppn>:
page2ppn(struct Page *page) {
c0106936:	55                   	push   %ebp
c0106937:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0106939:	8b 55 08             	mov    0x8(%ebp),%edx
c010693c:	a1 f8 50 12 c0       	mov    0xc01250f8,%eax
c0106941:	29 c2                	sub    %eax,%edx
c0106943:	89 d0                	mov    %edx,%eax
c0106945:	c1 f8 05             	sar    $0x5,%eax
}
c0106948:	5d                   	pop    %ebp
c0106949:	c3                   	ret    

c010694a <page2pa>:
page2pa(struct Page *page) {
c010694a:	55                   	push   %ebp
c010694b:	89 e5                	mov    %esp,%ebp
c010694d:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0106950:	8b 45 08             	mov    0x8(%ebp),%eax
c0106953:	89 04 24             	mov    %eax,(%esp)
c0106956:	e8 db ff ff ff       	call   c0106936 <page2ppn>
c010695b:	c1 e0 0c             	shl    $0xc,%eax
}
c010695e:	c9                   	leave  
c010695f:	c3                   	ret    

c0106960 <pa2page>:
pa2page(uintptr_t pa) {
c0106960:	55                   	push   %ebp
c0106961:	89 e5                	mov    %esp,%ebp
c0106963:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0106966:	8b 45 08             	mov    0x8(%ebp),%eax
c0106969:	c1 e8 0c             	shr    $0xc,%eax
c010696c:	89 c2                	mov    %eax,%edx
c010696e:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0106973:	39 c2                	cmp    %eax,%edx
c0106975:	72 1c                	jb     c0106993 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0106977:	c7 44 24 08 ac ac 10 	movl   $0xc010acac,0x8(%esp)
c010697e:	c0 
c010697f:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c0106986:	00 
c0106987:	c7 04 24 cb ac 10 c0 	movl   $0xc010accb,(%esp)
c010698e:	e8 65 9a ff ff       	call   c01003f8 <__panic>
    return &pages[PPN(pa)];
c0106993:	a1 f8 50 12 c0       	mov    0xc01250f8,%eax
c0106998:	8b 55 08             	mov    0x8(%ebp),%edx
c010699b:	c1 ea 0c             	shr    $0xc,%edx
c010699e:	c1 e2 05             	shl    $0x5,%edx
c01069a1:	01 d0                	add    %edx,%eax
}
c01069a3:	c9                   	leave  
c01069a4:	c3                   	ret    

c01069a5 <page2kva>:
page2kva(struct Page *page) {
c01069a5:	55                   	push   %ebp
c01069a6:	89 e5                	mov    %esp,%ebp
c01069a8:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c01069ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01069ae:	89 04 24             	mov    %eax,(%esp)
c01069b1:	e8 94 ff ff ff       	call   c010694a <page2pa>
c01069b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01069b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01069bc:	c1 e8 0c             	shr    $0xc,%eax
c01069bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01069c2:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c01069c7:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01069ca:	72 23                	jb     c01069ef <page2kva+0x4a>
c01069cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01069cf:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01069d3:	c7 44 24 08 dc ac 10 	movl   $0xc010acdc,0x8(%esp)
c01069da:	c0 
c01069db:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
c01069e2:	00 
c01069e3:	c7 04 24 cb ac 10 c0 	movl   $0xc010accb,(%esp)
c01069ea:	e8 09 9a ff ff       	call   c01003f8 <__panic>
c01069ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01069f2:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c01069f7:	c9                   	leave  
c01069f8:	c3                   	ret    

c01069f9 <kva2page>:
kva2page(void *kva) {
c01069f9:	55                   	push   %ebp
c01069fa:	89 e5                	mov    %esp,%ebp
c01069fc:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c01069ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a02:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106a05:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0106a0c:	77 23                	ja     c0106a31 <kva2page+0x38>
c0106a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106a11:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106a15:	c7 44 24 08 00 ad 10 	movl   $0xc010ad00,0x8(%esp)
c0106a1c:	c0 
c0106a1d:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c0106a24:	00 
c0106a25:	c7 04 24 cb ac 10 c0 	movl   $0xc010accb,(%esp)
c0106a2c:	e8 c7 99 ff ff       	call   c01003f8 <__panic>
c0106a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106a34:	05 00 00 00 40       	add    $0x40000000,%eax
c0106a39:	89 04 24             	mov    %eax,(%esp)
c0106a3c:	e8 1f ff ff ff       	call   c0106960 <pa2page>
}
c0106a41:	c9                   	leave  
c0106a42:	c3                   	ret    

c0106a43 <pte2page>:
pte2page(pte_t pte) {
c0106a43:	55                   	push   %ebp
c0106a44:	89 e5                	mov    %esp,%ebp
c0106a46:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0106a49:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a4c:	83 e0 01             	and    $0x1,%eax
c0106a4f:	85 c0                	test   %eax,%eax
c0106a51:	75 1c                	jne    c0106a6f <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0106a53:	c7 44 24 08 24 ad 10 	movl   $0xc010ad24,0x8(%esp)
c0106a5a:	c0 
c0106a5b:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0106a62:	00 
c0106a63:	c7 04 24 cb ac 10 c0 	movl   $0xc010accb,(%esp)
c0106a6a:	e8 89 99 ff ff       	call   c01003f8 <__panic>
    return pa2page(PTE_ADDR(pte));
c0106a6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a72:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106a77:	89 04 24             	mov    %eax,(%esp)
c0106a7a:	e8 e1 fe ff ff       	call   c0106960 <pa2page>
}
c0106a7f:	c9                   	leave  
c0106a80:	c3                   	ret    

c0106a81 <pde2page>:
pde2page(pde_t pde) {
c0106a81:	55                   	push   %ebp
c0106a82:	89 e5                	mov    %esp,%ebp
c0106a84:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0106a87:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a8a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106a8f:	89 04 24             	mov    %eax,(%esp)
c0106a92:	e8 c9 fe ff ff       	call   c0106960 <pa2page>
}
c0106a97:	c9                   	leave  
c0106a98:	c3                   	ret    

c0106a99 <page_ref>:
page_ref(struct Page *page) {
c0106a99:	55                   	push   %ebp
c0106a9a:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0106a9c:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a9f:	8b 00                	mov    (%eax),%eax
}
c0106aa1:	5d                   	pop    %ebp
c0106aa2:	c3                   	ret    

c0106aa3 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c0106aa3:	55                   	push   %ebp
c0106aa4:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0106aa6:	8b 45 08             	mov    0x8(%ebp),%eax
c0106aa9:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106aac:	89 10                	mov    %edx,(%eax)
}
c0106aae:	5d                   	pop    %ebp
c0106aaf:	c3                   	ret    

c0106ab0 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0106ab0:	55                   	push   %ebp
c0106ab1:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0106ab3:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ab6:	8b 00                	mov    (%eax),%eax
c0106ab8:	8d 50 01             	lea    0x1(%eax),%edx
c0106abb:	8b 45 08             	mov    0x8(%ebp),%eax
c0106abe:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0106ac0:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ac3:	8b 00                	mov    (%eax),%eax
}
c0106ac5:	5d                   	pop    %ebp
c0106ac6:	c3                   	ret    

c0106ac7 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0106ac7:	55                   	push   %ebp
c0106ac8:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0106aca:	8b 45 08             	mov    0x8(%ebp),%eax
c0106acd:	8b 00                	mov    (%eax),%eax
c0106acf:	8d 50 ff             	lea    -0x1(%eax),%edx
c0106ad2:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ad5:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0106ad7:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ada:	8b 00                	mov    (%eax),%eax
}
c0106adc:	5d                   	pop    %ebp
c0106add:	c3                   	ret    

c0106ade <__intr_save>:
__intr_save(void) {
c0106ade:	55                   	push   %ebp
c0106adf:	89 e5                	mov    %esp,%ebp
c0106ae1:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0106ae4:	9c                   	pushf  
c0106ae5:	58                   	pop    %eax
c0106ae6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0106ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0106aec:	25 00 02 00 00       	and    $0x200,%eax
c0106af1:	85 c0                	test   %eax,%eax
c0106af3:	74 0c                	je     c0106b01 <__intr_save+0x23>
        intr_disable();
c0106af5:	e8 11 b6 ff ff       	call   c010210b <intr_disable>
        return 1;
c0106afa:	b8 01 00 00 00       	mov    $0x1,%eax
c0106aff:	eb 05                	jmp    c0106b06 <__intr_save+0x28>
    return 0;
c0106b01:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106b06:	c9                   	leave  
c0106b07:	c3                   	ret    

c0106b08 <__intr_restore>:
__intr_restore(bool flag) {
c0106b08:	55                   	push   %ebp
c0106b09:	89 e5                	mov    %esp,%ebp
c0106b0b:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0106b0e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0106b12:	74 05                	je     c0106b19 <__intr_restore+0x11>
        intr_enable();
c0106b14:	e8 ec b5 ff ff       	call   c0102105 <intr_enable>
}
c0106b19:	c9                   	leave  
c0106b1a:	c3                   	ret    

c0106b1b <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0106b1b:	55                   	push   %ebp
c0106b1c:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0106b1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b21:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0106b24:	b8 23 00 00 00       	mov    $0x23,%eax
c0106b29:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0106b2b:	b8 23 00 00 00       	mov    $0x23,%eax
c0106b30:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0106b32:	b8 10 00 00 00       	mov    $0x10,%eax
c0106b37:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0106b39:	b8 10 00 00 00       	mov    $0x10,%eax
c0106b3e:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0106b40:	b8 10 00 00 00       	mov    $0x10,%eax
c0106b45:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0106b47:	ea 4e 6b 10 c0 08 00 	ljmp   $0x8,$0xc0106b4e
}
c0106b4e:	5d                   	pop    %ebp
c0106b4f:	c3                   	ret    

c0106b50 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0106b50:	55                   	push   %ebp
c0106b51:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0106b53:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b56:	a3 a4 4f 12 c0       	mov    %eax,0xc0124fa4
}
c0106b5b:	5d                   	pop    %ebp
c0106b5c:	c3                   	ret    

c0106b5d <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0106b5d:	55                   	push   %ebp
c0106b5e:	89 e5                	mov    %esp,%ebp
c0106b60:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0106b63:	b8 00 10 12 c0       	mov    $0xc0121000,%eax
c0106b68:	89 04 24             	mov    %eax,(%esp)
c0106b6b:	e8 e0 ff ff ff       	call   c0106b50 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0106b70:	66 c7 05 a8 4f 12 c0 	movw   $0x10,0xc0124fa8
c0106b77:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0106b79:	66 c7 05 68 1a 12 c0 	movw   $0x68,0xc0121a68
c0106b80:	68 00 
c0106b82:	b8 a0 4f 12 c0       	mov    $0xc0124fa0,%eax
c0106b87:	66 a3 6a 1a 12 c0    	mov    %ax,0xc0121a6a
c0106b8d:	b8 a0 4f 12 c0       	mov    $0xc0124fa0,%eax
c0106b92:	c1 e8 10             	shr    $0x10,%eax
c0106b95:	a2 6c 1a 12 c0       	mov    %al,0xc0121a6c
c0106b9a:	0f b6 05 6d 1a 12 c0 	movzbl 0xc0121a6d,%eax
c0106ba1:	83 e0 f0             	and    $0xfffffff0,%eax
c0106ba4:	83 c8 09             	or     $0x9,%eax
c0106ba7:	a2 6d 1a 12 c0       	mov    %al,0xc0121a6d
c0106bac:	0f b6 05 6d 1a 12 c0 	movzbl 0xc0121a6d,%eax
c0106bb3:	83 e0 ef             	and    $0xffffffef,%eax
c0106bb6:	a2 6d 1a 12 c0       	mov    %al,0xc0121a6d
c0106bbb:	0f b6 05 6d 1a 12 c0 	movzbl 0xc0121a6d,%eax
c0106bc2:	83 e0 9f             	and    $0xffffff9f,%eax
c0106bc5:	a2 6d 1a 12 c0       	mov    %al,0xc0121a6d
c0106bca:	0f b6 05 6d 1a 12 c0 	movzbl 0xc0121a6d,%eax
c0106bd1:	83 c8 80             	or     $0xffffff80,%eax
c0106bd4:	a2 6d 1a 12 c0       	mov    %al,0xc0121a6d
c0106bd9:	0f b6 05 6e 1a 12 c0 	movzbl 0xc0121a6e,%eax
c0106be0:	83 e0 f0             	and    $0xfffffff0,%eax
c0106be3:	a2 6e 1a 12 c0       	mov    %al,0xc0121a6e
c0106be8:	0f b6 05 6e 1a 12 c0 	movzbl 0xc0121a6e,%eax
c0106bef:	83 e0 ef             	and    $0xffffffef,%eax
c0106bf2:	a2 6e 1a 12 c0       	mov    %al,0xc0121a6e
c0106bf7:	0f b6 05 6e 1a 12 c0 	movzbl 0xc0121a6e,%eax
c0106bfe:	83 e0 df             	and    $0xffffffdf,%eax
c0106c01:	a2 6e 1a 12 c0       	mov    %al,0xc0121a6e
c0106c06:	0f b6 05 6e 1a 12 c0 	movzbl 0xc0121a6e,%eax
c0106c0d:	83 c8 40             	or     $0x40,%eax
c0106c10:	a2 6e 1a 12 c0       	mov    %al,0xc0121a6e
c0106c15:	0f b6 05 6e 1a 12 c0 	movzbl 0xc0121a6e,%eax
c0106c1c:	83 e0 7f             	and    $0x7f,%eax
c0106c1f:	a2 6e 1a 12 c0       	mov    %al,0xc0121a6e
c0106c24:	b8 a0 4f 12 c0       	mov    $0xc0124fa0,%eax
c0106c29:	c1 e8 18             	shr    $0x18,%eax
c0106c2c:	a2 6f 1a 12 c0       	mov    %al,0xc0121a6f

    // reload all segment registers
    lgdt(&gdt_pd);
c0106c31:	c7 04 24 70 1a 12 c0 	movl   $0xc0121a70,(%esp)
c0106c38:	e8 de fe ff ff       	call   c0106b1b <lgdt>
c0106c3d:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0106c43:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0106c47:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0106c4a:	c9                   	leave  
c0106c4b:	c3                   	ret    

c0106c4c <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0106c4c:	55                   	push   %ebp
c0106c4d:	89 e5                	mov    %esp,%ebp
c0106c4f:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0106c52:	c7 05 f0 50 12 c0 90 	movl   $0xc010ac90,0xc01250f0
c0106c59:	ac 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0106c5c:	a1 f0 50 12 c0       	mov    0xc01250f0,%eax
c0106c61:	8b 00                	mov    (%eax),%eax
c0106c63:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106c67:	c7 04 24 50 ad 10 c0 	movl   $0xc010ad50,(%esp)
c0106c6e:	e8 2e 96 ff ff       	call   c01002a1 <cprintf>
    pmm_manager->init();
c0106c73:	a1 f0 50 12 c0       	mov    0xc01250f0,%eax
c0106c78:	8b 40 04             	mov    0x4(%eax),%eax
c0106c7b:	ff d0                	call   *%eax
}
c0106c7d:	c9                   	leave  
c0106c7e:	c3                   	ret    

c0106c7f <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0106c7f:	55                   	push   %ebp
c0106c80:	89 e5                	mov    %esp,%ebp
c0106c82:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0106c85:	a1 f0 50 12 c0       	mov    0xc01250f0,%eax
c0106c8a:	8b 40 08             	mov    0x8(%eax),%eax
c0106c8d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106c90:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106c94:	8b 55 08             	mov    0x8(%ebp),%edx
c0106c97:	89 14 24             	mov    %edx,(%esp)
c0106c9a:	ff d0                	call   *%eax
}
c0106c9c:	c9                   	leave  
c0106c9d:	c3                   	ret    

c0106c9e <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0106c9e:	55                   	push   %ebp
c0106c9f:	89 e5                	mov    %esp,%ebp
c0106ca1:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0106ca4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    
    while (1)
    {
         local_intr_save(intr_flag);
c0106cab:	e8 2e fe ff ff       	call   c0106ade <__intr_save>
c0106cb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
         {
              page = pmm_manager->alloc_pages(n);
c0106cb3:	a1 f0 50 12 c0       	mov    0xc01250f0,%eax
c0106cb8:	8b 40 0c             	mov    0xc(%eax),%eax
c0106cbb:	8b 55 08             	mov    0x8(%ebp),%edx
c0106cbe:	89 14 24             	mov    %edx,(%esp)
c0106cc1:	ff d0                	call   *%eax
c0106cc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
         }
         local_intr_restore(intr_flag);
c0106cc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106cc9:	89 04 24             	mov    %eax,(%esp)
c0106ccc:	e8 37 fe ff ff       	call   c0106b08 <__intr_restore>

         if (page != NULL || n > 1 || swap_init_ok == 0) break;
c0106cd1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106cd5:	75 2d                	jne    c0106d04 <alloc_pages+0x66>
c0106cd7:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
c0106cdb:	77 27                	ja     c0106d04 <alloc_pages+0x66>
c0106cdd:	a1 68 4f 12 c0       	mov    0xc0124f68,%eax
c0106ce2:	85 c0                	test   %eax,%eax
c0106ce4:	74 1e                	je     c0106d04 <alloc_pages+0x66>
         
         extern struct mm_struct *check_mm_struct;
         //cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
         swap_out(check_mm_struct, n, 0);
c0106ce6:	8b 55 08             	mov    0x8(%ebp),%edx
c0106ce9:	a1 1c 50 12 c0       	mov    0xc012501c,%eax
c0106cee:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106cf5:	00 
c0106cf6:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106cfa:	89 04 24             	mov    %eax,(%esp)
c0106cfd:	e8 e3 da ff ff       	call   c01047e5 <swap_out>
    }
c0106d02:	eb a7                	jmp    c0106cab <alloc_pages+0xd>
    //cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
c0106d04:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106d07:	c9                   	leave  
c0106d08:	c3                   	ret    

c0106d09 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0106d09:	55                   	push   %ebp
c0106d0a:	89 e5                	mov    %esp,%ebp
c0106d0c:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0106d0f:	e8 ca fd ff ff       	call   c0106ade <__intr_save>
c0106d14:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0106d17:	a1 f0 50 12 c0       	mov    0xc01250f0,%eax
c0106d1c:	8b 40 10             	mov    0x10(%eax),%eax
c0106d1f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106d22:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106d26:	8b 55 08             	mov    0x8(%ebp),%edx
c0106d29:	89 14 24             	mov    %edx,(%esp)
c0106d2c:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0106d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106d31:	89 04 24             	mov    %eax,(%esp)
c0106d34:	e8 cf fd ff ff       	call   c0106b08 <__intr_restore>
}
c0106d39:	c9                   	leave  
c0106d3a:	c3                   	ret    

c0106d3b <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0106d3b:	55                   	push   %ebp
c0106d3c:	89 e5                	mov    %esp,%ebp
c0106d3e:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0106d41:	e8 98 fd ff ff       	call   c0106ade <__intr_save>
c0106d46:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0106d49:	a1 f0 50 12 c0       	mov    0xc01250f0,%eax
c0106d4e:	8b 40 14             	mov    0x14(%eax),%eax
c0106d51:	ff d0                	call   *%eax
c0106d53:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0106d56:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106d59:	89 04 24             	mov    %eax,(%esp)
c0106d5c:	e8 a7 fd ff ff       	call   c0106b08 <__intr_restore>
    return ret;
c0106d61:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0106d64:	c9                   	leave  
c0106d65:	c3                   	ret    

c0106d66 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0106d66:	55                   	push   %ebp
c0106d67:	89 e5                	mov    %esp,%ebp
c0106d69:	57                   	push   %edi
c0106d6a:	56                   	push   %esi
c0106d6b:	53                   	push   %ebx
c0106d6c:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0106d72:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0106d79:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0106d80:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0106d87:	c7 04 24 67 ad 10 c0 	movl   $0xc010ad67,(%esp)
c0106d8e:	e8 0e 95 ff ff       	call   c01002a1 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0106d93:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0106d9a:	e9 15 01 00 00       	jmp    c0106eb4 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0106d9f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106da2:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106da5:	89 d0                	mov    %edx,%eax
c0106da7:	c1 e0 02             	shl    $0x2,%eax
c0106daa:	01 d0                	add    %edx,%eax
c0106dac:	c1 e0 02             	shl    $0x2,%eax
c0106daf:	01 c8                	add    %ecx,%eax
c0106db1:	8b 50 08             	mov    0x8(%eax),%edx
c0106db4:	8b 40 04             	mov    0x4(%eax),%eax
c0106db7:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0106dba:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0106dbd:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106dc0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106dc3:	89 d0                	mov    %edx,%eax
c0106dc5:	c1 e0 02             	shl    $0x2,%eax
c0106dc8:	01 d0                	add    %edx,%eax
c0106dca:	c1 e0 02             	shl    $0x2,%eax
c0106dcd:	01 c8                	add    %ecx,%eax
c0106dcf:	8b 48 0c             	mov    0xc(%eax),%ecx
c0106dd2:	8b 58 10             	mov    0x10(%eax),%ebx
c0106dd5:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0106dd8:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0106ddb:	01 c8                	add    %ecx,%eax
c0106ddd:	11 da                	adc    %ebx,%edx
c0106ddf:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0106de2:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0106de5:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106de8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106deb:	89 d0                	mov    %edx,%eax
c0106ded:	c1 e0 02             	shl    $0x2,%eax
c0106df0:	01 d0                	add    %edx,%eax
c0106df2:	c1 e0 02             	shl    $0x2,%eax
c0106df5:	01 c8                	add    %ecx,%eax
c0106df7:	83 c0 14             	add    $0x14,%eax
c0106dfa:	8b 00                	mov    (%eax),%eax
c0106dfc:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0106e02:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0106e05:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0106e08:	83 c0 ff             	add    $0xffffffff,%eax
c0106e0b:	83 d2 ff             	adc    $0xffffffff,%edx
c0106e0e:	89 c6                	mov    %eax,%esi
c0106e10:	89 d7                	mov    %edx,%edi
c0106e12:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106e15:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106e18:	89 d0                	mov    %edx,%eax
c0106e1a:	c1 e0 02             	shl    $0x2,%eax
c0106e1d:	01 d0                	add    %edx,%eax
c0106e1f:	c1 e0 02             	shl    $0x2,%eax
c0106e22:	01 c8                	add    %ecx,%eax
c0106e24:	8b 48 0c             	mov    0xc(%eax),%ecx
c0106e27:	8b 58 10             	mov    0x10(%eax),%ebx
c0106e2a:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0106e30:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0106e34:	89 74 24 14          	mov    %esi,0x14(%esp)
c0106e38:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0106e3c:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0106e3f:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0106e42:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106e46:	89 54 24 10          	mov    %edx,0x10(%esp)
c0106e4a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0106e4e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0106e52:	c7 04 24 74 ad 10 c0 	movl   $0xc010ad74,(%esp)
c0106e59:	e8 43 94 ff ff       	call   c01002a1 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0106e5e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106e61:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106e64:	89 d0                	mov    %edx,%eax
c0106e66:	c1 e0 02             	shl    $0x2,%eax
c0106e69:	01 d0                	add    %edx,%eax
c0106e6b:	c1 e0 02             	shl    $0x2,%eax
c0106e6e:	01 c8                	add    %ecx,%eax
c0106e70:	83 c0 14             	add    $0x14,%eax
c0106e73:	8b 00                	mov    (%eax),%eax
c0106e75:	83 f8 01             	cmp    $0x1,%eax
c0106e78:	75 36                	jne    c0106eb0 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c0106e7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106e7d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106e80:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0106e83:	77 2b                	ja     c0106eb0 <page_init+0x14a>
c0106e85:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0106e88:	72 05                	jb     c0106e8f <page_init+0x129>
c0106e8a:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0106e8d:	73 21                	jae    c0106eb0 <page_init+0x14a>
c0106e8f:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0106e93:	77 1b                	ja     c0106eb0 <page_init+0x14a>
c0106e95:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0106e99:	72 09                	jb     c0106ea4 <page_init+0x13e>
c0106e9b:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0106ea2:	77 0c                	ja     c0106eb0 <page_init+0x14a>
                maxpa = end;
c0106ea4:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0106ea7:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0106eaa:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0106ead:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
c0106eb0:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0106eb4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0106eb7:	8b 00                	mov    (%eax),%eax
c0106eb9:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0106ebc:	0f 8f dd fe ff ff    	jg     c0106d9f <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0106ec2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106ec6:	72 1d                	jb     c0106ee5 <page_init+0x17f>
c0106ec8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106ecc:	77 09                	ja     c0106ed7 <page_init+0x171>
c0106ece:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0106ed5:	76 0e                	jbe    c0106ee5 <page_init+0x17f>
        maxpa = KMEMSIZE;
c0106ed7:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0106ede:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0106ee5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106ee8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106eeb:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0106eef:	c1 ea 0c             	shr    $0xc,%edx
c0106ef2:	a3 80 4f 12 c0       	mov    %eax,0xc0124f80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0106ef7:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0106efe:	b8 fc 50 12 c0       	mov    $0xc01250fc,%eax
c0106f03:	8d 50 ff             	lea    -0x1(%eax),%edx
c0106f06:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0106f09:	01 d0                	add    %edx,%eax
c0106f0b:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0106f0e:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106f11:	ba 00 00 00 00       	mov    $0x0,%edx
c0106f16:	f7 75 ac             	divl   -0x54(%ebp)
c0106f19:	89 d0                	mov    %edx,%eax
c0106f1b:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0106f1e:	29 c2                	sub    %eax,%edx
c0106f20:	89 d0                	mov    %edx,%eax
c0106f22:	a3 f8 50 12 c0       	mov    %eax,0xc01250f8

    for (i = 0; i < npage; i ++) {
c0106f27:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0106f2e:	eb 27                	jmp    c0106f57 <page_init+0x1f1>
        SetPageReserved(pages + i);
c0106f30:	a1 f8 50 12 c0       	mov    0xc01250f8,%eax
c0106f35:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106f38:	c1 e2 05             	shl    $0x5,%edx
c0106f3b:	01 d0                	add    %edx,%eax
c0106f3d:	83 c0 04             	add    $0x4,%eax
c0106f40:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0106f47:	89 45 8c             	mov    %eax,-0x74(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0106f4a:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0106f4d:	8b 55 90             	mov    -0x70(%ebp),%edx
c0106f50:	0f ab 10             	bts    %edx,(%eax)
    for (i = 0; i < npage; i ++) {
c0106f53:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0106f57:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106f5a:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0106f5f:	39 c2                	cmp    %eax,%edx
c0106f61:	72 cd                	jb     c0106f30 <page_init+0x1ca>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0106f63:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0106f68:	c1 e0 05             	shl    $0x5,%eax
c0106f6b:	89 c2                	mov    %eax,%edx
c0106f6d:	a1 f8 50 12 c0       	mov    0xc01250f8,%eax
c0106f72:	01 d0                	add    %edx,%eax
c0106f74:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0106f77:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0106f7e:	77 23                	ja     c0106fa3 <page_init+0x23d>
c0106f80:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0106f83:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106f87:	c7 44 24 08 00 ad 10 	movl   $0xc010ad00,0x8(%esp)
c0106f8e:	c0 
c0106f8f:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c0106f96:	00 
c0106f97:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c0106f9e:	e8 55 94 ff ff       	call   c01003f8 <__panic>
c0106fa3:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0106fa6:	05 00 00 00 40       	add    $0x40000000,%eax
c0106fab:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0106fae:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0106fb5:	e9 74 01 00 00       	jmp    c010712e <page_init+0x3c8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0106fba:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106fbd:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106fc0:	89 d0                	mov    %edx,%eax
c0106fc2:	c1 e0 02             	shl    $0x2,%eax
c0106fc5:	01 d0                	add    %edx,%eax
c0106fc7:	c1 e0 02             	shl    $0x2,%eax
c0106fca:	01 c8                	add    %ecx,%eax
c0106fcc:	8b 50 08             	mov    0x8(%eax),%edx
c0106fcf:	8b 40 04             	mov    0x4(%eax),%eax
c0106fd2:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0106fd5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0106fd8:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0106fdb:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106fde:	89 d0                	mov    %edx,%eax
c0106fe0:	c1 e0 02             	shl    $0x2,%eax
c0106fe3:	01 d0                	add    %edx,%eax
c0106fe5:	c1 e0 02             	shl    $0x2,%eax
c0106fe8:	01 c8                	add    %ecx,%eax
c0106fea:	8b 48 0c             	mov    0xc(%eax),%ecx
c0106fed:	8b 58 10             	mov    0x10(%eax),%ebx
c0106ff0:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106ff3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106ff6:	01 c8                	add    %ecx,%eax
c0106ff8:	11 da                	adc    %ebx,%edx
c0106ffa:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0106ffd:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0107000:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0107003:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0107006:	89 d0                	mov    %edx,%eax
c0107008:	c1 e0 02             	shl    $0x2,%eax
c010700b:	01 d0                	add    %edx,%eax
c010700d:	c1 e0 02             	shl    $0x2,%eax
c0107010:	01 c8                	add    %ecx,%eax
c0107012:	83 c0 14             	add    $0x14,%eax
c0107015:	8b 00                	mov    (%eax),%eax
c0107017:	83 f8 01             	cmp    $0x1,%eax
c010701a:	0f 85 0a 01 00 00    	jne    c010712a <page_init+0x3c4>
            if (begin < freemem) {
c0107020:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0107023:	ba 00 00 00 00       	mov    $0x0,%edx
c0107028:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010702b:	72 17                	jb     c0107044 <page_init+0x2de>
c010702d:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0107030:	77 05                	ja     c0107037 <page_init+0x2d1>
c0107032:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0107035:	76 0d                	jbe    c0107044 <page_init+0x2de>
                begin = freemem;
c0107037:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010703a:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010703d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0107044:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0107048:	72 1d                	jb     c0107067 <page_init+0x301>
c010704a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010704e:	77 09                	ja     c0107059 <page_init+0x2f3>
c0107050:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0107057:	76 0e                	jbe    c0107067 <page_init+0x301>
                end = KMEMSIZE;
c0107059:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0107060:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0107067:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010706a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010706d:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0107070:	0f 87 b4 00 00 00    	ja     c010712a <page_init+0x3c4>
c0107076:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0107079:	72 09                	jb     c0107084 <page_init+0x31e>
c010707b:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c010707e:	0f 83 a6 00 00 00    	jae    c010712a <page_init+0x3c4>
                begin = ROUNDUP(begin, PGSIZE);
c0107084:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c010708b:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010708e:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0107091:	01 d0                	add    %edx,%eax
c0107093:	83 e8 01             	sub    $0x1,%eax
c0107096:	89 45 98             	mov    %eax,-0x68(%ebp)
c0107099:	8b 45 98             	mov    -0x68(%ebp),%eax
c010709c:	ba 00 00 00 00       	mov    $0x0,%edx
c01070a1:	f7 75 9c             	divl   -0x64(%ebp)
c01070a4:	89 d0                	mov    %edx,%eax
c01070a6:	8b 55 98             	mov    -0x68(%ebp),%edx
c01070a9:	29 c2                	sub    %eax,%edx
c01070ab:	89 d0                	mov    %edx,%eax
c01070ad:	ba 00 00 00 00       	mov    $0x0,%edx
c01070b2:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01070b5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c01070b8:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01070bb:	89 45 94             	mov    %eax,-0x6c(%ebp)
c01070be:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01070c1:	ba 00 00 00 00       	mov    $0x0,%edx
c01070c6:	89 c7                	mov    %eax,%edi
c01070c8:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c01070ce:	89 7d 80             	mov    %edi,-0x80(%ebp)
c01070d1:	89 d0                	mov    %edx,%eax
c01070d3:	83 e0 00             	and    $0x0,%eax
c01070d6:	89 45 84             	mov    %eax,-0x7c(%ebp)
c01070d9:	8b 45 80             	mov    -0x80(%ebp),%eax
c01070dc:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01070df:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01070e2:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c01070e5:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01070e8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01070eb:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01070ee:	77 3a                	ja     c010712a <page_init+0x3c4>
c01070f0:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01070f3:	72 05                	jb     c01070fa <page_init+0x394>
c01070f5:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01070f8:	73 30                	jae    c010712a <page_init+0x3c4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c01070fa:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c01070fd:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c0107100:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0107103:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0107106:	29 c8                	sub    %ecx,%eax
c0107108:	19 da                	sbb    %ebx,%edx
c010710a:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010710e:	c1 ea 0c             	shr    $0xc,%edx
c0107111:	89 c3                	mov    %eax,%ebx
c0107113:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107116:	89 04 24             	mov    %eax,(%esp)
c0107119:	e8 42 f8 ff ff       	call   c0106960 <pa2page>
c010711e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0107122:	89 04 24             	mov    %eax,(%esp)
c0107125:	e8 55 fb ff ff       	call   c0106c7f <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
c010712a:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c010712e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0107131:	8b 00                	mov    (%eax),%eax
c0107133:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0107136:	0f 8f 7e fe ff ff    	jg     c0106fba <page_init+0x254>
                }
            }
        }
    }
}
c010713c:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0107142:	5b                   	pop    %ebx
c0107143:	5e                   	pop    %esi
c0107144:	5f                   	pop    %edi
c0107145:	5d                   	pop    %ebp
c0107146:	c3                   	ret    

c0107147 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0107147:	55                   	push   %ebp
c0107148:	89 e5                	mov    %esp,%ebp
c010714a:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c010714d:	8b 45 14             	mov    0x14(%ebp),%eax
c0107150:	8b 55 0c             	mov    0xc(%ebp),%edx
c0107153:	31 d0                	xor    %edx,%eax
c0107155:	25 ff 0f 00 00       	and    $0xfff,%eax
c010715a:	85 c0                	test   %eax,%eax
c010715c:	74 24                	je     c0107182 <boot_map_segment+0x3b>
c010715e:	c7 44 24 0c b2 ad 10 	movl   $0xc010adb2,0xc(%esp)
c0107165:	c0 
c0107166:	c7 44 24 08 c9 ad 10 	movl   $0xc010adc9,0x8(%esp)
c010716d:	c0 
c010716e:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
c0107175:	00 
c0107176:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c010717d:	e8 76 92 ff ff       	call   c01003f8 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0107182:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0107189:	8b 45 0c             	mov    0xc(%ebp),%eax
c010718c:	25 ff 0f 00 00       	and    $0xfff,%eax
c0107191:	89 c2                	mov    %eax,%edx
c0107193:	8b 45 10             	mov    0x10(%ebp),%eax
c0107196:	01 c2                	add    %eax,%edx
c0107198:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010719b:	01 d0                	add    %edx,%eax
c010719d:	83 e8 01             	sub    $0x1,%eax
c01071a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01071a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01071a6:	ba 00 00 00 00       	mov    $0x0,%edx
c01071ab:	f7 75 f0             	divl   -0x10(%ebp)
c01071ae:	89 d0                	mov    %edx,%eax
c01071b0:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01071b3:	29 c2                	sub    %eax,%edx
c01071b5:	89 d0                	mov    %edx,%eax
c01071b7:	c1 e8 0c             	shr    $0xc,%eax
c01071ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c01071bd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01071c0:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01071c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01071c6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01071cb:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c01071ce:	8b 45 14             	mov    0x14(%ebp),%eax
c01071d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01071d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01071d7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01071dc:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01071df:	eb 6b                	jmp    c010724c <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c01071e1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01071e8:	00 
c01071e9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01071ec:	89 44 24 04          	mov    %eax,0x4(%esp)
c01071f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01071f3:	89 04 24             	mov    %eax,(%esp)
c01071f6:	e8 82 01 00 00       	call   c010737d <get_pte>
c01071fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c01071fe:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0107202:	75 24                	jne    c0107228 <boot_map_segment+0xe1>
c0107204:	c7 44 24 0c de ad 10 	movl   $0xc010adde,0xc(%esp)
c010720b:	c0 
c010720c:	c7 44 24 08 c9 ad 10 	movl   $0xc010adc9,0x8(%esp)
c0107213:	c0 
c0107214:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
c010721b:	00 
c010721c:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c0107223:	e8 d0 91 ff ff       	call   c01003f8 <__panic>
        *ptep = pa | PTE_P | perm;
c0107228:	8b 45 18             	mov    0x18(%ebp),%eax
c010722b:	8b 55 14             	mov    0x14(%ebp),%edx
c010722e:	09 d0                	or     %edx,%eax
c0107230:	83 c8 01             	or     $0x1,%eax
c0107233:	89 c2                	mov    %eax,%edx
c0107235:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107238:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c010723a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010723e:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0107245:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c010724c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107250:	75 8f                	jne    c01071e1 <boot_map_segment+0x9a>
    }
}
c0107252:	c9                   	leave  
c0107253:	c3                   	ret    

c0107254 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c0107254:	55                   	push   %ebp
c0107255:	89 e5                	mov    %esp,%ebp
c0107257:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c010725a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107261:	e8 38 fa ff ff       	call   c0106c9e <alloc_pages>
c0107266:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0107269:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010726d:	75 1c                	jne    c010728b <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c010726f:	c7 44 24 08 eb ad 10 	movl   $0xc010adeb,0x8(%esp)
c0107276:	c0 
c0107277:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
c010727e:	00 
c010727f:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c0107286:	e8 6d 91 ff ff       	call   c01003f8 <__panic>
    }
    return page2kva(p);
c010728b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010728e:	89 04 24             	mov    %eax,(%esp)
c0107291:	e8 0f f7 ff ff       	call   c01069a5 <page2kva>
}
c0107296:	c9                   	leave  
c0107297:	c3                   	ret    

c0107298 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0107298:	55                   	push   %ebp
c0107299:	89 e5                	mov    %esp,%ebp
c010729b:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c010729e:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c01072a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01072a6:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01072ad:	77 23                	ja     c01072d2 <pmm_init+0x3a>
c01072af:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01072b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01072b6:	c7 44 24 08 00 ad 10 	movl   $0xc010ad00,0x8(%esp)
c01072bd:	c0 
c01072be:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c01072c5:	00 
c01072c6:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c01072cd:	e8 26 91 ff ff       	call   c01003f8 <__panic>
c01072d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01072d5:	05 00 00 00 40       	add    $0x40000000,%eax
c01072da:	a3 f4 50 12 c0       	mov    %eax,0xc01250f4
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c01072df:	e8 68 f9 ff ff       	call   c0106c4c <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c01072e4:	e8 7d fa ff ff       	call   c0106d66 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c01072e9:	e8 a6 04 00 00       	call   c0107794 <check_alloc_page>

    check_pgdir();
c01072ee:	e8 bf 04 00 00       	call   c01077b2 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c01072f3:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c01072f8:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c01072fe:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107303:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107306:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c010730d:	77 23                	ja     c0107332 <pmm_init+0x9a>
c010730f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107312:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107316:	c7 44 24 08 00 ad 10 	movl   $0xc010ad00,0x8(%esp)
c010731d:	c0 
c010731e:	c7 44 24 04 39 01 00 	movl   $0x139,0x4(%esp)
c0107325:	00 
c0107326:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c010732d:	e8 c6 90 ff ff       	call   c01003f8 <__panic>
c0107332:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107335:	05 00 00 00 40       	add    $0x40000000,%eax
c010733a:	83 c8 03             	or     $0x3,%eax
c010733d:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c010733f:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107344:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c010734b:	00 
c010734c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0107353:	00 
c0107354:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c010735b:	38 
c010735c:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0107363:	c0 
c0107364:	89 04 24             	mov    %eax,(%esp)
c0107367:	e8 db fd ff ff       	call   c0107147 <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c010736c:	e8 ec f7 ff ff       	call   c0106b5d <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0107371:	e8 d7 0a 00 00       	call   c0107e4d <check_boot_pgdir>

    print_pgdir();
c0107376:	e8 5f 0f 00 00       	call   c01082da <print_pgdir>

}
c010737b:	c9                   	leave  
c010737c:	c3                   	ret    

c010737d <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c010737d:	55                   	push   %ebp
c010737e:	89 e5                	mov    %esp,%ebp
c0107380:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];
c0107383:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107386:	c1 e8 16             	shr    $0x16,%eax
c0107389:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0107390:	8b 45 08             	mov    0x8(%ebp),%eax
c0107393:	01 d0                	add    %edx,%eax
c0107395:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {
c0107398:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010739b:	8b 00                	mov    (%eax),%eax
c010739d:	83 e0 01             	and    $0x1,%eax
c01073a0:	85 c0                	test   %eax,%eax
c01073a2:	0f 85 af 00 00 00    	jne    c0107457 <get_pte+0xda>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {
c01073a8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01073ac:	74 15                	je     c01073c3 <get_pte+0x46>
c01073ae:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01073b5:	e8 e4 f8 ff ff       	call   c0106c9e <alloc_pages>
c01073ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01073bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01073c1:	75 0a                	jne    c01073cd <get_pte+0x50>
            return NULL;
c01073c3:	b8 00 00 00 00       	mov    $0x0,%eax
c01073c8:	e9 e6 00 00 00       	jmp    c01074b3 <get_pte+0x136>
        }
        set_page_ref(page, 1);
c01073cd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01073d4:	00 
c01073d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01073d8:	89 04 24             	mov    %eax,(%esp)
c01073db:	e8 c3 f6 ff ff       	call   c0106aa3 <set_page_ref>
        uintptr_t pa = page2pa(page);
c01073e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01073e3:	89 04 24             	mov    %eax,(%esp)
c01073e6:	e8 5f f5 ff ff       	call   c010694a <page2pa>
c01073eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);
c01073ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01073f1:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01073f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01073f7:	c1 e8 0c             	shr    $0xc,%eax
c01073fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01073fd:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0107402:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0107405:	72 23                	jb     c010742a <get_pte+0xad>
c0107407:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010740a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010740e:	c7 44 24 08 dc ac 10 	movl   $0xc010acdc,0x8(%esp)
c0107415:	c0 
c0107416:	c7 44 24 04 7f 01 00 	movl   $0x17f,0x4(%esp)
c010741d:	00 
c010741e:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c0107425:	e8 ce 8f ff ff       	call   c01003f8 <__panic>
c010742a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010742d:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0107432:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0107439:	00 
c010743a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0107441:	00 
c0107442:	89 04 24             	mov    %eax,(%esp)
c0107445:	e8 11 16 00 00       	call   c0108a5b <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;
c010744a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010744d:	83 c8 07             	or     $0x7,%eax
c0107450:	89 c2                	mov    %eax,%edx
c0107452:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107455:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c0107457:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010745a:	8b 00                	mov    (%eax),%eax
c010745c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107461:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0107464:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107467:	c1 e8 0c             	shr    $0xc,%eax
c010746a:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010746d:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0107472:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0107475:	72 23                	jb     c010749a <get_pte+0x11d>
c0107477:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010747a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010747e:	c7 44 24 08 dc ac 10 	movl   $0xc010acdc,0x8(%esp)
c0107485:	c0 
c0107486:	c7 44 24 04 82 01 00 	movl   $0x182,0x4(%esp)
c010748d:	00 
c010748e:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c0107495:	e8 5e 8f ff ff       	call   c01003f8 <__panic>
c010749a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010749d:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01074a2:	8b 55 0c             	mov    0xc(%ebp),%edx
c01074a5:	c1 ea 0c             	shr    $0xc,%edx
c01074a8:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c01074ae:	c1 e2 02             	shl    $0x2,%edx
c01074b1:	01 d0                	add    %edx,%eax
}
c01074b3:	c9                   	leave  
c01074b4:	c3                   	ret    

c01074b5 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c01074b5:	55                   	push   %ebp
c01074b6:	89 e5                	mov    %esp,%ebp
c01074b8:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01074bb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01074c2:	00 
c01074c3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01074c6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01074ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01074cd:	89 04 24             	mov    %eax,(%esp)
c01074d0:	e8 a8 fe ff ff       	call   c010737d <get_pte>
c01074d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c01074d8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01074dc:	74 08                	je     c01074e6 <get_page+0x31>
        *ptep_store = ptep;
c01074de:	8b 45 10             	mov    0x10(%ebp),%eax
c01074e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01074e4:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c01074e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01074ea:	74 1b                	je     c0107507 <get_page+0x52>
c01074ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01074ef:	8b 00                	mov    (%eax),%eax
c01074f1:	83 e0 01             	and    $0x1,%eax
c01074f4:	85 c0                	test   %eax,%eax
c01074f6:	74 0f                	je     c0107507 <get_page+0x52>
        return pte2page(*ptep);
c01074f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01074fb:	8b 00                	mov    (%eax),%eax
c01074fd:	89 04 24             	mov    %eax,(%esp)
c0107500:	e8 3e f5 ff ff       	call   c0106a43 <pte2page>
c0107505:	eb 05                	jmp    c010750c <get_page+0x57>
    }
    return NULL;
c0107507:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010750c:	c9                   	leave  
c010750d:	c3                   	ret    

c010750e <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c010750e:	55                   	push   %ebp
c010750f:	89 e5                	mov    %esp,%ebp
c0107511:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P) {
c0107514:	8b 45 10             	mov    0x10(%ebp),%eax
c0107517:	8b 00                	mov    (%eax),%eax
c0107519:	83 e0 01             	and    $0x1,%eax
c010751c:	85 c0                	test   %eax,%eax
c010751e:	74 4d                	je     c010756d <page_remove_pte+0x5f>
        struct Page *page = pte2page(*ptep);
c0107520:	8b 45 10             	mov    0x10(%ebp),%eax
c0107523:	8b 00                	mov    (%eax),%eax
c0107525:	89 04 24             	mov    %eax,(%esp)
c0107528:	e8 16 f5 ff ff       	call   c0106a43 <pte2page>
c010752d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0) {
c0107530:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107533:	89 04 24             	mov    %eax,(%esp)
c0107536:	e8 8c f5 ff ff       	call   c0106ac7 <page_ref_dec>
c010753b:	85 c0                	test   %eax,%eax
c010753d:	75 13                	jne    c0107552 <page_remove_pte+0x44>
            free_page(page);
c010753f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0107546:	00 
c0107547:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010754a:	89 04 24             	mov    %eax,(%esp)
c010754d:	e8 b7 f7 ff ff       	call   c0106d09 <free_pages>
        }
        *ptep = 0;
c0107552:	8b 45 10             	mov    0x10(%ebp),%eax
c0107555:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
c010755b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010755e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107562:	8b 45 08             	mov    0x8(%ebp),%eax
c0107565:	89 04 24             	mov    %eax,(%esp)
c0107568:	e8 ff 00 00 00       	call   c010766c <tlb_invalidate>
    }
}
c010756d:	c9                   	leave  
c010756e:	c3                   	ret    

c010756f <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c010756f:	55                   	push   %ebp
c0107570:	89 e5                	mov    %esp,%ebp
c0107572:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0107575:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010757c:	00 
c010757d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107580:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107584:	8b 45 08             	mov    0x8(%ebp),%eax
c0107587:	89 04 24             	mov    %eax,(%esp)
c010758a:	e8 ee fd ff ff       	call   c010737d <get_pte>
c010758f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0107592:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107596:	74 19                	je     c01075b1 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c0107598:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010759b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010759f:	8b 45 0c             	mov    0xc(%ebp),%eax
c01075a2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01075a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01075a9:	89 04 24             	mov    %eax,(%esp)
c01075ac:	e8 5d ff ff ff       	call   c010750e <page_remove_pte>
    }
}
c01075b1:	c9                   	leave  
c01075b2:	c3                   	ret    

c01075b3 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c01075b3:	55                   	push   %ebp
c01075b4:	89 e5                	mov    %esp,%ebp
c01075b6:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c01075b9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01075c0:	00 
c01075c1:	8b 45 10             	mov    0x10(%ebp),%eax
c01075c4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01075c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01075cb:	89 04 24             	mov    %eax,(%esp)
c01075ce:	e8 aa fd ff ff       	call   c010737d <get_pte>
c01075d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c01075d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01075da:	75 0a                	jne    c01075e6 <page_insert+0x33>
        return -E_NO_MEM;
c01075dc:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01075e1:	e9 84 00 00 00       	jmp    c010766a <page_insert+0xb7>
    }
    page_ref_inc(page);
c01075e6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01075e9:	89 04 24             	mov    %eax,(%esp)
c01075ec:	e8 bf f4 ff ff       	call   c0106ab0 <page_ref_inc>
    if (*ptep & PTE_P) {
c01075f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01075f4:	8b 00                	mov    (%eax),%eax
c01075f6:	83 e0 01             	and    $0x1,%eax
c01075f9:	85 c0                	test   %eax,%eax
c01075fb:	74 3e                	je     c010763b <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c01075fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107600:	8b 00                	mov    (%eax),%eax
c0107602:	89 04 24             	mov    %eax,(%esp)
c0107605:	e8 39 f4 ff ff       	call   c0106a43 <pte2page>
c010760a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c010760d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107610:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107613:	75 0d                	jne    c0107622 <page_insert+0x6f>
            page_ref_dec(page);
c0107615:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107618:	89 04 24             	mov    %eax,(%esp)
c010761b:	e8 a7 f4 ff ff       	call   c0106ac7 <page_ref_dec>
c0107620:	eb 19                	jmp    c010763b <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0107622:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107625:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107629:	8b 45 10             	mov    0x10(%ebp),%eax
c010762c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107630:	8b 45 08             	mov    0x8(%ebp),%eax
c0107633:	89 04 24             	mov    %eax,(%esp)
c0107636:	e8 d3 fe ff ff       	call   c010750e <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c010763b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010763e:	89 04 24             	mov    %eax,(%esp)
c0107641:	e8 04 f3 ff ff       	call   c010694a <page2pa>
c0107646:	0b 45 14             	or     0x14(%ebp),%eax
c0107649:	83 c8 01             	or     $0x1,%eax
c010764c:	89 c2                	mov    %eax,%edx
c010764e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107651:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0107653:	8b 45 10             	mov    0x10(%ebp),%eax
c0107656:	89 44 24 04          	mov    %eax,0x4(%esp)
c010765a:	8b 45 08             	mov    0x8(%ebp),%eax
c010765d:	89 04 24             	mov    %eax,(%esp)
c0107660:	e8 07 00 00 00       	call   c010766c <tlb_invalidate>
    return 0;
c0107665:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010766a:	c9                   	leave  
c010766b:	c3                   	ret    

c010766c <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c010766c:	55                   	push   %ebp
c010766d:	89 e5                	mov    %esp,%ebp
c010766f:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0107672:	0f 20 d8             	mov    %cr3,%eax
c0107675:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c0107678:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c010767b:	89 c2                	mov    %eax,%edx
c010767d:	8b 45 08             	mov    0x8(%ebp),%eax
c0107680:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107683:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010768a:	77 23                	ja     c01076af <tlb_invalidate+0x43>
c010768c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010768f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107693:	c7 44 24 08 00 ad 10 	movl   $0xc010ad00,0x8(%esp)
c010769a:	c0 
c010769b:	c7 44 24 04 e4 01 00 	movl   $0x1e4,0x4(%esp)
c01076a2:	00 
c01076a3:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c01076aa:	e8 49 8d ff ff       	call   c01003f8 <__panic>
c01076af:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01076b2:	05 00 00 00 40       	add    $0x40000000,%eax
c01076b7:	39 c2                	cmp    %eax,%edx
c01076b9:	75 0c                	jne    c01076c7 <tlb_invalidate+0x5b>
        invlpg((void *)la);
c01076bb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01076be:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c01076c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01076c4:	0f 01 38             	invlpg (%eax)
    }
}
c01076c7:	c9                   	leave  
c01076c8:	c3                   	ret    

c01076c9 <pgdir_alloc_page>:

// pgdir_alloc_page - call alloc_page & page_insert functions to 
//                  - allocate a page size memory & setup an addr map
//                  - pa<->la with linear address la and the PDT pgdir
struct Page *
pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
c01076c9:	55                   	push   %ebp
c01076ca:	89 e5                	mov    %esp,%ebp
c01076cc:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_page();
c01076cf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01076d6:	e8 c3 f5 ff ff       	call   c0106c9e <alloc_pages>
c01076db:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c01076de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01076e2:	0f 84 a7 00 00 00    	je     c010778f <pgdir_alloc_page+0xc6>
        if (page_insert(pgdir, page, la, perm) != 0) {
c01076e8:	8b 45 10             	mov    0x10(%ebp),%eax
c01076eb:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01076ef:	8b 45 0c             	mov    0xc(%ebp),%eax
c01076f2:	89 44 24 08          	mov    %eax,0x8(%esp)
c01076f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01076f9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01076fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0107700:	89 04 24             	mov    %eax,(%esp)
c0107703:	e8 ab fe ff ff       	call   c01075b3 <page_insert>
c0107708:	85 c0                	test   %eax,%eax
c010770a:	74 1a                	je     c0107726 <pgdir_alloc_page+0x5d>
            free_page(page);
c010770c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0107713:	00 
c0107714:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107717:	89 04 24             	mov    %eax,(%esp)
c010771a:	e8 ea f5 ff ff       	call   c0106d09 <free_pages>
            return NULL;
c010771f:	b8 00 00 00 00       	mov    $0x0,%eax
c0107724:	eb 6c                	jmp    c0107792 <pgdir_alloc_page+0xc9>
        }
        if (swap_init_ok){
c0107726:	a1 68 4f 12 c0       	mov    0xc0124f68,%eax
c010772b:	85 c0                	test   %eax,%eax
c010772d:	74 60                	je     c010778f <pgdir_alloc_page+0xc6>
            swap_map_swappable(check_mm_struct, la, page, 0);
c010772f:	a1 1c 50 12 c0       	mov    0xc012501c,%eax
c0107734:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010773b:	00 
c010773c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010773f:	89 54 24 08          	mov    %edx,0x8(%esp)
c0107743:	8b 55 0c             	mov    0xc(%ebp),%edx
c0107746:	89 54 24 04          	mov    %edx,0x4(%esp)
c010774a:	89 04 24             	mov    %eax,(%esp)
c010774d:	e8 47 d0 ff ff       	call   c0104799 <swap_map_swappable>
            page->pra_vaddr=la;
c0107752:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107755:	8b 55 0c             	mov    0xc(%ebp),%edx
c0107758:	89 50 1c             	mov    %edx,0x1c(%eax)
            assert(page_ref(page) == 1);
c010775b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010775e:	89 04 24             	mov    %eax,(%esp)
c0107761:	e8 33 f3 ff ff       	call   c0106a99 <page_ref>
c0107766:	83 f8 01             	cmp    $0x1,%eax
c0107769:	74 24                	je     c010778f <pgdir_alloc_page+0xc6>
c010776b:	c7 44 24 0c 04 ae 10 	movl   $0xc010ae04,0xc(%esp)
c0107772:	c0 
c0107773:	c7 44 24 08 c9 ad 10 	movl   $0xc010adc9,0x8(%esp)
c010777a:	c0 
c010777b:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
c0107782:	00 
c0107783:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c010778a:	e8 69 8c ff ff       	call   c01003f8 <__panic>
            //cprintf("get No. %d  page: pra_vaddr %x, pra_link.prev %x, pra_link_next %x in pgdir_alloc_page\n", (page-pages), page->pra_vaddr,page->pra_page_link.prev, page->pra_page_link.next);
        }

    }

    return page;
c010778f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107792:	c9                   	leave  
c0107793:	c3                   	ret    

c0107794 <check_alloc_page>:

static void
check_alloc_page(void) {
c0107794:	55                   	push   %ebp
c0107795:	89 e5                	mov    %esp,%ebp
c0107797:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c010779a:	a1 f0 50 12 c0       	mov    0xc01250f0,%eax
c010779f:	8b 40 18             	mov    0x18(%eax),%eax
c01077a2:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c01077a4:	c7 04 24 18 ae 10 c0 	movl   $0xc010ae18,(%esp)
c01077ab:	e8 f1 8a ff ff       	call   c01002a1 <cprintf>
}
c01077b0:	c9                   	leave  
c01077b1:	c3                   	ret    

c01077b2 <check_pgdir>:

static void
check_pgdir(void) {
c01077b2:	55                   	push   %ebp
c01077b3:	89 e5                	mov    %esp,%ebp
c01077b5:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c01077b8:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c01077bd:	3d 00 80 03 00       	cmp    $0x38000,%eax
c01077c2:	76 24                	jbe    c01077e8 <check_pgdir+0x36>
c01077c4:	c7 44 24 0c 37 ae 10 	movl   $0xc010ae37,0xc(%esp)
c01077cb:	c0 
c01077cc:	c7 44 24 08 c9 ad 10 	movl   $0xc010adc9,0x8(%esp)
c01077d3:	c0 
c01077d4:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
c01077db:	00 
c01077dc:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c01077e3:	e8 10 8c ff ff       	call   c01003f8 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c01077e8:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c01077ed:	85 c0                	test   %eax,%eax
c01077ef:	74 0e                	je     c01077ff <check_pgdir+0x4d>
c01077f1:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c01077f6:	25 ff 0f 00 00       	and    $0xfff,%eax
c01077fb:	85 c0                	test   %eax,%eax
c01077fd:	74 24                	je     c0107823 <check_pgdir+0x71>
c01077ff:	c7 44 24 0c 54 ae 10 	movl   $0xc010ae54,0xc(%esp)
c0107806:	c0 
c0107807:	c7 44 24 08 c9 ad 10 	movl   $0xc010adc9,0x8(%esp)
c010780e:	c0 
c010780f:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c0107816:	00 
c0107817:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c010781e:	e8 d5 8b ff ff       	call   c01003f8 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0107823:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107828:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010782f:	00 
c0107830:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0107837:	00 
c0107838:	89 04 24             	mov    %eax,(%esp)
c010783b:	e8 75 fc ff ff       	call   c01074b5 <get_page>
c0107840:	85 c0                	test   %eax,%eax
c0107842:	74 24                	je     c0107868 <check_pgdir+0xb6>
c0107844:	c7 44 24 0c 8c ae 10 	movl   $0xc010ae8c,0xc(%esp)
c010784b:	c0 
c010784c:	c7 44 24 08 c9 ad 10 	movl   $0xc010adc9,0x8(%esp)
c0107853:	c0 
c0107854:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
c010785b:	00 
c010785c:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c0107863:	e8 90 8b ff ff       	call   c01003f8 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0107868:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010786f:	e8 2a f4 ff ff       	call   c0106c9e <alloc_pages>
c0107874:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0107877:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c010787c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0107883:	00 
c0107884:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010788b:	00 
c010788c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010788f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107893:	89 04 24             	mov    %eax,(%esp)
c0107896:	e8 18 fd ff ff       	call   c01075b3 <page_insert>
c010789b:	85 c0                	test   %eax,%eax
c010789d:	74 24                	je     c01078c3 <check_pgdir+0x111>
c010789f:	c7 44 24 0c b4 ae 10 	movl   $0xc010aeb4,0xc(%esp)
c01078a6:	c0 
c01078a7:	c7 44 24 08 c9 ad 10 	movl   $0xc010adc9,0x8(%esp)
c01078ae:	c0 
c01078af:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
c01078b6:	00 
c01078b7:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c01078be:	e8 35 8b ff ff       	call   c01003f8 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c01078c3:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c01078c8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01078cf:	00 
c01078d0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01078d7:	00 
c01078d8:	89 04 24             	mov    %eax,(%esp)
c01078db:	e8 9d fa ff ff       	call   c010737d <get_pte>
c01078e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01078e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01078e7:	75 24                	jne    c010790d <check_pgdir+0x15b>
c01078e9:	c7 44 24 0c e0 ae 10 	movl   $0xc010aee0,0xc(%esp)
c01078f0:	c0 
c01078f1:	c7 44 24 08 c9 ad 10 	movl   $0xc010adc9,0x8(%esp)
c01078f8:	c0 
c01078f9:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
c0107900:	00 
c0107901:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c0107908:	e8 eb 8a ff ff       	call   c01003f8 <__panic>
    assert(pte2page(*ptep) == p1);
c010790d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107910:	8b 00                	mov    (%eax),%eax
c0107912:	89 04 24             	mov    %eax,(%esp)
c0107915:	e8 29 f1 ff ff       	call   c0106a43 <pte2page>
c010791a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010791d:	74 24                	je     c0107943 <check_pgdir+0x191>
c010791f:	c7 44 24 0c 0d af 10 	movl   $0xc010af0d,0xc(%esp)
c0107926:	c0 
c0107927:	c7 44 24 08 c9 ad 10 	movl   $0xc010adc9,0x8(%esp)
c010792e:	c0 
c010792f:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
c0107936:	00 
c0107937:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c010793e:	e8 b5 8a ff ff       	call   c01003f8 <__panic>
    assert(page_ref(p1) == 1);
c0107943:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107946:	89 04 24             	mov    %eax,(%esp)
c0107949:	e8 4b f1 ff ff       	call   c0106a99 <page_ref>
c010794e:	83 f8 01             	cmp    $0x1,%eax
c0107951:	74 24                	je     c0107977 <check_pgdir+0x1c5>
c0107953:	c7 44 24 0c 23 af 10 	movl   $0xc010af23,0xc(%esp)
c010795a:	c0 
c010795b:	c7 44 24 08 c9 ad 10 	movl   $0xc010adc9,0x8(%esp)
c0107962:	c0 
c0107963:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
c010796a:	00 
c010796b:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c0107972:	e8 81 8a ff ff       	call   c01003f8 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0107977:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c010797c:	8b 00                	mov    (%eax),%eax
c010797e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107983:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0107986:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107989:	c1 e8 0c             	shr    $0xc,%eax
c010798c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010798f:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0107994:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0107997:	72 23                	jb     c01079bc <check_pgdir+0x20a>
c0107999:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010799c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01079a0:	c7 44 24 08 dc ac 10 	movl   $0xc010acdc,0x8(%esp)
c01079a7:	c0 
c01079a8:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
c01079af:	00 
c01079b0:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c01079b7:	e8 3c 8a ff ff       	call   c01003f8 <__panic>
c01079bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01079bf:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01079c4:	83 c0 04             	add    $0x4,%eax
c01079c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c01079ca:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c01079cf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01079d6:	00 
c01079d7:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01079de:	00 
c01079df:	89 04 24             	mov    %eax,(%esp)
c01079e2:	e8 96 f9 ff ff       	call   c010737d <get_pte>
c01079e7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01079ea:	74 24                	je     c0107a10 <check_pgdir+0x25e>
c01079ec:	c7 44 24 0c 38 af 10 	movl   $0xc010af38,0xc(%esp)
c01079f3:	c0 
c01079f4:	c7 44 24 08 c9 ad 10 	movl   $0xc010adc9,0x8(%esp)
c01079fb:	c0 
c01079fc:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
c0107a03:	00 
c0107a04:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c0107a0b:	e8 e8 89 ff ff       	call   c01003f8 <__panic>

    p2 = alloc_page();
c0107a10:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107a17:	e8 82 f2 ff ff       	call   c0106c9e <alloc_pages>
c0107a1c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0107a1f:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107a24:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0107a2b:	00 
c0107a2c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0107a33:	00 
c0107a34:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107a37:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107a3b:	89 04 24             	mov    %eax,(%esp)
c0107a3e:	e8 70 fb ff ff       	call   c01075b3 <page_insert>
c0107a43:	85 c0                	test   %eax,%eax
c0107a45:	74 24                	je     c0107a6b <check_pgdir+0x2b9>
c0107a47:	c7 44 24 0c 60 af 10 	movl   $0xc010af60,0xc(%esp)
c0107a4e:	c0 
c0107a4f:	c7 44 24 08 c9 ad 10 	movl   $0xc010adc9,0x8(%esp)
c0107a56:	c0 
c0107a57:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
c0107a5e:	00 
c0107a5f:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c0107a66:	e8 8d 89 ff ff       	call   c01003f8 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0107a6b:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107a70:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107a77:	00 
c0107a78:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0107a7f:	00 
c0107a80:	89 04 24             	mov    %eax,(%esp)
c0107a83:	e8 f5 f8 ff ff       	call   c010737d <get_pte>
c0107a88:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107a8b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107a8f:	75 24                	jne    c0107ab5 <check_pgdir+0x303>
c0107a91:	c7 44 24 0c 98 af 10 	movl   $0xc010af98,0xc(%esp)
c0107a98:	c0 
c0107a99:	c7 44 24 08 c9 ad 10 	movl   $0xc010adc9,0x8(%esp)
c0107aa0:	c0 
c0107aa1:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
c0107aa8:	00 
c0107aa9:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c0107ab0:	e8 43 89 ff ff       	call   c01003f8 <__panic>
    assert(*ptep & PTE_U);
c0107ab5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107ab8:	8b 00                	mov    (%eax),%eax
c0107aba:	83 e0 04             	and    $0x4,%eax
c0107abd:	85 c0                	test   %eax,%eax
c0107abf:	75 24                	jne    c0107ae5 <check_pgdir+0x333>
c0107ac1:	c7 44 24 0c c8 af 10 	movl   $0xc010afc8,0xc(%esp)
c0107ac8:	c0 
c0107ac9:	c7 44 24 08 c9 ad 10 	movl   $0xc010adc9,0x8(%esp)
c0107ad0:	c0 
c0107ad1:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
c0107ad8:	00 
c0107ad9:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c0107ae0:	e8 13 89 ff ff       	call   c01003f8 <__panic>
    assert(*ptep & PTE_W);
c0107ae5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107ae8:	8b 00                	mov    (%eax),%eax
c0107aea:	83 e0 02             	and    $0x2,%eax
c0107aed:	85 c0                	test   %eax,%eax
c0107aef:	75 24                	jne    c0107b15 <check_pgdir+0x363>
c0107af1:	c7 44 24 0c d6 af 10 	movl   $0xc010afd6,0xc(%esp)
c0107af8:	c0 
c0107af9:	c7 44 24 08 c9 ad 10 	movl   $0xc010adc9,0x8(%esp)
c0107b00:	c0 
c0107b01:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
c0107b08:	00 
c0107b09:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c0107b10:	e8 e3 88 ff ff       	call   c01003f8 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0107b15:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107b1a:	8b 00                	mov    (%eax),%eax
c0107b1c:	83 e0 04             	and    $0x4,%eax
c0107b1f:	85 c0                	test   %eax,%eax
c0107b21:	75 24                	jne    c0107b47 <check_pgdir+0x395>
c0107b23:	c7 44 24 0c e4 af 10 	movl   $0xc010afe4,0xc(%esp)
c0107b2a:	c0 
c0107b2b:	c7 44 24 08 c9 ad 10 	movl   $0xc010adc9,0x8(%esp)
c0107b32:	c0 
c0107b33:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
c0107b3a:	00 
c0107b3b:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c0107b42:	e8 b1 88 ff ff       	call   c01003f8 <__panic>
    assert(page_ref(p2) == 1);
c0107b47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107b4a:	89 04 24             	mov    %eax,(%esp)
c0107b4d:	e8 47 ef ff ff       	call   c0106a99 <page_ref>
c0107b52:	83 f8 01             	cmp    $0x1,%eax
c0107b55:	74 24                	je     c0107b7b <check_pgdir+0x3c9>
c0107b57:	c7 44 24 0c fa af 10 	movl   $0xc010affa,0xc(%esp)
c0107b5e:	c0 
c0107b5f:	c7 44 24 08 c9 ad 10 	movl   $0xc010adc9,0x8(%esp)
c0107b66:	c0 
c0107b67:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
c0107b6e:	00 
c0107b6f:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c0107b76:	e8 7d 88 ff ff       	call   c01003f8 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0107b7b:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107b80:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0107b87:	00 
c0107b88:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0107b8f:	00 
c0107b90:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107b93:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107b97:	89 04 24             	mov    %eax,(%esp)
c0107b9a:	e8 14 fa ff ff       	call   c01075b3 <page_insert>
c0107b9f:	85 c0                	test   %eax,%eax
c0107ba1:	74 24                	je     c0107bc7 <check_pgdir+0x415>
c0107ba3:	c7 44 24 0c 0c b0 10 	movl   $0xc010b00c,0xc(%esp)
c0107baa:	c0 
c0107bab:	c7 44 24 08 c9 ad 10 	movl   $0xc010adc9,0x8(%esp)
c0107bb2:	c0 
c0107bb3:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
c0107bba:	00 
c0107bbb:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c0107bc2:	e8 31 88 ff ff       	call   c01003f8 <__panic>
    assert(page_ref(p1) == 2);
c0107bc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107bca:	89 04 24             	mov    %eax,(%esp)
c0107bcd:	e8 c7 ee ff ff       	call   c0106a99 <page_ref>
c0107bd2:	83 f8 02             	cmp    $0x2,%eax
c0107bd5:	74 24                	je     c0107bfb <check_pgdir+0x449>
c0107bd7:	c7 44 24 0c 38 b0 10 	movl   $0xc010b038,0xc(%esp)
c0107bde:	c0 
c0107bdf:	c7 44 24 08 c9 ad 10 	movl   $0xc010adc9,0x8(%esp)
c0107be6:	c0 
c0107be7:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
c0107bee:	00 
c0107bef:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c0107bf6:	e8 fd 87 ff ff       	call   c01003f8 <__panic>
    assert(page_ref(p2) == 0);
c0107bfb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107bfe:	89 04 24             	mov    %eax,(%esp)
c0107c01:	e8 93 ee ff ff       	call   c0106a99 <page_ref>
c0107c06:	85 c0                	test   %eax,%eax
c0107c08:	74 24                	je     c0107c2e <check_pgdir+0x47c>
c0107c0a:	c7 44 24 0c 4a b0 10 	movl   $0xc010b04a,0xc(%esp)
c0107c11:	c0 
c0107c12:	c7 44 24 08 c9 ad 10 	movl   $0xc010adc9,0x8(%esp)
c0107c19:	c0 
c0107c1a:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
c0107c21:	00 
c0107c22:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c0107c29:	e8 ca 87 ff ff       	call   c01003f8 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0107c2e:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107c33:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107c3a:	00 
c0107c3b:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0107c42:	00 
c0107c43:	89 04 24             	mov    %eax,(%esp)
c0107c46:	e8 32 f7 ff ff       	call   c010737d <get_pte>
c0107c4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107c4e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107c52:	75 24                	jne    c0107c78 <check_pgdir+0x4c6>
c0107c54:	c7 44 24 0c 98 af 10 	movl   $0xc010af98,0xc(%esp)
c0107c5b:	c0 
c0107c5c:	c7 44 24 08 c9 ad 10 	movl   $0xc010adc9,0x8(%esp)
c0107c63:	c0 
c0107c64:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
c0107c6b:	00 
c0107c6c:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c0107c73:	e8 80 87 ff ff       	call   c01003f8 <__panic>
    assert(pte2page(*ptep) == p1);
c0107c78:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107c7b:	8b 00                	mov    (%eax),%eax
c0107c7d:	89 04 24             	mov    %eax,(%esp)
c0107c80:	e8 be ed ff ff       	call   c0106a43 <pte2page>
c0107c85:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0107c88:	74 24                	je     c0107cae <check_pgdir+0x4fc>
c0107c8a:	c7 44 24 0c 0d af 10 	movl   $0xc010af0d,0xc(%esp)
c0107c91:	c0 
c0107c92:	c7 44 24 08 c9 ad 10 	movl   $0xc010adc9,0x8(%esp)
c0107c99:	c0 
c0107c9a:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
c0107ca1:	00 
c0107ca2:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c0107ca9:	e8 4a 87 ff ff       	call   c01003f8 <__panic>
    assert((*ptep & PTE_U) == 0);
c0107cae:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107cb1:	8b 00                	mov    (%eax),%eax
c0107cb3:	83 e0 04             	and    $0x4,%eax
c0107cb6:	85 c0                	test   %eax,%eax
c0107cb8:	74 24                	je     c0107cde <check_pgdir+0x52c>
c0107cba:	c7 44 24 0c 5c b0 10 	movl   $0xc010b05c,0xc(%esp)
c0107cc1:	c0 
c0107cc2:	c7 44 24 08 c9 ad 10 	movl   $0xc010adc9,0x8(%esp)
c0107cc9:	c0 
c0107cca:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
c0107cd1:	00 
c0107cd2:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c0107cd9:	e8 1a 87 ff ff       	call   c01003f8 <__panic>

    page_remove(boot_pgdir, 0x0);
c0107cde:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107ce3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0107cea:	00 
c0107ceb:	89 04 24             	mov    %eax,(%esp)
c0107cee:	e8 7c f8 ff ff       	call   c010756f <page_remove>
    assert(page_ref(p1) == 1);
c0107cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107cf6:	89 04 24             	mov    %eax,(%esp)
c0107cf9:	e8 9b ed ff ff       	call   c0106a99 <page_ref>
c0107cfe:	83 f8 01             	cmp    $0x1,%eax
c0107d01:	74 24                	je     c0107d27 <check_pgdir+0x575>
c0107d03:	c7 44 24 0c 23 af 10 	movl   $0xc010af23,0xc(%esp)
c0107d0a:	c0 
c0107d0b:	c7 44 24 08 c9 ad 10 	movl   $0xc010adc9,0x8(%esp)
c0107d12:	c0 
c0107d13:	c7 44 24 04 28 02 00 	movl   $0x228,0x4(%esp)
c0107d1a:	00 
c0107d1b:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c0107d22:	e8 d1 86 ff ff       	call   c01003f8 <__panic>
    assert(page_ref(p2) == 0);
c0107d27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107d2a:	89 04 24             	mov    %eax,(%esp)
c0107d2d:	e8 67 ed ff ff       	call   c0106a99 <page_ref>
c0107d32:	85 c0                	test   %eax,%eax
c0107d34:	74 24                	je     c0107d5a <check_pgdir+0x5a8>
c0107d36:	c7 44 24 0c 4a b0 10 	movl   $0xc010b04a,0xc(%esp)
c0107d3d:	c0 
c0107d3e:	c7 44 24 08 c9 ad 10 	movl   $0xc010adc9,0x8(%esp)
c0107d45:	c0 
c0107d46:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
c0107d4d:	00 
c0107d4e:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c0107d55:	e8 9e 86 ff ff       	call   c01003f8 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0107d5a:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107d5f:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0107d66:	00 
c0107d67:	89 04 24             	mov    %eax,(%esp)
c0107d6a:	e8 00 f8 ff ff       	call   c010756f <page_remove>
    assert(page_ref(p1) == 0);
c0107d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107d72:	89 04 24             	mov    %eax,(%esp)
c0107d75:	e8 1f ed ff ff       	call   c0106a99 <page_ref>
c0107d7a:	85 c0                	test   %eax,%eax
c0107d7c:	74 24                	je     c0107da2 <check_pgdir+0x5f0>
c0107d7e:	c7 44 24 0c 71 b0 10 	movl   $0xc010b071,0xc(%esp)
c0107d85:	c0 
c0107d86:	c7 44 24 08 c9 ad 10 	movl   $0xc010adc9,0x8(%esp)
c0107d8d:	c0 
c0107d8e:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
c0107d95:	00 
c0107d96:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c0107d9d:	e8 56 86 ff ff       	call   c01003f8 <__panic>
    assert(page_ref(p2) == 0);
c0107da2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107da5:	89 04 24             	mov    %eax,(%esp)
c0107da8:	e8 ec ec ff ff       	call   c0106a99 <page_ref>
c0107dad:	85 c0                	test   %eax,%eax
c0107daf:	74 24                	je     c0107dd5 <check_pgdir+0x623>
c0107db1:	c7 44 24 0c 4a b0 10 	movl   $0xc010b04a,0xc(%esp)
c0107db8:	c0 
c0107db9:	c7 44 24 08 c9 ad 10 	movl   $0xc010adc9,0x8(%esp)
c0107dc0:	c0 
c0107dc1:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
c0107dc8:	00 
c0107dc9:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c0107dd0:	e8 23 86 ff ff       	call   c01003f8 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0107dd5:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107dda:	8b 00                	mov    (%eax),%eax
c0107ddc:	89 04 24             	mov    %eax,(%esp)
c0107ddf:	e8 9d ec ff ff       	call   c0106a81 <pde2page>
c0107de4:	89 04 24             	mov    %eax,(%esp)
c0107de7:	e8 ad ec ff ff       	call   c0106a99 <page_ref>
c0107dec:	83 f8 01             	cmp    $0x1,%eax
c0107def:	74 24                	je     c0107e15 <check_pgdir+0x663>
c0107df1:	c7 44 24 0c 84 b0 10 	movl   $0xc010b084,0xc(%esp)
c0107df8:	c0 
c0107df9:	c7 44 24 08 c9 ad 10 	movl   $0xc010adc9,0x8(%esp)
c0107e00:	c0 
c0107e01:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
c0107e08:	00 
c0107e09:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c0107e10:	e8 e3 85 ff ff       	call   c01003f8 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0107e15:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107e1a:	8b 00                	mov    (%eax),%eax
c0107e1c:	89 04 24             	mov    %eax,(%esp)
c0107e1f:	e8 5d ec ff ff       	call   c0106a81 <pde2page>
c0107e24:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0107e2b:	00 
c0107e2c:	89 04 24             	mov    %eax,(%esp)
c0107e2f:	e8 d5 ee ff ff       	call   c0106d09 <free_pages>
    boot_pgdir[0] = 0;
c0107e34:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107e39:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0107e3f:	c7 04 24 ab b0 10 c0 	movl   $0xc010b0ab,(%esp)
c0107e46:	e8 56 84 ff ff       	call   c01002a1 <cprintf>
}
c0107e4b:	c9                   	leave  
c0107e4c:	c3                   	ret    

c0107e4d <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0107e4d:	55                   	push   %ebp
c0107e4e:	89 e5                	mov    %esp,%ebp
c0107e50:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0107e53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0107e5a:	e9 ca 00 00 00       	jmp    c0107f29 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0107e5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e62:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107e65:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107e68:	c1 e8 0c             	shr    $0xc,%eax
c0107e6b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0107e6e:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0107e73:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0107e76:	72 23                	jb     c0107e9b <check_boot_pgdir+0x4e>
c0107e78:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107e7b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107e7f:	c7 44 24 08 dc ac 10 	movl   $0xc010acdc,0x8(%esp)
c0107e86:	c0 
c0107e87:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
c0107e8e:	00 
c0107e8f:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c0107e96:	e8 5d 85 ff ff       	call   c01003f8 <__panic>
c0107e9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107e9e:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0107ea3:	89 c2                	mov    %eax,%edx
c0107ea5:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107eaa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107eb1:	00 
c0107eb2:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107eb6:	89 04 24             	mov    %eax,(%esp)
c0107eb9:	e8 bf f4 ff ff       	call   c010737d <get_pte>
c0107ebe:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107ec1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0107ec5:	75 24                	jne    c0107eeb <check_boot_pgdir+0x9e>
c0107ec7:	c7 44 24 0c c8 b0 10 	movl   $0xc010b0c8,0xc(%esp)
c0107ece:	c0 
c0107ecf:	c7 44 24 08 c9 ad 10 	movl   $0xc010adc9,0x8(%esp)
c0107ed6:	c0 
c0107ed7:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
c0107ede:	00 
c0107edf:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c0107ee6:	e8 0d 85 ff ff       	call   c01003f8 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0107eeb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107eee:	8b 00                	mov    (%eax),%eax
c0107ef0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107ef5:	89 c2                	mov    %eax,%edx
c0107ef7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107efa:	39 c2                	cmp    %eax,%edx
c0107efc:	74 24                	je     c0107f22 <check_boot_pgdir+0xd5>
c0107efe:	c7 44 24 0c 05 b1 10 	movl   $0xc010b105,0xc(%esp)
c0107f05:	c0 
c0107f06:	c7 44 24 08 c9 ad 10 	movl   $0xc010adc9,0x8(%esp)
c0107f0d:	c0 
c0107f0e:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
c0107f15:	00 
c0107f16:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c0107f1d:	e8 d6 84 ff ff       	call   c01003f8 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
c0107f22:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0107f29:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107f2c:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c0107f31:	39 c2                	cmp    %eax,%edx
c0107f33:	0f 82 26 ff ff ff    	jb     c0107e5f <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0107f39:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107f3e:	05 ac 0f 00 00       	add    $0xfac,%eax
c0107f43:	8b 00                	mov    (%eax),%eax
c0107f45:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107f4a:	89 c2                	mov    %eax,%edx
c0107f4c:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107f51:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0107f54:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0107f5b:	77 23                	ja     c0107f80 <check_boot_pgdir+0x133>
c0107f5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107f60:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107f64:	c7 44 24 08 00 ad 10 	movl   $0xc010ad00,0x8(%esp)
c0107f6b:	c0 
c0107f6c:	c7 44 24 04 3f 02 00 	movl   $0x23f,0x4(%esp)
c0107f73:	00 
c0107f74:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c0107f7b:	e8 78 84 ff ff       	call   c01003f8 <__panic>
c0107f80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107f83:	05 00 00 00 40       	add    $0x40000000,%eax
c0107f88:	39 c2                	cmp    %eax,%edx
c0107f8a:	74 24                	je     c0107fb0 <check_boot_pgdir+0x163>
c0107f8c:	c7 44 24 0c 1c b1 10 	movl   $0xc010b11c,0xc(%esp)
c0107f93:	c0 
c0107f94:	c7 44 24 08 c9 ad 10 	movl   $0xc010adc9,0x8(%esp)
c0107f9b:	c0 
c0107f9c:	c7 44 24 04 3f 02 00 	movl   $0x23f,0x4(%esp)
c0107fa3:	00 
c0107fa4:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c0107fab:	e8 48 84 ff ff       	call   c01003f8 <__panic>

    assert(boot_pgdir[0] == 0);
c0107fb0:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107fb5:	8b 00                	mov    (%eax),%eax
c0107fb7:	85 c0                	test   %eax,%eax
c0107fb9:	74 24                	je     c0107fdf <check_boot_pgdir+0x192>
c0107fbb:	c7 44 24 0c 50 b1 10 	movl   $0xc010b150,0xc(%esp)
c0107fc2:	c0 
c0107fc3:	c7 44 24 08 c9 ad 10 	movl   $0xc010adc9,0x8(%esp)
c0107fca:	c0 
c0107fcb:	c7 44 24 04 41 02 00 	movl   $0x241,0x4(%esp)
c0107fd2:	00 
c0107fd3:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c0107fda:	e8 19 84 ff ff       	call   c01003f8 <__panic>

    struct Page *p;
    p = alloc_page();
c0107fdf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107fe6:	e8 b3 ec ff ff       	call   c0106c9e <alloc_pages>
c0107feb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0107fee:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0107ff3:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0107ffa:	00 
c0107ffb:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0108002:	00 
c0108003:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0108006:	89 54 24 04          	mov    %edx,0x4(%esp)
c010800a:	89 04 24             	mov    %eax,(%esp)
c010800d:	e8 a1 f5 ff ff       	call   c01075b3 <page_insert>
c0108012:	85 c0                	test   %eax,%eax
c0108014:	74 24                	je     c010803a <check_boot_pgdir+0x1ed>
c0108016:	c7 44 24 0c 64 b1 10 	movl   $0xc010b164,0xc(%esp)
c010801d:	c0 
c010801e:	c7 44 24 08 c9 ad 10 	movl   $0xc010adc9,0x8(%esp)
c0108025:	c0 
c0108026:	c7 44 24 04 45 02 00 	movl   $0x245,0x4(%esp)
c010802d:	00 
c010802e:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c0108035:	e8 be 83 ff ff       	call   c01003f8 <__panic>
    assert(page_ref(p) == 1);
c010803a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010803d:	89 04 24             	mov    %eax,(%esp)
c0108040:	e8 54 ea ff ff       	call   c0106a99 <page_ref>
c0108045:	83 f8 01             	cmp    $0x1,%eax
c0108048:	74 24                	je     c010806e <check_boot_pgdir+0x221>
c010804a:	c7 44 24 0c 92 b1 10 	movl   $0xc010b192,0xc(%esp)
c0108051:	c0 
c0108052:	c7 44 24 08 c9 ad 10 	movl   $0xc010adc9,0x8(%esp)
c0108059:	c0 
c010805a:	c7 44 24 04 46 02 00 	movl   $0x246,0x4(%esp)
c0108061:	00 
c0108062:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c0108069:	e8 8a 83 ff ff       	call   c01003f8 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c010806e:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0108073:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c010807a:	00 
c010807b:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0108082:	00 
c0108083:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0108086:	89 54 24 04          	mov    %edx,0x4(%esp)
c010808a:	89 04 24             	mov    %eax,(%esp)
c010808d:	e8 21 f5 ff ff       	call   c01075b3 <page_insert>
c0108092:	85 c0                	test   %eax,%eax
c0108094:	74 24                	je     c01080ba <check_boot_pgdir+0x26d>
c0108096:	c7 44 24 0c a4 b1 10 	movl   $0xc010b1a4,0xc(%esp)
c010809d:	c0 
c010809e:	c7 44 24 08 c9 ad 10 	movl   $0xc010adc9,0x8(%esp)
c01080a5:	c0 
c01080a6:	c7 44 24 04 47 02 00 	movl   $0x247,0x4(%esp)
c01080ad:	00 
c01080ae:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c01080b5:	e8 3e 83 ff ff       	call   c01003f8 <__panic>
    assert(page_ref(p) == 2);
c01080ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01080bd:	89 04 24             	mov    %eax,(%esp)
c01080c0:	e8 d4 e9 ff ff       	call   c0106a99 <page_ref>
c01080c5:	83 f8 02             	cmp    $0x2,%eax
c01080c8:	74 24                	je     c01080ee <check_boot_pgdir+0x2a1>
c01080ca:	c7 44 24 0c db b1 10 	movl   $0xc010b1db,0xc(%esp)
c01080d1:	c0 
c01080d2:	c7 44 24 08 c9 ad 10 	movl   $0xc010adc9,0x8(%esp)
c01080d9:	c0 
c01080da:	c7 44 24 04 48 02 00 	movl   $0x248,0x4(%esp)
c01080e1:	00 
c01080e2:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c01080e9:	e8 0a 83 ff ff       	call   c01003f8 <__panic>

    const char *str = "ucore: Hello world!!";
c01080ee:	c7 45 dc ec b1 10 c0 	movl   $0xc010b1ec,-0x24(%ebp)
    strcpy((void *)0x100, str);
c01080f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01080f8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01080fc:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0108103:	e8 7c 06 00 00       	call   c0108784 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0108108:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c010810f:	00 
c0108110:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0108117:	e8 e1 06 00 00       	call   c01087fd <strcmp>
c010811c:	85 c0                	test   %eax,%eax
c010811e:	74 24                	je     c0108144 <check_boot_pgdir+0x2f7>
c0108120:	c7 44 24 0c 04 b2 10 	movl   $0xc010b204,0xc(%esp)
c0108127:	c0 
c0108128:	c7 44 24 08 c9 ad 10 	movl   $0xc010adc9,0x8(%esp)
c010812f:	c0 
c0108130:	c7 44 24 04 4c 02 00 	movl   $0x24c,0x4(%esp)
c0108137:	00 
c0108138:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c010813f:	e8 b4 82 ff ff       	call   c01003f8 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0108144:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108147:	89 04 24             	mov    %eax,(%esp)
c010814a:	e8 56 e8 ff ff       	call   c01069a5 <page2kva>
c010814f:	05 00 01 00 00       	add    $0x100,%eax
c0108154:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0108157:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c010815e:	e8 c9 05 00 00       	call   c010872c <strlen>
c0108163:	85 c0                	test   %eax,%eax
c0108165:	74 24                	je     c010818b <check_boot_pgdir+0x33e>
c0108167:	c7 44 24 0c 3c b2 10 	movl   $0xc010b23c,0xc(%esp)
c010816e:	c0 
c010816f:	c7 44 24 08 c9 ad 10 	movl   $0xc010adc9,0x8(%esp)
c0108176:	c0 
c0108177:	c7 44 24 04 4f 02 00 	movl   $0x24f,0x4(%esp)
c010817e:	00 
c010817f:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c0108186:	e8 6d 82 ff ff       	call   c01003f8 <__panic>

    free_page(p);
c010818b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0108192:	00 
c0108193:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108196:	89 04 24             	mov    %eax,(%esp)
c0108199:	e8 6b eb ff ff       	call   c0106d09 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c010819e:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c01081a3:	8b 00                	mov    (%eax),%eax
c01081a5:	89 04 24             	mov    %eax,(%esp)
c01081a8:	e8 d4 e8 ff ff       	call   c0106a81 <pde2page>
c01081ad:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01081b4:	00 
c01081b5:	89 04 24             	mov    %eax,(%esp)
c01081b8:	e8 4c eb ff ff       	call   c0106d09 <free_pages>
    boot_pgdir[0] = 0;
c01081bd:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c01081c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c01081c8:	c7 04 24 60 b2 10 c0 	movl   $0xc010b260,(%esp)
c01081cf:	e8 cd 80 ff ff       	call   c01002a1 <cprintf>
}
c01081d4:	c9                   	leave  
c01081d5:	c3                   	ret    

c01081d6 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c01081d6:	55                   	push   %ebp
c01081d7:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c01081d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01081dc:	83 e0 04             	and    $0x4,%eax
c01081df:	85 c0                	test   %eax,%eax
c01081e1:	74 07                	je     c01081ea <perm2str+0x14>
c01081e3:	b8 75 00 00 00       	mov    $0x75,%eax
c01081e8:	eb 05                	jmp    c01081ef <perm2str+0x19>
c01081ea:	b8 2d 00 00 00       	mov    $0x2d,%eax
c01081ef:	a2 08 50 12 c0       	mov    %al,0xc0125008
    str[1] = 'r';
c01081f4:	c6 05 09 50 12 c0 72 	movb   $0x72,0xc0125009
    str[2] = (perm & PTE_W) ? 'w' : '-';
c01081fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01081fe:	83 e0 02             	and    $0x2,%eax
c0108201:	85 c0                	test   %eax,%eax
c0108203:	74 07                	je     c010820c <perm2str+0x36>
c0108205:	b8 77 00 00 00       	mov    $0x77,%eax
c010820a:	eb 05                	jmp    c0108211 <perm2str+0x3b>
c010820c:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0108211:	a2 0a 50 12 c0       	mov    %al,0xc012500a
    str[3] = '\0';
c0108216:	c6 05 0b 50 12 c0 00 	movb   $0x0,0xc012500b
    return str;
c010821d:	b8 08 50 12 c0       	mov    $0xc0125008,%eax
}
c0108222:	5d                   	pop    %ebp
c0108223:	c3                   	ret    

c0108224 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0108224:	55                   	push   %ebp
c0108225:	89 e5                	mov    %esp,%ebp
c0108227:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c010822a:	8b 45 10             	mov    0x10(%ebp),%eax
c010822d:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0108230:	72 0a                	jb     c010823c <get_pgtable_items+0x18>
        return 0;
c0108232:	b8 00 00 00 00       	mov    $0x0,%eax
c0108237:	e9 9c 00 00 00       	jmp    c01082d8 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c010823c:	eb 04                	jmp    c0108242 <get_pgtable_items+0x1e>
        start ++;
c010823e:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
c0108242:	8b 45 10             	mov    0x10(%ebp),%eax
c0108245:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0108248:	73 18                	jae    c0108262 <get_pgtable_items+0x3e>
c010824a:	8b 45 10             	mov    0x10(%ebp),%eax
c010824d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0108254:	8b 45 14             	mov    0x14(%ebp),%eax
c0108257:	01 d0                	add    %edx,%eax
c0108259:	8b 00                	mov    (%eax),%eax
c010825b:	83 e0 01             	and    $0x1,%eax
c010825e:	85 c0                	test   %eax,%eax
c0108260:	74 dc                	je     c010823e <get_pgtable_items+0x1a>
    }
    if (start < right) {
c0108262:	8b 45 10             	mov    0x10(%ebp),%eax
c0108265:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0108268:	73 69                	jae    c01082d3 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c010826a:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c010826e:	74 08                	je     c0108278 <get_pgtable_items+0x54>
            *left_store = start;
c0108270:	8b 45 18             	mov    0x18(%ebp),%eax
c0108273:	8b 55 10             	mov    0x10(%ebp),%edx
c0108276:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0108278:	8b 45 10             	mov    0x10(%ebp),%eax
c010827b:	8d 50 01             	lea    0x1(%eax),%edx
c010827e:	89 55 10             	mov    %edx,0x10(%ebp)
c0108281:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0108288:	8b 45 14             	mov    0x14(%ebp),%eax
c010828b:	01 d0                	add    %edx,%eax
c010828d:	8b 00                	mov    (%eax),%eax
c010828f:	83 e0 07             	and    $0x7,%eax
c0108292:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0108295:	eb 04                	jmp    c010829b <get_pgtable_items+0x77>
            start ++;
c0108297:	83 45 10 01          	addl   $0x1,0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c010829b:	8b 45 10             	mov    0x10(%ebp),%eax
c010829e:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01082a1:	73 1d                	jae    c01082c0 <get_pgtable_items+0x9c>
c01082a3:	8b 45 10             	mov    0x10(%ebp),%eax
c01082a6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01082ad:	8b 45 14             	mov    0x14(%ebp),%eax
c01082b0:	01 d0                	add    %edx,%eax
c01082b2:	8b 00                	mov    (%eax),%eax
c01082b4:	83 e0 07             	and    $0x7,%eax
c01082b7:	89 c2                	mov    %eax,%edx
c01082b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01082bc:	39 c2                	cmp    %eax,%edx
c01082be:	74 d7                	je     c0108297 <get_pgtable_items+0x73>
        }
        if (right_store != NULL) {
c01082c0:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01082c4:	74 08                	je     c01082ce <get_pgtable_items+0xaa>
            *right_store = start;
c01082c6:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01082c9:	8b 55 10             	mov    0x10(%ebp),%edx
c01082cc:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c01082ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01082d1:	eb 05                	jmp    c01082d8 <get_pgtable_items+0xb4>
    }
    return 0;
c01082d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01082d8:	c9                   	leave  
c01082d9:	c3                   	ret    

c01082da <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c01082da:	55                   	push   %ebp
c01082db:	89 e5                	mov    %esp,%ebp
c01082dd:	57                   	push   %edi
c01082de:	56                   	push   %esi
c01082df:	53                   	push   %ebx
c01082e0:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c01082e3:	c7 04 24 80 b2 10 c0 	movl   $0xc010b280,(%esp)
c01082ea:	e8 b2 7f ff ff       	call   c01002a1 <cprintf>
    size_t left, right = 0, perm;
c01082ef:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01082f6:	e9 fa 00 00 00       	jmp    c01083f5 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01082fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01082fe:	89 04 24             	mov    %eax,(%esp)
c0108301:	e8 d0 fe ff ff       	call   c01081d6 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0108306:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0108309:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010830c:	29 d1                	sub    %edx,%ecx
c010830e:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0108310:	89 d6                	mov    %edx,%esi
c0108312:	c1 e6 16             	shl    $0x16,%esi
c0108315:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108318:	89 d3                	mov    %edx,%ebx
c010831a:	c1 e3 16             	shl    $0x16,%ebx
c010831d:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0108320:	89 d1                	mov    %edx,%ecx
c0108322:	c1 e1 16             	shl    $0x16,%ecx
c0108325:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0108328:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010832b:	29 d7                	sub    %edx,%edi
c010832d:	89 fa                	mov    %edi,%edx
c010832f:	89 44 24 14          	mov    %eax,0x14(%esp)
c0108333:	89 74 24 10          	mov    %esi,0x10(%esp)
c0108337:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010833b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c010833f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108343:	c7 04 24 b1 b2 10 c0 	movl   $0xc010b2b1,(%esp)
c010834a:	e8 52 7f ff ff       	call   c01002a1 <cprintf>
        size_t l, r = left * NPTEENTRY;
c010834f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108352:	c1 e0 0a             	shl    $0xa,%eax
c0108355:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0108358:	eb 54                	jmp    c01083ae <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010835a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010835d:	89 04 24             	mov    %eax,(%esp)
c0108360:	e8 71 fe ff ff       	call   c01081d6 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0108365:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0108368:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010836b:	29 d1                	sub    %edx,%ecx
c010836d:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010836f:	89 d6                	mov    %edx,%esi
c0108371:	c1 e6 0c             	shl    $0xc,%esi
c0108374:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0108377:	89 d3                	mov    %edx,%ebx
c0108379:	c1 e3 0c             	shl    $0xc,%ebx
c010837c:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010837f:	c1 e2 0c             	shl    $0xc,%edx
c0108382:	89 d1                	mov    %edx,%ecx
c0108384:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0108387:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010838a:	29 d7                	sub    %edx,%edi
c010838c:	89 fa                	mov    %edi,%edx
c010838e:	89 44 24 14          	mov    %eax,0x14(%esp)
c0108392:	89 74 24 10          	mov    %esi,0x10(%esp)
c0108396:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010839a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c010839e:	89 54 24 04          	mov    %edx,0x4(%esp)
c01083a2:	c7 04 24 d0 b2 10 c0 	movl   $0xc010b2d0,(%esp)
c01083a9:	e8 f3 7e ff ff       	call   c01002a1 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01083ae:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c01083b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01083b6:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01083b9:	89 ce                	mov    %ecx,%esi
c01083bb:	c1 e6 0a             	shl    $0xa,%esi
c01083be:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c01083c1:	89 cb                	mov    %ecx,%ebx
c01083c3:	c1 e3 0a             	shl    $0xa,%ebx
c01083c6:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c01083c9:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c01083cd:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c01083d0:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01083d4:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01083d8:	89 44 24 08          	mov    %eax,0x8(%esp)
c01083dc:	89 74 24 04          	mov    %esi,0x4(%esp)
c01083e0:	89 1c 24             	mov    %ebx,(%esp)
c01083e3:	e8 3c fe ff ff       	call   c0108224 <get_pgtable_items>
c01083e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01083eb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01083ef:	0f 85 65 ff ff ff    	jne    c010835a <print_pgdir+0x80>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01083f5:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c01083fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01083fd:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c0108400:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0108404:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c0108407:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c010840b:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010840f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108413:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c010841a:	00 
c010841b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0108422:	e8 fd fd ff ff       	call   c0108224 <get_pgtable_items>
c0108427:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010842a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010842e:	0f 85 c7 fe ff ff    	jne    c01082fb <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0108434:	c7 04 24 f4 b2 10 c0 	movl   $0xc010b2f4,(%esp)
c010843b:	e8 61 7e ff ff       	call   c01002a1 <cprintf>
}
c0108440:	83 c4 4c             	add    $0x4c,%esp
c0108443:	5b                   	pop    %ebx
c0108444:	5e                   	pop    %esi
c0108445:	5f                   	pop    %edi
c0108446:	5d                   	pop    %ebp
c0108447:	c3                   	ret    

c0108448 <kmalloc>:

void *
kmalloc(size_t n) {
c0108448:	55                   	push   %ebp
c0108449:	89 e5                	mov    %esp,%ebp
c010844b:	83 ec 28             	sub    $0x28,%esp
    void * ptr=NULL;
c010844e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    struct Page *base=NULL;
c0108455:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    assert(n > 0 && n < 1024*0124);
c010845c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0108460:	74 09                	je     c010846b <kmalloc+0x23>
c0108462:	81 7d 08 ff 4f 01 00 	cmpl   $0x14fff,0x8(%ebp)
c0108469:	76 24                	jbe    c010848f <kmalloc+0x47>
c010846b:	c7 44 24 0c 25 b3 10 	movl   $0xc010b325,0xc(%esp)
c0108472:	c0 
c0108473:	c7 44 24 08 c9 ad 10 	movl   $0xc010adc9,0x8(%esp)
c010847a:	c0 
c010847b:	c7 44 24 04 9b 02 00 	movl   $0x29b,0x4(%esp)
c0108482:	00 
c0108483:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c010848a:	e8 69 7f ff ff       	call   c01003f8 <__panic>
    int num_pages=(n+PGSIZE-1)/PGSIZE;
c010848f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108492:	05 ff 0f 00 00       	add    $0xfff,%eax
c0108497:	c1 e8 0c             	shr    $0xc,%eax
c010849a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    base = alloc_pages(num_pages);
c010849d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01084a0:	89 04 24             	mov    %eax,(%esp)
c01084a3:	e8 f6 e7 ff ff       	call   c0106c9e <alloc_pages>
c01084a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(base != NULL);
c01084ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01084af:	75 24                	jne    c01084d5 <kmalloc+0x8d>
c01084b1:	c7 44 24 0c 3c b3 10 	movl   $0xc010b33c,0xc(%esp)
c01084b8:	c0 
c01084b9:	c7 44 24 08 c9 ad 10 	movl   $0xc010adc9,0x8(%esp)
c01084c0:	c0 
c01084c1:	c7 44 24 04 9e 02 00 	movl   $0x29e,0x4(%esp)
c01084c8:	00 
c01084c9:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c01084d0:	e8 23 7f ff ff       	call   c01003f8 <__panic>
    ptr=page2kva(base);
c01084d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01084d8:	89 04 24             	mov    %eax,(%esp)
c01084db:	e8 c5 e4 ff ff       	call   c01069a5 <page2kva>
c01084e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ptr;
c01084e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01084e6:	c9                   	leave  
c01084e7:	c3                   	ret    

c01084e8 <kfree>:

void 
kfree(void *ptr, size_t n) {
c01084e8:	55                   	push   %ebp
c01084e9:	89 e5                	mov    %esp,%ebp
c01084eb:	83 ec 28             	sub    $0x28,%esp
    assert(n > 0 && n < 1024*0124);
c01084ee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01084f2:	74 09                	je     c01084fd <kfree+0x15>
c01084f4:	81 7d 0c ff 4f 01 00 	cmpl   $0x14fff,0xc(%ebp)
c01084fb:	76 24                	jbe    c0108521 <kfree+0x39>
c01084fd:	c7 44 24 0c 25 b3 10 	movl   $0xc010b325,0xc(%esp)
c0108504:	c0 
c0108505:	c7 44 24 08 c9 ad 10 	movl   $0xc010adc9,0x8(%esp)
c010850c:	c0 
c010850d:	c7 44 24 04 a5 02 00 	movl   $0x2a5,0x4(%esp)
c0108514:	00 
c0108515:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c010851c:	e8 d7 7e ff ff       	call   c01003f8 <__panic>
    assert(ptr != NULL);
c0108521:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0108525:	75 24                	jne    c010854b <kfree+0x63>
c0108527:	c7 44 24 0c 49 b3 10 	movl   $0xc010b349,0xc(%esp)
c010852e:	c0 
c010852f:	c7 44 24 08 c9 ad 10 	movl   $0xc010adc9,0x8(%esp)
c0108536:	c0 
c0108537:	c7 44 24 04 a6 02 00 	movl   $0x2a6,0x4(%esp)
c010853e:	00 
c010853f:	c7 04 24 a4 ad 10 c0 	movl   $0xc010ada4,(%esp)
c0108546:	e8 ad 7e ff ff       	call   c01003f8 <__panic>
    struct Page *base=NULL;
c010854b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int num_pages=(n+PGSIZE-1)/PGSIZE;
c0108552:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108555:	05 ff 0f 00 00       	add    $0xfff,%eax
c010855a:	c1 e8 0c             	shr    $0xc,%eax
c010855d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    base = kva2page(ptr);
c0108560:	8b 45 08             	mov    0x8(%ebp),%eax
c0108563:	89 04 24             	mov    %eax,(%esp)
c0108566:	e8 8e e4 ff ff       	call   c01069f9 <kva2page>
c010856b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    free_pages(base, num_pages);
c010856e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108571:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108575:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108578:	89 04 24             	mov    %eax,(%esp)
c010857b:	e8 89 e7 ff ff       	call   c0106d09 <free_pages>
}
c0108580:	c9                   	leave  
c0108581:	c3                   	ret    

c0108582 <page2ppn>:
page2ppn(struct Page *page) {
c0108582:	55                   	push   %ebp
c0108583:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0108585:	8b 55 08             	mov    0x8(%ebp),%edx
c0108588:	a1 f8 50 12 c0       	mov    0xc01250f8,%eax
c010858d:	29 c2                	sub    %eax,%edx
c010858f:	89 d0                	mov    %edx,%eax
c0108591:	c1 f8 05             	sar    $0x5,%eax
}
c0108594:	5d                   	pop    %ebp
c0108595:	c3                   	ret    

c0108596 <page2pa>:
page2pa(struct Page *page) {
c0108596:	55                   	push   %ebp
c0108597:	89 e5                	mov    %esp,%ebp
c0108599:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c010859c:	8b 45 08             	mov    0x8(%ebp),%eax
c010859f:	89 04 24             	mov    %eax,(%esp)
c01085a2:	e8 db ff ff ff       	call   c0108582 <page2ppn>
c01085a7:	c1 e0 0c             	shl    $0xc,%eax
}
c01085aa:	c9                   	leave  
c01085ab:	c3                   	ret    

c01085ac <page2kva>:
page2kva(struct Page *page) {
c01085ac:	55                   	push   %ebp
c01085ad:	89 e5                	mov    %esp,%ebp
c01085af:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c01085b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01085b5:	89 04 24             	mov    %eax,(%esp)
c01085b8:	e8 d9 ff ff ff       	call   c0108596 <page2pa>
c01085bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01085c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01085c3:	c1 e8 0c             	shr    $0xc,%eax
c01085c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01085c9:	a1 80 4f 12 c0       	mov    0xc0124f80,%eax
c01085ce:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01085d1:	72 23                	jb     c01085f6 <page2kva+0x4a>
c01085d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01085d6:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01085da:	c7 44 24 08 58 b3 10 	movl   $0xc010b358,0x8(%esp)
c01085e1:	c0 
c01085e2:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
c01085e9:	00 
c01085ea:	c7 04 24 7b b3 10 c0 	movl   $0xc010b37b,(%esp)
c01085f1:	e8 02 7e ff ff       	call   c01003f8 <__panic>
c01085f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01085f9:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c01085fe:	c9                   	leave  
c01085ff:	c3                   	ret    

c0108600 <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
c0108600:	55                   	push   %ebp
c0108601:	89 e5                	mov    %esp,%ebp
c0108603:	83 ec 18             	sub    $0x18,%esp
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
c0108606:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010860d:	e8 0f 8b ff ff       	call   c0101121 <ide_device_valid>
c0108612:	85 c0                	test   %eax,%eax
c0108614:	75 1c                	jne    c0108632 <swapfs_init+0x32>
        panic("swap fs isn't available.\n");
c0108616:	c7 44 24 08 89 b3 10 	movl   $0xc010b389,0x8(%esp)
c010861d:	c0 
c010861e:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
c0108625:	00 
c0108626:	c7 04 24 a3 b3 10 c0 	movl   $0xc010b3a3,(%esp)
c010862d:	e8 c6 7d ff ff       	call   c01003f8 <__panic>
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
c0108632:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108639:	e8 22 8b ff ff       	call   c0101160 <ide_device_size>
c010863e:	c1 e8 03             	shr    $0x3,%eax
c0108641:	a3 bc 50 12 c0       	mov    %eax,0xc01250bc
}
c0108646:	c9                   	leave  
c0108647:	c3                   	ret    

c0108648 <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
c0108648:	55                   	push   %ebp
c0108649:	89 e5                	mov    %esp,%ebp
c010864b:	83 ec 28             	sub    $0x28,%esp
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c010864e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108651:	89 04 24             	mov    %eax,(%esp)
c0108654:	e8 53 ff ff ff       	call   c01085ac <page2kva>
c0108659:	8b 55 08             	mov    0x8(%ebp),%edx
c010865c:	c1 ea 08             	shr    $0x8,%edx
c010865f:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0108662:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108666:	74 0b                	je     c0108673 <swapfs_read+0x2b>
c0108668:	8b 15 bc 50 12 c0    	mov    0xc01250bc,%edx
c010866e:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c0108671:	72 23                	jb     c0108696 <swapfs_read+0x4e>
c0108673:	8b 45 08             	mov    0x8(%ebp),%eax
c0108676:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010867a:	c7 44 24 08 b4 b3 10 	movl   $0xc010b3b4,0x8(%esp)
c0108681:	c0 
c0108682:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
c0108689:	00 
c010868a:	c7 04 24 a3 b3 10 c0 	movl   $0xc010b3a3,(%esp)
c0108691:	e8 62 7d ff ff       	call   c01003f8 <__panic>
c0108696:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108699:	c1 e2 03             	shl    $0x3,%edx
c010869c:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c01086a3:	00 
c01086a4:	89 44 24 08          	mov    %eax,0x8(%esp)
c01086a8:	89 54 24 04          	mov    %edx,0x4(%esp)
c01086ac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01086b3:	e8 e7 8a ff ff       	call   c010119f <ide_read_secs>
}
c01086b8:	c9                   	leave  
c01086b9:	c3                   	ret    

c01086ba <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
c01086ba:	55                   	push   %ebp
c01086bb:	89 e5                	mov    %esp,%ebp
c01086bd:	83 ec 28             	sub    $0x28,%esp
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c01086c0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01086c3:	89 04 24             	mov    %eax,(%esp)
c01086c6:	e8 e1 fe ff ff       	call   c01085ac <page2kva>
c01086cb:	8b 55 08             	mov    0x8(%ebp),%edx
c01086ce:	c1 ea 08             	shr    $0x8,%edx
c01086d1:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01086d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01086d8:	74 0b                	je     c01086e5 <swapfs_write+0x2b>
c01086da:	8b 15 bc 50 12 c0    	mov    0xc01250bc,%edx
c01086e0:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c01086e3:	72 23                	jb     c0108708 <swapfs_write+0x4e>
c01086e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01086e8:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01086ec:	c7 44 24 08 b4 b3 10 	movl   $0xc010b3b4,0x8(%esp)
c01086f3:	c0 
c01086f4:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
c01086fb:	00 
c01086fc:	c7 04 24 a3 b3 10 c0 	movl   $0xc010b3a3,(%esp)
c0108703:	e8 f0 7c ff ff       	call   c01003f8 <__panic>
c0108708:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010870b:	c1 e2 03             	shl    $0x3,%edx
c010870e:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c0108715:	00 
c0108716:	89 44 24 08          	mov    %eax,0x8(%esp)
c010871a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010871e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108725:	e8 b7 8c ff ff       	call   c01013e1 <ide_write_secs>
}
c010872a:	c9                   	leave  
c010872b:	c3                   	ret    

c010872c <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c010872c:	55                   	push   %ebp
c010872d:	89 e5                	mov    %esp,%ebp
c010872f:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0108732:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0108739:	eb 04                	jmp    c010873f <strlen+0x13>
        cnt ++;
c010873b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (*s ++ != '\0') {
c010873f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108742:	8d 50 01             	lea    0x1(%eax),%edx
c0108745:	89 55 08             	mov    %edx,0x8(%ebp)
c0108748:	0f b6 00             	movzbl (%eax),%eax
c010874b:	84 c0                	test   %al,%al
c010874d:	75 ec                	jne    c010873b <strlen+0xf>
    }
    return cnt;
c010874f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0108752:	c9                   	leave  
c0108753:	c3                   	ret    

c0108754 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0108754:	55                   	push   %ebp
c0108755:	89 e5                	mov    %esp,%ebp
c0108757:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c010875a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0108761:	eb 04                	jmp    c0108767 <strnlen+0x13>
        cnt ++;
c0108763:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0108767:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010876a:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010876d:	73 10                	jae    c010877f <strnlen+0x2b>
c010876f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108772:	8d 50 01             	lea    0x1(%eax),%edx
c0108775:	89 55 08             	mov    %edx,0x8(%ebp)
c0108778:	0f b6 00             	movzbl (%eax),%eax
c010877b:	84 c0                	test   %al,%al
c010877d:	75 e4                	jne    c0108763 <strnlen+0xf>
    }
    return cnt;
c010877f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0108782:	c9                   	leave  
c0108783:	c3                   	ret    

c0108784 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0108784:	55                   	push   %ebp
c0108785:	89 e5                	mov    %esp,%ebp
c0108787:	57                   	push   %edi
c0108788:	56                   	push   %esi
c0108789:	83 ec 20             	sub    $0x20,%esp
c010878c:	8b 45 08             	mov    0x8(%ebp),%eax
c010878f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108792:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108795:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0108798:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010879b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010879e:	89 d1                	mov    %edx,%ecx
c01087a0:	89 c2                	mov    %eax,%edx
c01087a2:	89 ce                	mov    %ecx,%esi
c01087a4:	89 d7                	mov    %edx,%edi
c01087a6:	ac                   	lods   %ds:(%esi),%al
c01087a7:	aa                   	stos   %al,%es:(%edi)
c01087a8:	84 c0                	test   %al,%al
c01087aa:	75 fa                	jne    c01087a6 <strcpy+0x22>
c01087ac:	89 fa                	mov    %edi,%edx
c01087ae:	89 f1                	mov    %esi,%ecx
c01087b0:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c01087b3:	89 55 e8             	mov    %edx,-0x18(%ebp)
c01087b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c01087b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c01087bc:	83 c4 20             	add    $0x20,%esp
c01087bf:	5e                   	pop    %esi
c01087c0:	5f                   	pop    %edi
c01087c1:	5d                   	pop    %ebp
c01087c2:	c3                   	ret    

c01087c3 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c01087c3:	55                   	push   %ebp
c01087c4:	89 e5                	mov    %esp,%ebp
c01087c6:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c01087c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01087cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c01087cf:	eb 21                	jmp    c01087f2 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c01087d1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01087d4:	0f b6 10             	movzbl (%eax),%edx
c01087d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01087da:	88 10                	mov    %dl,(%eax)
c01087dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01087df:	0f b6 00             	movzbl (%eax),%eax
c01087e2:	84 c0                	test   %al,%al
c01087e4:	74 04                	je     c01087ea <strncpy+0x27>
            src ++;
c01087e6:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c01087ea:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01087ee:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    while (len > 0) {
c01087f2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01087f6:	75 d9                	jne    c01087d1 <strncpy+0xe>
    }
    return dst;
c01087f8:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01087fb:	c9                   	leave  
c01087fc:	c3                   	ret    

c01087fd <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c01087fd:	55                   	push   %ebp
c01087fe:	89 e5                	mov    %esp,%ebp
c0108800:	57                   	push   %edi
c0108801:	56                   	push   %esi
c0108802:	83 ec 20             	sub    $0x20,%esp
c0108805:	8b 45 08             	mov    0x8(%ebp),%eax
c0108808:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010880b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010880e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
c0108811:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108814:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108817:	89 d1                	mov    %edx,%ecx
c0108819:	89 c2                	mov    %eax,%edx
c010881b:	89 ce                	mov    %ecx,%esi
c010881d:	89 d7                	mov    %edx,%edi
c010881f:	ac                   	lods   %ds:(%esi),%al
c0108820:	ae                   	scas   %es:(%edi),%al
c0108821:	75 08                	jne    c010882b <strcmp+0x2e>
c0108823:	84 c0                	test   %al,%al
c0108825:	75 f8                	jne    c010881f <strcmp+0x22>
c0108827:	31 c0                	xor    %eax,%eax
c0108829:	eb 04                	jmp    c010882f <strcmp+0x32>
c010882b:	19 c0                	sbb    %eax,%eax
c010882d:	0c 01                	or     $0x1,%al
c010882f:	89 fa                	mov    %edi,%edx
c0108831:	89 f1                	mov    %esi,%ecx
c0108833:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108836:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0108839:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c010883c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c010883f:	83 c4 20             	add    $0x20,%esp
c0108842:	5e                   	pop    %esi
c0108843:	5f                   	pop    %edi
c0108844:	5d                   	pop    %ebp
c0108845:	c3                   	ret    

c0108846 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0108846:	55                   	push   %ebp
c0108847:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0108849:	eb 0c                	jmp    c0108857 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c010884b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010884f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0108853:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0108857:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010885b:	74 1a                	je     c0108877 <strncmp+0x31>
c010885d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108860:	0f b6 00             	movzbl (%eax),%eax
c0108863:	84 c0                	test   %al,%al
c0108865:	74 10                	je     c0108877 <strncmp+0x31>
c0108867:	8b 45 08             	mov    0x8(%ebp),%eax
c010886a:	0f b6 10             	movzbl (%eax),%edx
c010886d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108870:	0f b6 00             	movzbl (%eax),%eax
c0108873:	38 c2                	cmp    %al,%dl
c0108875:	74 d4                	je     c010884b <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0108877:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010887b:	74 18                	je     c0108895 <strncmp+0x4f>
c010887d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108880:	0f b6 00             	movzbl (%eax),%eax
c0108883:	0f b6 d0             	movzbl %al,%edx
c0108886:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108889:	0f b6 00             	movzbl (%eax),%eax
c010888c:	0f b6 c0             	movzbl %al,%eax
c010888f:	29 c2                	sub    %eax,%edx
c0108891:	89 d0                	mov    %edx,%eax
c0108893:	eb 05                	jmp    c010889a <strncmp+0x54>
c0108895:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010889a:	5d                   	pop    %ebp
c010889b:	c3                   	ret    

c010889c <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c010889c:	55                   	push   %ebp
c010889d:	89 e5                	mov    %esp,%ebp
c010889f:	83 ec 04             	sub    $0x4,%esp
c01088a2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01088a5:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c01088a8:	eb 14                	jmp    c01088be <strchr+0x22>
        if (*s == c) {
c01088aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01088ad:	0f b6 00             	movzbl (%eax),%eax
c01088b0:	3a 45 fc             	cmp    -0x4(%ebp),%al
c01088b3:	75 05                	jne    c01088ba <strchr+0x1e>
            return (char *)s;
c01088b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01088b8:	eb 13                	jmp    c01088cd <strchr+0x31>
        }
        s ++;
c01088ba:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
c01088be:	8b 45 08             	mov    0x8(%ebp),%eax
c01088c1:	0f b6 00             	movzbl (%eax),%eax
c01088c4:	84 c0                	test   %al,%al
c01088c6:	75 e2                	jne    c01088aa <strchr+0xe>
    }
    return NULL;
c01088c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01088cd:	c9                   	leave  
c01088ce:	c3                   	ret    

c01088cf <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c01088cf:	55                   	push   %ebp
c01088d0:	89 e5                	mov    %esp,%ebp
c01088d2:	83 ec 04             	sub    $0x4,%esp
c01088d5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01088d8:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c01088db:	eb 11                	jmp    c01088ee <strfind+0x1f>
        if (*s == c) {
c01088dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01088e0:	0f b6 00             	movzbl (%eax),%eax
c01088e3:	3a 45 fc             	cmp    -0x4(%ebp),%al
c01088e6:	75 02                	jne    c01088ea <strfind+0x1b>
            break;
c01088e8:	eb 0e                	jmp    c01088f8 <strfind+0x29>
        }
        s ++;
c01088ea:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
c01088ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01088f1:	0f b6 00             	movzbl (%eax),%eax
c01088f4:	84 c0                	test   %al,%al
c01088f6:	75 e5                	jne    c01088dd <strfind+0xe>
    }
    return (char *)s;
c01088f8:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01088fb:	c9                   	leave  
c01088fc:	c3                   	ret    

c01088fd <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c01088fd:	55                   	push   %ebp
c01088fe:	89 e5                	mov    %esp,%ebp
c0108900:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0108903:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c010890a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0108911:	eb 04                	jmp    c0108917 <strtol+0x1a>
        s ++;
c0108913:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
c0108917:	8b 45 08             	mov    0x8(%ebp),%eax
c010891a:	0f b6 00             	movzbl (%eax),%eax
c010891d:	3c 20                	cmp    $0x20,%al
c010891f:	74 f2                	je     c0108913 <strtol+0x16>
c0108921:	8b 45 08             	mov    0x8(%ebp),%eax
c0108924:	0f b6 00             	movzbl (%eax),%eax
c0108927:	3c 09                	cmp    $0x9,%al
c0108929:	74 e8                	je     c0108913 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
c010892b:	8b 45 08             	mov    0x8(%ebp),%eax
c010892e:	0f b6 00             	movzbl (%eax),%eax
c0108931:	3c 2b                	cmp    $0x2b,%al
c0108933:	75 06                	jne    c010893b <strtol+0x3e>
        s ++;
c0108935:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0108939:	eb 15                	jmp    c0108950 <strtol+0x53>
    }
    else if (*s == '-') {
c010893b:	8b 45 08             	mov    0x8(%ebp),%eax
c010893e:	0f b6 00             	movzbl (%eax),%eax
c0108941:	3c 2d                	cmp    $0x2d,%al
c0108943:	75 0b                	jne    c0108950 <strtol+0x53>
        s ++, neg = 1;
c0108945:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0108949:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0108950:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108954:	74 06                	je     c010895c <strtol+0x5f>
c0108956:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c010895a:	75 24                	jne    c0108980 <strtol+0x83>
c010895c:	8b 45 08             	mov    0x8(%ebp),%eax
c010895f:	0f b6 00             	movzbl (%eax),%eax
c0108962:	3c 30                	cmp    $0x30,%al
c0108964:	75 1a                	jne    c0108980 <strtol+0x83>
c0108966:	8b 45 08             	mov    0x8(%ebp),%eax
c0108969:	83 c0 01             	add    $0x1,%eax
c010896c:	0f b6 00             	movzbl (%eax),%eax
c010896f:	3c 78                	cmp    $0x78,%al
c0108971:	75 0d                	jne    c0108980 <strtol+0x83>
        s += 2, base = 16;
c0108973:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0108977:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c010897e:	eb 2a                	jmp    c01089aa <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0108980:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108984:	75 17                	jne    c010899d <strtol+0xa0>
c0108986:	8b 45 08             	mov    0x8(%ebp),%eax
c0108989:	0f b6 00             	movzbl (%eax),%eax
c010898c:	3c 30                	cmp    $0x30,%al
c010898e:	75 0d                	jne    c010899d <strtol+0xa0>
        s ++, base = 8;
c0108990:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0108994:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c010899b:	eb 0d                	jmp    c01089aa <strtol+0xad>
    }
    else if (base == 0) {
c010899d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01089a1:	75 07                	jne    c01089aa <strtol+0xad>
        base = 10;
c01089a3:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c01089aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01089ad:	0f b6 00             	movzbl (%eax),%eax
c01089b0:	3c 2f                	cmp    $0x2f,%al
c01089b2:	7e 1b                	jle    c01089cf <strtol+0xd2>
c01089b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01089b7:	0f b6 00             	movzbl (%eax),%eax
c01089ba:	3c 39                	cmp    $0x39,%al
c01089bc:	7f 11                	jg     c01089cf <strtol+0xd2>
            dig = *s - '0';
c01089be:	8b 45 08             	mov    0x8(%ebp),%eax
c01089c1:	0f b6 00             	movzbl (%eax),%eax
c01089c4:	0f be c0             	movsbl %al,%eax
c01089c7:	83 e8 30             	sub    $0x30,%eax
c01089ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01089cd:	eb 48                	jmp    c0108a17 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c01089cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01089d2:	0f b6 00             	movzbl (%eax),%eax
c01089d5:	3c 60                	cmp    $0x60,%al
c01089d7:	7e 1b                	jle    c01089f4 <strtol+0xf7>
c01089d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01089dc:	0f b6 00             	movzbl (%eax),%eax
c01089df:	3c 7a                	cmp    $0x7a,%al
c01089e1:	7f 11                	jg     c01089f4 <strtol+0xf7>
            dig = *s - 'a' + 10;
c01089e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01089e6:	0f b6 00             	movzbl (%eax),%eax
c01089e9:	0f be c0             	movsbl %al,%eax
c01089ec:	83 e8 57             	sub    $0x57,%eax
c01089ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01089f2:	eb 23                	jmp    c0108a17 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c01089f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01089f7:	0f b6 00             	movzbl (%eax),%eax
c01089fa:	3c 40                	cmp    $0x40,%al
c01089fc:	7e 3d                	jle    c0108a3b <strtol+0x13e>
c01089fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a01:	0f b6 00             	movzbl (%eax),%eax
c0108a04:	3c 5a                	cmp    $0x5a,%al
c0108a06:	7f 33                	jg     c0108a3b <strtol+0x13e>
            dig = *s - 'A' + 10;
c0108a08:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a0b:	0f b6 00             	movzbl (%eax),%eax
c0108a0e:	0f be c0             	movsbl %al,%eax
c0108a11:	83 e8 37             	sub    $0x37,%eax
c0108a14:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0108a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108a1a:	3b 45 10             	cmp    0x10(%ebp),%eax
c0108a1d:	7c 02                	jl     c0108a21 <strtol+0x124>
            break;
c0108a1f:	eb 1a                	jmp    c0108a3b <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c0108a21:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0108a25:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108a28:	0f af 45 10          	imul   0x10(%ebp),%eax
c0108a2c:	89 c2                	mov    %eax,%edx
c0108a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108a31:	01 d0                	add    %edx,%eax
c0108a33:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0108a36:	e9 6f ff ff ff       	jmp    c01089aa <strtol+0xad>

    if (endptr) {
c0108a3b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0108a3f:	74 08                	je     c0108a49 <strtol+0x14c>
        *endptr = (char *) s;
c0108a41:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108a44:	8b 55 08             	mov    0x8(%ebp),%edx
c0108a47:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0108a49:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0108a4d:	74 07                	je     c0108a56 <strtol+0x159>
c0108a4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108a52:	f7 d8                	neg    %eax
c0108a54:	eb 03                	jmp    c0108a59 <strtol+0x15c>
c0108a56:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0108a59:	c9                   	leave  
c0108a5a:	c3                   	ret    

c0108a5b <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0108a5b:	55                   	push   %ebp
c0108a5c:	89 e5                	mov    %esp,%ebp
c0108a5e:	57                   	push   %edi
c0108a5f:	83 ec 24             	sub    $0x24,%esp
c0108a62:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108a65:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0108a68:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0108a6c:	8b 55 08             	mov    0x8(%ebp),%edx
c0108a6f:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0108a72:	88 45 f7             	mov    %al,-0x9(%ebp)
c0108a75:	8b 45 10             	mov    0x10(%ebp),%eax
c0108a78:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0108a7b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0108a7e:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0108a82:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0108a85:	89 d7                	mov    %edx,%edi
c0108a87:	f3 aa                	rep stos %al,%es:(%edi)
c0108a89:	89 fa                	mov    %edi,%edx
c0108a8b:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0108a8e:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0108a91:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0108a94:	83 c4 24             	add    $0x24,%esp
c0108a97:	5f                   	pop    %edi
c0108a98:	5d                   	pop    %ebp
c0108a99:	c3                   	ret    

c0108a9a <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0108a9a:	55                   	push   %ebp
c0108a9b:	89 e5                	mov    %esp,%ebp
c0108a9d:	57                   	push   %edi
c0108a9e:	56                   	push   %esi
c0108a9f:	53                   	push   %ebx
c0108aa0:	83 ec 30             	sub    $0x30,%esp
c0108aa3:	8b 45 08             	mov    0x8(%ebp),%eax
c0108aa6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108aa9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108aac:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108aaf:	8b 45 10             	mov    0x10(%ebp),%eax
c0108ab2:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0108ab5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108ab8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0108abb:	73 42                	jae    c0108aff <memmove+0x65>
c0108abd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108ac0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0108ac3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108ac6:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108ac9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108acc:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0108acf:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108ad2:	c1 e8 02             	shr    $0x2,%eax
c0108ad5:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0108ad7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108ada:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108add:	89 d7                	mov    %edx,%edi
c0108adf:	89 c6                	mov    %eax,%esi
c0108ae1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0108ae3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0108ae6:	83 e1 03             	and    $0x3,%ecx
c0108ae9:	74 02                	je     c0108aed <memmove+0x53>
c0108aeb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0108aed:	89 f0                	mov    %esi,%eax
c0108aef:	89 fa                	mov    %edi,%edx
c0108af1:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0108af4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0108af7:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c0108afa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108afd:	eb 36                	jmp    c0108b35 <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0108aff:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108b02:	8d 50 ff             	lea    -0x1(%eax),%edx
c0108b05:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108b08:	01 c2                	add    %eax,%edx
c0108b0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108b0d:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0108b10:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108b13:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
c0108b16:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108b19:	89 c1                	mov    %eax,%ecx
c0108b1b:	89 d8                	mov    %ebx,%eax
c0108b1d:	89 d6                	mov    %edx,%esi
c0108b1f:	89 c7                	mov    %eax,%edi
c0108b21:	fd                   	std    
c0108b22:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0108b24:	fc                   	cld    
c0108b25:	89 f8                	mov    %edi,%eax
c0108b27:	89 f2                	mov    %esi,%edx
c0108b29:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0108b2c:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0108b2f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c0108b32:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0108b35:	83 c4 30             	add    $0x30,%esp
c0108b38:	5b                   	pop    %ebx
c0108b39:	5e                   	pop    %esi
c0108b3a:	5f                   	pop    %edi
c0108b3b:	5d                   	pop    %ebp
c0108b3c:	c3                   	ret    

c0108b3d <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0108b3d:	55                   	push   %ebp
c0108b3e:	89 e5                	mov    %esp,%ebp
c0108b40:	57                   	push   %edi
c0108b41:	56                   	push   %esi
c0108b42:	83 ec 20             	sub    $0x20,%esp
c0108b45:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b48:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108b4b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108b4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108b51:	8b 45 10             	mov    0x10(%ebp),%eax
c0108b54:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0108b57:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108b5a:	c1 e8 02             	shr    $0x2,%eax
c0108b5d:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0108b5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108b62:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108b65:	89 d7                	mov    %edx,%edi
c0108b67:	89 c6                	mov    %eax,%esi
c0108b69:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0108b6b:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0108b6e:	83 e1 03             	and    $0x3,%ecx
c0108b71:	74 02                	je     c0108b75 <memcpy+0x38>
c0108b73:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0108b75:	89 f0                	mov    %esi,%eax
c0108b77:	89 fa                	mov    %edi,%edx
c0108b79:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0108b7c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0108b7f:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c0108b82:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0108b85:	83 c4 20             	add    $0x20,%esp
c0108b88:	5e                   	pop    %esi
c0108b89:	5f                   	pop    %edi
c0108b8a:	5d                   	pop    %ebp
c0108b8b:	c3                   	ret    

c0108b8c <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0108b8c:	55                   	push   %ebp
c0108b8d:	89 e5                	mov    %esp,%ebp
c0108b8f:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0108b92:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b95:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0108b98:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108b9b:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0108b9e:	eb 30                	jmp    c0108bd0 <memcmp+0x44>
        if (*s1 != *s2) {
c0108ba0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108ba3:	0f b6 10             	movzbl (%eax),%edx
c0108ba6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108ba9:	0f b6 00             	movzbl (%eax),%eax
c0108bac:	38 c2                	cmp    %al,%dl
c0108bae:	74 18                	je     c0108bc8 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0108bb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108bb3:	0f b6 00             	movzbl (%eax),%eax
c0108bb6:	0f b6 d0             	movzbl %al,%edx
c0108bb9:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108bbc:	0f b6 00             	movzbl (%eax),%eax
c0108bbf:	0f b6 c0             	movzbl %al,%eax
c0108bc2:	29 c2                	sub    %eax,%edx
c0108bc4:	89 d0                	mov    %edx,%eax
c0108bc6:	eb 1a                	jmp    c0108be2 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0108bc8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0108bcc:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    while (n -- > 0) {
c0108bd0:	8b 45 10             	mov    0x10(%ebp),%eax
c0108bd3:	8d 50 ff             	lea    -0x1(%eax),%edx
c0108bd6:	89 55 10             	mov    %edx,0x10(%ebp)
c0108bd9:	85 c0                	test   %eax,%eax
c0108bdb:	75 c3                	jne    c0108ba0 <memcmp+0x14>
    }
    return 0;
c0108bdd:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108be2:	c9                   	leave  
c0108be3:	c3                   	ret    

c0108be4 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0108be4:	55                   	push   %ebp
c0108be5:	89 e5                	mov    %esp,%ebp
c0108be7:	83 ec 58             	sub    $0x58,%esp
c0108bea:	8b 45 10             	mov    0x10(%ebp),%eax
c0108bed:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0108bf0:	8b 45 14             	mov    0x14(%ebp),%eax
c0108bf3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0108bf6:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108bf9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0108bfc:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108bff:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0108c02:	8b 45 18             	mov    0x18(%ebp),%eax
c0108c05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0108c08:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108c0b:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108c0e:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108c11:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0108c14:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108c17:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108c1a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0108c1e:	74 1c                	je     c0108c3c <printnum+0x58>
c0108c20:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108c23:	ba 00 00 00 00       	mov    $0x0,%edx
c0108c28:	f7 75 e4             	divl   -0x1c(%ebp)
c0108c2b:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0108c2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108c31:	ba 00 00 00 00       	mov    $0x0,%edx
c0108c36:	f7 75 e4             	divl   -0x1c(%ebp)
c0108c39:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108c3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108c3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108c42:	f7 75 e4             	divl   -0x1c(%ebp)
c0108c45:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108c48:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0108c4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108c4e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0108c51:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108c54:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0108c57:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108c5a:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0108c5d:	8b 45 18             	mov    0x18(%ebp),%eax
c0108c60:	ba 00 00 00 00       	mov    $0x0,%edx
c0108c65:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0108c68:	77 56                	ja     c0108cc0 <printnum+0xdc>
c0108c6a:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0108c6d:	72 05                	jb     c0108c74 <printnum+0x90>
c0108c6f:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0108c72:	77 4c                	ja     c0108cc0 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c0108c74:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0108c77:	8d 50 ff             	lea    -0x1(%eax),%edx
c0108c7a:	8b 45 20             	mov    0x20(%ebp),%eax
c0108c7d:	89 44 24 18          	mov    %eax,0x18(%esp)
c0108c81:	89 54 24 14          	mov    %edx,0x14(%esp)
c0108c85:	8b 45 18             	mov    0x18(%ebp),%eax
c0108c88:	89 44 24 10          	mov    %eax,0x10(%esp)
c0108c8c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108c8f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108c92:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108c96:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0108c9a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108c9d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108ca1:	8b 45 08             	mov    0x8(%ebp),%eax
c0108ca4:	89 04 24             	mov    %eax,(%esp)
c0108ca7:	e8 38 ff ff ff       	call   c0108be4 <printnum>
c0108cac:	eb 1c                	jmp    c0108cca <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0108cae:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108cb1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108cb5:	8b 45 20             	mov    0x20(%ebp),%eax
c0108cb8:	89 04 24             	mov    %eax,(%esp)
c0108cbb:	8b 45 08             	mov    0x8(%ebp),%eax
c0108cbe:	ff d0                	call   *%eax
        while (-- width > 0)
c0108cc0:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c0108cc4:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0108cc8:	7f e4                	jg     c0108cae <printnum+0xca>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0108cca:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108ccd:	05 54 b4 10 c0       	add    $0xc010b454,%eax
c0108cd2:	0f b6 00             	movzbl (%eax),%eax
c0108cd5:	0f be c0             	movsbl %al,%eax
c0108cd8:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108cdb:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108cdf:	89 04 24             	mov    %eax,(%esp)
c0108ce2:	8b 45 08             	mov    0x8(%ebp),%eax
c0108ce5:	ff d0                	call   *%eax
}
c0108ce7:	c9                   	leave  
c0108ce8:	c3                   	ret    

c0108ce9 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0108ce9:	55                   	push   %ebp
c0108cea:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0108cec:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0108cf0:	7e 14                	jle    c0108d06 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0108cf2:	8b 45 08             	mov    0x8(%ebp),%eax
c0108cf5:	8b 00                	mov    (%eax),%eax
c0108cf7:	8d 48 08             	lea    0x8(%eax),%ecx
c0108cfa:	8b 55 08             	mov    0x8(%ebp),%edx
c0108cfd:	89 0a                	mov    %ecx,(%edx)
c0108cff:	8b 50 04             	mov    0x4(%eax),%edx
c0108d02:	8b 00                	mov    (%eax),%eax
c0108d04:	eb 30                	jmp    c0108d36 <getuint+0x4d>
    }
    else if (lflag) {
c0108d06:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0108d0a:	74 16                	je     c0108d22 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0108d0c:	8b 45 08             	mov    0x8(%ebp),%eax
c0108d0f:	8b 00                	mov    (%eax),%eax
c0108d11:	8d 48 04             	lea    0x4(%eax),%ecx
c0108d14:	8b 55 08             	mov    0x8(%ebp),%edx
c0108d17:	89 0a                	mov    %ecx,(%edx)
c0108d19:	8b 00                	mov    (%eax),%eax
c0108d1b:	ba 00 00 00 00       	mov    $0x0,%edx
c0108d20:	eb 14                	jmp    c0108d36 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0108d22:	8b 45 08             	mov    0x8(%ebp),%eax
c0108d25:	8b 00                	mov    (%eax),%eax
c0108d27:	8d 48 04             	lea    0x4(%eax),%ecx
c0108d2a:	8b 55 08             	mov    0x8(%ebp),%edx
c0108d2d:	89 0a                	mov    %ecx,(%edx)
c0108d2f:	8b 00                	mov    (%eax),%eax
c0108d31:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0108d36:	5d                   	pop    %ebp
c0108d37:	c3                   	ret    

c0108d38 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0108d38:	55                   	push   %ebp
c0108d39:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0108d3b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0108d3f:	7e 14                	jle    c0108d55 <getint+0x1d>
        return va_arg(*ap, long long);
c0108d41:	8b 45 08             	mov    0x8(%ebp),%eax
c0108d44:	8b 00                	mov    (%eax),%eax
c0108d46:	8d 48 08             	lea    0x8(%eax),%ecx
c0108d49:	8b 55 08             	mov    0x8(%ebp),%edx
c0108d4c:	89 0a                	mov    %ecx,(%edx)
c0108d4e:	8b 50 04             	mov    0x4(%eax),%edx
c0108d51:	8b 00                	mov    (%eax),%eax
c0108d53:	eb 28                	jmp    c0108d7d <getint+0x45>
    }
    else if (lflag) {
c0108d55:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0108d59:	74 12                	je     c0108d6d <getint+0x35>
        return va_arg(*ap, long);
c0108d5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0108d5e:	8b 00                	mov    (%eax),%eax
c0108d60:	8d 48 04             	lea    0x4(%eax),%ecx
c0108d63:	8b 55 08             	mov    0x8(%ebp),%edx
c0108d66:	89 0a                	mov    %ecx,(%edx)
c0108d68:	8b 00                	mov    (%eax),%eax
c0108d6a:	99                   	cltd   
c0108d6b:	eb 10                	jmp    c0108d7d <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0108d6d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108d70:	8b 00                	mov    (%eax),%eax
c0108d72:	8d 48 04             	lea    0x4(%eax),%ecx
c0108d75:	8b 55 08             	mov    0x8(%ebp),%edx
c0108d78:	89 0a                	mov    %ecx,(%edx)
c0108d7a:	8b 00                	mov    (%eax),%eax
c0108d7c:	99                   	cltd   
    }
}
c0108d7d:	5d                   	pop    %ebp
c0108d7e:	c3                   	ret    

c0108d7f <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0108d7f:	55                   	push   %ebp
c0108d80:	89 e5                	mov    %esp,%ebp
c0108d82:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c0108d85:	8d 45 14             	lea    0x14(%ebp),%eax
c0108d88:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0108d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108d8e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108d92:	8b 45 10             	mov    0x10(%ebp),%eax
c0108d95:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108d99:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108d9c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108da0:	8b 45 08             	mov    0x8(%ebp),%eax
c0108da3:	89 04 24             	mov    %eax,(%esp)
c0108da6:	e8 02 00 00 00       	call   c0108dad <vprintfmt>
    va_end(ap);
}
c0108dab:	c9                   	leave  
c0108dac:	c3                   	ret    

c0108dad <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0108dad:	55                   	push   %ebp
c0108dae:	89 e5                	mov    %esp,%ebp
c0108db0:	56                   	push   %esi
c0108db1:	53                   	push   %ebx
c0108db2:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0108db5:	eb 18                	jmp    c0108dcf <vprintfmt+0x22>
            if (ch == '\0') {
c0108db7:	85 db                	test   %ebx,%ebx
c0108db9:	75 05                	jne    c0108dc0 <vprintfmt+0x13>
                return;
c0108dbb:	e9 d1 03 00 00       	jmp    c0109191 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c0108dc0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108dc3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108dc7:	89 1c 24             	mov    %ebx,(%esp)
c0108dca:	8b 45 08             	mov    0x8(%ebp),%eax
c0108dcd:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0108dcf:	8b 45 10             	mov    0x10(%ebp),%eax
c0108dd2:	8d 50 01             	lea    0x1(%eax),%edx
c0108dd5:	89 55 10             	mov    %edx,0x10(%ebp)
c0108dd8:	0f b6 00             	movzbl (%eax),%eax
c0108ddb:	0f b6 d8             	movzbl %al,%ebx
c0108dde:	83 fb 25             	cmp    $0x25,%ebx
c0108de1:	75 d4                	jne    c0108db7 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
c0108de3:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0108de7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0108dee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108df1:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0108df4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0108dfb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108dfe:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0108e01:	8b 45 10             	mov    0x10(%ebp),%eax
c0108e04:	8d 50 01             	lea    0x1(%eax),%edx
c0108e07:	89 55 10             	mov    %edx,0x10(%ebp)
c0108e0a:	0f b6 00             	movzbl (%eax),%eax
c0108e0d:	0f b6 d8             	movzbl %al,%ebx
c0108e10:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0108e13:	83 f8 55             	cmp    $0x55,%eax
c0108e16:	0f 87 44 03 00 00    	ja     c0109160 <vprintfmt+0x3b3>
c0108e1c:	8b 04 85 78 b4 10 c0 	mov    -0x3fef4b88(,%eax,4),%eax
c0108e23:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0108e25:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0108e29:	eb d6                	jmp    c0108e01 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0108e2b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0108e2f:	eb d0                	jmp    c0108e01 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0108e31:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0108e38:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108e3b:	89 d0                	mov    %edx,%eax
c0108e3d:	c1 e0 02             	shl    $0x2,%eax
c0108e40:	01 d0                	add    %edx,%eax
c0108e42:	01 c0                	add    %eax,%eax
c0108e44:	01 d8                	add    %ebx,%eax
c0108e46:	83 e8 30             	sub    $0x30,%eax
c0108e49:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0108e4c:	8b 45 10             	mov    0x10(%ebp),%eax
c0108e4f:	0f b6 00             	movzbl (%eax),%eax
c0108e52:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0108e55:	83 fb 2f             	cmp    $0x2f,%ebx
c0108e58:	7e 0b                	jle    c0108e65 <vprintfmt+0xb8>
c0108e5a:	83 fb 39             	cmp    $0x39,%ebx
c0108e5d:	7f 06                	jg     c0108e65 <vprintfmt+0xb8>
            for (precision = 0; ; ++ fmt) {
c0108e5f:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                    break;
                }
            }
c0108e63:	eb d3                	jmp    c0108e38 <vprintfmt+0x8b>
            goto process_precision;
c0108e65:	eb 33                	jmp    c0108e9a <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c0108e67:	8b 45 14             	mov    0x14(%ebp),%eax
c0108e6a:	8d 50 04             	lea    0x4(%eax),%edx
c0108e6d:	89 55 14             	mov    %edx,0x14(%ebp)
c0108e70:	8b 00                	mov    (%eax),%eax
c0108e72:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0108e75:	eb 23                	jmp    c0108e9a <vprintfmt+0xed>

        case '.':
            if (width < 0)
c0108e77:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108e7b:	79 0c                	jns    c0108e89 <vprintfmt+0xdc>
                width = 0;
c0108e7d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0108e84:	e9 78 ff ff ff       	jmp    c0108e01 <vprintfmt+0x54>
c0108e89:	e9 73 ff ff ff       	jmp    c0108e01 <vprintfmt+0x54>

        case '#':
            altflag = 1;
c0108e8e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0108e95:	e9 67 ff ff ff       	jmp    c0108e01 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c0108e9a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108e9e:	79 12                	jns    c0108eb2 <vprintfmt+0x105>
                width = precision, precision = -1;
c0108ea0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108ea3:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108ea6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0108ead:	e9 4f ff ff ff       	jmp    c0108e01 <vprintfmt+0x54>
c0108eb2:	e9 4a ff ff ff       	jmp    c0108e01 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0108eb7:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c0108ebb:	e9 41 ff ff ff       	jmp    c0108e01 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0108ec0:	8b 45 14             	mov    0x14(%ebp),%eax
c0108ec3:	8d 50 04             	lea    0x4(%eax),%edx
c0108ec6:	89 55 14             	mov    %edx,0x14(%ebp)
c0108ec9:	8b 00                	mov    (%eax),%eax
c0108ecb:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108ece:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108ed2:	89 04 24             	mov    %eax,(%esp)
c0108ed5:	8b 45 08             	mov    0x8(%ebp),%eax
c0108ed8:	ff d0                	call   *%eax
            break;
c0108eda:	e9 ac 02 00 00       	jmp    c010918b <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0108edf:	8b 45 14             	mov    0x14(%ebp),%eax
c0108ee2:	8d 50 04             	lea    0x4(%eax),%edx
c0108ee5:	89 55 14             	mov    %edx,0x14(%ebp)
c0108ee8:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0108eea:	85 db                	test   %ebx,%ebx
c0108eec:	79 02                	jns    c0108ef0 <vprintfmt+0x143>
                err = -err;
c0108eee:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0108ef0:	83 fb 06             	cmp    $0x6,%ebx
c0108ef3:	7f 0b                	jg     c0108f00 <vprintfmt+0x153>
c0108ef5:	8b 34 9d 38 b4 10 c0 	mov    -0x3fef4bc8(,%ebx,4),%esi
c0108efc:	85 f6                	test   %esi,%esi
c0108efe:	75 23                	jne    c0108f23 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c0108f00:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0108f04:	c7 44 24 08 65 b4 10 	movl   $0xc010b465,0x8(%esp)
c0108f0b:	c0 
c0108f0c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108f0f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108f13:	8b 45 08             	mov    0x8(%ebp),%eax
c0108f16:	89 04 24             	mov    %eax,(%esp)
c0108f19:	e8 61 fe ff ff       	call   c0108d7f <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0108f1e:	e9 68 02 00 00       	jmp    c010918b <vprintfmt+0x3de>
                printfmt(putch, putdat, "%s", p);
c0108f23:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0108f27:	c7 44 24 08 6e b4 10 	movl   $0xc010b46e,0x8(%esp)
c0108f2e:	c0 
c0108f2f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108f32:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108f36:	8b 45 08             	mov    0x8(%ebp),%eax
c0108f39:	89 04 24             	mov    %eax,(%esp)
c0108f3c:	e8 3e fe ff ff       	call   c0108d7f <printfmt>
            break;
c0108f41:	e9 45 02 00 00       	jmp    c010918b <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0108f46:	8b 45 14             	mov    0x14(%ebp),%eax
c0108f49:	8d 50 04             	lea    0x4(%eax),%edx
c0108f4c:	89 55 14             	mov    %edx,0x14(%ebp)
c0108f4f:	8b 30                	mov    (%eax),%esi
c0108f51:	85 f6                	test   %esi,%esi
c0108f53:	75 05                	jne    c0108f5a <vprintfmt+0x1ad>
                p = "(null)";
c0108f55:	be 71 b4 10 c0       	mov    $0xc010b471,%esi
            }
            if (width > 0 && padc != '-') {
c0108f5a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108f5e:	7e 3e                	jle    c0108f9e <vprintfmt+0x1f1>
c0108f60:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0108f64:	74 38                	je     c0108f9e <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0108f66:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c0108f69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108f6c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108f70:	89 34 24             	mov    %esi,(%esp)
c0108f73:	e8 dc f7 ff ff       	call   c0108754 <strnlen>
c0108f78:	29 c3                	sub    %eax,%ebx
c0108f7a:	89 d8                	mov    %ebx,%eax
c0108f7c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108f7f:	eb 17                	jmp    c0108f98 <vprintfmt+0x1eb>
                    putch(padc, putdat);
c0108f81:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0108f85:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108f88:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108f8c:	89 04 24             	mov    %eax,(%esp)
c0108f8f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108f92:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
c0108f94:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0108f98:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108f9c:	7f e3                	jg     c0108f81 <vprintfmt+0x1d4>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0108f9e:	eb 38                	jmp    c0108fd8 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c0108fa0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0108fa4:	74 1f                	je     c0108fc5 <vprintfmt+0x218>
c0108fa6:	83 fb 1f             	cmp    $0x1f,%ebx
c0108fa9:	7e 05                	jle    c0108fb0 <vprintfmt+0x203>
c0108fab:	83 fb 7e             	cmp    $0x7e,%ebx
c0108fae:	7e 15                	jle    c0108fc5 <vprintfmt+0x218>
                    putch('?', putdat);
c0108fb0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108fb3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108fb7:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0108fbe:	8b 45 08             	mov    0x8(%ebp),%eax
c0108fc1:	ff d0                	call   *%eax
c0108fc3:	eb 0f                	jmp    c0108fd4 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c0108fc5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108fc8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108fcc:	89 1c 24             	mov    %ebx,(%esp)
c0108fcf:	8b 45 08             	mov    0x8(%ebp),%eax
c0108fd2:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0108fd4:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0108fd8:	89 f0                	mov    %esi,%eax
c0108fda:	8d 70 01             	lea    0x1(%eax),%esi
c0108fdd:	0f b6 00             	movzbl (%eax),%eax
c0108fe0:	0f be d8             	movsbl %al,%ebx
c0108fe3:	85 db                	test   %ebx,%ebx
c0108fe5:	74 10                	je     c0108ff7 <vprintfmt+0x24a>
c0108fe7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0108feb:	78 b3                	js     c0108fa0 <vprintfmt+0x1f3>
c0108fed:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0108ff1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0108ff5:	79 a9                	jns    c0108fa0 <vprintfmt+0x1f3>
                }
            }
            for (; width > 0; width --) {
c0108ff7:	eb 17                	jmp    c0109010 <vprintfmt+0x263>
                putch(' ', putdat);
c0108ff9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108ffc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109000:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0109007:	8b 45 08             	mov    0x8(%ebp),%eax
c010900a:	ff d0                	call   *%eax
            for (; width > 0; width --) {
c010900c:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0109010:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109014:	7f e3                	jg     c0108ff9 <vprintfmt+0x24c>
            }
            break;
c0109016:	e9 70 01 00 00       	jmp    c010918b <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c010901b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010901e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109022:	8d 45 14             	lea    0x14(%ebp),%eax
c0109025:	89 04 24             	mov    %eax,(%esp)
c0109028:	e8 0b fd ff ff       	call   c0108d38 <getint>
c010902d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109030:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0109033:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109036:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109039:	85 d2                	test   %edx,%edx
c010903b:	79 26                	jns    c0109063 <vprintfmt+0x2b6>
                putch('-', putdat);
c010903d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109040:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109044:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c010904b:	8b 45 08             	mov    0x8(%ebp),%eax
c010904e:	ff d0                	call   *%eax
                num = -(long long)num;
c0109050:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109053:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109056:	f7 d8                	neg    %eax
c0109058:	83 d2 00             	adc    $0x0,%edx
c010905b:	f7 da                	neg    %edx
c010905d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109060:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0109063:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c010906a:	e9 a8 00 00 00       	jmp    c0109117 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c010906f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109072:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109076:	8d 45 14             	lea    0x14(%ebp),%eax
c0109079:	89 04 24             	mov    %eax,(%esp)
c010907c:	e8 68 fc ff ff       	call   c0108ce9 <getuint>
c0109081:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109084:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0109087:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c010908e:	e9 84 00 00 00       	jmp    c0109117 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0109093:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109096:	89 44 24 04          	mov    %eax,0x4(%esp)
c010909a:	8d 45 14             	lea    0x14(%ebp),%eax
c010909d:	89 04 24             	mov    %eax,(%esp)
c01090a0:	e8 44 fc ff ff       	call   c0108ce9 <getuint>
c01090a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01090a8:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c01090ab:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c01090b2:	eb 63                	jmp    c0109117 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c01090b4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01090b7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01090bb:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c01090c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01090c5:	ff d0                	call   *%eax
            putch('x', putdat);
c01090c7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01090ca:	89 44 24 04          	mov    %eax,0x4(%esp)
c01090ce:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c01090d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01090d8:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c01090da:	8b 45 14             	mov    0x14(%ebp),%eax
c01090dd:	8d 50 04             	lea    0x4(%eax),%edx
c01090e0:	89 55 14             	mov    %edx,0x14(%ebp)
c01090e3:	8b 00                	mov    (%eax),%eax
c01090e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01090e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c01090ef:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c01090f6:	eb 1f                	jmp    c0109117 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c01090f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01090fb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01090ff:	8d 45 14             	lea    0x14(%ebp),%eax
c0109102:	89 04 24             	mov    %eax,(%esp)
c0109105:	e8 df fb ff ff       	call   c0108ce9 <getuint>
c010910a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010910d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0109110:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0109117:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c010911b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010911e:	89 54 24 18          	mov    %edx,0x18(%esp)
c0109122:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0109125:	89 54 24 14          	mov    %edx,0x14(%esp)
c0109129:	89 44 24 10          	mov    %eax,0x10(%esp)
c010912d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109130:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109133:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109137:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010913b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010913e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109142:	8b 45 08             	mov    0x8(%ebp),%eax
c0109145:	89 04 24             	mov    %eax,(%esp)
c0109148:	e8 97 fa ff ff       	call   c0108be4 <printnum>
            break;
c010914d:	eb 3c                	jmp    c010918b <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c010914f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109152:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109156:	89 1c 24             	mov    %ebx,(%esp)
c0109159:	8b 45 08             	mov    0x8(%ebp),%eax
c010915c:	ff d0                	call   *%eax
            break;
c010915e:	eb 2b                	jmp    c010918b <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0109160:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109163:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109167:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c010916e:	8b 45 08             	mov    0x8(%ebp),%eax
c0109171:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0109173:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0109177:	eb 04                	jmp    c010917d <vprintfmt+0x3d0>
c0109179:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010917d:	8b 45 10             	mov    0x10(%ebp),%eax
c0109180:	83 e8 01             	sub    $0x1,%eax
c0109183:	0f b6 00             	movzbl (%eax),%eax
c0109186:	3c 25                	cmp    $0x25,%al
c0109188:	75 ef                	jne    c0109179 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c010918a:	90                   	nop
        }
    }
c010918b:	90                   	nop
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010918c:	e9 3e fc ff ff       	jmp    c0108dcf <vprintfmt+0x22>
}
c0109191:	83 c4 40             	add    $0x40,%esp
c0109194:	5b                   	pop    %ebx
c0109195:	5e                   	pop    %esi
c0109196:	5d                   	pop    %ebp
c0109197:	c3                   	ret    

c0109198 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0109198:	55                   	push   %ebp
c0109199:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c010919b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010919e:	8b 40 08             	mov    0x8(%eax),%eax
c01091a1:	8d 50 01             	lea    0x1(%eax),%edx
c01091a4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01091a7:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c01091aa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01091ad:	8b 10                	mov    (%eax),%edx
c01091af:	8b 45 0c             	mov    0xc(%ebp),%eax
c01091b2:	8b 40 04             	mov    0x4(%eax),%eax
c01091b5:	39 c2                	cmp    %eax,%edx
c01091b7:	73 12                	jae    c01091cb <sprintputch+0x33>
        *b->buf ++ = ch;
c01091b9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01091bc:	8b 00                	mov    (%eax),%eax
c01091be:	8d 48 01             	lea    0x1(%eax),%ecx
c01091c1:	8b 55 0c             	mov    0xc(%ebp),%edx
c01091c4:	89 0a                	mov    %ecx,(%edx)
c01091c6:	8b 55 08             	mov    0x8(%ebp),%edx
c01091c9:	88 10                	mov    %dl,(%eax)
    }
}
c01091cb:	5d                   	pop    %ebp
c01091cc:	c3                   	ret    

c01091cd <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c01091cd:	55                   	push   %ebp
c01091ce:	89 e5                	mov    %esp,%ebp
c01091d0:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c01091d3:	8d 45 14             	lea    0x14(%ebp),%eax
c01091d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c01091d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01091dc:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01091e0:	8b 45 10             	mov    0x10(%ebp),%eax
c01091e3:	89 44 24 08          	mov    %eax,0x8(%esp)
c01091e7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01091ea:	89 44 24 04          	mov    %eax,0x4(%esp)
c01091ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01091f1:	89 04 24             	mov    %eax,(%esp)
c01091f4:	e8 08 00 00 00       	call   c0109201 <vsnprintf>
c01091f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01091fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01091ff:	c9                   	leave  
c0109200:	c3                   	ret    

c0109201 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0109201:	55                   	push   %ebp
c0109202:	89 e5                	mov    %esp,%ebp
c0109204:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0109207:	8b 45 08             	mov    0x8(%ebp),%eax
c010920a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010920d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109210:	8d 50 ff             	lea    -0x1(%eax),%edx
c0109213:	8b 45 08             	mov    0x8(%ebp),%eax
c0109216:	01 d0                	add    %edx,%eax
c0109218:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010921b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0109222:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0109226:	74 0a                	je     c0109232 <vsnprintf+0x31>
c0109228:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010922b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010922e:	39 c2                	cmp    %eax,%edx
c0109230:	76 07                	jbe    c0109239 <vsnprintf+0x38>
        return -E_INVAL;
c0109232:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0109237:	eb 2a                	jmp    c0109263 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0109239:	8b 45 14             	mov    0x14(%ebp),%eax
c010923c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109240:	8b 45 10             	mov    0x10(%ebp),%eax
c0109243:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109247:	8d 45 ec             	lea    -0x14(%ebp),%eax
c010924a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010924e:	c7 04 24 98 91 10 c0 	movl   $0xc0109198,(%esp)
c0109255:	e8 53 fb ff ff       	call   c0108dad <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c010925a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010925d:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0109260:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0109263:	c9                   	leave  
c0109264:	c3                   	ret    

c0109265 <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
c0109265:	55                   	push   %ebp
c0109266:	89 e5                	mov    %esp,%ebp
c0109268:	57                   	push   %edi
c0109269:	56                   	push   %esi
c010926a:	53                   	push   %ebx
c010926b:	83 ec 24             	sub    $0x24,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
c010926e:	a1 78 1a 12 c0       	mov    0xc0121a78,%eax
c0109273:	8b 15 7c 1a 12 c0    	mov    0xc0121a7c,%edx
c0109279:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
c010927f:	6b f0 05             	imul   $0x5,%eax,%esi
c0109282:	01 f7                	add    %esi,%edi
c0109284:	be 6d e6 ec de       	mov    $0xdeece66d,%esi
c0109289:	f7 e6                	mul    %esi
c010928b:	8d 34 17             	lea    (%edi,%edx,1),%esi
c010928e:	89 f2                	mov    %esi,%edx
c0109290:	83 c0 0b             	add    $0xb,%eax
c0109293:	83 d2 00             	adc    $0x0,%edx
c0109296:	89 c7                	mov    %eax,%edi
c0109298:	83 e7 ff             	and    $0xffffffff,%edi
c010929b:	89 f9                	mov    %edi,%ecx
c010929d:	0f b7 da             	movzwl %dx,%ebx
c01092a0:	89 0d 78 1a 12 c0    	mov    %ecx,0xc0121a78
c01092a6:	89 1d 7c 1a 12 c0    	mov    %ebx,0xc0121a7c
    unsigned long long result = (next >> 12);
c01092ac:	a1 78 1a 12 c0       	mov    0xc0121a78,%eax
c01092b1:	8b 15 7c 1a 12 c0    	mov    0xc0121a7c,%edx
c01092b7:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01092bb:	c1 ea 0c             	shr    $0xc,%edx
c01092be:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01092c1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
c01092c4:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
c01092cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01092ce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01092d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01092d4:	89 55 e8             	mov    %edx,-0x18(%ebp)
c01092d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01092da:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01092dd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01092e1:	74 1c                	je     c01092ff <rand+0x9a>
c01092e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01092e6:	ba 00 00 00 00       	mov    $0x0,%edx
c01092eb:	f7 75 dc             	divl   -0x24(%ebp)
c01092ee:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01092f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01092f4:	ba 00 00 00 00       	mov    $0x0,%edx
c01092f9:	f7 75 dc             	divl   -0x24(%ebp)
c01092fc:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01092ff:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0109302:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109305:	f7 75 dc             	divl   -0x24(%ebp)
c0109308:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010930b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010930e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0109311:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0109314:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0109317:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c010931a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
c010931d:	83 c4 24             	add    $0x24,%esp
c0109320:	5b                   	pop    %ebx
c0109321:	5e                   	pop    %esi
c0109322:	5f                   	pop    %edi
c0109323:	5d                   	pop    %ebp
c0109324:	c3                   	ret    

c0109325 <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
c0109325:	55                   	push   %ebp
c0109326:	89 e5                	mov    %esp,%ebp
    next = seed;
c0109328:	8b 45 08             	mov    0x8(%ebp),%eax
c010932b:	ba 00 00 00 00       	mov    $0x0,%edx
c0109330:	a3 78 1a 12 c0       	mov    %eax,0xc0121a78
c0109335:	89 15 7c 1a 12 c0    	mov    %edx,0xc0121a7c
}
c010933b:	5d                   	pop    %ebp
c010933c:	c3                   	ret    
