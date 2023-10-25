
kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00007117          	auipc	sp,0x7
    80000004:	aa013103          	ld	sp,-1376(sp) # 80006aa0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	00001537          	lui	a0,0x1
    8000000c:	f14025f3          	csrr	a1,mhartid
    80000010:	00158593          	addi	a1,a1,1
    80000014:	02b50533          	mul	a0,a0,a1
    80000018:	00a10133          	add	sp,sp,a0
    8000001c:	0ad030ef          	jal	ra,800038c8 <start>

0000000080000020 <spin>:
    80000020:	0000006f          	j	80000020 <spin>
	...

0000000080001000 <copy_and_swap>:
# a1 holds expected value
# a2 holds desired value
# a0 holds return value, 0 if successful, !0 otherwise
.global copy_and_swap
copy_and_swap:
    lr.w t0, (a0)          # Load original value.
    80001000:	100522af          	lr.w	t0,(a0)
    bne t0, a1, fail       # Doesn’t match, so fail.
    80001004:	00b29a63          	bne	t0,a1,80001018 <fail>
    sc.w t0, a2, (a0)      # Try to update.
    80001008:	18c522af          	sc.w	t0,a2,(a0)
    bnez t0, copy_and_swap # Retry if store-conditional failed.
    8000100c:	fe029ae3          	bnez	t0,80001000 <copy_and_swap>
    li a0, 0               # Set return to success.
    80001010:	00000513          	li	a0,0
    jr ra                  # Return.
    80001014:	00008067          	ret

0000000080001018 <fail>:
    fail:
    li a0, 1               # Set return to failure.
    80001018:	00100513          	li	a0,1
    8000101c:	00008067          	ret

0000000080001020 <supervisorTrap>:
.align 4
.global supervisorTrap
.type supervisorTrap, @function
supervisorTrap:
    # push all registers to stack
    addi sp, sp, -256
    80001020:	f0010113          	addi	sp,sp,-256
    .irp index, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    sd x\index, \index * 8(sp)
    .endr
    80001024:	00013023          	sd	zero,0(sp)
    80001028:	00113423          	sd	ra,8(sp)
    8000102c:	00213823          	sd	sp,16(sp)
    80001030:	00313c23          	sd	gp,24(sp)
    80001034:	02413023          	sd	tp,32(sp)
    80001038:	02513423          	sd	t0,40(sp)
    8000103c:	02613823          	sd	t1,48(sp)
    80001040:	02713c23          	sd	t2,56(sp)
    80001044:	04813023          	sd	s0,64(sp)
    80001048:	04913423          	sd	s1,72(sp)
    8000104c:	04a13823          	sd	a0,80(sp)
    80001050:	04b13c23          	sd	a1,88(sp)
    80001054:	06c13023          	sd	a2,96(sp)
    80001058:	06d13423          	sd	a3,104(sp)
    8000105c:	06e13823          	sd	a4,112(sp)
    80001060:	06f13c23          	sd	a5,120(sp)
    80001064:	09013023          	sd	a6,128(sp)
    80001068:	09113423          	sd	a7,136(sp)
    8000106c:	09213823          	sd	s2,144(sp)
    80001070:	09313c23          	sd	s3,152(sp)
    80001074:	0b413023          	sd	s4,160(sp)
    80001078:	0b513423          	sd	s5,168(sp)
    8000107c:	0b613823          	sd	s6,176(sp)
    80001080:	0b713c23          	sd	s7,184(sp)
    80001084:	0d813023          	sd	s8,192(sp)
    80001088:	0d913423          	sd	s9,200(sp)
    8000108c:	0da13823          	sd	s10,208(sp)
    80001090:	0db13c23          	sd	s11,216(sp)
    80001094:	0fc13023          	sd	t3,224(sp)
    80001098:	0fd13423          	sd	t4,232(sp)
    8000109c:	0fe13823          	sd	t5,240(sp)
    800010a0:	0ff13c23          	sd	t6,248(sp)
    addi sp, sp, -32
    800010a4:	fe010113          	addi	sp,sp,-32
    sd a0, 0*8(sp)
    800010a8:	00a13023          	sd	a0,0(sp)
    sd a1, 1*8(sp)
    800010ac:	00b13423          	sd	a1,8(sp)
    sd a2, 2*8(sp)
    800010b0:	00c13823          	sd	a2,16(sp)
    sd a3, 3*8(sp)
    800010b4:	00d13c23          	sd	a3,24(sp)
    mv a0,sp
    800010b8:	00010513          	mv	a0,sp
    call handleSupervisorTrap
    800010bc:	3f9000ef          	jal	ra,80001cb4 <handleSupervisorTrap>



    addi sp, sp, 32
    800010c0:	02010113          	addi	sp,sp,32
    # pop all registers from stack
    .irp index, 0,1,2,3,4,5,6,7,8,9,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    ld x\index, \index * 8(sp)
    .endr
    800010c4:	00013003          	ld	zero,0(sp)
    800010c8:	00813083          	ld	ra,8(sp)
    800010cc:	01013103          	ld	sp,16(sp)
    800010d0:	01813183          	ld	gp,24(sp)
    800010d4:	02013203          	ld	tp,32(sp)
    800010d8:	02813283          	ld	t0,40(sp)
    800010dc:	03013303          	ld	t1,48(sp)
    800010e0:	03813383          	ld	t2,56(sp)
    800010e4:	04013403          	ld	s0,64(sp)
    800010e8:	04813483          	ld	s1,72(sp)
    800010ec:	05813583          	ld	a1,88(sp)
    800010f0:	06013603          	ld	a2,96(sp)
    800010f4:	06813683          	ld	a3,104(sp)
    800010f8:	07013703          	ld	a4,112(sp)
    800010fc:	07813783          	ld	a5,120(sp)
    80001100:	08013803          	ld	a6,128(sp)
    80001104:	08813883          	ld	a7,136(sp)
    80001108:	09013903          	ld	s2,144(sp)
    8000110c:	09813983          	ld	s3,152(sp)
    80001110:	0a013a03          	ld	s4,160(sp)
    80001114:	0a813a83          	ld	s5,168(sp)
    80001118:	0b013b03          	ld	s6,176(sp)
    8000111c:	0b813b83          	ld	s7,184(sp)
    80001120:	0c013c03          	ld	s8,192(sp)
    80001124:	0c813c83          	ld	s9,200(sp)
    80001128:	0d013d03          	ld	s10,208(sp)
    8000112c:	0d813d83          	ld	s11,216(sp)
    80001130:	0e013e03          	ld	t3,224(sp)
    80001134:	0e813e83          	ld	t4,232(sp)
    80001138:	0f013f03          	ld	t5,240(sp)
    8000113c:	0f813f83          	ld	t6,248(sp)
    addi sp, sp, 256
    80001140:	10010113          	addi	sp,sp,256

    sret
    80001144:	10200073          	sret
	...

0000000080001150 <contextSwitch>:
.global contextSwitch
.type contextSwitch, @function
contextSwitch:
    sd ra, 0 * 8(a0)
    80001150:	00153023          	sd	ra,0(a0) # 1000 <_entry-0x7ffff000>
    sd sp, 1 * 8(a0)
    80001154:	00253423          	sd	sp,8(a0)

    ld ra, 0 * 8(a1)
    80001158:	0005b083          	ld	ra,0(a1)
    ld sp, 1 * 8(a1)
    8000115c:	0085b103          	ld	sp,8(a1)

    80001160:	00008067          	ret

0000000080001164 <idle_funct>:
    running->state=RUNNING;
    contextSwitch(old->context, running->context);

}
void  printc(char c);
void  idle_funct(){
    80001164:	ff010113          	addi	sp,sp,-16
    80001168:	00813423          	sd	s0,8(sp)
    8000116c:	01010413          	addi	s0,sp,16
    //printc('i');
    for(;;){
    80001170:	0000006f          	j	80001170 <idle_funct+0xc>

0000000080001174 <popSppSpie>:
{
    80001174:	ff010113          	addi	sp,sp,-16
    80001178:	00813423          	sd	s0,8(sp)
    8000117c:	01010413          	addi	s0,sp,16
    __asm__ volatile ("csrw sepc, ra");
    80001180:	14109073          	csrw	sepc,ra
    __asm__ volatile ("sret");
    80001184:	10200073          	sret
}
    80001188:	00813403          	ld	s0,8(sp)
    8000118c:	01010113          	addi	sp,sp,16
    80001190:	00008067          	ret

0000000080001194 <thread_wrapper>:
void thread_wrapper() {
    80001194:	fe010113          	addi	sp,sp,-32
    80001198:	00113c23          	sd	ra,24(sp)
    8000119c:	00813823          	sd	s0,16(sp)
    800011a0:	00913423          	sd	s1,8(sp)
    800011a4:	02010413          	addi	s0,sp,32
    popSppSpie();
    800011a8:	00000097          	auipc	ra,0x0
    800011ac:	fcc080e7          	jalr	-52(ra) # 80001174 <popSppSpie>
    running->start_routine(running->arg);
    800011b0:	00006497          	auipc	s1,0x6
    800011b4:	95848493          	addi	s1,s1,-1704 # 80006b08 <running>
    800011b8:	0004b783          	ld	a5,0(s1)
    800011bc:	0207b703          	ld	a4,32(a5)
    800011c0:	0287b503          	ld	a0,40(a5)
    800011c4:	000700e7          	jalr	a4
    running->state=DEAD;
    800011c8:	0004b783          	ld	a5,0(s1)
    800011cc:	00500713          	li	a4,5
    800011d0:	00e7ac23          	sw	a4,24(a5)
    thread_dispatch();
    800011d4:	00002097          	auipc	ra,0x2
    800011d8:	948080e7          	jalr	-1720(ra) # 80002b1c <thread_dispatch>
}
    800011dc:	01813083          	ld	ra,24(sp)
    800011e0:	01013403          	ld	s0,16(sp)
    800011e4:	00813483          	ld	s1,8(sp)
    800011e8:	02010113          	addi	sp,sp,32
    800011ec:	00008067          	ret

00000000800011f0 <__thread_create>:
        ){
    800011f0:	fd010113          	addi	sp,sp,-48
    800011f4:	02113423          	sd	ra,40(sp)
    800011f8:	02813023          	sd	s0,32(sp)
    800011fc:	00913c23          	sd	s1,24(sp)
    80001200:	01213823          	sd	s2,16(sp)
    80001204:	01313423          	sd	s3,8(sp)
    80001208:	03010413          	addi	s0,sp,48
    8000120c:	00060913          	mv	s2,a2
     if(handle==NULL){
    80001210:	10050863          	beqz	a0,80001320 <__thread_create+0x130>
    80001214:	00050493          	mv	s1,a0
    80001218:	00058993          	mv	s3,a1
         (*handle)= __mem_alloc(sizeof (_thread));
    8000121c:	05000513          	li	a0,80
    80001220:	00001097          	auipc	ra,0x1
    80001224:	538080e7          	jalr	1336(ra) # 80002758 <__mem_alloc>
    80001228:	00a4b023          	sd	a0,0(s1)
         if((*handle)==NULL)return -1;
    8000122c:	1e050063          	beqz	a0,8000140c <__thread_create+0x21c>
         (*handle)->id = ++stID;
    80001230:	00005717          	auipc	a4,0x5
    80001234:	76070713          	addi	a4,a4,1888 # 80006990 <stID>
    80001238:	00073783          	ld	a5,0(a4)
    8000123c:	00178793          	addi	a5,a5,1
    80001240:	00f73023          	sd	a5,0(a4)
    80001244:	00f53023          	sd	a5,0(a0)
         (*handle)->timeslice = DEFAULT_TIME_SLICE;
    80001248:	0004b783          	ld	a5,0(s1)
    8000124c:	00200713          	li	a4,2
    80001250:	02e7b823          	sd	a4,48(a5)
         (*handle)->start_routine = start_routine;
    80001254:	0004b783          	ld	a5,0(s1)
    80001258:	0337b023          	sd	s3,32(a5)
         (*handle)->stack = __mem_alloc(DEFAULT_STACK_SIZE * sizeof(uint64));
    8000125c:	0004b983          	ld	s3,0(s1)
    80001260:	00008537          	lui	a0,0x8
    80001264:	00001097          	auipc	ra,0x1
    80001268:	4f4080e7          	jalr	1268(ra) # 80002758 <__mem_alloc>
    8000126c:	00a9b823          	sd	a0,16(s3)
         if ((*handle)->stack == NULL) return -1;
    80001270:	0004b983          	ld	s3,0(s1)
    80001274:	0109b783          	ld	a5,16(s3)
    80001278:	18078e63          	beqz	a5,80001414 <__thread_create+0x224>
         (*handle)->context=__mem_alloc(sizeof(_pcb));
    8000127c:	01000513          	li	a0,16
    80001280:	00001097          	auipc	ra,0x1
    80001284:	4d8080e7          	jalr	1240(ra) # 80002758 <__mem_alloc>
    80001288:	00a9b423          	sd	a0,8(s3)
         if ((*handle)->context == NULL) return -1;
    8000128c:	0004b703          	ld	a4,0(s1)
    80001290:	00873783          	ld	a5,8(a4)
    80001294:	18078463          	beqz	a5,8000141c <__thread_create+0x22c>
         if(*handle==consolethr)(*handle)->context->ra = (uint64)&system_thread_wrapper;
    80001298:	00006697          	auipc	a3,0x6
    8000129c:	8586b683          	ld	a3,-1960(a3) # 80006af0 <consolethr>
    800012a0:	14d70263          	beq	a4,a3,800013e4 <__thread_create+0x1f4>
         else (*handle)->context->ra = (uint64)&thread_wrapper;
    800012a4:	00000717          	auipc	a4,0x0
    800012a8:	ef070713          	addi	a4,a4,-272 # 80001194 <thread_wrapper>
    800012ac:	00e7b023          	sd	a4,0(a5)
         (*handle)->context->sp = (uint64) (&((*handle)->stack[DEFAULT_STACK_SIZE-1]));
    800012b0:	0004b683          	ld	a3,0(s1)
    800012b4:	0106b783          	ld	a5,16(a3)
    800012b8:	00008737          	lui	a4,0x8
    800012bc:	ff870713          	addi	a4,a4,-8 # 7ff8 <_entry-0x7fff8008>
    800012c0:	00e787b3          	add	a5,a5,a4
    800012c4:	0086b703          	ld	a4,8(a3)
    800012c8:	00f73423          	sd	a5,8(a4)
         (*handle)->state = READY;
    800012cc:	0004b783          	ld	a5,0(s1)
    800012d0:	00100713          	li	a4,1
    800012d4:	00e7ac23          	sw	a4,24(a5)
         (*handle)->arg=arg;
    800012d8:	0004b783          	ld	a5,0(s1)
    800012dc:	0327b423          	sd	s2,40(a5)
         (*handle)->isPer=0;
    800012e0:	0004b783          	ld	a5,0(s1)
    800012e4:	0407b423          	sd	zero,72(a5)
         if(handle!=&idle)sc_put(*handle);
    800012e8:	00006797          	auipc	a5,0x6
    800012ec:	81878793          	addi	a5,a5,-2024 # 80006b00 <idle>
    800012f0:	12f48a63          	beq	s1,a5,80001424 <__thread_create+0x234>
    800012f4:	0004b503          	ld	a0,0(s1)
    800012f8:	00002097          	auipc	ra,0x2
    800012fc:	8ac080e7          	jalr	-1876(ra) # 80002ba4 <sc_put>
     return 0;
    80001300:	00000513          	li	a0,0
 }
    80001304:	02813083          	ld	ra,40(sp)
    80001308:	02013403          	ld	s0,32(sp)
    8000130c:	01813483          	ld	s1,24(sp)
    80001310:	01013903          	ld	s2,16(sp)
    80001314:	00813983          	ld	s3,8(sp)
    80001318:	03010113          	addi	sp,sp,48
    8000131c:	00008067          	ret
        (*handle)= __mem_alloc(sizeof(_thread));
    80001320:	05000513          	li	a0,80
    80001324:	00001097          	auipc	ra,0x1
    80001328:	434080e7          	jalr	1076(ra) # 80002758 <__mem_alloc>
    8000132c:	00005797          	auipc	a5,0x5
    80001330:	7ca7b623          	sd	a0,1996(a5) # 80006af8 <mainthr>
        if((*handle)==NULL) return -1;
    80001334:	0c050063          	beqz	a0,800013f4 <__thread_create+0x204>
         (*handle)->id = ++stID;
    80001338:	00005717          	auipc	a4,0x5
    8000133c:	65870713          	addi	a4,a4,1624 # 80006990 <stID>
    80001340:	00073783          	ld	a5,0(a4)
    80001344:	00178793          	addi	a5,a5,1
    80001348:	00f73023          	sd	a5,0(a4)
    8000134c:	00f53023          	sd	a5,0(a0) # 8000 <_entry-0x7fff8000>
         (*handle)->timeslice = DEFAULT_TIME_SLICE;
    80001350:	00005997          	auipc	s3,0x5
    80001354:	7a898993          	addi	s3,s3,1960 # 80006af8 <mainthr>
    80001358:	0009b483          	ld	s1,0(s3)
    8000135c:	00200793          	li	a5,2
    80001360:	02f4b823          	sd	a5,48(s1)
         (*handle)->state = READY;
    80001364:	00100793          	li	a5,1
    80001368:	00f4ac23          	sw	a5,24(s1)
         (*handle)->context=__mem_alloc(sizeof(_pcb));
    8000136c:	01000513          	li	a0,16
    80001370:	00001097          	auipc	ra,0x1
    80001374:	3e8080e7          	jalr	1000(ra) # 80002758 <__mem_alloc>
    80001378:	00a4b423          	sd	a0,8(s1)
         if ((*handle)->context == NULL) return -1;
    8000137c:	0009b783          	ld	a5,0(s3)
    80001380:	0087b783          	ld	a5,8(a5)
    80001384:	06078c63          	beqz	a5,800013fc <__thread_create+0x20c>
         (*handle)->context->ra=(uint64)&thread_wrapper;
    80001388:	00000717          	auipc	a4,0x0
    8000138c:	e0c70713          	addi	a4,a4,-500 # 80001194 <thread_wrapper>
    80001390:	00e7b023          	sd	a4,0(a5)
         (*handle)->stack = __mem_alloc(DEFAULT_STACK_SIZE * sizeof(uint64));
    80001394:	00098493          	mv	s1,s3
    80001398:	0009b983          	ld	s3,0(s3)
    8000139c:	00008537          	lui	a0,0x8
    800013a0:	00001097          	auipc	ra,0x1
    800013a4:	3b8080e7          	jalr	952(ra) # 80002758 <__mem_alloc>
    800013a8:	00a9b823          	sd	a0,16(s3)
         if ((*handle)->stack == NULL) return -1;
    800013ac:	0004b783          	ld	a5,0(s1)
    800013b0:	0107b703          	ld	a4,16(a5)
    800013b4:	04070863          	beqz	a4,80001404 <__thread_create+0x214>
         (*handle)->context->sp = (uint64) (&((*handle)->stack[DEFAULT_STACK_SIZE-1]));
    800013b8:	000086b7          	lui	a3,0x8
    800013bc:	ff868693          	addi	a3,a3,-8 # 7ff8 <_entry-0x7fff8008>
    800013c0:	00d70733          	add	a4,a4,a3
    800013c4:	0087b683          	ld	a3,8(a5)
    800013c8:	00e6b423          	sd	a4,8(a3)
         (*handle)->state = RUNNING;
    800013cc:	00200713          	li	a4,2
    800013d0:	00e7ac23          	sw	a4,24(a5)
         (*handle)->isPer=0;
    800013d4:	0407b423          	sd	zero,72(a5)
         (*handle)->arg=arg;
    800013d8:	0327b423          	sd	s2,40(a5)
     return 0;
    800013dc:	00000513          	li	a0,0
    800013e0:	f25ff06f          	j	80001304 <__thread_create+0x114>
         if(*handle==consolethr)(*handle)->context->ra = (uint64)&system_thread_wrapper;
    800013e4:	00000717          	auipc	a4,0x0
    800013e8:	10070713          	addi	a4,a4,256 # 800014e4 <system_thread_wrapper>
    800013ec:	00e7b023          	sd	a4,0(a5)
    800013f0:	ec1ff06f          	j	800012b0 <__thread_create+0xc0>
        if((*handle)==NULL) return -1;
    800013f4:	fff00513          	li	a0,-1
    800013f8:	f0dff06f          	j	80001304 <__thread_create+0x114>
         if ((*handle)->context == NULL) return -1;
    800013fc:	fff00513          	li	a0,-1
    80001400:	f05ff06f          	j	80001304 <__thread_create+0x114>
         if ((*handle)->stack == NULL) return -1;
    80001404:	fff00513          	li	a0,-1
    80001408:	efdff06f          	j	80001304 <__thread_create+0x114>
         if((*handle)==NULL)return -1;
    8000140c:	fff00513          	li	a0,-1
    80001410:	ef5ff06f          	j	80001304 <__thread_create+0x114>
         if ((*handle)->stack == NULL) return -1;
    80001414:	fff00513          	li	a0,-1
    80001418:	eedff06f          	j	80001304 <__thread_create+0x114>
         if ((*handle)->context == NULL) return -1;
    8000141c:	fff00513          	li	a0,-1
    80001420:	ee5ff06f          	j	80001304 <__thread_create+0x114>
     return 0;
    80001424:	00000513          	li	a0,0
    80001428:	eddff06f          	j	80001304 <__thread_create+0x114>

000000008000142c <__thread_dispatch>:
void __thread_dispatch(){
    8000142c:	fe010113          	addi	sp,sp,-32
    80001430:	00113c23          	sd	ra,24(sp)
    80001434:	00813823          	sd	s0,16(sp)
    80001438:	00913423          	sd	s1,8(sp)
    8000143c:	02010413          	addi	s0,sp,32
    thread_t old = running;
    80001440:	00005497          	auipc	s1,0x5
    80001444:	6c84b483          	ld	s1,1736(s1) # 80006b08 <running>
    running = sc_get();
    80001448:	00002097          	auipc	ra,0x2
    8000144c:	80c080e7          	jalr	-2036(ra) # 80002c54 <sc_get>
    80001450:	00005797          	auipc	a5,0x5
    80001454:	6aa7bc23          	sd	a0,1720(a5) # 80006b08 <running>
    if(running==NULL){
    80001458:	00050c63          	beqz	a0,80001470 <__thread_dispatch+0x44>
    }else if((running->state)==CREATED){
    8000145c:	01852783          	lw	a5,24(a0) # 8018 <_entry-0x7fff7fe8>
    80001460:	02079063          	bnez	a5,80001480 <__thread_dispatch+0x54>
        sc_put(running);
    80001464:	00001097          	auipc	ra,0x1
    80001468:	740080e7          	jalr	1856(ra) # 80002ba4 <sc_put>
        goto  again;
    8000146c:	fddff06f          	j	80001448 <__thread_dispatch+0x1c>
        running=idle;
    80001470:	00005797          	auipc	a5,0x5
    80001474:	6907b783          	ld	a5,1680(a5) # 80006b00 <idle>
    80001478:	00005717          	auipc	a4,0x5
    8000147c:	68f73823          	sd	a5,1680(a4) # 80006b08 <running>
    if (old->state==RUNNING && old!=idle) {
    80001480:	0184a703          	lw	a4,24(s1)
    80001484:	00200793          	li	a5,2
    80001488:	02f70c63          	beq	a4,a5,800014c0 <__thread_dispatch+0x94>
    running->state=RUNNING;
    8000148c:	00005797          	auipc	a5,0x5
    80001490:	67c7b783          	ld	a5,1660(a5) # 80006b08 <running>
    80001494:	00200713          	li	a4,2
    80001498:	00e7ac23          	sw	a4,24(a5)
    contextSwitch(old->context, running->context);
    8000149c:	0087b583          	ld	a1,8(a5)
    800014a0:	0084b503          	ld	a0,8(s1)
    800014a4:	00000097          	auipc	ra,0x0
    800014a8:	cac080e7          	jalr	-852(ra) # 80001150 <contextSwitch>
}
    800014ac:	01813083          	ld	ra,24(sp)
    800014b0:	01013403          	ld	s0,16(sp)
    800014b4:	00813483          	ld	s1,8(sp)
    800014b8:	02010113          	addi	sp,sp,32
    800014bc:	00008067          	ret
    if (old->state==RUNNING && old!=idle) {
    800014c0:	00005797          	auipc	a5,0x5
    800014c4:	6407b783          	ld	a5,1600(a5) # 80006b00 <idle>
    800014c8:	fc9782e3          	beq	a5,s1,8000148c <__thread_dispatch+0x60>
        old->state=READY;
    800014cc:	00100793          	li	a5,1
    800014d0:	00f4ac23          	sw	a5,24(s1)
        sc_put(old);
    800014d4:	00048513          	mv	a0,s1
    800014d8:	00001097          	auipc	ra,0x1
    800014dc:	6cc080e7          	jalr	1740(ra) # 80002ba4 <sc_put>
    800014e0:	fadff06f          	j	8000148c <__thread_dispatch+0x60>

00000000800014e4 <system_thread_wrapper>:
void system_thread_wrapper() {
    800014e4:	fe010113          	addi	sp,sp,-32
    800014e8:	00113c23          	sd	ra,24(sp)
    800014ec:	00813823          	sd	s0,16(sp)
    800014f0:	00913423          	sd	s1,8(sp)
    800014f4:	02010413          	addi	s0,sp,32
    running->start_routine(running->arg);
    800014f8:	00005497          	auipc	s1,0x5
    800014fc:	61048493          	addi	s1,s1,1552 # 80006b08 <running>
    80001500:	0004b783          	ld	a5,0(s1)
    80001504:	0207b703          	ld	a4,32(a5)
    80001508:	0287b503          	ld	a0,40(a5)
    8000150c:	000700e7          	jalr	a4
    running->state=DEAD;
    80001510:	0004b783          	ld	a5,0(s1)
    80001514:	00500713          	li	a4,5
    80001518:	00e7ac23          	sw	a4,24(a5)
    timeSliceCounter=0;
    8000151c:	00005797          	auipc	a5,0x5
    80001520:	5c07b623          	sd	zero,1484(a5) # 80006ae8 <timeSliceCounter>
    __thread_dispatch();
    80001524:	00000097          	auipc	ra,0x0
    80001528:	f08080e7          	jalr	-248(ra) # 8000142c <__thread_dispatch>
}
    8000152c:	01813083          	ld	ra,24(sp)
    80001530:	01013403          	ld	s0,16(sp)
    80001534:	00813483          	ld	s1,8(sp)
    80001538:	02010113          	addi	sp,sp,32
    8000153c:	00008067          	ret

0000000080001540 <memset>:
extern char getc ();
extern void putc (char);
extern void sc_put(thread_t thr);
extern thread_t sc_get();
extern int sc_empty();
void *memset(void *ptr, int b, size_t n) {
    80001540:	ff010113          	addi	sp,sp,-16
    80001544:	00813423          	sd	s0,8(sp)
    80001548:	01010413          	addi	s0,sp,16
    char *t = ptr;
    for (int i = 0; i < n; t[i++] = b);
    8000154c:	00000793          	li	a5,0
    80001550:	00078713          	mv	a4,a5
    80001554:	00c7fa63          	bgeu	a5,a2,80001568 <memset+0x28>
    80001558:	0017879b          	addiw	a5,a5,1
    8000155c:	00e50733          	add	a4,a0,a4
    80001560:	00b70023          	sb	a1,0(a4)
    80001564:	fedff06f          	j	80001550 <memset+0x10>
    return  ptr;
}
    80001568:	00813403          	ld	s0,8(sp)
    8000156c:	01010113          	addi	sp,sp,16
    80001570:	00008067          	ret

0000000080001574 <__thread_exit>:
        puthexdigit(lo);
    }
}

int __thread_exit(){
  if(running->state==DEAD){
    80001574:	00005797          	auipc	a5,0x5
    80001578:	5947b783          	ld	a5,1428(a5) # 80006b08 <running>
    8000157c:	0187a683          	lw	a3,24(a5)
    80001580:	00500713          	li	a4,5
    80001584:	02e68a63          	beq	a3,a4,800015b8 <__thread_exit+0x44>
int __thread_exit(){
    80001588:	ff010113          	addi	sp,sp,-16
    8000158c:	00113423          	sd	ra,8(sp)
    80001590:	00813023          	sd	s0,0(sp)
    80001594:	01010413          	addi	s0,sp,16
      return -1;
  }
    running->state=DEAD;
    80001598:	00e7ac23          	sw	a4,24(a5)
    __thread_dispatch();
    8000159c:	00000097          	auipc	ra,0x0
    800015a0:	e90080e7          	jalr	-368(ra) # 8000142c <__thread_dispatch>
    return 0;
    800015a4:	00000513          	li	a0,0
}
    800015a8:	00813083          	ld	ra,8(sp)
    800015ac:	00013403          	ld	s0,0(sp)
    800015b0:	01010113          	addi	sp,sp,16
    800015b4:	00008067          	ret
      return -1;
    800015b8:	fff00513          	li	a0,-1
}
    800015bc:	00008067          	ret

00000000800015c0 <__sem_open>:
extern int mem_free(void* p);

int __sem_open (
        sem_t* handle,
        unsigned init
){
    800015c0:	fe010113          	addi	sp,sp,-32
    800015c4:	00113c23          	sd	ra,24(sp)
    800015c8:	00813823          	sd	s0,16(sp)
    800015cc:	00913423          	sd	s1,8(sp)
    800015d0:	01213023          	sd	s2,0(sp)
    800015d4:	02010413          	addi	s0,sp,32
    800015d8:	00050493          	mv	s1,a0
    800015dc:	00058913          	mv	s2,a1

    (*handle)= __mem_alloc(sizeof(_sem));
    800015e0:	01800513          	li	a0,24
    800015e4:	00001097          	auipc	ra,0x1
    800015e8:	174080e7          	jalr	372(ra) # 80002758 <__mem_alloc>
    800015ec:	00a4b023          	sd	a0,0(s1)
    if(!(*handle)) return -1;
    800015f0:	02050a63          	beqz	a0,80001624 <__sem_open+0x64>
    (*handle)->value=init;
    800015f4:	01252023          	sw	s2,0(a0)
    (*handle)->blocked=NULL;
    800015f8:	0004b783          	ld	a5,0(s1)
    800015fc:	0007b423          	sd	zero,8(a5)
    (*handle)->blend=NULL;
    80001600:	0004b783          	ld	a5,0(s1)
    80001604:	0007b823          	sd	zero,16(a5)
    return 0;
    80001608:	00000513          	li	a0,0
}
    8000160c:	01813083          	ld	ra,24(sp)
    80001610:	01013403          	ld	s0,16(sp)
    80001614:	00813483          	ld	s1,8(sp)
    80001618:	00013903          	ld	s2,0(sp)
    8000161c:	02010113          	addi	sp,sp,32
    80001620:	00008067          	ret
    if(!(*handle)) return -1;
    80001624:	fff00513          	li	a0,-1
    80001628:	fe5ff06f          	j	8000160c <__sem_open+0x4c>

000000008000162c <__sem_close>:
int __sem_close(sem_t handle){
    8000162c:	fe010113          	addi	sp,sp,-32
    80001630:	00113c23          	sd	ra,24(sp)
    80001634:	00813823          	sd	s0,16(sp)
    80001638:	00913423          	sd	s1,8(sp)
    8000163c:	01213023          	sd	s2,0(sp)
    80001640:	02010413          	addi	s0,sp,32
    80001644:	00050913          	mv	s2,a0
    blist* s;
    while(handle->blocked){
    80001648:	00893483          	ld	s1,8(s2)
    8000164c:	02048e63          	beqz	s1,80001688 <__sem_close+0x5c>
        s=handle->blocked;
        thread_t thr=s->data;
    80001650:	0004b503          	ld	a0,0(s1)
        thr->state=READY;
    80001654:	00100793          	li	a5,1
    80001658:	00f52c23          	sw	a5,24(a0)
        sc_put(thr);
    8000165c:	00001097          	auipc	ra,0x1
    80001660:	548080e7          	jalr	1352(ra) # 80002ba4 <sc_put>
        handle->blocked=handle->blocked->next;
    80001664:	00893783          	ld	a5,8(s2)
    80001668:	0107b783          	ld	a5,16(a5)
    8000166c:	00f93423          	sd	a5,8(s2)
        if(__mem_free(s)==-1) return -1;
    80001670:	00048513          	mv	a0,s1
    80001674:	00001097          	auipc	ra,0x1
    80001678:	244080e7          	jalr	580(ra) # 800028b8 <__mem_free>
    8000167c:	fff00793          	li	a5,-1
    80001680:	fcf514e3          	bne	a0,a5,80001648 <__sem_close+0x1c>
    80001684:	01c0006f          	j	800016a0 <__sem_close+0x74>

    }
    if(__mem_free(handle)==-1)return -1;
    80001688:	00090513          	mv	a0,s2
    8000168c:	00001097          	auipc	ra,0x1
    80001690:	22c080e7          	jalr	556(ra) # 800028b8 <__mem_free>
    80001694:	fff00793          	li	a5,-1
    80001698:	00f50463          	beq	a0,a5,800016a0 <__sem_close+0x74>
    return 0;
    8000169c:	00000513          	li	a0,0
}
    800016a0:	01813083          	ld	ra,24(sp)
    800016a4:	01013403          	ld	s0,16(sp)
    800016a8:	00813483          	ld	s1,8(sp)
    800016ac:	00013903          	ld	s2,0(sp)
    800016b0:	02010113          	addi	sp,sp,32
    800016b4:	00008067          	ret

00000000800016b8 <__sem_wait>:
void putc1(char c);
spinlock semlock=INITLOCK;
int __sem_wait (sem_t id){
    //mc_sstatus(SSTATUS_SIE);
    if(id && (--id->value<0)){
    800016b8:	06050a63          	beqz	a0,8000172c <__sem_wait+0x74>
    800016bc:	00052783          	lw	a5,0(a0)
    800016c0:	fff7879b          	addiw	a5,a5,-1
    800016c4:	00f52023          	sw	a5,0(a0)
    800016c8:	02079713          	slli	a4,a5,0x20
    800016cc:	00074663          	bltz	a4,800016d8 <__sem_wait+0x20>
            __thread_dispatch();

    }
    //ms_sstatus(SSTATUS_SIE);

    return 0;
    800016d0:	00000513          	li	a0,0
}
    800016d4:	00008067          	ret
int __sem_wait (sem_t id){
    800016d8:	ff010113          	addi	sp,sp,-16
    800016dc:	00113423          	sd	ra,8(sp)
    800016e0:	00813023          	sd	s0,0(sp)
    800016e4:	01010413          	addi	s0,sp,16
        running->state=BLOCKED;
    800016e8:	00005597          	auipc	a1,0x5
    800016ec:	4205b583          	ld	a1,1056(a1) # 80006b08 <running>
    800016f0:	00300793          	li	a5,3
    800016f4:	00f5ac23          	sw	a5,24(a1)
        int x=b_put(id,running);
    800016f8:	00001097          	auipc	ra,0x1
    800016fc:	600080e7          	jalr	1536(ra) # 80002cf8 <b_put>
        if(x==-1) return -1;
    80001700:	fff00793          	li	a5,-1
    80001704:	00f50c63          	beq	a0,a5,8000171c <__sem_wait+0x64>
            timeSliceCounter=0;
    80001708:	00005797          	auipc	a5,0x5
    8000170c:	3e07b023          	sd	zero,992(a5) # 80006ae8 <timeSliceCounter>
            __thread_dispatch();
    80001710:	00000097          	auipc	ra,0x0
    80001714:	d1c080e7          	jalr	-740(ra) # 8000142c <__thread_dispatch>
    return 0;
    80001718:	00000513          	li	a0,0
}
    8000171c:	00813083          	ld	ra,8(sp)
    80001720:	00013403          	ld	s0,0(sp)
    80001724:	01010113          	addi	sp,sp,16
    80001728:	00008067          	ret
    return 0;
    8000172c:	00000513          	li	a0,0
    80001730:	00008067          	ret

0000000080001734 <__sem_signal>:

int __sem_signal (sem_t id){

            //mc_sstatus(SSTATUS_SIE);
            ++id->value;
    80001734:	00052783          	lw	a5,0(a0)
    80001738:	0017879b          	addiw	a5,a5,1
    8000173c:	0007871b          	sext.w	a4,a5
    80001740:	00f52023          	sw	a5,0(a0)
            //ms_sstatus(SSTATUS_SIE);
            if (id->value <= 0) {
    80001744:	04e04263          	bgtz	a4,80001788 <__sem_signal+0x54>
int __sem_signal (sem_t id){
    80001748:	ff010113          	addi	sp,sp,-16
    8000174c:	00113423          	sd	ra,8(sp)
    80001750:	00813023          	sd	s0,0(sp)
    80001754:	01010413          	addi	s0,sp,16
                thread_t thr = b_get(id);
    80001758:	00001097          	auipc	ra,0x1
    8000175c:	628080e7          	jalr	1576(ra) # 80002d80 <b_get>

                if (thr) {
    80001760:	02050863          	beqz	a0,80001790 <__sem_signal+0x5c>
                    thr->state = READY;
    80001764:	00100793          	li	a5,1
    80001768:	00f52c23          	sw	a5,24(a0)
                    sc_put(thr);
    8000176c:	00001097          	auipc	ra,0x1
    80001770:	438080e7          	jalr	1080(ra) # 80002ba4 <sc_put>
                    return 0;
    80001774:	00000513          	li	a0,0

        return -1;



}
    80001778:	00813083          	ld	ra,8(sp)
    8000177c:	00013403          	ld	s0,0(sp)
    80001780:	01010113          	addi	sp,sp,16
    80001784:	00008067          	ret
        return -1;
    80001788:	fff00513          	li	a0,-1
}
    8000178c:	00008067          	ret
        return -1;
    80001790:	fff00513          	li	a0,-1
    80001794:	fe5ff06f          	j	80001778 <__sem_signal+0x44>

0000000080001798 <console_putc>:
extern char get_uart2();
extern void initBuffers();
extern int isEmpty1();
extern int isEmpty2();
void  printc(char c);
void console_putc(){
    80001798:	fe010113          	addi	sp,sp,-32
    8000179c:	00113c23          	sd	ra,24(sp)
    800017a0:	00813823          	sd	s0,16(sp)
    800017a4:	00913423          	sd	s1,8(sp)
    800017a8:	01213023          	sd	s2,0(sp)
    800017ac:	02010413          	addi	s0,sp,32
    800017b0:	00c0006f          	j	800017bc <console_putc+0x24>
    __asm__ volatile ("csrs sstatus, %[mask]" : : [mask] "r"(mask));
    800017b4:	00200793          	li	a5,2
    800017b8:	1007a073          	csrs	sstatus,a5
    while(1) {
        while((mainthr->state==DEAD) && !isEmpty2()){
    800017bc:	00005797          	auipc	a5,0x5
    800017c0:	33c7b783          	ld	a5,828(a5) # 80006af8 <mainthr>
    800017c4:	0187a703          	lw	a4,24(a5)
    800017c8:	00500793          	li	a5,5
    800017cc:	06f71463          	bne	a4,a5,80001834 <console_putc+0x9c>
    800017d0:	00001097          	auipc	ra,0x1
    800017d4:	d84080e7          	jalr	-636(ra) # 80002554 <isEmpty2>
    800017d8:	04051e63          	bnez	a0,80001834 <console_putc+0x9c>
    __asm__ volatile ("csrc sstatus, %[mask]" : : [mask] "r"(mask));
    800017dc:	00200793          	li	a5,2
    800017e0:	1007b073          	csrc	sstatus,a5
            mc_sstatus(SSTATUS_SIE);
            uint8 status = *(uint8*)CONSOLE_STATUS;
    800017e4:	00005917          	auipc	s2,0x5
    800017e8:	82c93903          	ld	s2,-2004(s2) # 80006010 <CONSOLE_STATUS>
    800017ec:	00094783          	lbu	a5,0(s2)
            while ((status & CONSOLE_TX_STATUS_BIT) && !isEmpty2()) {
    800017f0:	0207f793          	andi	a5,a5,32
    800017f4:	fc0780e3          	beqz	a5,800017b4 <console_putc+0x1c>
    800017f8:	00001097          	auipc	ra,0x1
    800017fc:	d5c080e7          	jalr	-676(ra) # 80002554 <isEmpty2>
    80001800:	fa051ae3          	bnez	a0,800017b4 <console_putc+0x1c>

                char c = get_uart2();
    80001804:	00001097          	auipc	ra,0x1
    80001808:	c74080e7          	jalr	-908(ra) # 80002478 <get_uart2>
    8000180c:	00050493          	mv	s1,a0
                __sem_signal(fullPutc);
    80001810:	00005517          	auipc	a0,0x5
    80001814:	2c853503          	ld	a0,712(a0) # 80006ad8 <fullPutc>
    80001818:	00000097          	auipc	ra,0x0
    8000181c:	f1c080e7          	jalr	-228(ra) # 80001734 <__sem_signal>
                *((char *) (CONSOLE_TX_DATA)) = c;
    80001820:	00004797          	auipc	a5,0x4
    80001824:	7e87b783          	ld	a5,2024(a5) # 80006008 <CONSOLE_TX_DATA>
    80001828:	00978023          	sb	s1,0(a5)
                status = *(uint8*)CONSOLE_STATUS;
    8000182c:	00094783          	lbu	a5,0(s2)
    80001830:	fc1ff06f          	j	800017f0 <console_putc+0x58>

            }
            ms_sstatus(SSTATUS_SIE);
        }

        if((mainthr->state==DEAD) && isEmpty2()) break;
    80001834:	00005797          	auipc	a5,0x5
    80001838:	2c47b783          	ld	a5,708(a5) # 80006af8 <mainthr>
    8000183c:	0187a703          	lw	a4,24(a5)
    80001840:	00500793          	li	a5,5
    80001844:	00f71863          	bne	a4,a5,80001854 <console_putc+0xbc>
    80001848:	00001097          	auipc	ra,0x1
    8000184c:	d0c080e7          	jalr	-756(ra) # 80002554 <isEmpty2>
    80001850:	06051263          	bnez	a0,800018b4 <console_putc+0x11c>
        }*/
        /*while(isEmpty2()){
           if(sc_in(0) || scheduler->next!=NULL)__thread_dispatch();
           else break;
        }*/
        if(isEmpty2()){
    80001854:	00001097          	auipc	ra,0x1
    80001858:	d00080e7          	jalr	-768(ra) # 80002554 <isEmpty2>
    8000185c:	00051a63          	bnez	a0,80001870 <console_putc+0xd8>
            __sem_wait(ioSem);
        }

            //mc_sstatus(SSTATUS_SIE);
            uint8 status = *(uint8*)CONSOLE_STATUS;
    80001860:	00004497          	auipc	s1,0x4
    80001864:	7b04b483          	ld	s1,1968(s1) # 80006010 <CONSOLE_STATUS>
    80001868:	0004c783          	lbu	a5,0(s1)
            while ((status & CONSOLE_TX_STATUS_BIT) && !isEmpty2()) {
    8000186c:	0300006f          	j	8000189c <console_putc+0x104>
            __sem_wait(ioSem);
    80001870:	00005517          	auipc	a0,0x5
    80001874:	27053503          	ld	a0,624(a0) # 80006ae0 <ioSem>
    80001878:	00000097          	auipc	ra,0x0
    8000187c:	e40080e7          	jalr	-448(ra) # 800016b8 <__sem_wait>
    80001880:	fe1ff06f          	j	80001860 <console_putc+0xc8>

                char c = get_uart2();
    80001884:	00001097          	auipc	ra,0x1
    80001888:	bf4080e7          	jalr	-1036(ra) # 80002478 <get_uart2>
                *((char *) (CONSOLE_TX_DATA)) = c;
    8000188c:	00004797          	auipc	a5,0x4
    80001890:	77c7b783          	ld	a5,1916(a5) # 80006008 <CONSOLE_TX_DATA>
    80001894:	00a78023          	sb	a0,0(a5)
                status = *(uint8*)CONSOLE_STATUS;
    80001898:	0004c783          	lbu	a5,0(s1)
            while ((status & CONSOLE_TX_STATUS_BIT) && !isEmpty2()) {
    8000189c:	0207f793          	andi	a5,a5,32
    800018a0:	f0078ee3          	beqz	a5,800017bc <console_putc+0x24>
    800018a4:	00001097          	auipc	ra,0x1
    800018a8:	cb0080e7          	jalr	-848(ra) # 80002554 <isEmpty2>
    800018ac:	fc050ce3          	beqz	a0,80001884 <console_putc+0xec>
    800018b0:	f0dff06f          	j	800017bc <console_putc+0x24>
          // ms_sstatus(SSTATUS_SIE);


    }

}
    800018b4:	01813083          	ld	ra,24(sp)
    800018b8:	01013403          	ld	s0,16(sp)
    800018bc:	00813483          	ld	s1,8(sp)
    800018c0:	00013903          	ld	s2,0(sp)
    800018c4:	02010113          	addi	sp,sp,32
    800018c8:	00008067          	ret

00000000800018cc <getc1>:
extern char* uartBuffer2,uartBuffer1;
char getc1 (){
    800018cc:	ff010113          	addi	sp,sp,-16
    800018d0:	00113423          	sd	ra,8(sp)
    800018d4:	00813023          	sd	s0,0(sp)
    800018d8:	01010413          	addi	s0,sp,16
    char c;



    //*(uint8*)CONSOLE_STATUS|=!CONSOLE_RX_STATUS_BIT;
    c=get_uart1();
    800018dc:	00001097          	auipc	ra,0x1
    800018e0:	a48080e7          	jalr	-1464(ra) # 80002324 <get_uart1>
    //__putc(c);
    return c;
}
    800018e4:	00813083          	ld	ra,8(sp)
    800018e8:	00013403          	ld	s0,0(sp)
    800018ec:	01010113          	addi	sp,sp,16
    800018f0:	00008067          	ret

00000000800018f4 <putc1>:
extern int isFull2();
extern int isFull1();
void putc1 (char c){
    800018f4:	fe010113          	addi	sp,sp,-32
    800018f8:	00113c23          	sd	ra,24(sp)
    800018fc:	00813823          	sd	s0,16(sp)
    80001900:	00913423          	sd	s1,8(sp)
    80001904:	02010413          	addi	s0,sp,32
    80001908:	00050493          	mv	s1,a0
    //popSppSpie();
    /*while(isFull2()){
       // __thread_dispatch();
    }*/
    if(isFull2()){
    8000190c:	00001097          	auipc	ra,0x1
    80001910:	c80080e7          	jalr	-896(ra) # 8000258c <isFull2>
    80001914:	02051a63          	bnez	a0,80001948 <putc1+0x54>
        __sem_wait(fullPutc);
    }
    __sem_signal(ioSem);
    80001918:	00005517          	auipc	a0,0x5
    8000191c:	1c853503          	ld	a0,456(a0) # 80006ae0 <ioSem>
    80001920:	00000097          	auipc	ra,0x0
    80001924:	e14080e7          	jalr	-492(ra) # 80001734 <__sem_signal>
    put_uart2(c);
    80001928:	00048513          	mv	a0,s1
    8000192c:	00001097          	auipc	ra,0x1
    80001930:	ad0080e7          	jalr	-1328(ra) # 800023fc <put_uart2>

}
    80001934:	01813083          	ld	ra,24(sp)
    80001938:	01013403          	ld	s0,16(sp)
    8000193c:	00813483          	ld	s1,8(sp)
    80001940:	02010113          	addi	sp,sp,32
    80001944:	00008067          	ret
        __sem_wait(fullPutc);
    80001948:	00005517          	auipc	a0,0x5
    8000194c:	19053503          	ld	a0,400(a0) # 80006ad8 <fullPutc>
    80001950:	00000097          	auipc	ra,0x0
    80001954:	d68080e7          	jalr	-664(ra) # 800016b8 <__sem_wait>
    80001958:	fc1ff06f          	j	80001918 <putc1+0x24>

000000008000195c <puthexdigit>:
void puthexdigit(int a) {
    8000195c:	ff010113          	addi	sp,sp,-16
    80001960:	00113423          	sd	ra,8(sp)
    80001964:	00813023          	sd	s0,0(sp)
    80001968:	01010413          	addi	s0,sp,16
   if (a > 9)
    8000196c:	00900793          	li	a5,9
    80001970:	02a7d263          	bge	a5,a0,80001994 <puthexdigit+0x38>
       putc1('a'+ a - 10);
    80001974:	0575051b          	addiw	a0,a0,87
    80001978:	0ff57513          	andi	a0,a0,255
    8000197c:	00000097          	auipc	ra,0x0
    80001980:	f78080e7          	jalr	-136(ra) # 800018f4 <putc1>
}
    80001984:	00813083          	ld	ra,8(sp)
    80001988:	00013403          	ld	s0,0(sp)
    8000198c:	01010113          	addi	sp,sp,16
    80001990:	00008067          	ret
        putc1('0'+ a);
    80001994:	0305051b          	addiw	a0,a0,48
    80001998:	0ff57513          	andi	a0,a0,255
    8000199c:	00000097          	auipc	ra,0x0
    800019a0:	f58080e7          	jalr	-168(ra) # 800018f4 <putc1>
}
    800019a4:	fe1ff06f          	j	80001984 <puthexdigit+0x28>

00000000800019a8 <printaddr>:
void printaddr(uintptr a) {
    800019a8:	fd010113          	addi	sp,sp,-48
    800019ac:	02113423          	sd	ra,40(sp)
    800019b0:	02813023          	sd	s0,32(sp)
    800019b4:	00913c23          	sd	s1,24(sp)
    800019b8:	01213823          	sd	s2,16(sp)
    800019bc:	01313423          	sd	s3,8(sp)
    800019c0:	03010413          	addi	s0,sp,48
    800019c4:	00050993          	mv	s3,a0
    for (int i = 7; i >= 0; i--) {
    800019c8:	00700913          	li	s2,7
    800019cc:	0300006f          	j	800019fc <printaddr+0x54>
        int bajt = (a >> (i*8)) & 0xff;
    800019d0:	0039179b          	slliw	a5,s2,0x3
    800019d4:	00f9d7b3          	srl	a5,s3,a5
    800019d8:	0ff7f513          	andi	a0,a5,255
        int lo = bajt & 0xf;
    800019dc:	00f7f493          	andi	s1,a5,15
        puthexdigit(hi);
    800019e0:	00455513          	srli	a0,a0,0x4
    800019e4:	00000097          	auipc	ra,0x0
    800019e8:	f78080e7          	jalr	-136(ra) # 8000195c <puthexdigit>
        puthexdigit(lo);
    800019ec:	00048513          	mv	a0,s1
    800019f0:	00000097          	auipc	ra,0x0
    800019f4:	f6c080e7          	jalr	-148(ra) # 8000195c <puthexdigit>
    for (int i = 7; i >= 0; i--) {
    800019f8:	fff9091b          	addiw	s2,s2,-1
    800019fc:	fc095ae3          	bgez	s2,800019d0 <printaddr+0x28>
}
    80001a00:	02813083          	ld	ra,40(sp)
    80001a04:	02013403          	ld	s0,32(sp)
    80001a08:	01813483          	ld	s1,24(sp)
    80001a0c:	01013903          	ld	s2,16(sp)
    80001a10:	00813983          	ld	s3,8(sp)
    80001a14:	03010113          	addi	sp,sp,48
    80001a18:	00008067          	ret

0000000080001a1c <__time_sleep>:
int __time_sleep (time_t time){
    80001a1c:	fe010113          	addi	sp,sp,-32
    80001a20:	00113c23          	sd	ra,24(sp)
    80001a24:	00813823          	sd	s0,16(sp)
    80001a28:	00913423          	sd	s1,8(sp)
    80001a2c:	02010413          	addi	s0,sp,32
    80001a30:	00050593          	mv	a1,a0
        running->state=WAITING;
    80001a34:	00005517          	auipc	a0,0x5
    80001a38:	0d453503          	ld	a0,212(a0) # 80006b08 <running>
    80001a3c:	00400793          	li	a5,4
    80001a40:	00f52c23          	sw	a5,24(a0)
        running->sleep=time;
    80001a44:	04b53023          	sd	a1,64(a0)
        int ret=putblocked(running,time);
    80001a48:	00001097          	auipc	ra,0x1
    80001a4c:	390080e7          	jalr	912(ra) # 80002dd8 <putblocked>
        if(ret==-1) {putc1('G');return -1;}
    80001a50:	fff00793          	li	a5,-1
    80001a54:	02f50863          	beq	a0,a5,80001a84 <__time_sleep+0x68>
        timeSliceCounter=0;
    80001a58:	00005797          	auipc	a5,0x5
    80001a5c:	0807b823          	sd	zero,144(a5) # 80006ae8 <timeSliceCounter>
        __thread_dispatch();
    80001a60:	00000097          	auipc	ra,0x0
    80001a64:	9cc080e7          	jalr	-1588(ra) # 8000142c <__thread_dispatch>
        return 0;
    80001a68:	00000493          	li	s1,0
}
    80001a6c:	00048513          	mv	a0,s1
    80001a70:	01813083          	ld	ra,24(sp)
    80001a74:	01013403          	ld	s0,16(sp)
    80001a78:	00813483          	ld	s1,8(sp)
    80001a7c:	02010113          	addi	sp,sp,32
    80001a80:	00008067          	ret
    80001a84:	00050493          	mv	s1,a0
        if(ret==-1) {putc1('G');return -1;}
    80001a88:	04700513          	li	a0,71
    80001a8c:	00000097          	auipc	ra,0x0
    80001a90:	e68080e7          	jalr	-408(ra) # 800018f4 <putc1>
    80001a94:	fd9ff06f          	j	80001a6c <__time_sleep+0x50>

0000000080001a98 <handleblocked>:
void userMain();
extern blist* blend;
void handleblocked() {
    80001a98:	fd010113          	addi	sp,sp,-48
    80001a9c:	02113423          	sd	ra,40(sp)
    80001aa0:	02813023          	sd	s0,32(sp)
    80001aa4:	00913c23          	sd	s1,24(sp)
    80001aa8:	01213823          	sd	s2,16(sp)
    80001aac:	01313423          	sd	s3,8(sp)
    80001ab0:	01413023          	sd	s4,0(sp)
    80001ab4:	03010413          	addi	s0,sp,48

    if (blocked) {
    80001ab8:	00005497          	auipc	s1,0x5
    80001abc:	0c84b483          	ld	s1,200(s1) # 80006b80 <blocked>
    80001ac0:	0c048e63          	beqz	s1,80001b9c <handleblocked+0x104>
                putc1(' ');

            }
            putc1('\n');*/
///////////////////////////////////////////////////
       for (b = blocked; b != NULL; b = b->next) {
    80001ac4:	00048913          	mv	s2,s1
    80001ac8:	0080006f          	j	80001ad0 <handleblocked+0x38>
    80001acc:	01093903          	ld	s2,16(s2)
    80001ad0:	00090c63          	beqz	s2,80001ae8 <handleblocked+0x50>
            if (b->time > 0) b->time--;
    80001ad4:	00893783          	ld	a5,8(s2)
    80001ad8:	fe078ae3          	beqz	a5,80001acc <handleblocked+0x34>
    80001adc:	fff78793          	addi	a5,a5,-1
    80001ae0:	00f93423          	sd	a5,8(s2)
    80001ae4:	fe9ff06f          	j	80001acc <handleblocked+0x34>
       blist *b , *prev = NULL;
    80001ae8:	00090993          	mv	s3,s2
    80001aec:	0780006f          	j	80001b64 <handleblocked+0xcc>
        while (b) {
            if (b->time == 0) {
                blist* tmp = b;

                if (prev == NULL) {
                    if (b == blend) {
    80001af0:	00005797          	auipc	a5,0x5
    80001af4:	0887b783          	ld	a5,136(a5) # 80006b78 <blend>
    80001af8:	02978063          	beq	a5,s1,80001b18 <handleblocked+0x80>
                        blocked = blend = NULL;
                        b = NULL;
                    } else {
                        blocked = blocked->next;
    80001afc:	00005797          	auipc	a5,0x5
    80001b00:	08478793          	addi	a5,a5,132 # 80006b80 <blocked>
    80001b04:	0007b703          	ld	a4,0(a5)
    80001b08:	01073703          	ld	a4,16(a4)
    80001b0c:	00e7b023          	sd	a4,0(a5)
                        b = b->next;
    80001b10:	0104ba03          	ld	s4,16(s1)
    80001b14:	02c0006f          	j	80001b40 <handleblocked+0xa8>
                        blocked = blend = NULL;
    80001b18:	00005797          	auipc	a5,0x5
    80001b1c:	0607b023          	sd	zero,96(a5) # 80006b78 <blend>
    80001b20:	00005797          	auipc	a5,0x5
    80001b24:	0607b023          	sd	zero,96(a5) # 80006b80 <blocked>
                        b = NULL;
    80001b28:	00098a13          	mv	s4,s3
    80001b2c:	0140006f          	j	80001b40 <handleblocked+0xa8>
                    }
                } else {
                    if (b == blend) {
                        blend = prev;
    80001b30:	00005797          	auipc	a5,0x5
    80001b34:	0537b423          	sd	s3,72(a5) # 80006b78 <blend>
                        blend->next=NULL;
    80001b38:	0009b823          	sd	zero,16(s3)
                        b = NULL;
    80001b3c:	00090a13          	mv	s4,s2
                    } else {
                        prev->next = b->next;
                        b = b->next;
                    }
                }
                thread_t data = tmp->data;
    80001b40:	0004b503          	ld	a0,0(s1)
                data->state = READY;
    80001b44:	00100793          	li	a5,1
    80001b48:	00f52c23          	sw	a5,24(a0)
                sc_put(data);
    80001b4c:	00001097          	auipc	ra,0x1
    80001b50:	058080e7          	jalr	88(ra) # 80002ba4 <sc_put>
                __mem_free(tmp);
    80001b54:	00048513          	mv	a0,s1
    80001b58:	00001097          	auipc	ra,0x1
    80001b5c:	d60080e7          	jalr	-672(ra) # 800028b8 <__mem_free>
    80001b60:	000a0493          	mv	s1,s4
        while (b) {
    80001b64:	02048c63          	beqz	s1,80001b9c <handleblocked+0x104>
            if (b->time == 0) {
    80001b68:	0084b783          	ld	a5,8(s1)
    80001b6c:	02079263          	bnez	a5,80001b90 <handleblocked+0xf8>
                if (prev == NULL) {
    80001b70:	f80980e3          	beqz	s3,80001af0 <handleblocked+0x58>
                    if (b == blend) {
    80001b74:	00005797          	auipc	a5,0x5
    80001b78:	0047b783          	ld	a5,4(a5) # 80006b78 <blend>
    80001b7c:	fa978ae3          	beq	a5,s1,80001b30 <handleblocked+0x98>
                        prev->next = b->next;
    80001b80:	0104b783          	ld	a5,16(s1)
    80001b84:	00f9b823          	sd	a5,16(s3)
                        b = b->next;
    80001b88:	0104ba03          	ld	s4,16(s1)
    80001b8c:	fb5ff06f          	j	80001b40 <handleblocked+0xa8>
            } else {
                prev = b;
    80001b90:	00048993          	mv	s3,s1
                b = b->next;
    80001b94:	0104b483          	ld	s1,16(s1)
    80001b98:	fcdff06f          	j	80001b64 <handleblocked+0xcc>
            }
        }

    }

}
    80001b9c:	02813083          	ld	ra,40(sp)
    80001ba0:	02013403          	ld	s0,32(sp)
    80001ba4:	01813483          	ld	s1,24(sp)
    80001ba8:	01013903          	ld	s2,16(sp)
    80001bac:	00813983          	ld	s3,8(sp)
    80001bb0:	00013a03          	ld	s4,0(sp)
    80001bb4:	03010113          	addi	sp,sp,48
    80001bb8:	00008067          	ret

0000000080001bbc <printc>:
void printc(char c){
    80001bbc:	ff010113          	addi	sp,sp,-16
    80001bc0:	00813423          	sd	s0,8(sp)
    80001bc4:	01010413          	addi	s0,sp,16

    uint8 status = *(uint8*)CONSOLE_STATUS;
    80001bc8:	00004797          	auipc	a5,0x4
    80001bcc:	4487b783          	ld	a5,1096(a5) # 80006010 <CONSOLE_STATUS>
    80001bd0:	0007c783          	lbu	a5,0(a5)
    if ((status & CONSOLE_TX_STATUS_BIT)) {
    80001bd4:	0207f793          	andi	a5,a5,32
    80001bd8:	00078863          	beqz	a5,80001be8 <printc+0x2c>

        //char c = get_uart2();
        *((char *) (CONSOLE_TX_DATA)) = c;
    80001bdc:	00004797          	auipc	a5,0x4
    80001be0:	42c7b783          	ld	a5,1068(a5) # 80006008 <CONSOLE_TX_DATA>
    80001be4:	00a78023          	sb	a0,0(a5)
        status = *(uint8*)CONSOLE_STATUS;
    }

}
    80001be8:	00813403          	ld	s0,8(sp)
    80001bec:	01010113          	addi	sp,sp,16
    80001bf0:	00008067          	ret

0000000080001bf4 <puthexdigit1>:
void puthexdigit1(int a) {
    80001bf4:	ff010113          	addi	sp,sp,-16
    80001bf8:	00113423          	sd	ra,8(sp)
    80001bfc:	00813023          	sd	s0,0(sp)
    80001c00:	01010413          	addi	s0,sp,16
    if (a > 9)
    80001c04:	00900793          	li	a5,9
    80001c08:	02a7d263          	bge	a5,a0,80001c2c <puthexdigit1+0x38>
        printc('a'+ a - 10);
    80001c0c:	0575051b          	addiw	a0,a0,87
    80001c10:	0ff57513          	andi	a0,a0,255
    80001c14:	00000097          	auipc	ra,0x0
    80001c18:	fa8080e7          	jalr	-88(ra) # 80001bbc <printc>
    else
        printc('0'+ a);

}
    80001c1c:	00813083          	ld	ra,8(sp)
    80001c20:	00013403          	ld	s0,0(sp)
    80001c24:	01010113          	addi	sp,sp,16
    80001c28:	00008067          	ret
        printc('0'+ a);
    80001c2c:	0305051b          	addiw	a0,a0,48
    80001c30:	0ff57513          	andi	a0,a0,255
    80001c34:	00000097          	auipc	ra,0x0
    80001c38:	f88080e7          	jalr	-120(ra) # 80001bbc <printc>
}
    80001c3c:	fe1ff06f          	j	80001c1c <puthexdigit1+0x28>

0000000080001c40 <printaddr1>:
void printaddr1(uintptr a) {
    80001c40:	fd010113          	addi	sp,sp,-48
    80001c44:	02113423          	sd	ra,40(sp)
    80001c48:	02813023          	sd	s0,32(sp)
    80001c4c:	00913c23          	sd	s1,24(sp)
    80001c50:	01213823          	sd	s2,16(sp)
    80001c54:	01313423          	sd	s3,8(sp)
    80001c58:	03010413          	addi	s0,sp,48
    80001c5c:	00050993          	mv	s3,a0
    for (int i = 7; i >= 0; i--) {
    80001c60:	00700913          	li	s2,7
    80001c64:	0300006f          	j	80001c94 <printaddr1+0x54>
        int bajt = (a >> (i*8)) & 0xff;
    80001c68:	0039179b          	slliw	a5,s2,0x3
    80001c6c:	00f9d7b3          	srl	a5,s3,a5
    80001c70:	0ff7f513          	andi	a0,a5,255
        int hi = bajt >> 4;
        int lo = bajt & 0xf;
    80001c74:	00f7f493          	andi	s1,a5,15
        puthexdigit1(hi);
    80001c78:	00455513          	srli	a0,a0,0x4
    80001c7c:	00000097          	auipc	ra,0x0
    80001c80:	f78080e7          	jalr	-136(ra) # 80001bf4 <puthexdigit1>
        puthexdigit1(lo);
    80001c84:	00048513          	mv	a0,s1
    80001c88:	00000097          	auipc	ra,0x0
    80001c8c:	f6c080e7          	jalr	-148(ra) # 80001bf4 <puthexdigit1>
    for (int i = 7; i >= 0; i--) {
    80001c90:	fff9091b          	addiw	s2,s2,-1
    80001c94:	fc095ae3          	bgez	s2,80001c68 <printaddr1+0x28>
    }
}
    80001c98:	02813083          	ld	ra,40(sp)
    80001c9c:	02013403          	ld	s0,32(sp)
    80001ca0:	01813483          	ld	s1,24(sp)
    80001ca4:	01013903          	ld	s2,16(sp)
    80001ca8:	00813983          	ld	s3,8(sp)
    80001cac:	03010113          	addi	sp,sp,48
    80001cb0:	00008067          	ret

0000000080001cb4 <handleSupervisorTrap>:
extern sem_t ioSemEmpty1;
uint64 handleSupervisorTrap(args* arg) {
    80001cb4:	f8010113          	addi	sp,sp,-128
    80001cb8:	06113c23          	sd	ra,120(sp)
    80001cbc:	06813823          	sd	s0,112(sp)
    80001cc0:	06913423          	sd	s1,104(sp)
    80001cc4:	07213023          	sd	s2,96(sp)
    80001cc8:	05313c23          	sd	s3,88(sp)
    80001ccc:	08010413          	addi	s0,sp,128
    80001cd0:	00050913          	mv	s2,a0
    //putc1('p');
    uint64 scause;
    __asm__ volatile ("csrr %[scause], scause" : [scause] "=r"(scause));
    80001cd4:	142024f3          	csrr	s1,scause
    if (scause == 0x0000000000000008UL || scause == 0x0000000000000009UL) {
    80001cd8:	ff848713          	addi	a4,s1,-8
    80001cdc:	00100793          	li	a5,1
    80001ce0:	0ce7fe63          	bgeu	a5,a4,80001dbc <handleSupervisorTrap+0x108>

        w_sstatus(sstatus);
        w_sepc(sepc);

        return ret;
    } else if (scause == 0x8000000000000001UL) {
    80001ce4:	fff00793          	li	a5,-1
    80001ce8:	03f79793          	slli	a5,a5,0x3f
    80001cec:	00178793          	addi	a5,a5,1
    80001cf0:	22f48a63          	beq	s1,a5,80001f24 <handleSupervisorTrap+0x270>

        }
        mc_sip(SIP_SSIP);
        return arg->a0;

    } else if (scause == 0x8000000000000009UL) {
    80001cf4:	fff00793          	li	a5,-1
    80001cf8:	03f79793          	slli	a5,a5,0x3f
    80001cfc:	00978793          	addi	a5,a5,9
    80001d00:	2af48263          	beq	s1,a5,80001fa4 <handleSupervisorTrap+0x2f0>
    __asm__ volatile ("csrr %[sepc], sepc" : [sepc] "=r"(sepc));
    80001d04:	141027f3          	csrr	a5,sepc
    80001d08:	fcf43423          	sd	a5,-56(s0)
    return sepc;
    80001d0c:	fc843783          	ld	a5,-56(s0)

        return 0;
    } else {

        // unexpected trap cause
        uint64 volatile sepc = r_sepc();
    80001d10:	fcf43023          	sd	a5,-64(s0)
        uint64 ra,sp;
        __asm__ volatile ("mv %0, ra" : "=r"(ra));
    80001d14:	00008793          	mv	a5,ra
        __asm__ volatile ("mv %0, sp" : "=r"(sp));
    80001d18:	00010993          	mv	s3,sp
        printc('\n');
    80001d1c:	00a00513          	li	a0,10
    80001d20:	00000097          	auipc	ra,0x0
    80001d24:	e9c080e7          	jalr	-356(ra) # 80001bbc <printc>
        printaddr1(scause);
    80001d28:	00048513          	mv	a0,s1
    80001d2c:	00000097          	auipc	ra,0x0
    80001d30:	f14080e7          	jalr	-236(ra) # 80001c40 <printaddr1>
        printc('\n');
    80001d34:	00a00513          	li	a0,10
    80001d38:	00000097          	auipc	ra,0x0
    80001d3c:	e84080e7          	jalr	-380(ra) # 80001bbc <printc>
        printaddr1(sepc);
    80001d40:	fc043503          	ld	a0,-64(s0)
    80001d44:	00000097          	auipc	ra,0x0
    80001d48:	efc080e7          	jalr	-260(ra) # 80001c40 <printaddr1>
        printc('\n');
    80001d4c:	00a00513          	li	a0,10
    80001d50:	00000097          	auipc	ra,0x0
    80001d54:	e6c080e7          	jalr	-404(ra) # 80001bbc <printc>
        printaddr1(sp);
    80001d58:	00098513          	mv	a0,s3
    80001d5c:	00000097          	auipc	ra,0x0
    80001d60:	ee4080e7          	jalr	-284(ra) # 80001c40 <printaddr1>
        printc('\n');
    80001d64:	00a00513          	li	a0,10
    80001d68:	00000097          	auipc	ra,0x0
    80001d6c:	e54080e7          	jalr	-428(ra) # 80001bbc <printc>
        printaddr1(arg->a0);
    80001d70:	00093503          	ld	a0,0(s2)
    80001d74:	00000097          	auipc	ra,0x0
    80001d78:	ecc080e7          	jalr	-308(ra) # 80001c40 <printaddr1>
        printc('\n');
    80001d7c:	00a00513          	li	a0,10
    80001d80:	00000097          	auipc	ra,0x0
    80001d84:	e3c080e7          	jalr	-452(ra) # 80001bbc <printc>
        printaddr1((uintptr)arg);
    80001d88:	00090513          	mv	a0,s2
    80001d8c:	00000097          	auipc	ra,0x0
    80001d90:	eb4080e7          	jalr	-332(ra) # 80001c40 <printaddr1>
        printc('\n');
    80001d94:	00a00513          	li	a0,10
    80001d98:	00000097          	auipc	ra,0x0
    80001d9c:	e24080e7          	jalr	-476(ra) # 80001bbc <printc>
        printaddr1(running->context->ra);
    80001da0:	00005797          	auipc	a5,0x5
    80001da4:	d687b783          	ld	a5,-664(a5) # 80006b08 <running>
    80001da8:	0087b783          	ld	a5,8(a5)
    80001dac:	0007b503          	ld	a0,0(a5)
    80001db0:	00000097          	auipc	ra,0x0
    80001db4:	e90080e7          	jalr	-368(ra) # 80001c40 <printaddr1>

        for(;;);
    80001db8:	0000006f          	j	80001db8 <handleSupervisorTrap+0x104>
    __asm__ volatile ("csrr %[sepc], sepc" : [sepc] "=r"(sepc));
    80001dbc:	141027f3          	csrr	a5,sepc
    80001dc0:	faf43c23          	sd	a5,-72(s0)
    return sepc;
    80001dc4:	fb843783          	ld	a5,-72(s0)
         uint64 volatile sepc = r_sepc() + 4;
    80001dc8:	00478793          	addi	a5,a5,4
    80001dcc:	f8f43823          	sd	a5,-112(s0)
    __asm__ volatile ("csrr %[sstatus], sstatus" : [sstatus] "=r"(sstatus));
    80001dd0:	100027f3          	csrr	a5,sstatus
    80001dd4:	faf43823          	sd	a5,-80(s0)
    return sstatus;
    80001dd8:	fb043783          	ld	a5,-80(s0)
         uint64  volatile sstatus = r_sstatus();
    80001ddc:	f8f43c23          	sd	a5,-104(s0)
        uint64 ret = arg->a0;
    80001de0:	00053483          	ld	s1,0(a0)
        switch (arg->a0) {
    80001de4:	04200793          	li	a5,66
    80001de8:	0297e863          	bltu	a5,s1,80001e18 <handleSupervisorTrap+0x164>
    80001dec:	00249793          	slli	a5,s1,0x2
    80001df0:	00004717          	auipc	a4,0x4
    80001df4:	23070713          	addi	a4,a4,560 # 80006020 <CONSOLE_STATUS+0x10>
    80001df8:	00e787b3          	add	a5,a5,a4
    80001dfc:	0007a783          	lw	a5,0(a5)
    80001e00:	00e787b3          	add	a5,a5,a4
    80001e04:	00078067          	jr	a5
                ret = (uintptr)__mem_alloc(velicina);
    80001e08:	00853503          	ld	a0,8(a0)
    80001e0c:	00001097          	auipc	ra,0x1
    80001e10:	94c080e7          	jalr	-1716(ra) # 80002758 <__mem_alloc>
    80001e14:	00050493          	mv	s1,a0
        w_sstatus(sstatus);
    80001e18:	f9843783          	ld	a5,-104(s0)
    __asm__ volatile ("csrw sstatus, %[sstatus]" : : [sstatus] "r"(sstatus));
    80001e1c:	10079073          	csrw	sstatus,a5
        w_sepc(sepc);
    80001e20:	f9043783          	ld	a5,-112(s0)
    __asm__ volatile ("csrw sepc, %[sepc]" : : [sepc] "r"(sepc));
    80001e24:	14179073          	csrw	sepc,a5

    }
    return arg->a0;


}
    80001e28:	00048513          	mv	a0,s1
    80001e2c:	07813083          	ld	ra,120(sp)
    80001e30:	07013403          	ld	s0,112(sp)
    80001e34:	06813483          	ld	s1,104(sp)
    80001e38:	06013903          	ld	s2,96(sp)
    80001e3c:	05813983          	ld	s3,88(sp)
    80001e40:	08010113          	addi	sp,sp,128
    80001e44:	00008067          	ret
                ret = (uintptr)__mem_free(chunk);
    80001e48:	00853503          	ld	a0,8(a0)
    80001e4c:	00001097          	auipc	ra,0x1
    80001e50:	a6c080e7          	jalr	-1428(ra) # 800028b8 <__mem_free>
    80001e54:	00050493          	mv	s1,a0
                break;
    80001e58:	fc1ff06f          	j	80001e18 <handleSupervisorTrap+0x164>
                ret= __thread_create(thr,pfunct,arg1);
    80001e5c:	01853603          	ld	a2,24(a0)
    80001e60:	01053583          	ld	a1,16(a0)
    80001e64:	00853503          	ld	a0,8(a0)
    80001e68:	fffff097          	auipc	ra,0xfffff
    80001e6c:	388080e7          	jalr	904(ra) # 800011f0 <__thread_create>
    80001e70:	00050493          	mv	s1,a0
                break;
    80001e74:	fa5ff06f          	j	80001e18 <handleSupervisorTrap+0x164>
              ret =  __thread_exit();
    80001e78:	fffff097          	auipc	ra,0xfffff
    80001e7c:	6fc080e7          	jalr	1788(ra) # 80001574 <__thread_exit>
    80001e80:	00050493          	mv	s1,a0
              break;
    80001e84:	f95ff06f          	j	80001e18 <handleSupervisorTrap+0x164>
                timeSliceCounter = 0;
    80001e88:	00005797          	auipc	a5,0x5
    80001e8c:	c607b023          	sd	zero,-928(a5) # 80006ae8 <timeSliceCounter>
                __thread_dispatch();
    80001e90:	fffff097          	auipc	ra,0xfffff
    80001e94:	59c080e7          	jalr	1436(ra) # 8000142c <__thread_dispatch>
                break;
    80001e98:	f81ff06f          	j	80001e18 <handleSupervisorTrap+0x164>
                ret=__sem_open((sem_t*)arg->a1,(unsigned)arg->a2);
    80001e9c:	01052583          	lw	a1,16(a0)
    80001ea0:	00853503          	ld	a0,8(a0)
    80001ea4:	fffff097          	auipc	ra,0xfffff
    80001ea8:	71c080e7          	jalr	1820(ra) # 800015c0 <__sem_open>
    80001eac:	00050493          	mv	s1,a0
                break;
    80001eb0:	f69ff06f          	j	80001e18 <handleSupervisorTrap+0x164>
                ret=__sem_close((sem_t)arg->a1);
    80001eb4:	00853503          	ld	a0,8(a0)
    80001eb8:	fffff097          	auipc	ra,0xfffff
    80001ebc:	774080e7          	jalr	1908(ra) # 8000162c <__sem_close>
    80001ec0:	00050493          	mv	s1,a0
                break;
    80001ec4:	f55ff06f          	j	80001e18 <handleSupervisorTrap+0x164>
                ret=__sem_wait((sem_t)arg->a1);
    80001ec8:	00853503          	ld	a0,8(a0)
    80001ecc:	fffff097          	auipc	ra,0xfffff
    80001ed0:	7ec080e7          	jalr	2028(ra) # 800016b8 <__sem_wait>
    80001ed4:	00050493          	mv	s1,a0
                break;
    80001ed8:	f41ff06f          	j	80001e18 <handleSupervisorTrap+0x164>
                ret=__sem_signal((sem_t)arg->a1);
    80001edc:	00853503          	ld	a0,8(a0)
    80001ee0:	00000097          	auipc	ra,0x0
    80001ee4:	854080e7          	jalr	-1964(ra) # 80001734 <__sem_signal>
    80001ee8:	00050493          	mv	s1,a0
                break;
    80001eec:	f2dff06f          	j	80001e18 <handleSupervisorTrap+0x164>
                ret=__time_sleep((time_t)arg->a1);
    80001ef0:	00853503          	ld	a0,8(a0)
    80001ef4:	00000097          	auipc	ra,0x0
    80001ef8:	b28080e7          	jalr	-1240(ra) # 80001a1c <__time_sleep>
    80001efc:	00050493          	mv	s1,a0
                break;
    80001f00:	f19ff06f          	j	80001e18 <handleSupervisorTrap+0x164>
                 putc1((char)arg->a1);
    80001f04:	00854503          	lbu	a0,8(a0)
    80001f08:	00000097          	auipc	ra,0x0
    80001f0c:	9ec080e7          	jalr	-1556(ra) # 800018f4 <putc1>
                 break;
    80001f10:	f09ff06f          	j	80001e18 <handleSupervisorTrap+0x164>
                ret=getc1();
    80001f14:	00000097          	auipc	ra,0x0
    80001f18:	9b8080e7          	jalr	-1608(ra) # 800018cc <getc1>
    80001f1c:	00050493          	mv	s1,a0
                break;
    80001f20:	ef9ff06f          	j	80001e18 <handleSupervisorTrap+0x164>
        handleblocked();
    80001f24:	00000097          	auipc	ra,0x0
    80001f28:	b74080e7          	jalr	-1164(ra) # 80001a98 <handleblocked>
        timeSliceCounter++;
    80001f2c:	00005717          	auipc	a4,0x5
    80001f30:	bbc70713          	addi	a4,a4,-1092 # 80006ae8 <timeSliceCounter>
    80001f34:	00073783          	ld	a5,0(a4)
    80001f38:	00178793          	addi	a5,a5,1
    80001f3c:	00f73023          	sd	a5,0(a4)
       if (timeSliceCounter >= running->timeslice)
    80001f40:	00005717          	auipc	a4,0x5
    80001f44:	bc873703          	ld	a4,-1080(a4) # 80006b08 <running>
    80001f48:	03073703          	ld	a4,48(a4)
    80001f4c:	00e7fa63          	bgeu	a5,a4,80001f60 <handleSupervisorTrap+0x2ac>
    __asm__ volatile ("csrc sip, %[mask]" : : [mask] "r"(mask));
    80001f50:	00200793          	li	a5,2
    80001f54:	1447b073          	csrc	sip,a5
        return arg->a0;
    80001f58:	00093483          	ld	s1,0(s2)
    80001f5c:	ecdff06f          	j	80001e28 <handleSupervisorTrap+0x174>
    __asm__ volatile ("csrr %[sepc], sepc" : [sepc] "=r"(sepc));
    80001f60:	141027f3          	csrr	a5,sepc
    80001f64:	fcf43423          	sd	a5,-56(s0)
    return sepc;
    80001f68:	fc843783          	ld	a5,-56(s0)
            uint64 volatile sepc = r_sepc();
    80001f6c:	faf43023          	sd	a5,-96(s0)
    __asm__ volatile ("csrr %[sstatus], sstatus" : [sstatus] "=r"(sstatus));
    80001f70:	100027f3          	csrr	a5,sstatus
    80001f74:	fcf43023          	sd	a5,-64(s0)
    return sstatus;
    80001f78:	fc043783          	ld	a5,-64(s0)
            uint64 volatile sstatus = r_sstatus();
    80001f7c:	faf43423          	sd	a5,-88(s0)
            timeSliceCounter = 0;
    80001f80:	00005797          	auipc	a5,0x5
    80001f84:	b607b423          	sd	zero,-1176(a5) # 80006ae8 <timeSliceCounter>
            __thread_dispatch();
    80001f88:	fffff097          	auipc	ra,0xfffff
    80001f8c:	4a4080e7          	jalr	1188(ra) # 8000142c <__thread_dispatch>
            w_sstatus(sstatus);
    80001f90:	fa843783          	ld	a5,-88(s0)
    __asm__ volatile ("csrw sstatus, %[sstatus]" : : [sstatus] "r"(sstatus));
    80001f94:	10079073          	csrw	sstatus,a5
            w_sepc(sepc);
    80001f98:	fa043783          	ld	a5,-96(s0)
    __asm__ volatile ("csrw sepc, %[sepc]" : : [sepc] "r"(sepc));
    80001f9c:	14179073          	csrw	sepc,a5
}
    80001fa0:	fb1ff06f          	j	80001f50 <handleSupervisorTrap+0x29c>
        int volatile irq = plic_claim();
    80001fa4:	00002097          	auipc	ra,0x2
    80001fa8:	180080e7          	jalr	384(ra) # 80004124 <plic_claim>
    80001fac:	f8a42623          	sw	a0,-116(s0)
        if(irq==CONSOLE_IRQ){
    80001fb0:	f8c42783          	lw	a5,-116(s0)
    80001fb4:	0007879b          	sext.w	a5,a5
    80001fb8:	00a00713          	li	a4,10
    80001fbc:	00e78e63          	beq	a5,a4,80001fd8 <handleSupervisorTrap+0x324>
        plic_complete(irq);
    80001fc0:	f8c42503          	lw	a0,-116(s0)
    80001fc4:	0005051b          	sext.w	a0,a0
    80001fc8:	00002097          	auipc	ra,0x2
    80001fcc:	194080e7          	jalr	404(ra) # 8000415c <plic_complete>
        return 0;
    80001fd0:	00000493          	li	s1,0
    80001fd4:	e55ff06f          	j	80001e28 <handleSupervisorTrap+0x174>
           volatile uint8 status = *(uint8*)CONSOLE_STATUS;
    80001fd8:	00004497          	auipc	s1,0x4
    80001fdc:	0384b483          	ld	s1,56(s1) # 80006010 <CONSOLE_STATUS>
    80001fe0:	0004c783          	lbu	a5,0(s1)
    80001fe4:	f8f40523          	sb	a5,-118(s0)
            while (status & CONSOLE_RX_STATUS_BIT){
    80001fe8:	0240006f          	j	8000200c <handleSupervisorTrap+0x358>
                    put_uart1(c);
    80001fec:	f8b44503          	lbu	a0,-117(s0)
    80001ff0:	0ff57513          	andi	a0,a0,255
    80001ff4:	00000097          	auipc	ra,0x0
    80001ff8:	2b4080e7          	jalr	692(ra) # 800022a8 <put_uart1>
                    __sem_signal(ioSemEmpty1);
    80001ffc:	00005517          	auipc	a0,0x5
    80002000:	b1453503          	ld	a0,-1260(a0) # 80006b10 <ioSemEmpty1>
    80002004:	fffff097          	auipc	ra,0xfffff
    80002008:	730080e7          	jalr	1840(ra) # 80001734 <__sem_signal>
            while (status & CONSOLE_RX_STATUS_BIT){
    8000200c:	f8a44783          	lbu	a5,-118(s0)
    80002010:	0017f793          	andi	a5,a5,1
    80002014:	fa0786e3          	beqz	a5,80001fc0 <handleSupervisorTrap+0x30c>
                volatile char c=*((char*)CONSOLE_RX_DATA);
    80002018:	00004797          	auipc	a5,0x4
    8000201c:	fe87b783          	ld	a5,-24(a5) # 80006000 <CONSOLE_RX_DATA>
    80002020:	0007c783          	lbu	a5,0(a5)
    80002024:	f8f405a3          	sb	a5,-117(s0)
                status=*(uint8*)CONSOLE_STATUS;
    80002028:	0004c783          	lbu	a5,0(s1)
    8000202c:	f8f40523          	sb	a5,-118(s0)
                if(c=='\r') c='\n';
    80002030:	f8b44783          	lbu	a5,-117(s0)
    80002034:	0ff7f793          	andi	a5,a5,255
    80002038:	00d00713          	li	a4,13
    8000203c:	fae798e3          	bne	a5,a4,80001fec <handleSupervisorTrap+0x338>
    80002040:	00a00793          	li	a5,10
    80002044:	f8f405a3          	sb	a5,-117(s0)
    80002048:	fa5ff06f          	j	80001fec <handleSupervisorTrap+0x338>

000000008000204c <semTest>:

uint64 supervisorTrap();
sem_t sem1;
void semTest(){
    8000204c:	fe010113          	addi	sp,sp,-32
    80002050:	00113c23          	sd	ra,24(sp)
    80002054:	00813823          	sd	s0,16(sp)
    80002058:	00913423          	sd	s1,8(sp)
    8000205c:	02010413          	addi	s0,sp,32

    //sem_open(&sem1,0);
    for(int i = 0;i<3;i++){
    80002060:	00000493          	li	s1,0
    80002064:	0180006f          	j	8000207c <semTest+0x30>
        sem_wait(sem1);
    80002068:	00005517          	auipc	a0,0x5
    8000206c:	a5853503          	ld	a0,-1448(a0) # 80006ac0 <sem1>
    80002070:	00001097          	auipc	ra,0x1
    80002074:	9e4080e7          	jalr	-1564(ra) # 80002a54 <sem_wait>
    for(int i = 0;i<3;i++){
    80002078:	0014849b          	addiw	s1,s1,1
    8000207c:	00200793          	li	a5,2
    80002080:	fe97d4e3          	bge	a5,s1,80002068 <semTest+0x1c>
    }
}
    80002084:	01813083          	ld	ra,24(sp)
    80002088:	01013403          	ld	s0,16(sp)
    8000208c:	00813483          	ld	s1,8(sp)
    80002090:	02010113          	addi	sp,sp,32
    80002094:	00008067          	ret

0000000080002098 <main>:

extern int sc_in(uint64 thr);
extern void userMain();
int main(){
    80002098:	fe010113          	addi	sp,sp,-32
    8000209c:	00113c23          	sd	ra,24(sp)
    800020a0:	00813823          	sd	s0,16(sp)
    800020a4:	02010413          	addi	s0,sp,32
    __asm__ volatile ("csrc sip, %[mask]" : : [mask] "r"(mask));
    800020a8:	00200793          	li	a5,2
    800020ac:	1447b073          	csrc	sip,a5

      mc_sip(SIP_SSIP);
      initmem();
    800020b0:	00000097          	auipc	ra,0x0
    800020b4:	5f4080e7          	jalr	1524(ra) # 800026a4 <initmem>
      initBuffers();
    800020b8:	00000097          	auipc	ra,0x0
    800020bc:	160080e7          	jalr	352(ra) # 80002218 <initBuffers>
      int ret;
      thread_t uthr;
      ret=__thread_create(&uthr,&userMain,NULL);
    800020c0:	00000613          	li	a2,0
    800020c4:	00001597          	auipc	a1,0x1
    800020c8:	0a058593          	addi	a1,a1,160 # 80003164 <userMain>
    800020cc:	fe840513          	addi	a0,s0,-24
    800020d0:	fffff097          	auipc	ra,0xfffff
    800020d4:	120080e7          	jalr	288(ra) # 800011f0 <__thread_create>
      if(ret==-1){
    800020d8:	fff00793          	li	a5,-1
    800020dc:	12f50663          	beq	a0,a5,80002208 <main+0x170>
        // putc('G');
        return -1;
      }
      ret=__thread_create(&consolethr,&console_putc,NULL);
    800020e0:	00000613          	li	a2,0
    800020e4:	fffff597          	auipc	a1,0xfffff
    800020e8:	6b458593          	addi	a1,a1,1716 # 80001798 <console_putc>
    800020ec:	00005517          	auipc	a0,0x5
    800020f0:	a0450513          	addi	a0,a0,-1532 # 80006af0 <consolethr>
    800020f4:	fffff097          	auipc	ra,0xfffff
    800020f8:	0fc080e7          	jalr	252(ra) # 800011f0 <__thread_create>
      if(ret==-1){
    800020fc:	fff00793          	li	a5,-1
    80002100:	10f50463          	beq	a0,a5,80002208 <main+0x170>
        //__putc('G');
        return -1;
      }
      ret=__thread_create(NULL,NULL,NULL);
    80002104:	00000613          	li	a2,0
    80002108:	00000593          	li	a1,0
    8000210c:	00000513          	li	a0,0
    80002110:	fffff097          	auipc	ra,0xfffff
    80002114:	0e0080e7          	jalr	224(ra) # 800011f0 <__thread_create>
      if(ret==-1) {
    80002118:	fff00793          	li	a5,-1
    8000211c:	0ef50663          	beq	a0,a5,80002208 <main+0x170>
         // __putc('G');
          return -1;
      }
      running=mainthr;
    80002120:	00005797          	auipc	a5,0x5
    80002124:	9d87b783          	ld	a5,-1576(a5) # 80006af8 <mainthr>
    80002128:	00005717          	auipc	a4,0x5
    8000212c:	9ef73023          	sd	a5,-1568(a4) # 80006b08 <running>
      ret=__thread_create(&idle,&idle_funct,NULL);
    80002130:	00000613          	li	a2,0
    80002134:	fffff597          	auipc	a1,0xfffff
    80002138:	03058593          	addi	a1,a1,48 # 80001164 <idle_funct>
    8000213c:	00005517          	auipc	a0,0x5
    80002140:	9c450513          	addi	a0,a0,-1596 # 80006b00 <idle>
    80002144:	fffff097          	auipc	ra,0xfffff
    80002148:	0ac080e7          	jalr	172(ra) # 800011f0 <__thread_create>
      if(ret==-1){
    8000214c:	fff00793          	li	a5,-1
    80002150:	0af50c63          	beq	a0,a5,80002208 <main+0x170>
         // __putc('G');
          return -1;
      }

        __sem_open(&ioSem,0);
    80002154:	00000593          	li	a1,0
    80002158:	00005517          	auipc	a0,0x5
    8000215c:	98850513          	addi	a0,a0,-1656 # 80006ae0 <ioSem>
    80002160:	fffff097          	auipc	ra,0xfffff
    80002164:	460080e7          	jalr	1120(ra) # 800015c0 <__sem_open>
        __sem_open(&fullPutc,900000);
    80002168:	000dc5b7          	lui	a1,0xdc
    8000216c:	ba058593          	addi	a1,a1,-1120 # dbba0 <_entry-0x7ff24460>
    80002170:	00005517          	auipc	a0,0x5
    80002174:	96850513          	addi	a0,a0,-1688 # 80006ad8 <fullPutc>
    80002178:	fffff097          	auipc	ra,0xfffff
    8000217c:	448080e7          	jalr	1096(ra) # 800015c0 <__sem_open>
        __sem_open(&sem1,0);
    80002180:	00000593          	li	a1,0
    80002184:	00005517          	auipc	a0,0x5
    80002188:	93c50513          	addi	a0,a0,-1732 # 80006ac0 <sem1>
    8000218c:	fffff097          	auipc	ra,0xfffff
    80002190:	434080e7          	jalr	1076(ra) # 800015c0 <__sem_open>
        w_stvec((uintptr)supervisorTrap);
    80002194:	fffff797          	auipc	a5,0xfffff
    80002198:	e8c78793          	addi	a5,a5,-372 # 80001020 <supervisorTrap>
    __asm__ volatile ("csrw stvec, %[stvec]" : : [stvec] "r"(stvec));
    8000219c:	10579073          	csrw	stvec,a5
    __asm__ volatile ("csrs sstatus, %[mask]" : : [mask] "r"(mask));
    800021a0:	00200793          	li	a5,2
    800021a4:	1007a073          	csrs	sstatus,a5
        ms_sstatus(SSTATUS_SIE);

       __thread_dispatch();
    800021a8:	fffff097          	auipc	ra,0xfffff
    800021ac:	284080e7          	jalr	644(ra) # 8000142c <__thread_dispatch>
        while (uthr->state!=DEAD){
    800021b0:	01c0006f          	j	800021cc <main+0x134>
        //ms_sstatus(SSTATUS_SIE);
            __sem_signal(sem1);
    800021b4:	00005517          	auipc	a0,0x5
    800021b8:	90c53503          	ld	a0,-1780(a0) # 80006ac0 <sem1>
    800021bc:	fffff097          	auipc	ra,0xfffff
    800021c0:	578080e7          	jalr	1400(ra) # 80001734 <__sem_signal>
            __thread_dispatch();
    800021c4:	fffff097          	auipc	ra,0xfffff
    800021c8:	268080e7          	jalr	616(ra) # 8000142c <__thread_dispatch>
        while (uthr->state!=DEAD){
    800021cc:	fe843783          	ld	a5,-24(s0)
    800021d0:	0187a703          	lw	a4,24(a5)
    800021d4:	00500793          	li	a5,5
    800021d8:	fcf71ee3          	bne	a4,a5,800021b4 <main+0x11c>
    800021dc:	01c0006f          	j	800021f8 <main+0x160>

        }

    while(!isEmpty2()){
        __sem_signal(ioSem);
    800021e0:	00005517          	auipc	a0,0x5
    800021e4:	90053503          	ld	a0,-1792(a0) # 80006ae0 <ioSem>
    800021e8:	fffff097          	auipc	ra,0xfffff
    800021ec:	54c080e7          	jalr	1356(ra) # 80001734 <__sem_signal>

        __thread_dispatch();
    800021f0:	fffff097          	auipc	ra,0xfffff
    800021f4:	23c080e7          	jalr	572(ra) # 8000142c <__thread_dispatch>
    while(!isEmpty2()){
    800021f8:	00000097          	auipc	ra,0x0
    800021fc:	35c080e7          	jalr	860(ra) # 80002554 <isEmpty2>
    80002200:	fe0500e3          	beqz	a0,800021e0 <main+0x148>
    }


 return 0;
    80002204:	00000513          	li	a0,0
}
    80002208:	01813083          	ld	ra,24(sp)
    8000220c:	01013403          	ld	s0,16(sp)
    80002210:	02010113          	addi	sp,sp,32
    80002214:	00008067          	ret

0000000080002218 <initBuffers>:
char* uartBuffer2;
volatile int bw1=0,br1=0;
volatile int bw2=0,br2=0;
sem_t mutex1,mutex2;
sem_t ioSemEmpty1;
void initBuffers(){
    80002218:	fe010113          	addi	sp,sp,-32
    8000221c:	00113c23          	sd	ra,24(sp)
    80002220:	00813823          	sd	s0,16(sp)
    80002224:	00913423          	sd	s1,8(sp)
    80002228:	02010413          	addi	s0,sp,32
    uartBuffer1= __mem_alloc(BUFFSIZE*sizeof (char));
    8000222c:	000dc4b7          	lui	s1,0xdc
    80002230:	ba048513          	addi	a0,s1,-1120 # dbba0 <_entry-0x7ff24460>
    80002234:	00000097          	auipc	ra,0x0
    80002238:	524080e7          	jalr	1316(ra) # 80002758 <__mem_alloc>
    8000223c:	00005797          	auipc	a5,0x5
    80002240:	90a7b223          	sd	a0,-1788(a5) # 80006b40 <uartBuffer1>
    uartBuffer2= __mem_alloc(BUFFSIZE*sizeof (char));
    80002244:	ba048513          	addi	a0,s1,-1120
    80002248:	00000097          	auipc	ra,0x0
    8000224c:	510080e7          	jalr	1296(ra) # 80002758 <__mem_alloc>
    80002250:	00005797          	auipc	a5,0x5
    80002254:	8ea7b423          	sd	a0,-1816(a5) # 80006b38 <uartBuffer2>
    __sem_open(&mutex1,1);
    80002258:	00100593          	li	a1,1
    8000225c:	00005517          	auipc	a0,0x5
    80002260:	8c450513          	addi	a0,a0,-1852 # 80006b20 <mutex1>
    80002264:	fffff097          	auipc	ra,0xfffff
    80002268:	35c080e7          	jalr	860(ra) # 800015c0 <__sem_open>
    __sem_open(&mutex2,1);
    8000226c:	00100593          	li	a1,1
    80002270:	00005517          	auipc	a0,0x5
    80002274:	8a850513          	addi	a0,a0,-1880 # 80006b18 <mutex2>
    80002278:	fffff097          	auipc	ra,0xfffff
    8000227c:	348080e7          	jalr	840(ra) # 800015c0 <__sem_open>
    __sem_open(&ioSemEmpty1,0);
    80002280:	00000593          	li	a1,0
    80002284:	00005517          	auipc	a0,0x5
    80002288:	88c50513          	addi	a0,a0,-1908 # 80006b10 <ioSemEmpty1>
    8000228c:	fffff097          	auipc	ra,0xfffff
    80002290:	334080e7          	jalr	820(ra) # 800015c0 <__sem_open>
}
    80002294:	01813083          	ld	ra,24(sp)
    80002298:	01013403          	ld	s0,16(sp)
    8000229c:	00813483          	ld	s1,8(sp)
    800022a0:	02010113          	addi	sp,sp,32
    800022a4:	00008067          	ret

00000000800022a8 <put_uart1>:
void put_uart1(char c){
    800022a8:	fe010113          	addi	sp,sp,-32
    800022ac:	00113c23          	sd	ra,24(sp)
    800022b0:	00813823          	sd	s0,16(sp)
    800022b4:	00913423          	sd	s1,8(sp)
    800022b8:	01213023          	sd	s2,0(sp)
    800022bc:	02010413          	addi	s0,sp,32
    800022c0:	00050493          	mv	s1,a0
    __sem_wait(mutex1);
    800022c4:	00005917          	auipc	s2,0x5
    800022c8:	85c90913          	addi	s2,s2,-1956 # 80006b20 <mutex1>
    800022cc:	00093503          	ld	a0,0(s2)
    800022d0:	fffff097          	auipc	ra,0xfffff
    800022d4:	3e8080e7          	jalr	1000(ra) # 800016b8 <__sem_wait>
    uartBuffer1[bw1++]=c;
    800022d8:	00005717          	auipc	a4,0x5
    800022dc:	85c70713          	addi	a4,a4,-1956 # 80006b34 <bw1>
    800022e0:	00072783          	lw	a5,0(a4)
    800022e4:	0007869b          	sext.w	a3,a5
    800022e8:	0017879b          	addiw	a5,a5,1
    800022ec:	00f72023          	sw	a5,0(a4)
    800022f0:	00005797          	auipc	a5,0x5
    800022f4:	8507b783          	ld	a5,-1968(a5) # 80006b40 <uartBuffer1>
    800022f8:	00d787b3          	add	a5,a5,a3
    800022fc:	00978023          	sb	s1,0(a5)

    __sem_signal(mutex1);
    80002300:	00093503          	ld	a0,0(s2)
    80002304:	fffff097          	auipc	ra,0xfffff
    80002308:	430080e7          	jalr	1072(ra) # 80001734 <__sem_signal>
}
    8000230c:	01813083          	ld	ra,24(sp)
    80002310:	01013403          	ld	s0,16(sp)
    80002314:	00813483          	ld	s1,8(sp)
    80002318:	00013903          	ld	s2,0(sp)
    8000231c:	02010113          	addi	sp,sp,32
    80002320:	00008067          	ret

0000000080002324 <get_uart1>:
char get_uart1(){
    80002324:	fe010113          	addi	sp,sp,-32
    80002328:	00113c23          	sd	ra,24(sp)
    8000232c:	00813823          	sd	s0,16(sp)
    80002330:	00913423          	sd	s1,8(sp)
    80002334:	02010413          	addi	s0,sp,32
    __sem_wait(mutex1);
    80002338:	00004517          	auipc	a0,0x4
    8000233c:	7e853503          	ld	a0,2024(a0) # 80006b20 <mutex1>
    80002340:	fffff097          	auipc	ra,0xfffff
    80002344:	378080e7          	jalr	888(ra) # 800016b8 <__sem_wait>
    if(br1==bw1){
    80002348:	00004717          	auipc	a4,0x4
    8000234c:	7e872703          	lw	a4,2024(a4) # 80006b30 <br1>
    80002350:	00004797          	auipc	a5,0x4
    80002354:	7e47a783          	lw	a5,2020(a5) # 80006b34 <bw1>
    80002358:	04f70263          	beq	a4,a5,8000239c <get_uart1+0x78>
        br1=0;bw1=0;
        __sem_signal(mutex1);
    }
    if(br1<bw1) {
    8000235c:	00004717          	auipc	a4,0x4
    80002360:	7d472703          	lw	a4,2004(a4) # 80006b30 <br1>
    80002364:	00004797          	auipc	a5,0x4
    80002368:	7d07a783          	lw	a5,2000(a5) # 80006b34 <bw1>
    8000236c:	04f74a63          	blt	a4,a5,800023c0 <get_uart1+0x9c>
        char c = uartBuffer1[br1++];
        __sem_signal(mutex1);
        return c;
    }
    __sem_signal(mutex1);
    80002370:	00004517          	auipc	a0,0x4
    80002374:	7b053503          	ld	a0,1968(a0) # 80006b20 <mutex1>
    80002378:	fffff097          	auipc	ra,0xfffff
    8000237c:	3bc080e7          	jalr	956(ra) # 80001734 <__sem_signal>
    return EOF;
    80002380:	0ff00493          	li	s1,255
}
    80002384:	00048513          	mv	a0,s1
    80002388:	01813083          	ld	ra,24(sp)
    8000238c:	01013403          	ld	s0,16(sp)
    80002390:	00813483          	ld	s1,8(sp)
    80002394:	02010113          	addi	sp,sp,32
    80002398:	00008067          	ret
        br1=0;bw1=0;
    8000239c:	00004797          	auipc	a5,0x4
    800023a0:	7807aa23          	sw	zero,1940(a5) # 80006b30 <br1>
    800023a4:	00004797          	auipc	a5,0x4
    800023a8:	7807a823          	sw	zero,1936(a5) # 80006b34 <bw1>
        __sem_signal(mutex1);
    800023ac:	00004517          	auipc	a0,0x4
    800023b0:	77453503          	ld	a0,1908(a0) # 80006b20 <mutex1>
    800023b4:	fffff097          	auipc	ra,0xfffff
    800023b8:	380080e7          	jalr	896(ra) # 80001734 <__sem_signal>
    800023bc:	fa1ff06f          	j	8000235c <get_uart1+0x38>
        char c = uartBuffer1[br1++];
    800023c0:	00004717          	auipc	a4,0x4
    800023c4:	77070713          	addi	a4,a4,1904 # 80006b30 <br1>
    800023c8:	00072783          	lw	a5,0(a4)
    800023cc:	0007869b          	sext.w	a3,a5
    800023d0:	0017879b          	addiw	a5,a5,1
    800023d4:	00f72023          	sw	a5,0(a4)
    800023d8:	00004797          	auipc	a5,0x4
    800023dc:	7687b783          	ld	a5,1896(a5) # 80006b40 <uartBuffer1>
    800023e0:	00d787b3          	add	a5,a5,a3
    800023e4:	0007c483          	lbu	s1,0(a5)
        __sem_signal(mutex1);
    800023e8:	00004517          	auipc	a0,0x4
    800023ec:	73853503          	ld	a0,1848(a0) # 80006b20 <mutex1>
    800023f0:	fffff097          	auipc	ra,0xfffff
    800023f4:	344080e7          	jalr	836(ra) # 80001734 <__sem_signal>
        return c;
    800023f8:	f8dff06f          	j	80002384 <get_uart1+0x60>

00000000800023fc <put_uart2>:
void put_uart2(char c){
    800023fc:	fe010113          	addi	sp,sp,-32
    80002400:	00113c23          	sd	ra,24(sp)
    80002404:	00813823          	sd	s0,16(sp)
    80002408:	00913423          	sd	s1,8(sp)
    8000240c:	01213023          	sd	s2,0(sp)
    80002410:	02010413          	addi	s0,sp,32
    80002414:	00050493          	mv	s1,a0
    __sem_wait(mutex2);
    80002418:	00004917          	auipc	s2,0x4
    8000241c:	70090913          	addi	s2,s2,1792 # 80006b18 <mutex2>
    80002420:	00093503          	ld	a0,0(s2)
    80002424:	fffff097          	auipc	ra,0xfffff
    80002428:	294080e7          	jalr	660(ra) # 800016b8 <__sem_wait>
    uartBuffer2[bw2++]=c;
    8000242c:	00004717          	auipc	a4,0x4
    80002430:	70070713          	addi	a4,a4,1792 # 80006b2c <bw2>
    80002434:	00072783          	lw	a5,0(a4)
    80002438:	0007869b          	sext.w	a3,a5
    8000243c:	0017879b          	addiw	a5,a5,1
    80002440:	00f72023          	sw	a5,0(a4)
    80002444:	00004797          	auipc	a5,0x4
    80002448:	6f47b783          	ld	a5,1780(a5) # 80006b38 <uartBuffer2>
    8000244c:	00d787b3          	add	a5,a5,a3
    80002450:	00978023          	sb	s1,0(a5)
    __sem_signal(mutex2);
    80002454:	00093503          	ld	a0,0(s2)
    80002458:	fffff097          	auipc	ra,0xfffff
    8000245c:	2dc080e7          	jalr	732(ra) # 80001734 <__sem_signal>
}
    80002460:	01813083          	ld	ra,24(sp)
    80002464:	01013403          	ld	s0,16(sp)
    80002468:	00813483          	ld	s1,8(sp)
    8000246c:	00013903          	ld	s2,0(sp)
    80002470:	02010113          	addi	sp,sp,32
    80002474:	00008067          	ret

0000000080002478 <get_uart2>:
char get_uart2(){
    80002478:	ff010113          	addi	sp,sp,-16
    8000247c:	00113423          	sd	ra,8(sp)
    80002480:	00813023          	sd	s0,0(sp)
    80002484:	01010413          	addi	s0,sp,16
    __sem_wait(mutex2);
    80002488:	00004517          	auipc	a0,0x4
    8000248c:	69053503          	ld	a0,1680(a0) # 80006b18 <mutex2>
    80002490:	fffff097          	auipc	ra,0xfffff
    80002494:	228080e7          	jalr	552(ra) # 800016b8 <__sem_wait>
    if(br2<bw2) {
    80002498:	00004717          	auipc	a4,0x4
    8000249c:	69072703          	lw	a4,1680(a4) # 80006b28 <br2>
    800024a0:	00004797          	auipc	a5,0x4
    800024a4:	68c7a783          	lw	a5,1676(a5) # 80006b2c <bw2>
    800024a8:	02f74c63          	blt	a4,a5,800024e0 <get_uart2+0x68>
        __sem_signal(mutex2);
        return uartBuffer2[br2++];

    }
    br2=0;bw2=0;
    800024ac:	00004797          	auipc	a5,0x4
    800024b0:	6607ae23          	sw	zero,1660(a5) # 80006b28 <br2>
    800024b4:	00004797          	auipc	a5,0x4
    800024b8:	6607ac23          	sw	zero,1656(a5) # 80006b2c <bw2>
    __sem_signal(mutex2);
    800024bc:	00004517          	auipc	a0,0x4
    800024c0:	65c53503          	ld	a0,1628(a0) # 80006b18 <mutex2>
    800024c4:	fffff097          	auipc	ra,0xfffff
    800024c8:	270080e7          	jalr	624(ra) # 80001734 <__sem_signal>
    return EOF;
    800024cc:	0ff00513          	li	a0,255

}
    800024d0:	00813083          	ld	ra,8(sp)
    800024d4:	00013403          	ld	s0,0(sp)
    800024d8:	01010113          	addi	sp,sp,16
    800024dc:	00008067          	ret
        __sem_signal(mutex2);
    800024e0:	00004517          	auipc	a0,0x4
    800024e4:	63853503          	ld	a0,1592(a0) # 80006b18 <mutex2>
    800024e8:	fffff097          	auipc	ra,0xfffff
    800024ec:	24c080e7          	jalr	588(ra) # 80001734 <__sem_signal>
        return uartBuffer2[br2++];
    800024f0:	00004717          	auipc	a4,0x4
    800024f4:	63870713          	addi	a4,a4,1592 # 80006b28 <br2>
    800024f8:	00072783          	lw	a5,0(a4)
    800024fc:	0007869b          	sext.w	a3,a5
    80002500:	0017879b          	addiw	a5,a5,1
    80002504:	00f72023          	sw	a5,0(a4)
    80002508:	00004797          	auipc	a5,0x4
    8000250c:	6307b783          	ld	a5,1584(a5) # 80006b38 <uartBuffer2>
    80002510:	00d787b3          	add	a5,a5,a3
    80002514:	0007c503          	lbu	a0,0(a5)
    80002518:	fb9ff06f          	j	800024d0 <get_uart2+0x58>

000000008000251c <isEmpty1>:
int  isEmpty1(){
    8000251c:	ff010113          	addi	sp,sp,-16
    80002520:	00813423          	sd	s0,8(sp)
    80002524:	01010413          	addi	s0,sp,16

    if(br1==bw1){
    80002528:	00004717          	auipc	a4,0x4
    8000252c:	60872703          	lw	a4,1544(a4) # 80006b30 <br1>
    80002530:	00004797          	auipc	a5,0x4
    80002534:	6047a783          	lw	a5,1540(a5) # 80006b34 <bw1>
    80002538:	00f70a63          	beq	a4,a5,8000254c <isEmpty1+0x30>
        return 1;
    }
    return 0;
    8000253c:	00000513          	li	a0,0
}
    80002540:	00813403          	ld	s0,8(sp)
    80002544:	01010113          	addi	sp,sp,16
    80002548:	00008067          	ret
        return 1;
    8000254c:	00100513          	li	a0,1
    80002550:	ff1ff06f          	j	80002540 <isEmpty1+0x24>

0000000080002554 <isEmpty2>:
int  isEmpty2(){
    80002554:	ff010113          	addi	sp,sp,-16
    80002558:	00813423          	sd	s0,8(sp)
    8000255c:	01010413          	addi	s0,sp,16

    if(br2==bw2){
    80002560:	00004717          	auipc	a4,0x4
    80002564:	5c872703          	lw	a4,1480(a4) # 80006b28 <br2>
    80002568:	00004797          	auipc	a5,0x4
    8000256c:	5c47a783          	lw	a5,1476(a5) # 80006b2c <bw2>
    80002570:	00f70a63          	beq	a4,a5,80002584 <isEmpty2+0x30>

        return 1;
    }
    return 0;
    80002574:	00000513          	li	a0,0
}
    80002578:	00813403          	ld	s0,8(sp)
    8000257c:	01010113          	addi	sp,sp,16
    80002580:	00008067          	ret
        return 1;
    80002584:	00100513          	li	a0,1
    80002588:	ff1ff06f          	j	80002578 <isEmpty2+0x24>

000000008000258c <isFull2>:
int isFull2(){
    8000258c:	ff010113          	addi	sp,sp,-16
    80002590:	00813423          	sd	s0,8(sp)
    80002594:	01010413          	addi	s0,sp,16
    if(bw2>=(BUFFSIZE-1)){
    80002598:	00004717          	auipc	a4,0x4
    8000259c:	59472703          	lw	a4,1428(a4) # 80006b2c <bw2>
    800025a0:	000dc7b7          	lui	a5,0xdc
    800025a4:	b9e78793          	addi	a5,a5,-1122 # dbb9e <_entry-0x7ff24462>
    800025a8:	00e7da63          	bge	a5,a4,800025bc <isFull2+0x30>
        return 1;
    800025ac:	00100513          	li	a0,1
    }
    else return 0;
}
    800025b0:	00813403          	ld	s0,8(sp)
    800025b4:	01010113          	addi	sp,sp,16
    800025b8:	00008067          	ret
    else return 0;
    800025bc:	00000513          	li	a0,0
    800025c0:	ff1ff06f          	j	800025b0 <isFull2+0x24>

00000000800025c4 <isFull1>:
int isFull1(){
    800025c4:	ff010113          	addi	sp,sp,-16
    800025c8:	00813423          	sd	s0,8(sp)
    800025cc:	01010413          	addi	s0,sp,16
    if(bw1>=(BUFFSIZE-1)){
    800025d0:	00004717          	auipc	a4,0x4
    800025d4:	56472703          	lw	a4,1380(a4) # 80006b34 <bw1>
    800025d8:	000dc7b7          	lui	a5,0xdc
    800025dc:	b9e78793          	addi	a5,a5,-1122 # dbb9e <_entry-0x7ff24462>
    800025e0:	00e7da63          	bge	a5,a4,800025f4 <isFull1+0x30>
        return 1;
    800025e4:	00100513          	li	a0,1
    }
    else return 0;
}
    800025e8:	00813403          	ld	s0,8(sp)
    800025ec:	01010113          	addi	sp,sp,16
    800025f0:	00008067          	ret
    else return 0;
    800025f4:	00000513          	li	a0,0
    800025f8:	ff1ff06f          	j	800025e8 <isFull1+0x24>

00000000800025fc <getc>:
char getc (){
    int ret;
    if(!uartBuffer1) return EOF;
    800025fc:	00004797          	auipc	a5,0x4
    80002600:	5447b783          	ld	a5,1348(a5) # 80006b40 <uartBuffer1>
    80002604:	04078a63          	beqz	a5,80002658 <getc+0x5c>
char getc (){
    80002608:	ff010113          	addi	sp,sp,-16
    8000260c:	00113423          	sd	ra,8(sp)
    80002610:	00813023          	sd	s0,0(sp)
    80002614:	01010413          	addi	s0,sp,16
    80002618:	0140006f          	j	8000262c <getc+0x30>
    while(isEmpty1()){
        sem_wait(ioSemEmpty1);
    8000261c:	00004517          	auipc	a0,0x4
    80002620:	4f453503          	ld	a0,1268(a0) # 80006b10 <ioSemEmpty1>
    80002624:	00000097          	auipc	ra,0x0
    80002628:	430080e7          	jalr	1072(ra) # 80002a54 <sem_wait>
    while(isEmpty1()){
    8000262c:	00000097          	auipc	ra,0x0
    80002630:	ef0080e7          	jalr	-272(ra) # 8000251c <isEmpty1>
    80002634:	fe0514e3          	bnez	a0,8000261c <getc+0x20>
    }
    /*while(isEmpty1()){
        __sem_wait(ioSemEmpty1);
    }*/
    asm volatile ("li a0, 0x41\n" // Broj poziva
    80002638:	04100513          	li	a0,65
    8000263c:	00000073          	ecall
    80002640:	00050793          	mv	a5,a0
                    : "=r" (ret)
                    :
                    : "a0");


    return ret;
    80002644:	0ff7f513          	andi	a0,a5,255

}
    80002648:	00813083          	ld	ra,8(sp)
    8000264c:	00013403          	ld	s0,0(sp)
    80002650:	01010113          	addi	sp,sp,16
    80002654:	00008067          	ret
    if(!uartBuffer1) return EOF;
    80002658:	0ff00513          	li	a0,255
}
    8000265c:	00008067          	ret

0000000080002660 <putc>:
void putc (char c){
    80002660:	fe010113          	addi	sp,sp,-32
    80002664:	00113c23          	sd	ra,24(sp)
    80002668:	00813823          	sd	s0,16(sp)
    8000266c:	00913423          	sd	s1,8(sp)
    80002670:	02010413          	addi	s0,sp,32
    80002674:	00050493          	mv	s1,a0

    while(isFull2()){}
    80002678:	00000097          	auipc	ra,0x0
    8000267c:	f14080e7          	jalr	-236(ra) # 8000258c <isFull2>
    80002680:	fe051ce3          	bnez	a0,80002678 <putc+0x18>
    asm volatile ("li a0, 0x42\n"// Broj poziva
    80002684:	04200513          	li	a0,66
    80002688:	00048593          	mv	a1,s1
    8000268c:	00000073          	ecall
                  ::"r"(c)
                  :"a0","a1"
            );


}
    80002690:	01813083          	ld	ra,24(sp)
    80002694:	01013403          	ld	s0,16(sp)
    80002698:	00813483          	ld	s1,8(sp)
    8000269c:	02010113          	addi	sp,sp,32
    800026a0:	00008067          	ret

00000000800026a4 <initmem>:
#define ROUNDDOWN(x, n) ((x) % (n) ? ((x) / (n)) * (n) : (x))

extern void printaddr(uintptr a);


void initmem() {
    800026a4:	ff010113          	addi	sp,sp,-16
    800026a8:	00113423          	sd	ra,8(sp)
    800026ac:	00813023          	sd	s0,0(sp)
    800026b0:	01010413          	addi	s0,sp,16
    hstart = ROUNDUP((uintptr)HEAP_START_ADDR, MEM_BLOCK_SIZE);
    800026b4:	00004797          	auipc	a5,0x4
    800026b8:	2ec7b783          	ld	a5,748(a5) # 800069a0 <HEAP_START_ADDR>
    800026bc:	03f7f713          	andi	a4,a5,63
    800026c0:	00070863          	beqz	a4,800026d0 <initmem+0x2c>
    800026c4:	0067d793          	srli	a5,a5,0x6
    800026c8:	00178793          	addi	a5,a5,1
    800026cc:	00679793          	slli	a5,a5,0x6
    800026d0:	00004717          	auipc	a4,0x4
    800026d4:	48f73423          	sd	a5,1160(a4) # 80006b58 <hstart>
    hend = ROUNDDOWN((uintptr)(HEAP_END_ADDR-1), MEM_BLOCK_SIZE);
    800026d8:	00004717          	auipc	a4,0x4
    800026dc:	2c073703          	ld	a4,704(a4) # 80006998 <HEAP_END_ADDR>
    800026e0:	fff70713          	addi	a4,a4,-1
    800026e4:	03f77693          	andi	a3,a4,63
    800026e8:	00068463          	beqz	a3,800026f0 <initmem+0x4c>
    800026ec:	fc077713          	andi	a4,a4,-64
    800026f0:	00004697          	auipc	a3,0x4
    800026f4:	46e6b023          	sd	a4,1120(a3) # 80006b50 <hend>

    size_t heapsize = hend - hstart;
    800026f8:	40f70633          	sub	a2,a4,a5
    size_t blocknum = heapsize / MEM_BLOCK_SIZE;

    size_t bitmapsz = blocknum / 8;
    800026fc:	00965613          	srli	a2,a2,0x9

    bitmap = (void*)hstart;
    80002700:	00078513          	mv	a0,a5
    80002704:	00004697          	auipc	a3,0x4
    80002708:	46f6b623          	sd	a5,1132(a3) # 80006b70 <bitmap>
    heapstart = (void*)ROUNDUP(hstart + bitmapsz, MEM_BLOCK_SIZE);
    8000270c:	00c787b3          	add	a5,a5,a2
    80002710:	03f7f693          	andi	a3,a5,63
    80002714:	00068863          	beqz	a3,80002724 <initmem+0x80>
    80002718:	0067d793          	srli	a5,a5,0x6
    8000271c:	00178793          	addi	a5,a5,1
    80002720:	00679793          	slli	a5,a5,0x6
    80002724:	00004697          	auipc	a3,0x4
    80002728:	44f6b223          	sd	a5,1092(a3) # 80006b68 <heapstart>
    heapsz = ((uintptr)heapstart - hend) / MEM_BLOCK_SIZE;
    8000272c:	40e787b3          	sub	a5,a5,a4
    80002730:	0067d793          	srli	a5,a5,0x6
    80002734:	00004717          	auipc	a4,0x4
    80002738:	42f73623          	sd	a5,1068(a4) # 80006b60 <heapsz>

    memset(bitmap, 0, bitmapsz);
    8000273c:	00000593          	li	a1,0
    80002740:	fffff097          	auipc	ra,0xfffff
    80002744:	e00080e7          	jalr	-512(ra) # 80001540 <memset>
}
    80002748:	00813083          	ld	ra,8(sp)
    8000274c:	00013403          	ld	s0,0(sp)
    80002750:	01010113          	addi	sp,sp,16
    80002754:	00008067          	ret

0000000080002758 <__mem_alloc>:

extern void putc1(char c);

void* __mem_alloc(size_t size){
    80002758:	fe010113          	addi	sp,sp,-32
    8000275c:	00113c23          	sd	ra,24(sp)
    80002760:	00813823          	sd	s0,16(sp)
    80002764:	00913423          	sd	s1,8(sp)
    80002768:	02010413          	addi	s0,sp,32
    8000276c:	00050493          	mv	s1,a0
    void *ret = NULL;

   slacquire(&memlock);
    80002770:	00004517          	auipc	a0,0x4
    80002774:	3d850513          	addi	a0,a0,984 # 80006b48 <memlock>
    80002778:	00000097          	auipc	ra,0x0
    8000277c:	25c080e7          	jalr	604(ra) # 800029d4 <slacquire>

    size_t numblock = ROUNDUP(size, MEM_BLOCK_SIZE) / MEM_BLOCK_SIZE + 1;
    80002780:	03f4f793          	andi	a5,s1,63
    80002784:	02078263          	beqz	a5,800027a8 <__mem_alloc+0x50>
    80002788:	0064d593          	srli	a1,s1,0x6
    8000278c:	00158593          	addi	a1,a1,1
    80002790:	fff00793          	li	a5,-1
    80002794:	0067d793          	srli	a5,a5,0x6
    80002798:	00f5f5b3          	and	a1,a1,a5
    8000279c:	00158593          	addi	a1,a1,1



    for (size_t i = 0; i < heapsz; i++) {
    800027a0:	00000613          	li	a2,0
    800027a4:	0a40006f          	j	80002848 <__mem_alloc+0xf0>
    size_t numblock = ROUNDUP(size, MEM_BLOCK_SIZE) / MEM_BLOCK_SIZE + 1;
    800027a8:	0064d593          	srli	a1,s1,0x6
    800027ac:	00158593          	addi	a1,a1,1
    800027b0:	ff1ff06f          	j	800027a0 <__mem_alloc+0x48>

                goto petlja;
            }

        }
        for (size_t j = 0; j < numblock; j++)
    800027b4:	00000713          	li	a4,0
    800027b8:	02b77e63          	bgeu	a4,a1,800027f4 <__mem_alloc+0x9c>
            bitmap[(i+j)/8] |= 1<<((i+j)%8);
    800027bc:	00e606b3          	add	a3,a2,a4
    800027c0:	0036d793          	srli	a5,a3,0x3
    800027c4:	00004697          	auipc	a3,0x4
    800027c8:	3ac6b683          	ld	a3,940(a3) # 80006b70 <bitmap>
    800027cc:	00f686b3          	add	a3,a3,a5
    800027d0:	010707bb          	addw	a5,a4,a6
    800027d4:	0077f513          	andi	a0,a5,7
    800027d8:	00100793          	li	a5,1
    800027dc:	00a797bb          	sllw	a5,a5,a0
    800027e0:	0006c503          	lbu	a0,0(a3)
    800027e4:	00a7e7b3          	or	a5,a5,a0
    800027e8:	00f68023          	sb	a5,0(a3)
        for (size_t j = 0; j < numblock; j++)
    800027ec:	00170713          	addi	a4,a4,1
    800027f0:	fc9ff06f          	j	800027b8 <__mem_alloc+0x60>

        *(size_t*)((uintptr)heapstart + i*MEM_BLOCK_SIZE) = numblock;
    800027f4:	00661793          	slli	a5,a2,0x6
    800027f8:	00004717          	auipc	a4,0x4
    800027fc:	37070713          	addi	a4,a4,880 # 80006b68 <heapstart>
    80002800:	00073683          	ld	a3,0(a4)
    80002804:	00d787b3          	add	a5,a5,a3
    80002808:	00b7b023          	sd	a1,0(a5)
        //printaddr((uintptr)numblock);
        ret = (void*)((uintptr)heapstart + (i + 1)*MEM_BLOCK_SIZE);
    8000280c:	00160493          	addi	s1,a2,1
    80002810:	00649493          	slli	s1,s1,0x6
    80002814:	00073783          	ld	a5,0(a4)
    80002818:	00f484b3          	add	s1,s1,a5
        petlja:
        (void)1;//putc1('?');
    }

    retuwurn:
    slrelease(&memlock);
    8000281c:	00004517          	auipc	a0,0x4
    80002820:	32c50513          	addi	a0,a0,812 # 80006b48 <memlock>
    80002824:	00000097          	auipc	ra,0x0
    80002828:	1dc080e7          	jalr	476(ra) # 80002a00 <slrelease>
    return ret;
}
    8000282c:	00048513          	mv	a0,s1
    80002830:	01813083          	ld	ra,24(sp)
    80002834:	01013403          	ld	s0,16(sp)
    80002838:	00813483          	ld	s1,8(sp)
    8000283c:	02010113          	addi	sp,sp,32
    80002840:	00008067          	ret
    for (size_t i = 0; i < heapsz; i++) {
    80002844:	00160613          	addi	a2,a2,1
    80002848:	00004797          	auipc	a5,0x4
    8000284c:	3187b783          	ld	a5,792(a5) # 80006b60 <heapsz>
    80002850:	06f67063          	bgeu	a2,a5,800028b0 <__mem_alloc+0x158>
        if (bitmap[i/8] & (1<<(i%8)))
    80002854:	00004517          	auipc	a0,0x4
    80002858:	31c53503          	ld	a0,796(a0) # 80006b70 <bitmap>
    8000285c:	00365793          	srli	a5,a2,0x3
    80002860:	00f507b3          	add	a5,a0,a5
    80002864:	0007c783          	lbu	a5,0(a5)
    80002868:	0006081b          	sext.w	a6,a2
    8000286c:	00767713          	andi	a4,a2,7
    80002870:	40e7d7bb          	sraw	a5,a5,a4
    80002874:	0017f793          	andi	a5,a5,1
    80002878:	fc0796e3          	bnez	a5,80002844 <__mem_alloc+0xec>
        for (size_t j = 0; j < numblock; j++) {
    8000287c:	00000713          	li	a4,0
    80002880:	f2b77ae3          	bgeu	a4,a1,800027b4 <__mem_alloc+0x5c>
            if (bitmap[(i + j) / 8] & (1 << ((i + j) % 8))){
    80002884:	00e607b3          	add	a5,a2,a4
    80002888:	0037d793          	srli	a5,a5,0x3
    8000288c:	00f507b3          	add	a5,a0,a5
    80002890:	0007c783          	lbu	a5,0(a5)
    80002894:	010706bb          	addw	a3,a4,a6
    80002898:	0076f693          	andi	a3,a3,7
    8000289c:	40d7d7bb          	sraw	a5,a5,a3
    800028a0:	0017f793          	andi	a5,a5,1
    800028a4:	fa0790e3          	bnez	a5,80002844 <__mem_alloc+0xec>
        for (size_t j = 0; j < numblock; j++) {
    800028a8:	00170713          	addi	a4,a4,1
    800028ac:	fd5ff06f          	j	80002880 <__mem_alloc+0x128>
    void *ret = NULL;
    800028b0:	00000493          	li	s1,0
    800028b4:	f69ff06f          	j	8000281c <__mem_alloc+0xc4>

00000000800028b8 <__mem_free>:
int __mem_free(void *p){
    800028b8:	fe010113          	addi	sp,sp,-32
    800028bc:	00113c23          	sd	ra,24(sp)
    800028c0:	00813823          	sd	s0,16(sp)
    800028c4:	00913423          	sd	s1,8(sp)
    800028c8:	02010413          	addi	s0,sp,32
    800028cc:	00050493          	mv	s1,a0
    slacquire(&memlock);
    800028d0:	00004517          	auipc	a0,0x4
    800028d4:	27850513          	addi	a0,a0,632 # 80006b48 <memlock>
    800028d8:	00000097          	auipc	ra,0x0
    800028dc:	0fc080e7          	jalr	252(ra) # 800029d4 <slacquire>
    // ret = (void*)((uintptr)heapstart + i*MEM_BLOCK_SIZE + 1);
    size_t ind = ((uintptr)p - (uintptr)heapstart) / MEM_BLOCK_SIZE - 1;
    800028e0:	00004817          	auipc	a6,0x4
    800028e4:	28883803          	ld	a6,648(a6) # 80006b68 <heapstart>
    800028e8:	41048833          	sub	a6,s1,a6
    800028ec:	00685813          	srli	a6,a6,0x6
    800028f0:	fff80813          	addi	a6,a6,-1
    size_t numblock = *(size_t *)((uintptr)p - MEM_BLOCK_SIZE);
    800028f4:	fc04b883          	ld	a7,-64(s1)
    size_t i = ind;
    800028f8:	00080713          	mv	a4,a6
    for (; i < ind + numblock; i++) {
    800028fc:	011807b3          	add	a5,a6,a7
    80002900:	04f77263          	bgeu	a4,a5,80002944 <__mem_free+0x8c>
        if (((bitmap[i / 8] >> (i % 8)) & 1) == 0) return -1;
    80002904:	00375693          	srli	a3,a4,0x3
    80002908:	00004797          	auipc	a5,0x4
    8000290c:	2687b783          	ld	a5,616(a5) # 80006b70 <bitmap>
    80002910:	00d786b3          	add	a3,a5,a3
    80002914:	0006c583          	lbu	a1,0(a3)
    80002918:	00777513          	andi	a0,a4,7
    8000291c:	40a5d63b          	sraw	a2,a1,a0
    80002920:	00167613          	andi	a2,a2,1
    80002924:	04060463          	beqz	a2,8000296c <__mem_free+0xb4>
        bitmap[i / 8] &= ~(1 << (i % 8));
    80002928:	00100793          	li	a5,1
    8000292c:	00a797bb          	sllw	a5,a5,a0
    80002930:	fff7c793          	not	a5,a5
    80002934:	00b7f7b3          	and	a5,a5,a1
    80002938:	00f68023          	sb	a5,0(a3)
    for (; i < ind + numblock; i++) {
    8000293c:	00170713          	addi	a4,a4,1
    80002940:	fbdff06f          	j	800028fc <__mem_free+0x44>
    }
    slrelease(&memlock);
    80002944:	00004517          	auipc	a0,0x4
    80002948:	20450513          	addi	a0,a0,516 # 80006b48 <memlock>
    8000294c:	00000097          	auipc	ra,0x0
    80002950:	0b4080e7          	jalr	180(ra) # 80002a00 <slrelease>
    return 0;
    80002954:	00000513          	li	a0,0
}
    80002958:	01813083          	ld	ra,24(sp)
    8000295c:	01013403          	ld	s0,16(sp)
    80002960:	00813483          	ld	s1,8(sp)
    80002964:	02010113          	addi	sp,sp,32
    80002968:	00008067          	ret
        if (((bitmap[i / 8] >> (i % 8)) & 1) == 0) return -1;
    8000296c:	fff00513          	li	a0,-1
    80002970:	fe9ff06f          	j	80002958 <__mem_free+0xa0>

0000000080002974 <mem_alloc>:
void *mem_alloc(size_t size) {
    80002974:	ff010113          	addi	sp,sp,-16
    80002978:	00813423          	sd	s0,8(sp)
    8000297c:	01010413          	addi	s0,sp,16
    80002980:	00050793          	mv	a5,a0
    void *ret;

    asm volatile ("li a0, 1\n" // Broj poziva
    80002984:	00100513          	li	a0,1
    80002988:	00078593          	mv	a1,a5
    8000298c:	00000073          	ecall
    80002990:	00050793          	mv	a5,a0
            : "=r" (ret)
            : "r" (size)
            : "a0", "a1");

    return ret;
}
    80002994:	00078513          	mv	a0,a5
    80002998:	00813403          	ld	s0,8(sp)
    8000299c:	01010113          	addi	sp,sp,16
    800029a0:	00008067          	ret

00000000800029a4 <mem_free>:
int mem_free(void* p) {
    800029a4:	ff010113          	addi	sp,sp,-16
    800029a8:	00813423          	sd	s0,8(sp)
    800029ac:	01010413          	addi	s0,sp,16
    800029b0:	00050793          	mv	a5,a0
    void *ret;

    asm volatile ("li a0, 2\n" // Broj poziva
    800029b4:	00200513          	li	a0,2
    800029b8:	00078593          	mv	a1,a5
    800029bc:	00000073          	ecall
    800029c0:	00050793          	mv	a5,a0
            : "=r" (ret)
            : "r" (p)
            : "a0", "a1");

    return (uint64)ret;
}
    800029c4:	0007851b          	sext.w	a0,a5
    800029c8:	00813403          	ld	s0,8(sp)
    800029cc:	01010113          	addi	sp,sp,16
    800029d0:	00008067          	ret

00000000800029d4 <slacquire>:
#include "../h/kernel.h"

void slacquire(spinlock *lk) {
    800029d4:	ff010113          	addi	sp,sp,-16
    800029d8:	00813423          	sd	s0,8(sp)
    800029dc:	01010413          	addi	s0,sp,16
    while(__sync_lock_test_and_set(lk, 1) != 0);
    800029e0:	00100793          	li	a5,1
    800029e4:	0cf527af          	amoswap.w.aq	a5,a5,(a0)
    800029e8:	0007879b          	sext.w	a5,a5
    800029ec:	fe079ae3          	bnez	a5,800029e0 <slacquire+0xc>
    __sync_synchronize();
    800029f0:	0ff0000f          	fence
}
    800029f4:	00813403          	ld	s0,8(sp)
    800029f8:	01010113          	addi	sp,sp,16
    800029fc:	00008067          	ret

0000000080002a00 <slrelease>:

void slrelease(spinlock *lk) {
    80002a00:	ff010113          	addi	sp,sp,-16
    80002a04:	00813423          	sd	s0,8(sp)
    80002a08:	01010413          	addi	s0,sp,16
    __sync_synchronize();
    80002a0c:	0ff0000f          	fence
    __sync_lock_release(lk);
    80002a10:	0f50000f          	fence	iorw,ow
    80002a14:	0805202f          	amoswap.w	zero,zero,(a0)
}
    80002a18:	00813403          	ld	s0,8(sp)
    80002a1c:	01010113          	addi	sp,sp,16
    80002a20:	00008067          	ret

0000000080002a24 <sem_close>:
//
// Created by os on 7/28/22.
//
#include "../h/syscall_c.h"
#include "../lib/hw.h"
int sem_close (sem_t handle){
    80002a24:	ff010113          	addi	sp,sp,-16
    80002a28:	00813423          	sd	s0,8(sp)
    80002a2c:	01010413          	addi	s0,sp,16
    80002a30:	00050793          	mv	a5,a0
    int ret;

    asm volatile ("li a0, 0x22\n" // Broj poziva
    80002a34:	02200513          	li	a0,34
    80002a38:	00078593          	mv	a1,a5
    80002a3c:	00000073          	ecall
    80002a40:	00050793          	mv	a5,a0
            : "r" (handle)
    , "r" (handle)
            : "a0", "a1");

    return ret;
}
    80002a44:	0007851b          	sext.w	a0,a5
    80002a48:	00813403          	ld	s0,8(sp)
    80002a4c:	01010113          	addi	sp,sp,16
    80002a50:	00008067          	ret

0000000080002a54 <sem_wait>:
int sem_wait (sem_t id){
    80002a54:	ff010113          	addi	sp,sp,-16
    80002a58:	00813423          	sd	s0,8(sp)
    80002a5c:	01010413          	addi	s0,sp,16
    80002a60:	00050793          	mv	a5,a0
    int ret;

    asm volatile ("li a0, 0x23\n" // Broj poziva
    80002a64:	02300513          	li	a0,35
    80002a68:	00078593          	mv	a1,a5
    80002a6c:	00000073          	ecall
    80002a70:	00050793          	mv	a5,a0
            : "=r" (ret)
            : "r" (id)
            : "a0", "a1");

    return ret;
}
    80002a74:	0007851b          	sext.w	a0,a5
    80002a78:	00813403          	ld	s0,8(sp)
    80002a7c:	01010113          	addi	sp,sp,16
    80002a80:	00008067          	ret

0000000080002a84 <sem_signal>:
int sem_signal (sem_t id){
    80002a84:	ff010113          	addi	sp,sp,-16
    80002a88:	00813423          	sd	s0,8(sp)
    80002a8c:	01010413          	addi	s0,sp,16
    80002a90:	00050793          	mv	a5,a0
    int ret;

    asm volatile ("li a0, 0x24\n" // Broj poziva
    80002a94:	02400513          	li	a0,36
    80002a98:	00078593          	mv	a1,a5
    80002a9c:	00000073          	ecall
    80002aa0:	00050793          	mv	a5,a0
            : "=r" (ret)
            : "r" (id)
            : "a0", "a1");

    return ret;
}
    80002aa4:	0007851b          	sext.w	a0,a5
    80002aa8:	00813403          	ld	s0,8(sp)
    80002aac:	01010113          	addi	sp,sp,16
    80002ab0:	00008067          	ret

0000000080002ab4 <sem_open>:
int sem_open (
        sem_t* handle,
        unsigned init
){
    80002ab4:	ff010113          	addi	sp,sp,-16
    80002ab8:	00813423          	sd	s0,8(sp)
    80002abc:	01010413          	addi	s0,sp,16
    80002ac0:	00050793          	mv	a5,a0
    80002ac4:	00058713          	mv	a4,a1
    int ret;

    asm volatile ("li a0, 0x21\n" // Broj poziva
    80002ac8:	02100513          	li	a0,33
    80002acc:	00078593          	mv	a1,a5
    80002ad0:	00070613          	mv	a2,a4
    80002ad4:	00000073          	ecall
    80002ad8:	00050793          	mv	a5,a0
            : "=r" (ret)
            :"r" (handle), "r" (init)
            : "a0", "a1","a2");

    return ret;
}
    80002adc:	0007851b          	sext.w	a0,a5
    80002ae0:	00813403          	ld	s0,8(sp)
    80002ae4:	01010113          	addi	sp,sp,16
    80002ae8:	00008067          	ret

0000000080002aec <time_sleep>:
int time_sleep (time_t time){
    80002aec:	ff010113          	addi	sp,sp,-16
    80002af0:	00813423          	sd	s0,8(sp)
    80002af4:	01010413          	addi	s0,sp,16
    80002af8:	00050793          	mv	a5,a0
    int ret;

    asm volatile ("li a0, 0x31\n" // Broj poziva
    80002afc:	03100513          	li	a0,49
    80002b00:	00078593          	mv	a1,a5
    80002b04:	00000073          	ecall
    80002b08:	00050793          	mv	a5,a0
            : "=r" (ret)
            :"r" (time)
            : "a0", "a1");

    return ret;
    80002b0c:	0007851b          	sext.w	a0,a5
    80002b10:	00813403          	ld	s0,8(sp)
    80002b14:	01010113          	addi	sp,sp,16
    80002b18:	00008067          	ret

0000000080002b1c <thread_dispatch>:
//#include "../h/kernel.h"
#include "../h/syscall_c.h"
#include "../lib/hw.h"


void thread_dispatch (){
    80002b1c:	ff010113          	addi	sp,sp,-16
    80002b20:	00813423          	sd	s0,8(sp)
    80002b24:	01010413          	addi	s0,sp,16
    asm volatile ("li a0, 0x13\n" // Broj poziva
    80002b28:	01300513          	li	a0,19
    80002b2c:	00000073          	ecall
                  "\tecall\n");
}
    80002b30:	00813403          	ld	s0,8(sp)
    80002b34:	01010113          	addi	sp,sp,16
    80002b38:	00008067          	ret

0000000080002b3c <thread_create>:
int thread_create(thread_t* handle,
                  void(*start_routine)(void*),
                  void* arg) {
    80002b3c:	ff010113          	addi	sp,sp,-16
    80002b40:	00813423          	sd	s0,8(sp)
    80002b44:	01010413          	addi	s0,sp,16
    80002b48:	00050793          	mv	a5,a0
    80002b4c:	00058713          	mv	a4,a1
    80002b50:	00060813          	mv	a6,a2
    void *ret=(void*)0;

    asm volatile ("li a0, 0x11\n" // Broj poziva
    80002b54:	01100513          	li	a0,17
    80002b58:	00078593          	mv	a1,a5
    80002b5c:	00070613          	mv	a2,a4
    80002b60:	00080693          	mv	a3,a6
    80002b64:	00000073          	ecall
    80002b68:	00050793          	mv	a5,a0
    , "r" (start_routine)
    , "r" (arg)
            : "a0", "a1","a2","a3");

    return (uint64)ret;
}
    80002b6c:	0007851b          	sext.w	a0,a5
    80002b70:	00813403          	ld	s0,8(sp)
    80002b74:	01010113          	addi	sp,sp,16
    80002b78:	00008067          	ret

0000000080002b7c <thread_exit>:
int thread_exit (){
    80002b7c:	ff010113          	addi	sp,sp,-16
    80002b80:	00813423          	sd	s0,8(sp)
    80002b84:	01010413          	addi	s0,sp,16

    int ret;

    asm volatile ("li a0, 0x12\n" // Broj poziva
    80002b88:	01200513          	li	a0,18
    80002b8c:	00000073          	ecall
    80002b90:	00050793          	mv	a5,a0
            :"=r" (ret)
            :
            : "a0");

    return ret;
    80002b94:	0007851b          	sext.w	a0,a5
    80002b98:	00813403          	ld	s0,8(sp)
    80002b9c:	01010113          	addi	sp,sp,16
    80002ba0:	00008067          	ret

0000000080002ba4 <sc_put>:
    __asm__ volatile ("csrs sstatus, %[mask]" : : [mask] "r"(mask));
}
volatile sched scheduler=0,schend=0;
volatile blist *blocked = 0,*blend = NULL;
extern void printc(char c);
void sc_put(thread_t thr){
    80002ba4:	fe010113          	addi	sp,sp,-32
    80002ba8:	00113c23          	sd	ra,24(sp)
    80002bac:	00813823          	sd	s0,16(sp)
    80002bb0:	00913423          	sd	s1,8(sp)
    80002bb4:	02010413          	addi	s0,sp,32
    80002bb8:	00050493          	mv	s1,a0
    //printc('u');
    //mc_sstatus(SSTATUS_SIE);
    sched pom=__mem_alloc(sizeof(_scheduler));
    80002bbc:	01000513          	li	a0,16
    80002bc0:	00000097          	auipc	ra,0x0
    80002bc4:	b98080e7          	jalr	-1128(ra) # 80002758 <__mem_alloc>
    if(pom==NULL) {
    80002bc8:	04050863          	beqz	a0,80002c18 <sc_put+0x74>
        printc('g');
        return;
    }
    if(!scheduler){
    80002bcc:	00004797          	auipc	a5,0x4
    80002bd0:	fc47b783          	ld	a5,-60(a5) # 80006b90 <scheduler>
    80002bd4:	04078a63          	beqz	a5,80002c28 <sc_put+0x84>
        scheduler->data=thr;
        scheduler->next=NULL;
        schend=scheduler;
        return;
    }
    schend->next=pom;
    80002bd8:	00004797          	auipc	a5,0x4
    80002bdc:	fb078793          	addi	a5,a5,-80 # 80006b88 <schend>
    80002be0:	0007b703          	ld	a4,0(a5)
    80002be4:	00a73423          	sd	a0,8(a4)
    schend=schend->next;
    80002be8:	0007b703          	ld	a4,0(a5)
    80002bec:	00873703          	ld	a4,8(a4)
    80002bf0:	00e7b023          	sd	a4,0(a5)
    schend->data=thr;
    80002bf4:	0007b703          	ld	a4,0(a5)
    80002bf8:	00973023          	sd	s1,0(a4)
    schend->next=NULL;
    80002bfc:	0007b783          	ld	a5,0(a5)
    80002c00:	0007b423          	sd	zero,8(a5)
    //printc('p');
    //ms_sstatus(SSTATUS_SIE);
}
    80002c04:	01813083          	ld	ra,24(sp)
    80002c08:	01013403          	ld	s0,16(sp)
    80002c0c:	00813483          	ld	s1,8(sp)
    80002c10:	02010113          	addi	sp,sp,32
    80002c14:	00008067          	ret
        printc('g');
    80002c18:	06700513          	li	a0,103
    80002c1c:	fffff097          	auipc	ra,0xfffff
    80002c20:	fa0080e7          	jalr	-96(ra) # 80001bbc <printc>
        return;
    80002c24:	fe1ff06f          	j	80002c04 <sc_put+0x60>
        scheduler= pom;
    80002c28:	00004797          	auipc	a5,0x4
    80002c2c:	f6878793          	addi	a5,a5,-152 # 80006b90 <scheduler>
    80002c30:	00a7b023          	sd	a0,0(a5)
        scheduler->data=thr;
    80002c34:	0007b703          	ld	a4,0(a5)
    80002c38:	00973023          	sd	s1,0(a4)
        scheduler->next=NULL;
    80002c3c:	0007b703          	ld	a4,0(a5)
    80002c40:	00073423          	sd	zero,8(a4)
        schend=scheduler;
    80002c44:	0007b783          	ld	a5,0(a5)
    80002c48:	00004717          	auipc	a4,0x4
    80002c4c:	f4f73023          	sd	a5,-192(a4) # 80006b88 <schend>
        return;
    80002c50:	fb5ff06f          	j	80002c04 <sc_put+0x60>

0000000080002c54 <sc_get>:
thread_t sc_get(){
    80002c54:	fe010113          	addi	sp,sp,-32
    80002c58:	00113c23          	sd	ra,24(sp)
    80002c5c:	00813823          	sd	s0,16(sp)
    80002c60:	00913423          	sd	s1,8(sp)
    80002c64:	02010413          	addi	s0,sp,32
    //mc_sstatus(SSTATUS_SIE);
    sched s=scheduler;
    80002c68:	00004517          	auipc	a0,0x4
    80002c6c:	f2853503          	ld	a0,-216(a0) # 80006b90 <scheduler>
    if(s==NULL){
    80002c70:	04050463          	beqz	a0,80002cb8 <sc_get+0x64>
        schend=NULL;
        return NULL;
    }
    thread_t t=s->data;
    80002c74:	00053483          	ld	s1,0(a0)
    if(scheduler)scheduler=scheduler->next;
    80002c78:	00004797          	auipc	a5,0x4
    80002c7c:	f187b783          	ld	a5,-232(a5) # 80006b90 <scheduler>
    80002c80:	00078c63          	beqz	a5,80002c98 <sc_get+0x44>
    80002c84:	00004797          	auipc	a5,0x4
    80002c88:	f0c78793          	addi	a5,a5,-244 # 80006b90 <scheduler>
    80002c8c:	0007b703          	ld	a4,0(a5)
    80002c90:	00873703          	ld	a4,8(a4)
    80002c94:	00e7b023          	sd	a4,0(a5)
    __mem_free(s);
    80002c98:	00000097          	auipc	ra,0x0
    80002c9c:	c20080e7          	jalr	-992(ra) # 800028b8 <__mem_free>
    //ms_sstatus(SSTATUS_SIE);
    return t;
}
    80002ca0:	00048513          	mv	a0,s1
    80002ca4:	01813083          	ld	ra,24(sp)
    80002ca8:	01013403          	ld	s0,16(sp)
    80002cac:	00813483          	ld	s1,8(sp)
    80002cb0:	02010113          	addi	sp,sp,32
    80002cb4:	00008067          	ret
        schend=NULL;
    80002cb8:	00004797          	auipc	a5,0x4
    80002cbc:	ec07b823          	sd	zero,-304(a5) # 80006b88 <schend>
        return NULL;
    80002cc0:	00050493          	mv	s1,a0
    80002cc4:	fddff06f          	j	80002ca0 <sc_get+0x4c>

0000000080002cc8 <sc_empty>:
int sc_empty(){
    80002cc8:	ff010113          	addi	sp,sp,-16
    80002ccc:	00813423          	sd	s0,8(sp)
    80002cd0:	01010413          	addi	s0,sp,16
    if(scheduler==NULL){
    80002cd4:	00004797          	auipc	a5,0x4
    80002cd8:	ebc7b783          	ld	a5,-324(a5) # 80006b90 <scheduler>
    80002cdc:	00078a63          	beqz	a5,80002cf0 <sc_empty+0x28>
        return 1;
    }
    else return 0;
    80002ce0:	00000513          	li	a0,0
}
    80002ce4:	00813403          	ld	s0,8(sp)
    80002ce8:	01010113          	addi	sp,sp,16
    80002cec:	00008067          	ret
        return 1;
    80002cf0:	00100513          	li	a0,1
    80002cf4:	ff1ff06f          	j	80002ce4 <sc_empty+0x1c>

0000000080002cf8 <b_put>:
extern void printaddr(uintptr a);
int b_put(sem_t sem ,thread_t thr){
    80002cf8:	fe010113          	addi	sp,sp,-32
    80002cfc:	00113c23          	sd	ra,24(sp)
    80002d00:	00813823          	sd	s0,16(sp)
    80002d04:	00913423          	sd	s1,8(sp)
    80002d08:	01213023          	sd	s2,0(sp)
    80002d0c:	02010413          	addi	s0,sp,32
    80002d10:	00050493          	mv	s1,a0
    80002d14:	00058913          	mv	s2,a1
    blist* pom=__mem_alloc(sizeof(blist));
    80002d18:	01800513          	li	a0,24
    80002d1c:	00000097          	auipc	ra,0x0
    80002d20:	a3c080e7          	jalr	-1476(ra) # 80002758 <__mem_alloc>
    if(pom==NULL)return -1;
    80002d24:	04050a63          	beqz	a0,80002d78 <b_put+0x80>
    pom->data=thr;
    80002d28:	01253023          	sd	s2,0(a0)
    pom->next=NULL;
    80002d2c:	00053823          	sd	zero,16(a0)
    if(!sem->blocked){
    80002d30:	0084b783          	ld	a5,8(s1)
    80002d34:	02078a63          	beqz	a5,80002d68 <b_put+0x70>
        sem->blocked= pom;
        sem->blend=sem->blocked;
        return 0;
    }
    sem->blend->next=pom;
    80002d38:	0104b783          	ld	a5,16(s1)
    80002d3c:	00a7b823          	sd	a0,16(a5)
    sem->blend= sem->blend->next;
    80002d40:	0104b783          	ld	a5,16(s1)
    80002d44:	0107b783          	ld	a5,16(a5)
    80002d48:	00f4b823          	sd	a5,16(s1)
    return 0;
    80002d4c:	00000513          	li	a0,0
}
    80002d50:	01813083          	ld	ra,24(sp)
    80002d54:	01013403          	ld	s0,16(sp)
    80002d58:	00813483          	ld	s1,8(sp)
    80002d5c:	00013903          	ld	s2,0(sp)
    80002d60:	02010113          	addi	sp,sp,32
    80002d64:	00008067          	ret
        sem->blocked= pom;
    80002d68:	00a4b423          	sd	a0,8(s1)
        sem->blend=sem->blocked;
    80002d6c:	00a4b823          	sd	a0,16(s1)
        return 0;
    80002d70:	00000513          	li	a0,0
    80002d74:	fddff06f          	j	80002d50 <b_put+0x58>
    if(pom==NULL)return -1;
    80002d78:	fff00513          	li	a0,-1
    80002d7c:	fd5ff06f          	j	80002d50 <b_put+0x58>

0000000080002d80 <b_get>:

thread_t b_get(sem_t sem){
    80002d80:	fe010113          	addi	sp,sp,-32
    80002d84:	00113c23          	sd	ra,24(sp)
    80002d88:	00813823          	sd	s0,16(sp)
    80002d8c:	00913423          	sd	s1,8(sp)
    80002d90:	02010413          	addi	s0,sp,32
    80002d94:	00050793          	mv	a5,a0
    blist* s=sem->blocked;
    80002d98:	00853503          	ld	a0,8(a0)
    if(s==NULL){
    80002d9c:	02050863          	beqz	a0,80002dcc <b_get+0x4c>
        sem->blend=NULL;
        return NULL;
    }
    thread_t thr=s->data;
    80002da0:	00053483          	ld	s1,0(a0)
    sem->blocked=sem->blocked->next;
    80002da4:	01053703          	ld	a4,16(a0)
    80002da8:	00e7b423          	sd	a4,8(a5)
    __mem_free(s);
    80002dac:	00000097          	auipc	ra,0x0
    80002db0:	b0c080e7          	jalr	-1268(ra) # 800028b8 <__mem_free>
    return thr;

}
    80002db4:	00048513          	mv	a0,s1
    80002db8:	01813083          	ld	ra,24(sp)
    80002dbc:	01013403          	ld	s0,16(sp)
    80002dc0:	00813483          	ld	s1,8(sp)
    80002dc4:	02010113          	addi	sp,sp,32
    80002dc8:	00008067          	ret
        sem->blend=NULL;
    80002dcc:	0007b823          	sd	zero,16(a5)
        return NULL;
    80002dd0:	00050493          	mv	s1,a0
    80002dd4:	fe1ff06f          	j	80002db4 <b_get+0x34>

0000000080002dd8 <putblocked>:
extern void putc1(char c);
int putblocked(thread_t thr,time_t time){
    80002dd8:	fe010113          	addi	sp,sp,-32
    80002ddc:	00113c23          	sd	ra,24(sp)
    80002de0:	00813823          	sd	s0,16(sp)
    80002de4:	00913423          	sd	s1,8(sp)
    80002de8:	01213023          	sd	s2,0(sp)
    80002dec:	02010413          	addi	s0,sp,32
    80002df0:	00050913          	mv	s2,a0
    80002df4:	00058493          	mv	s1,a1
    blist* pom=__mem_alloc(sizeof(blist));
    80002df8:	01800513          	li	a0,24
    80002dfc:	00000097          	auipc	ra,0x0
    80002e00:	95c080e7          	jalr	-1700(ra) # 80002758 <__mem_alloc>
    if(!pom)return -1;
    80002e04:	06050463          	beqz	a0,80002e6c <putblocked+0x94>
    pom->data=thr;
    80002e08:	01253023          	sd	s2,0(a0)
    pom->time=time;
    80002e0c:	00953423          	sd	s1,8(a0)
    pom->next=NULL;
    80002e10:	00053823          	sd	zero,16(a0)
    if(!blocked){
    80002e14:	00004797          	auipc	a5,0x4
    80002e18:	d6c7b783          	ld	a5,-660(a5) # 80006b80 <blocked>
    80002e1c:	02078c63          	beqz	a5,80002e54 <putblocked+0x7c>

        blocked= pom;
        blend=blocked;
        return 0;
    }
    blend->next=pom;
    80002e20:	00004797          	auipc	a5,0x4
    80002e24:	d5878793          	addi	a5,a5,-680 # 80006b78 <blend>
    80002e28:	0007b703          	ld	a4,0(a5)
    80002e2c:	00a73823          	sd	a0,16(a4)
    blend=blend->next;
    80002e30:	01073703          	ld	a4,16(a4)
    80002e34:	00e7b023          	sd	a4,0(a5)

    return 0;
    80002e38:	00000513          	li	a0,0
}
    80002e3c:	01813083          	ld	ra,24(sp)
    80002e40:	01013403          	ld	s0,16(sp)
    80002e44:	00813483          	ld	s1,8(sp)
    80002e48:	00013903          	ld	s2,0(sp)
    80002e4c:	02010113          	addi	sp,sp,32
    80002e50:	00008067          	ret
        blocked= pom;
    80002e54:	00004797          	auipc	a5,0x4
    80002e58:	d2a7b623          	sd	a0,-724(a5) # 80006b80 <blocked>
        blend=blocked;
    80002e5c:	00004797          	auipc	a5,0x4
    80002e60:	d0a7be23          	sd	a0,-740(a5) # 80006b78 <blend>
        return 0;
    80002e64:	00000513          	li	a0,0
    80002e68:	fd5ff06f          	j	80002e3c <putblocked+0x64>
    if(!pom)return -1;
    80002e6c:	fff00513          	li	a0,-1
    80002e70:	fcdff06f          	j	80002e3c <putblocked+0x64>

0000000080002e74 <sc_in>:
int sc_in(uint64 id){
    80002e74:	ff010113          	addi	sp,sp,-16
    80002e78:	00813423          	sd	s0,8(sp)
    80002e7c:	01010413          	addi	s0,sp,16
    for(sched s=scheduler;s;s=s->next){
    80002e80:	00004797          	auipc	a5,0x4
    80002e84:	d107b783          	ld	a5,-752(a5) # 80006b90 <scheduler>
    80002e88:	00078c63          	beqz	a5,80002ea0 <sc_in+0x2c>
        if(s->data->id==id) return 1;
    80002e8c:	0007b703          	ld	a4,0(a5)
    80002e90:	00073703          	ld	a4,0(a4)
    80002e94:	00a70e63          	beq	a4,a0,80002eb0 <sc_in+0x3c>
    for(sched s=scheduler;s;s=s->next){
    80002e98:	0087b783          	ld	a5,8(a5)
    80002e9c:	fedff06f          	j	80002e88 <sc_in+0x14>
    }
    return 0;
    80002ea0:	00000513          	li	a0,0
}
    80002ea4:	00813403          	ld	s0,8(sp)
    80002ea8:	01010113          	addi	sp,sp,16
    80002eac:	00008067          	ret
        if(s->data->id==id) return 1;
    80002eb0:	00100513          	li	a0,1
    80002eb4:	ff1ff06f          	j	80002ea4 <sc_in+0x30>

0000000080002eb8 <_Z11printStringPKc>:

#define LOCK() while(copy_and_swap(lockPrint, 0, 1))
#define UNLOCK() while(copy_and_swap(lockPrint, 1, 0))

void printString(char const *string)
{
    80002eb8:	fe010113          	addi	sp,sp,-32
    80002ebc:	00113c23          	sd	ra,24(sp)
    80002ec0:	00813823          	sd	s0,16(sp)
    80002ec4:	00913423          	sd	s1,8(sp)
    80002ec8:	02010413          	addi	s0,sp,32
    80002ecc:	00050493          	mv	s1,a0
    LOCK();
    80002ed0:	00100613          	li	a2,1
    80002ed4:	00000593          	li	a1,0
    80002ed8:	00004517          	auipc	a0,0x4
    80002edc:	ce850513          	addi	a0,a0,-792 # 80006bc0 <lockPrint>
    80002ee0:	ffffe097          	auipc	ra,0xffffe
    80002ee4:	120080e7          	jalr	288(ra) # 80001000 <copy_and_swap>
    80002ee8:	fe0514e3          	bnez	a0,80002ed0 <_Z11printStringPKc+0x18>
    while (*string != '\0')
    80002eec:	0004c503          	lbu	a0,0(s1)
    80002ef0:	00050a63          	beqz	a0,80002f04 <_Z11printStringPKc+0x4c>
    {
        putc(*string);
    80002ef4:	fffff097          	auipc	ra,0xfffff
    80002ef8:	76c080e7          	jalr	1900(ra) # 80002660 <putc>
        string++;
    80002efc:	00148493          	addi	s1,s1,1
    while (*string != '\0')
    80002f00:	fedff06f          	j	80002eec <_Z11printStringPKc+0x34>
    }
    UNLOCK();
    80002f04:	00000613          	li	a2,0
    80002f08:	00100593          	li	a1,1
    80002f0c:	00004517          	auipc	a0,0x4
    80002f10:	cb450513          	addi	a0,a0,-844 # 80006bc0 <lockPrint>
    80002f14:	ffffe097          	auipc	ra,0xffffe
    80002f18:	0ec080e7          	jalr	236(ra) # 80001000 <copy_and_swap>
    80002f1c:	fe0514e3          	bnez	a0,80002f04 <_Z11printStringPKc+0x4c>
}
    80002f20:	01813083          	ld	ra,24(sp)
    80002f24:	01013403          	ld	s0,16(sp)
    80002f28:	00813483          	ld	s1,8(sp)
    80002f2c:	02010113          	addi	sp,sp,32
    80002f30:	00008067          	ret

0000000080002f34 <_Z9getStringPci>:

char* getString(char *buf, int max) {
    80002f34:	fd010113          	addi	sp,sp,-48
    80002f38:	02113423          	sd	ra,40(sp)
    80002f3c:	02813023          	sd	s0,32(sp)
    80002f40:	00913c23          	sd	s1,24(sp)
    80002f44:	01213823          	sd	s2,16(sp)
    80002f48:	01313423          	sd	s3,8(sp)
    80002f4c:	01413023          	sd	s4,0(sp)
    80002f50:	03010413          	addi	s0,sp,48
    80002f54:	00050993          	mv	s3,a0
    80002f58:	00058a13          	mv	s4,a1
    LOCK();
    80002f5c:	00100613          	li	a2,1
    80002f60:	00000593          	li	a1,0
    80002f64:	00004517          	auipc	a0,0x4
    80002f68:	c5c50513          	addi	a0,a0,-932 # 80006bc0 <lockPrint>
    80002f6c:	ffffe097          	auipc	ra,0xffffe
    80002f70:	094080e7          	jalr	148(ra) # 80001000 <copy_and_swap>
    80002f74:	fe0514e3          	bnez	a0,80002f5c <_Z9getStringPci+0x28>
    int i, cc;
    char c;

    for(i=0; i+1 < max; ){
    80002f78:	00000913          	li	s2,0
    80002f7c:	00090493          	mv	s1,s2
    80002f80:	0019091b          	addiw	s2,s2,1
    80002f84:	03495a63          	bge	s2,s4,80002fb8 <_Z9getStringPci+0x84>
        cc = getc();
    80002f88:	fffff097          	auipc	ra,0xfffff
    80002f8c:	674080e7          	jalr	1652(ra) # 800025fc <getc>
        if(cc < 1)
    80002f90:	02050463          	beqz	a0,80002fb8 <_Z9getStringPci+0x84>
            break;
        c = cc;
        buf[i++] = c;
    80002f94:	009984b3          	add	s1,s3,s1
    80002f98:	00a48023          	sb	a0,0(s1)
        if(c == '\n' || c == '\r')
    80002f9c:	00a00793          	li	a5,10
    80002fa0:	00f50a63          	beq	a0,a5,80002fb4 <_Z9getStringPci+0x80>
    80002fa4:	00d00793          	li	a5,13
    80002fa8:	fcf51ae3          	bne	a0,a5,80002f7c <_Z9getStringPci+0x48>
        buf[i++] = c;
    80002fac:	00090493          	mv	s1,s2
    80002fb0:	0080006f          	j	80002fb8 <_Z9getStringPci+0x84>
    80002fb4:	00090493          	mv	s1,s2
            break;
    }
    buf[i] = '\0';
    80002fb8:	009984b3          	add	s1,s3,s1
    80002fbc:	00048023          	sb	zero,0(s1)

    UNLOCK();
    80002fc0:	00000613          	li	a2,0
    80002fc4:	00100593          	li	a1,1
    80002fc8:	00004517          	auipc	a0,0x4
    80002fcc:	bf850513          	addi	a0,a0,-1032 # 80006bc0 <lockPrint>
    80002fd0:	ffffe097          	auipc	ra,0xffffe
    80002fd4:	030080e7          	jalr	48(ra) # 80001000 <copy_and_swap>
    80002fd8:	fe0514e3          	bnez	a0,80002fc0 <_Z9getStringPci+0x8c>
    return buf;
}
    80002fdc:	00098513          	mv	a0,s3
    80002fe0:	02813083          	ld	ra,40(sp)
    80002fe4:	02013403          	ld	s0,32(sp)
    80002fe8:	01813483          	ld	s1,24(sp)
    80002fec:	01013903          	ld	s2,16(sp)
    80002ff0:	00813983          	ld	s3,8(sp)
    80002ff4:	00013a03          	ld	s4,0(sp)
    80002ff8:	03010113          	addi	sp,sp,48
    80002ffc:	00008067          	ret

0000000080003000 <_Z11stringToIntPKc>:

int stringToInt(const char *s) {
    80003000:	ff010113          	addi	sp,sp,-16
    80003004:	00813423          	sd	s0,8(sp)
    80003008:	01010413          	addi	s0,sp,16
    8000300c:	00050693          	mv	a3,a0
    int n;

    n = 0;
    80003010:	00000513          	li	a0,0
    while ('0' <= *s && *s <= '9')
    80003014:	0006c603          	lbu	a2,0(a3)
    80003018:	fd06071b          	addiw	a4,a2,-48
    8000301c:	0ff77713          	andi	a4,a4,255
    80003020:	00900793          	li	a5,9
    80003024:	02e7e063          	bltu	a5,a4,80003044 <_Z11stringToIntPKc+0x44>
        n = n * 10 + *s++ - '0';
    80003028:	0025179b          	slliw	a5,a0,0x2
    8000302c:	00a787bb          	addw	a5,a5,a0
    80003030:	0017979b          	slliw	a5,a5,0x1
    80003034:	00168693          	addi	a3,a3,1
    80003038:	00c787bb          	addw	a5,a5,a2
    8000303c:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
    80003040:	fd5ff06f          	j	80003014 <_Z11stringToIntPKc+0x14>
    return n;
}
    80003044:	00813403          	ld	s0,8(sp)
    80003048:	01010113          	addi	sp,sp,16
    8000304c:	00008067          	ret

0000000080003050 <_Z8printIntiii>:

char digits[] = "0123456789ABCDEF";

void printInt(int xx, int base, int sgn)
{
    80003050:	fc010113          	addi	sp,sp,-64
    80003054:	02113c23          	sd	ra,56(sp)
    80003058:	02813823          	sd	s0,48(sp)
    8000305c:	02913423          	sd	s1,40(sp)
    80003060:	03213023          	sd	s2,32(sp)
    80003064:	01313c23          	sd	s3,24(sp)
    80003068:	04010413          	addi	s0,sp,64
    8000306c:	00050493          	mv	s1,a0
    80003070:	00058913          	mv	s2,a1
    80003074:	00060993          	mv	s3,a2
    LOCK();
    80003078:	00100613          	li	a2,1
    8000307c:	00000593          	li	a1,0
    80003080:	00004517          	auipc	a0,0x4
    80003084:	b4050513          	addi	a0,a0,-1216 # 80006bc0 <lockPrint>
    80003088:	ffffe097          	auipc	ra,0xffffe
    8000308c:	f78080e7          	jalr	-136(ra) # 80001000 <copy_and_swap>
    80003090:	fe0514e3          	bnez	a0,80003078 <_Z8printIntiii+0x28>
    char buf[16];
    int i, neg;
    uint x;

    neg = 0;
    if(sgn && xx < 0){
    80003094:	00098463          	beqz	s3,8000309c <_Z8printIntiii+0x4c>
    80003098:	0804c463          	bltz	s1,80003120 <_Z8printIntiii+0xd0>
        neg = 1;
        x = -xx;
    } else {
        x = xx;
    8000309c:	0004851b          	sext.w	a0,s1
    neg = 0;
    800030a0:	00000593          	li	a1,0
    }

    i = 0;
    800030a4:	00000493          	li	s1,0
    do{
        buf[i++] = digits[x % base];
    800030a8:	0009079b          	sext.w	a5,s2
    800030ac:	0325773b          	remuw	a4,a0,s2
    800030b0:	00048613          	mv	a2,s1
    800030b4:	0014849b          	addiw	s1,s1,1
    800030b8:	02071693          	slli	a3,a4,0x20
    800030bc:	0206d693          	srli	a3,a3,0x20
    800030c0:	00004717          	auipc	a4,0x4
    800030c4:	8f070713          	addi	a4,a4,-1808 # 800069b0 <digits>
    800030c8:	00d70733          	add	a4,a4,a3
    800030cc:	00074683          	lbu	a3,0(a4)
    800030d0:	fd040713          	addi	a4,s0,-48
    800030d4:	00c70733          	add	a4,a4,a2
    800030d8:	fed70823          	sb	a3,-16(a4)
    }while((x /= base) != 0);
    800030dc:	0005071b          	sext.w	a4,a0
    800030e0:	0325553b          	divuw	a0,a0,s2
    800030e4:	fcf772e3          	bgeu	a4,a5,800030a8 <_Z8printIntiii+0x58>
    if(neg)
    800030e8:	00058c63          	beqz	a1,80003100 <_Z8printIntiii+0xb0>
        buf[i++] = '-';
    800030ec:	fd040793          	addi	a5,s0,-48
    800030f0:	009784b3          	add	s1,a5,s1
    800030f4:	02d00793          	li	a5,45
    800030f8:	fef48823          	sb	a5,-16(s1)
    800030fc:	0026049b          	addiw	s1,a2,2

    while(--i >= 0)
    80003100:	fff4849b          	addiw	s1,s1,-1
    80003104:	0204c463          	bltz	s1,8000312c <_Z8printIntiii+0xdc>
        putc(buf[i]);
    80003108:	fd040793          	addi	a5,s0,-48
    8000310c:	009787b3          	add	a5,a5,s1
    80003110:	ff07c503          	lbu	a0,-16(a5)
    80003114:	fffff097          	auipc	ra,0xfffff
    80003118:	54c080e7          	jalr	1356(ra) # 80002660 <putc>
    8000311c:	fe5ff06f          	j	80003100 <_Z8printIntiii+0xb0>
        x = -xx;
    80003120:	4090053b          	negw	a0,s1
        neg = 1;
    80003124:	00100593          	li	a1,1
        x = -xx;
    80003128:	f7dff06f          	j	800030a4 <_Z8printIntiii+0x54>

    UNLOCK();
    8000312c:	00000613          	li	a2,0
    80003130:	00100593          	li	a1,1
    80003134:	00004517          	auipc	a0,0x4
    80003138:	a8c50513          	addi	a0,a0,-1396 # 80006bc0 <lockPrint>
    8000313c:	ffffe097          	auipc	ra,0xffffe
    80003140:	ec4080e7          	jalr	-316(ra) # 80001000 <copy_and_swap>
    80003144:	fe0514e3          	bnez	a0,8000312c <_Z8printIntiii+0xdc>
}
    80003148:	03813083          	ld	ra,56(sp)
    8000314c:	03013403          	ld	s0,48(sp)
    80003150:	02813483          	ld	s1,40(sp)
    80003154:	02013903          	ld	s2,32(sp)
    80003158:	01813983          	ld	s3,24(sp)
    8000315c:	04010113          	addi	sp,sp,64
    80003160:	00008067          	ret

0000000080003164 <userMain>:
        printString("Action1\n");
    }

};

void userMain() {
    80003164:	fe010113          	addi	sp,sp,-32
    80003168:	00113c23          	sd	ra,24(sp)
    8000316c:	00813823          	sd	s0,16(sp)
    80003170:	00913423          	sd	s1,8(sp)
    80003174:	01213023          	sd	s2,0(sp)
    80003178:	02010413          	addi	s0,sp,32
   // Pthread* p = new Pthread(20);
    RunThread* r = new RunThread();
    8000317c:	01000513          	li	a0,16
    80003180:	00000097          	auipc	ra,0x0
    80003184:	25c080e7          	jalr	604(ra) # 800033dc <_Znwm>
    80003188:	00050913          	mv	s2,a0
    public:RunThread():Thread(){}
    8000318c:	00000097          	auipc	ra,0x0
    80003190:	42c080e7          	jalr	1068(ra) # 800035b8 <_ZN6ThreadC1Ev>
    80003194:	00004797          	auipc	a5,0x4
    80003198:	84478793          	addi	a5,a5,-1980 # 800069d8 <_ZTV9RunThread+0x10>
    8000319c:	00f93023          	sd	a5,0(s2)
    RunThread1* r1 = new RunThread1();
    800031a0:	01000513          	li	a0,16
    800031a4:	00000097          	auipc	ra,0x0
    800031a8:	238080e7          	jalr	568(ra) # 800033dc <_Znwm>
    800031ac:	00050493          	mv	s1,a0
public:RunThread1():Thread(){}
    800031b0:	00000097          	auipc	ra,0x0
    800031b4:	408080e7          	jalr	1032(ra) # 800035b8 <_ZN6ThreadC1Ev>
    800031b8:	00004797          	auipc	a5,0x4
    800031bc:	84878793          	addi	a5,a5,-1976 # 80006a00 <_ZTV10RunThread1+0x10>
    800031c0:	00f4b023          	sd	a5,0(s1)
    r->start();
    800031c4:	00090513          	mv	a0,s2
    800031c8:	00000097          	auipc	ra,0x0
    800031cc:	444080e7          	jalr	1092(ra) # 8000360c <_ZN6Thread5startEv>
    r1->start();
    800031d0:	00048513          	mv	a0,s1
    800031d4:	00000097          	auipc	ra,0x0
    800031d8:	438080e7          	jalr	1080(ra) # 8000360c <_ZN6Thread5startEv>
    while(1){
    800031dc:	0000006f          	j	800031dc <userMain+0x78>
    800031e0:	00050493          	mv	s1,a0
    RunThread* r = new RunThread();
    800031e4:	00090513          	mv	a0,s2
    800031e8:	00000097          	auipc	ra,0x0
    800031ec:	244080e7          	jalr	580(ra) # 8000342c <_ZdlPv>
    800031f0:	00048513          	mv	a0,s1
    800031f4:	00005097          	auipc	ra,0x5
    800031f8:	aa4080e7          	jalr	-1372(ra) # 80007c98 <_Unwind_Resume>
    800031fc:	00050913          	mv	s2,a0
    RunThread1* r1 = new RunThread1();
    80003200:	00048513          	mv	a0,s1
    80003204:	00000097          	auipc	ra,0x0
    80003208:	228080e7          	jalr	552(ra) # 8000342c <_ZdlPv>
    8000320c:	00090513          	mv	a0,s2
    80003210:	00005097          	auipc	ra,0x5
    80003214:	a88080e7          	jalr	-1400(ra) # 80007c98 <_Unwind_Resume>

0000000080003218 <_ZN9RunThread3runEv>:
    private: void run() override{
    80003218:	ff010113          	addi	sp,sp,-16
    8000321c:	00113423          	sd	ra,8(sp)
    80003220:	00813023          	sd	s0,0(sp)
    80003224:	01010413          	addi	s0,sp,16
            printString("Action\n");
    80003228:	00003517          	auipc	a0,0x3
    8000322c:	f0850513          	addi	a0,a0,-248 # 80006130 <CONSOLE_STATUS+0x120>
    80003230:	00000097          	auipc	ra,0x0
    80003234:	c88080e7          	jalr	-888(ra) # 80002eb8 <_Z11printStringPKc>
    }
    80003238:	00813083          	ld	ra,8(sp)
    8000323c:	00013403          	ld	s0,0(sp)
    80003240:	01010113          	addi	sp,sp,16
    80003244:	00008067          	ret

0000000080003248 <_ZN10RunThread13runEv>:
private: void run() override{
    80003248:	ff010113          	addi	sp,sp,-16
    8000324c:	00113423          	sd	ra,8(sp)
    80003250:	00813023          	sd	s0,0(sp)
    80003254:	01010413          	addi	s0,sp,16
        printString("Action1\n");
    80003258:	00003517          	auipc	a0,0x3
    8000325c:	ee050513          	addi	a0,a0,-288 # 80006138 <CONSOLE_STATUS+0x128>
    80003260:	00000097          	auipc	ra,0x0
    80003264:	c58080e7          	jalr	-936(ra) # 80002eb8 <_Z11printStringPKc>
    }
    80003268:	00813083          	ld	ra,8(sp)
    8000326c:	00013403          	ld	s0,0(sp)
    80003270:	01010113          	addi	sp,sp,16
    80003274:	00008067          	ret

0000000080003278 <_ZN9RunThreadD1Ev>:
    class RunThread:public Thread{
    80003278:	ff010113          	addi	sp,sp,-16
    8000327c:	00113423          	sd	ra,8(sp)
    80003280:	00813023          	sd	s0,0(sp)
    80003284:	01010413          	addi	s0,sp,16
    80003288:	00003797          	auipc	a5,0x3
    8000328c:	75078793          	addi	a5,a5,1872 # 800069d8 <_ZTV9RunThread+0x10>
    80003290:	00f53023          	sd	a5,0(a0)
    80003294:	00000097          	auipc	ra,0x0
    80003298:	228080e7          	jalr	552(ra) # 800034bc <_ZN6ThreadD1Ev>
    8000329c:	00813083          	ld	ra,8(sp)
    800032a0:	00013403          	ld	s0,0(sp)
    800032a4:	01010113          	addi	sp,sp,16
    800032a8:	00008067          	ret

00000000800032ac <_ZN9RunThreadD0Ev>:
    800032ac:	fe010113          	addi	sp,sp,-32
    800032b0:	00113c23          	sd	ra,24(sp)
    800032b4:	00813823          	sd	s0,16(sp)
    800032b8:	00913423          	sd	s1,8(sp)
    800032bc:	02010413          	addi	s0,sp,32
    800032c0:	00050493          	mv	s1,a0
    800032c4:	00003797          	auipc	a5,0x3
    800032c8:	71478793          	addi	a5,a5,1812 # 800069d8 <_ZTV9RunThread+0x10>
    800032cc:	00f53023          	sd	a5,0(a0)
    800032d0:	00000097          	auipc	ra,0x0
    800032d4:	1ec080e7          	jalr	492(ra) # 800034bc <_ZN6ThreadD1Ev>
    800032d8:	00048513          	mv	a0,s1
    800032dc:	00000097          	auipc	ra,0x0
    800032e0:	150080e7          	jalr	336(ra) # 8000342c <_ZdlPv>
    800032e4:	01813083          	ld	ra,24(sp)
    800032e8:	01013403          	ld	s0,16(sp)
    800032ec:	00813483          	ld	s1,8(sp)
    800032f0:	02010113          	addi	sp,sp,32
    800032f4:	00008067          	ret

00000000800032f8 <_ZN10RunThread1D1Ev>:
class RunThread1:public Thread{
    800032f8:	ff010113          	addi	sp,sp,-16
    800032fc:	00113423          	sd	ra,8(sp)
    80003300:	00813023          	sd	s0,0(sp)
    80003304:	01010413          	addi	s0,sp,16
    80003308:	00003797          	auipc	a5,0x3
    8000330c:	6f878793          	addi	a5,a5,1784 # 80006a00 <_ZTV10RunThread1+0x10>
    80003310:	00f53023          	sd	a5,0(a0)
    80003314:	00000097          	auipc	ra,0x0
    80003318:	1a8080e7          	jalr	424(ra) # 800034bc <_ZN6ThreadD1Ev>
    8000331c:	00813083          	ld	ra,8(sp)
    80003320:	00013403          	ld	s0,0(sp)
    80003324:	01010113          	addi	sp,sp,16
    80003328:	00008067          	ret

000000008000332c <_ZN10RunThread1D0Ev>:
    8000332c:	fe010113          	addi	sp,sp,-32
    80003330:	00113c23          	sd	ra,24(sp)
    80003334:	00813823          	sd	s0,16(sp)
    80003338:	00913423          	sd	s1,8(sp)
    8000333c:	02010413          	addi	s0,sp,32
    80003340:	00050493          	mv	s1,a0
    80003344:	00003797          	auipc	a5,0x3
    80003348:	6bc78793          	addi	a5,a5,1724 # 80006a00 <_ZTV10RunThread1+0x10>
    8000334c:	00f53023          	sd	a5,0(a0)
    80003350:	00000097          	auipc	ra,0x0
    80003354:	16c080e7          	jalr	364(ra) # 800034bc <_ZN6ThreadD1Ev>
    80003358:	00048513          	mv	a0,s1
    8000335c:	00000097          	auipc	ra,0x0
    80003360:	0d0080e7          	jalr	208(ra) # 8000342c <_ZdlPv>
    80003364:	01813083          	ld	ra,24(sp)
    80003368:	01013403          	ld	s0,16(sp)
    8000336c:	00813483          	ld	s1,8(sp)
    80003370:	02010113          	addi	sp,sp,32
    80003374:	00008067          	ret

0000000080003378 <_ZN6Thread7wrapperEPv>:
void operator delete[](void *p)
{
 mem_free(p);
}

void Thread::wrapper(void* t) {
    80003378:	ff010113          	addi	sp,sp,-16
    8000337c:	00113423          	sd	ra,8(sp)
    80003380:	00813023          	sd	s0,0(sp)
    80003384:	01010413          	addi	s0,sp,16
    ((Thread*)t)->run();
    80003388:	00053783          	ld	a5,0(a0)
    8000338c:	0107b783          	ld	a5,16(a5)
    80003390:	000780e7          	jalr	a5
}
    80003394:	00813083          	ld	ra,8(sp)
    80003398:	00013403          	ld	s0,0(sp)
    8000339c:	01010113          	addi	sp,sp,16
    800033a0:	00008067          	ret

00000000800033a4 <_ZN9SemaphoreD1Ev>:
}

int Thread::sleep(time_t time) {
    return time_sleep(time);
}
Semaphore::~Semaphore() {
    800033a4:	ff010113          	addi	sp,sp,-16
    800033a8:	00113423          	sd	ra,8(sp)
    800033ac:	00813023          	sd	s0,0(sp)
    800033b0:	01010413          	addi	s0,sp,16
    800033b4:	00003797          	auipc	a5,0x3
    800033b8:	6a478793          	addi	a5,a5,1700 # 80006a58 <_ZTV9Semaphore+0x10>
    800033bc:	00f53023          	sd	a5,0(a0)
    sem_close(this->myHandle);
    800033c0:	00853503          	ld	a0,8(a0)
    800033c4:	fffff097          	auipc	ra,0xfffff
    800033c8:	660080e7          	jalr	1632(ra) # 80002a24 <sem_close>
}
    800033cc:	00813083          	ld	ra,8(sp)
    800033d0:	00013403          	ld	s0,0(sp)
    800033d4:	01010113          	addi	sp,sp,16
    800033d8:	00008067          	ret

00000000800033dc <_Znwm>:
{
    800033dc:	ff010113          	addi	sp,sp,-16
    800033e0:	00113423          	sd	ra,8(sp)
    800033e4:	00813023          	sd	s0,0(sp)
    800033e8:	01010413          	addi	s0,sp,16
    return mem_alloc(n);
    800033ec:	fffff097          	auipc	ra,0xfffff
    800033f0:	588080e7          	jalr	1416(ra) # 80002974 <mem_alloc>
}
    800033f4:	00813083          	ld	ra,8(sp)
    800033f8:	00013403          	ld	s0,0(sp)
    800033fc:	01010113          	addi	sp,sp,16
    80003400:	00008067          	ret

0000000080003404 <_Znam>:
{
    80003404:	ff010113          	addi	sp,sp,-16
    80003408:	00113423          	sd	ra,8(sp)
    8000340c:	00813023          	sd	s0,0(sp)
    80003410:	01010413          	addi	s0,sp,16
    return mem_alloc(n);
    80003414:	fffff097          	auipc	ra,0xfffff
    80003418:	560080e7          	jalr	1376(ra) # 80002974 <mem_alloc>
}
    8000341c:	00813083          	ld	ra,8(sp)
    80003420:	00013403          	ld	s0,0(sp)
    80003424:	01010113          	addi	sp,sp,16
    80003428:	00008067          	ret

000000008000342c <_ZdlPv>:
{
    8000342c:	ff010113          	addi	sp,sp,-16
    80003430:	00113423          	sd	ra,8(sp)
    80003434:	00813023          	sd	s0,0(sp)
    80003438:	01010413          	addi	s0,sp,16
 mem_free(p);
    8000343c:	fffff097          	auipc	ra,0xfffff
    80003440:	568080e7          	jalr	1384(ra) # 800029a4 <mem_free>
}
    80003444:	00813083          	ld	ra,8(sp)
    80003448:	00013403          	ld	s0,0(sp)
    8000344c:	01010113          	addi	sp,sp,16
    80003450:	00008067          	ret

0000000080003454 <_ZN9SemaphoreD0Ev>:
Semaphore::~Semaphore() {
    80003454:	fe010113          	addi	sp,sp,-32
    80003458:	00113c23          	sd	ra,24(sp)
    8000345c:	00813823          	sd	s0,16(sp)
    80003460:	00913423          	sd	s1,8(sp)
    80003464:	02010413          	addi	s0,sp,32
    80003468:	00050493          	mv	s1,a0
}
    8000346c:	00000097          	auipc	ra,0x0
    80003470:	f38080e7          	jalr	-200(ra) # 800033a4 <_ZN9SemaphoreD1Ev>
    80003474:	00048513          	mv	a0,s1
    80003478:	00000097          	auipc	ra,0x0
    8000347c:	fb4080e7          	jalr	-76(ra) # 8000342c <_ZdlPv>
    80003480:	01813083          	ld	ra,24(sp)
    80003484:	01013403          	ld	s0,16(sp)
    80003488:	00813483          	ld	s1,8(sp)
    8000348c:	02010113          	addi	sp,sp,32
    80003490:	00008067          	ret

0000000080003494 <_ZdaPv>:
{
    80003494:	ff010113          	addi	sp,sp,-16
    80003498:	00113423          	sd	ra,8(sp)
    8000349c:	00813023          	sd	s0,0(sp)
    800034a0:	01010413          	addi	s0,sp,16
 mem_free(p);
    800034a4:	fffff097          	auipc	ra,0xfffff
    800034a8:	500080e7          	jalr	1280(ra) # 800029a4 <mem_free>
}
    800034ac:	00813083          	ld	ra,8(sp)
    800034b0:	00013403          	ld	s0,0(sp)
    800034b4:	01010113          	addi	sp,sp,16
    800034b8:	00008067          	ret

00000000800034bc <_ZN6ThreadD1Ev>:
Thread::~Thread() {
    800034bc:	fe010113          	addi	sp,sp,-32
    800034c0:	00113c23          	sd	ra,24(sp)
    800034c4:	00813823          	sd	s0,16(sp)
    800034c8:	00913423          	sd	s1,8(sp)
    800034cc:	02010413          	addi	s0,sp,32
    800034d0:	00050493          	mv	s1,a0
    800034d4:	00003797          	auipc	a5,0x3
    800034d8:	55c78793          	addi	a5,a5,1372 # 80006a30 <_ZTV6Thread+0x10>
    800034dc:	00f53023          	sd	a5,0(a0)
    delete this->myHandle->context;
    800034e0:	00853783          	ld	a5,8(a0)
    800034e4:	0087b503          	ld	a0,8(a5)
    800034e8:	00050663          	beqz	a0,800034f4 <_ZN6ThreadD1Ev+0x38>
    800034ec:	00000097          	auipc	ra,0x0
    800034f0:	f40080e7          	jalr	-192(ra) # 8000342c <_ZdlPv>
    delete[] this->myHandle->stack;
    800034f4:	0084b783          	ld	a5,8(s1)
    800034f8:	0107b503          	ld	a0,16(a5)
    800034fc:	00050663          	beqz	a0,80003508 <_ZN6ThreadD1Ev+0x4c>
    80003500:	00000097          	auipc	ra,0x0
    80003504:	f94080e7          	jalr	-108(ra) # 80003494 <_ZdaPv>
    delete this->myHandle;
    80003508:	0084b503          	ld	a0,8(s1)
    8000350c:	00050663          	beqz	a0,80003518 <_ZN6ThreadD1Ev+0x5c>
    80003510:	00000097          	auipc	ra,0x0
    80003514:	f1c080e7          	jalr	-228(ra) # 8000342c <_ZdlPv>
}
    80003518:	01813083          	ld	ra,24(sp)
    8000351c:	01013403          	ld	s0,16(sp)
    80003520:	00813483          	ld	s1,8(sp)
    80003524:	02010113          	addi	sp,sp,32
    80003528:	00008067          	ret

000000008000352c <_ZN6ThreadD0Ev>:
Thread::~Thread() {
    8000352c:	fe010113          	addi	sp,sp,-32
    80003530:	00113c23          	sd	ra,24(sp)
    80003534:	00813823          	sd	s0,16(sp)
    80003538:	00913423          	sd	s1,8(sp)
    8000353c:	02010413          	addi	s0,sp,32
    80003540:	00050493          	mv	s1,a0
}
    80003544:	00000097          	auipc	ra,0x0
    80003548:	f78080e7          	jalr	-136(ra) # 800034bc <_ZN6ThreadD1Ev>
    8000354c:	00048513          	mv	a0,s1
    80003550:	00000097          	auipc	ra,0x0
    80003554:	edc080e7          	jalr	-292(ra) # 8000342c <_ZdlPv>
    80003558:	01813083          	ld	ra,24(sp)
    8000355c:	01013403          	ld	s0,16(sp)
    80003560:	00813483          	ld	s1,8(sp)
    80003564:	02010113          	addi	sp,sp,32
    80003568:	00008067          	ret

000000008000356c <_ZN6ThreadC1EPFvPvES0_>:
Thread::Thread (void (*body)(void*),void* arg){
    8000356c:	fe010113          	addi	sp,sp,-32
    80003570:	00113c23          	sd	ra,24(sp)
    80003574:	00813823          	sd	s0,16(sp)
    80003578:	00913423          	sd	s1,8(sp)
    8000357c:	02010413          	addi	s0,sp,32
    80003580:	00050493          	mv	s1,a0
    80003584:	00003797          	auipc	a5,0x3
    80003588:	4ac78793          	addi	a5,a5,1196 # 80006a30 <_ZTV6Thread+0x10>
    8000358c:	00f53023          	sd	a5,0(a0)
    thread_create(&(this->myHandle),body,arg);
    80003590:	00850513          	addi	a0,a0,8
    80003594:	fffff097          	auipc	ra,0xfffff
    80003598:	5a8080e7          	jalr	1448(ra) # 80002b3c <thread_create>
    this->myHandle->state=CREATED;
    8000359c:	0084b783          	ld	a5,8(s1)
    800035a0:	0007ac23          	sw	zero,24(a5)
}
    800035a4:	01813083          	ld	ra,24(sp)
    800035a8:	01013403          	ld	s0,16(sp)
    800035ac:	00813483          	ld	s1,8(sp)
    800035b0:	02010113          	addi	sp,sp,32
    800035b4:	00008067          	ret

00000000800035b8 <_ZN6ThreadC1Ev>:
Thread::Thread() {
    800035b8:	fe010113          	addi	sp,sp,-32
    800035bc:	00113c23          	sd	ra,24(sp)
    800035c0:	00813823          	sd	s0,16(sp)
    800035c4:	00913423          	sd	s1,8(sp)
    800035c8:	02010413          	addi	s0,sp,32
    800035cc:	00050493          	mv	s1,a0
    800035d0:	00003797          	auipc	a5,0x3
    800035d4:	46078793          	addi	a5,a5,1120 # 80006a30 <_ZTV6Thread+0x10>
    800035d8:	00f53023          	sd	a5,0(a0)
    thread_create(&(this->myHandle),0,this);
    800035dc:	00050613          	mv	a2,a0
    800035e0:	00000593          	li	a1,0
    800035e4:	00850513          	addi	a0,a0,8
    800035e8:	fffff097          	auipc	ra,0xfffff
    800035ec:	554080e7          	jalr	1364(ra) # 80002b3c <thread_create>
    this->myHandle->state=CREATED;
    800035f0:	0084b783          	ld	a5,8(s1)
    800035f4:	0007ac23          	sw	zero,24(a5)
}
    800035f8:	01813083          	ld	ra,24(sp)
    800035fc:	01013403          	ld	s0,16(sp)
    80003600:	00813483          	ld	s1,8(sp)
    80003604:	02010113          	addi	sp,sp,32
    80003608:	00008067          	ret

000000008000360c <_ZN6Thread5startEv>:
int Thread::start() {
    8000360c:	ff010113          	addi	sp,sp,-16
    80003610:	00813423          	sd	s0,8(sp)
    80003614:	01010413          	addi	s0,sp,16
    if(this->myHandle->start_routine==0){
    80003618:	00853783          	ld	a5,8(a0)
    8000361c:	0207b703          	ld	a4,32(a5)
    80003620:	02070063          	beqz	a4,80003640 <_ZN6Thread5startEv+0x34>
    this->myHandle->state=READY;
    80003624:	00853783          	ld	a5,8(a0)
    80003628:	00100713          	li	a4,1
    8000362c:	00e7ac23          	sw	a4,24(a5)
}
    80003630:	00000513          	li	a0,0
    80003634:	00813403          	ld	s0,8(sp)
    80003638:	01010113          	addi	sp,sp,16
    8000363c:	00008067          	ret
        this->myHandle->start_routine=&Thread::wrapper;
    80003640:	00000717          	auipc	a4,0x0
    80003644:	d3870713          	addi	a4,a4,-712 # 80003378 <_ZN6Thread7wrapperEPv>
    80003648:	02e7b023          	sd	a4,32(a5)
        this->myHandle->arg=this;
    8000364c:	00853783          	ld	a5,8(a0)
    80003650:	02a7b423          	sd	a0,40(a5)
    80003654:	fd1ff06f          	j	80003624 <_ZN6Thread5startEv+0x18>

0000000080003658 <_ZN6Thread8dispatchEv>:
void Thread::dispatch() {
    80003658:	ff010113          	addi	sp,sp,-16
    8000365c:	00113423          	sd	ra,8(sp)
    80003660:	00813023          	sd	s0,0(sp)
    80003664:	01010413          	addi	s0,sp,16
    thread_dispatch();
    80003668:	fffff097          	auipc	ra,0xfffff
    8000366c:	4b4080e7          	jalr	1204(ra) # 80002b1c <thread_dispatch>
}
    80003670:	00813083          	ld	ra,8(sp)
    80003674:	00013403          	ld	s0,0(sp)
    80003678:	01010113          	addi	sp,sp,16
    8000367c:	00008067          	ret

0000000080003680 <_ZN6Thread5sleepEm>:
int Thread::sleep(time_t time) {
    80003680:	ff010113          	addi	sp,sp,-16
    80003684:	00113423          	sd	ra,8(sp)
    80003688:	00813023          	sd	s0,0(sp)
    8000368c:	01010413          	addi	s0,sp,16
    return time_sleep(time);
    80003690:	fffff097          	auipc	ra,0xfffff
    80003694:	45c080e7          	jalr	1116(ra) # 80002aec <time_sleep>
}
    80003698:	00813083          	ld	ra,8(sp)
    8000369c:	00013403          	ld	s0,0(sp)
    800036a0:	01010113          	addi	sp,sp,16
    800036a4:	00008067          	ret

00000000800036a8 <_ZN14PeriodicThread3runEv>:
    myHandle->period=period;


}

void PeriodicThread::run() {
    800036a8:	fe010113          	addi	sp,sp,-32
    800036ac:	00113c23          	sd	ra,24(sp)
    800036b0:	00813823          	sd	s0,16(sp)
    800036b4:	00913423          	sd	s1,8(sp)
    800036b8:	02010413          	addi	s0,sp,32
    800036bc:	00050493          	mv	s1,a0
    while(1){
        this->periodicActivation();
    800036c0:	0004b783          	ld	a5,0(s1)
    800036c4:	0187b783          	ld	a5,24(a5)
    800036c8:	00048513          	mv	a0,s1
    800036cc:	000780e7          	jalr	a5
        this->sleep(myHandle->period);
    800036d0:	0084b783          	ld	a5,8(s1)
    800036d4:	0387b503          	ld	a0,56(a5)
    800036d8:	00000097          	auipc	ra,0x0
    800036dc:	fa8080e7          	jalr	-88(ra) # 80003680 <_ZN6Thread5sleepEm>
    while(1){
    800036e0:	fe1ff06f          	j	800036c0 <_ZN14PeriodicThread3runEv+0x18>

00000000800036e4 <_ZN9SemaphoreC1Ej>:
Semaphore::Semaphore(unsigned int init) {
    800036e4:	ff010113          	addi	sp,sp,-16
    800036e8:	00113423          	sd	ra,8(sp)
    800036ec:	00813023          	sd	s0,0(sp)
    800036f0:	01010413          	addi	s0,sp,16
    800036f4:	00003797          	auipc	a5,0x3
    800036f8:	36478793          	addi	a5,a5,868 # 80006a58 <_ZTV9Semaphore+0x10>
    800036fc:	00f53023          	sd	a5,0(a0)
    sem_open(&this->myHandle,init);
    80003700:	00850513          	addi	a0,a0,8
    80003704:	fffff097          	auipc	ra,0xfffff
    80003708:	3b0080e7          	jalr	944(ra) # 80002ab4 <sem_open>
}
    8000370c:	00813083          	ld	ra,8(sp)
    80003710:	00013403          	ld	s0,0(sp)
    80003714:	01010113          	addi	sp,sp,16
    80003718:	00008067          	ret

000000008000371c <_ZN9Semaphore6signalEv>:
int Semaphore::signal() {
    8000371c:	ff010113          	addi	sp,sp,-16
    80003720:	00113423          	sd	ra,8(sp)
    80003724:	00813023          	sd	s0,0(sp)
    80003728:	01010413          	addi	s0,sp,16
   return sem_signal(this->myHandle);
    8000372c:	00853503          	ld	a0,8(a0)
    80003730:	fffff097          	auipc	ra,0xfffff
    80003734:	354080e7          	jalr	852(ra) # 80002a84 <sem_signal>
}
    80003738:	00813083          	ld	ra,8(sp)
    8000373c:	00013403          	ld	s0,0(sp)
    80003740:	01010113          	addi	sp,sp,16
    80003744:	00008067          	ret

0000000080003748 <_ZN9Semaphore4waitEv>:
int Semaphore::wait() {
    80003748:	ff010113          	addi	sp,sp,-16
    8000374c:	00113423          	sd	ra,8(sp)
    80003750:	00813023          	sd	s0,0(sp)
    80003754:	01010413          	addi	s0,sp,16
   return sem_wait(this->myHandle);
    80003758:	00853503          	ld	a0,8(a0)
    8000375c:	fffff097          	auipc	ra,0xfffff
    80003760:	2f8080e7          	jalr	760(ra) # 80002a54 <sem_wait>
}
    80003764:	00813083          	ld	ra,8(sp)
    80003768:	00013403          	ld	s0,0(sp)
    8000376c:	01010113          	addi	sp,sp,16
    80003770:	00008067          	ret

0000000080003774 <_ZN7Console4getcEv>:
char Console::getc() {
    80003774:	ff010113          	addi	sp,sp,-16
    80003778:	00113423          	sd	ra,8(sp)
    8000377c:	00813023          	sd	s0,0(sp)
    80003780:	01010413          	addi	s0,sp,16
       return ::getc();
    80003784:	fffff097          	auipc	ra,0xfffff
    80003788:	e78080e7          	jalr	-392(ra) # 800025fc <getc>
}
    8000378c:	00813083          	ld	ra,8(sp)
    80003790:	00013403          	ld	s0,0(sp)
    80003794:	01010113          	addi	sp,sp,16
    80003798:	00008067          	ret

000000008000379c <_ZN7Console4putcEc>:
void Console::putc(char c) {
    8000379c:	ff010113          	addi	sp,sp,-16
    800037a0:	00113423          	sd	ra,8(sp)
    800037a4:	00813023          	sd	s0,0(sp)
    800037a8:	01010413          	addi	s0,sp,16
     ::putc(c);
    800037ac:	fffff097          	auipc	ra,0xfffff
    800037b0:	eb4080e7          	jalr	-332(ra) # 80002660 <putc>
}
    800037b4:	00813083          	ld	ra,8(sp)
    800037b8:	00013403          	ld	s0,0(sp)
    800037bc:	01010113          	addi	sp,sp,16
    800037c0:	00008067          	ret

00000000800037c4 <_ZN14PeriodicThreadC1Em>:
PeriodicThread::PeriodicThread(time_t period):Thread(){
    800037c4:	fe010113          	addi	sp,sp,-32
    800037c8:	00113c23          	sd	ra,24(sp)
    800037cc:	00813823          	sd	s0,16(sp)
    800037d0:	00913423          	sd	s1,8(sp)
    800037d4:	01213023          	sd	s2,0(sp)
    800037d8:	02010413          	addi	s0,sp,32
    800037dc:	00050493          	mv	s1,a0
    800037e0:	00058913          	mv	s2,a1
    800037e4:	00000097          	auipc	ra,0x0
    800037e8:	dd4080e7          	jalr	-556(ra) # 800035b8 <_ZN6ThreadC1Ev>
    800037ec:	00003797          	auipc	a5,0x3
    800037f0:	28c78793          	addi	a5,a5,652 # 80006a78 <_ZTV14PeriodicThread+0x10>
    800037f4:	00f4b023          	sd	a5,0(s1)
    myHandle->period=period;
    800037f8:	0084b783          	ld	a5,8(s1)
    800037fc:	0327bc23          	sd	s2,56(a5)
}
    80003800:	01813083          	ld	ra,24(sp)
    80003804:	01013403          	ld	s0,16(sp)
    80003808:	00813483          	ld	s1,8(sp)
    8000380c:	00013903          	ld	s2,0(sp)
    80003810:	02010113          	addi	sp,sp,32
    80003814:	00008067          	ret

0000000080003818 <_ZN6Thread3runEv>:
    static void wrapper(void* t);
    friend class PeriodicThread;
protected:

    Thread();
    virtual void run(){}
    80003818:	ff010113          	addi	sp,sp,-16
    8000381c:	00813423          	sd	s0,8(sp)
    80003820:	01010413          	addi	s0,sp,16
    80003824:	00813403          	ld	s0,8(sp)
    80003828:	01010113          	addi	sp,sp,16
    8000382c:	00008067          	ret

0000000080003830 <_ZN14PeriodicThread18periodicActivationEv>:
    sem_t myHandle;
};
class PeriodicThread:public Thread{
protected:
    PeriodicThread(time_t period);
    virtual void periodicActivation(){}
    80003830:	ff010113          	addi	sp,sp,-16
    80003834:	00813423          	sd	s0,8(sp)
    80003838:	01010413          	addi	s0,sp,16
    8000383c:	00813403          	ld	s0,8(sp)
    80003840:	01010113          	addi	sp,sp,16
    80003844:	00008067          	ret

0000000080003848 <_ZN14PeriodicThreadD1Ev>:
class PeriodicThread:public Thread{
    80003848:	ff010113          	addi	sp,sp,-16
    8000384c:	00113423          	sd	ra,8(sp)
    80003850:	00813023          	sd	s0,0(sp)
    80003854:	01010413          	addi	s0,sp,16
    80003858:	00003797          	auipc	a5,0x3
    8000385c:	22078793          	addi	a5,a5,544 # 80006a78 <_ZTV14PeriodicThread+0x10>
    80003860:	00f53023          	sd	a5,0(a0)
    80003864:	00000097          	auipc	ra,0x0
    80003868:	c58080e7          	jalr	-936(ra) # 800034bc <_ZN6ThreadD1Ev>
    8000386c:	00813083          	ld	ra,8(sp)
    80003870:	00013403          	ld	s0,0(sp)
    80003874:	01010113          	addi	sp,sp,16
    80003878:	00008067          	ret

000000008000387c <_ZN14PeriodicThreadD0Ev>:
    8000387c:	fe010113          	addi	sp,sp,-32
    80003880:	00113c23          	sd	ra,24(sp)
    80003884:	00813823          	sd	s0,16(sp)
    80003888:	00913423          	sd	s1,8(sp)
    8000388c:	02010413          	addi	s0,sp,32
    80003890:	00050493          	mv	s1,a0
    80003894:	00003797          	auipc	a5,0x3
    80003898:	1e478793          	addi	a5,a5,484 # 80006a78 <_ZTV14PeriodicThread+0x10>
    8000389c:	00f53023          	sd	a5,0(a0)
    800038a0:	00000097          	auipc	ra,0x0
    800038a4:	c1c080e7          	jalr	-996(ra) # 800034bc <_ZN6ThreadD1Ev>
    800038a8:	00048513          	mv	a0,s1
    800038ac:	00000097          	auipc	ra,0x0
    800038b0:	b80080e7          	jalr	-1152(ra) # 8000342c <_ZdlPv>
    800038b4:	01813083          	ld	ra,24(sp)
    800038b8:	01013403          	ld	s0,16(sp)
    800038bc:	00813483          	ld	s1,8(sp)
    800038c0:	02010113          	addi	sp,sp,32
    800038c4:	00008067          	ret

00000000800038c8 <start>:
    800038c8:	ff010113          	addi	sp,sp,-16
    800038cc:	00813423          	sd	s0,8(sp)
    800038d0:	01010413          	addi	s0,sp,16
    800038d4:	300027f3          	csrr	a5,mstatus
    800038d8:	ffffe737          	lui	a4,0xffffe
    800038dc:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7fff69cf>
    800038e0:	00e7f7b3          	and	a5,a5,a4
    800038e4:	00001737          	lui	a4,0x1
    800038e8:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800038ec:	00e7e7b3          	or	a5,a5,a4
    800038f0:	30079073          	csrw	mstatus,a5
    800038f4:	00000797          	auipc	a5,0x0
    800038f8:	16078793          	addi	a5,a5,352 # 80003a54 <system_main>
    800038fc:	34179073          	csrw	mepc,a5
    80003900:	00000793          	li	a5,0
    80003904:	18079073          	csrw	satp,a5
    80003908:	000107b7          	lui	a5,0x10
    8000390c:	fff78793          	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80003910:	30279073          	csrw	medeleg,a5
    80003914:	30379073          	csrw	mideleg,a5
    80003918:	104027f3          	csrr	a5,sie
    8000391c:	2227e793          	ori	a5,a5,546
    80003920:	10479073          	csrw	sie,a5
    80003924:	fff00793          	li	a5,-1
    80003928:	00a7d793          	srli	a5,a5,0xa
    8000392c:	3b079073          	csrw	pmpaddr0,a5
    80003930:	00f00793          	li	a5,15
    80003934:	3a079073          	csrw	pmpcfg0,a5
    80003938:	f14027f3          	csrr	a5,mhartid
    8000393c:	0200c737          	lui	a4,0x200c
    80003940:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80003944:	0007869b          	sext.w	a3,a5
    80003948:	00269713          	slli	a4,a3,0x2
    8000394c:	000f4637          	lui	a2,0xf4
    80003950:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80003954:	00d70733          	add	a4,a4,a3
    80003958:	0037979b          	slliw	a5,a5,0x3
    8000395c:	020046b7          	lui	a3,0x2004
    80003960:	00d787b3          	add	a5,a5,a3
    80003964:	00c585b3          	add	a1,a1,a2
    80003968:	00371693          	slli	a3,a4,0x3
    8000396c:	00003717          	auipc	a4,0x3
    80003970:	26470713          	addi	a4,a4,612 # 80006bd0 <timer_scratch>
    80003974:	00b7b023          	sd	a1,0(a5)
    80003978:	00d70733          	add	a4,a4,a3
    8000397c:	00f73c23          	sd	a5,24(a4)
    80003980:	02c73023          	sd	a2,32(a4)
    80003984:	34071073          	csrw	mscratch,a4
    80003988:	00000797          	auipc	a5,0x0
    8000398c:	6e878793          	addi	a5,a5,1768 # 80004070 <timervec>
    80003990:	30579073          	csrw	mtvec,a5
    80003994:	300027f3          	csrr	a5,mstatus
    80003998:	0087e793          	ori	a5,a5,8
    8000399c:	30079073          	csrw	mstatus,a5
    800039a0:	304027f3          	csrr	a5,mie
    800039a4:	0807e793          	ori	a5,a5,128
    800039a8:	30479073          	csrw	mie,a5
    800039ac:	f14027f3          	csrr	a5,mhartid
    800039b0:	0007879b          	sext.w	a5,a5
    800039b4:	00078213          	mv	tp,a5
    800039b8:	30200073          	mret
    800039bc:	00813403          	ld	s0,8(sp)
    800039c0:	01010113          	addi	sp,sp,16
    800039c4:	00008067          	ret

00000000800039c8 <timerinit>:
    800039c8:	ff010113          	addi	sp,sp,-16
    800039cc:	00813423          	sd	s0,8(sp)
    800039d0:	01010413          	addi	s0,sp,16
    800039d4:	f14027f3          	csrr	a5,mhartid
    800039d8:	0200c737          	lui	a4,0x200c
    800039dc:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800039e0:	0007869b          	sext.w	a3,a5
    800039e4:	00269713          	slli	a4,a3,0x2
    800039e8:	000f4637          	lui	a2,0xf4
    800039ec:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800039f0:	00d70733          	add	a4,a4,a3
    800039f4:	0037979b          	slliw	a5,a5,0x3
    800039f8:	020046b7          	lui	a3,0x2004
    800039fc:	00d787b3          	add	a5,a5,a3
    80003a00:	00c585b3          	add	a1,a1,a2
    80003a04:	00371693          	slli	a3,a4,0x3
    80003a08:	00003717          	auipc	a4,0x3
    80003a0c:	1c870713          	addi	a4,a4,456 # 80006bd0 <timer_scratch>
    80003a10:	00b7b023          	sd	a1,0(a5)
    80003a14:	00d70733          	add	a4,a4,a3
    80003a18:	00f73c23          	sd	a5,24(a4)
    80003a1c:	02c73023          	sd	a2,32(a4)
    80003a20:	34071073          	csrw	mscratch,a4
    80003a24:	00000797          	auipc	a5,0x0
    80003a28:	64c78793          	addi	a5,a5,1612 # 80004070 <timervec>
    80003a2c:	30579073          	csrw	mtvec,a5
    80003a30:	300027f3          	csrr	a5,mstatus
    80003a34:	0087e793          	ori	a5,a5,8
    80003a38:	30079073          	csrw	mstatus,a5
    80003a3c:	304027f3          	csrr	a5,mie
    80003a40:	0807e793          	ori	a5,a5,128
    80003a44:	30479073          	csrw	mie,a5
    80003a48:	00813403          	ld	s0,8(sp)
    80003a4c:	01010113          	addi	sp,sp,16
    80003a50:	00008067          	ret

0000000080003a54 <system_main>:
    80003a54:	fe010113          	addi	sp,sp,-32
    80003a58:	00813823          	sd	s0,16(sp)
    80003a5c:	00913423          	sd	s1,8(sp)
    80003a60:	00113c23          	sd	ra,24(sp)
    80003a64:	02010413          	addi	s0,sp,32
    80003a68:	00000097          	auipc	ra,0x0
    80003a6c:	0c4080e7          	jalr	196(ra) # 80003b2c <cpuid>
    80003a70:	00003497          	auipc	s1,0x3
    80003a74:	12848493          	addi	s1,s1,296 # 80006b98 <started>
    80003a78:	02050263          	beqz	a0,80003a9c <system_main+0x48>
    80003a7c:	0004a783          	lw	a5,0(s1)
    80003a80:	0007879b          	sext.w	a5,a5
    80003a84:	fe078ce3          	beqz	a5,80003a7c <system_main+0x28>
    80003a88:	0ff0000f          	fence
    80003a8c:	00002517          	auipc	a0,0x2
    80003a90:	6ec50513          	addi	a0,a0,1772 # 80006178 <CONSOLE_STATUS+0x168>
    80003a94:	00001097          	auipc	ra,0x1
    80003a98:	a78080e7          	jalr	-1416(ra) # 8000450c <panic>
    80003a9c:	00001097          	auipc	ra,0x1
    80003aa0:	9cc080e7          	jalr	-1588(ra) # 80004468 <consoleinit>
    80003aa4:	00001097          	auipc	ra,0x1
    80003aa8:	158080e7          	jalr	344(ra) # 80004bfc <printfinit>
    80003aac:	00002517          	auipc	a0,0x2
    80003ab0:	7ac50513          	addi	a0,a0,1964 # 80006258 <CONSOLE_STATUS+0x248>
    80003ab4:	00001097          	auipc	ra,0x1
    80003ab8:	ab4080e7          	jalr	-1356(ra) # 80004568 <__printf>
    80003abc:	00002517          	auipc	a0,0x2
    80003ac0:	68c50513          	addi	a0,a0,1676 # 80006148 <CONSOLE_STATUS+0x138>
    80003ac4:	00001097          	auipc	ra,0x1
    80003ac8:	aa4080e7          	jalr	-1372(ra) # 80004568 <__printf>
    80003acc:	00002517          	auipc	a0,0x2
    80003ad0:	78c50513          	addi	a0,a0,1932 # 80006258 <CONSOLE_STATUS+0x248>
    80003ad4:	00001097          	auipc	ra,0x1
    80003ad8:	a94080e7          	jalr	-1388(ra) # 80004568 <__printf>
    80003adc:	00001097          	auipc	ra,0x1
    80003ae0:	4ac080e7          	jalr	1196(ra) # 80004f88 <kinit>
    80003ae4:	00000097          	auipc	ra,0x0
    80003ae8:	148080e7          	jalr	328(ra) # 80003c2c <trapinit>
    80003aec:	00000097          	auipc	ra,0x0
    80003af0:	16c080e7          	jalr	364(ra) # 80003c58 <trapinithart>
    80003af4:	00000097          	auipc	ra,0x0
    80003af8:	5bc080e7          	jalr	1468(ra) # 800040b0 <plicinit>
    80003afc:	00000097          	auipc	ra,0x0
    80003b00:	5dc080e7          	jalr	1500(ra) # 800040d8 <plicinithart>
    80003b04:	00000097          	auipc	ra,0x0
    80003b08:	078080e7          	jalr	120(ra) # 80003b7c <userinit>
    80003b0c:	0ff0000f          	fence
    80003b10:	00100793          	li	a5,1
    80003b14:	00002517          	auipc	a0,0x2
    80003b18:	64c50513          	addi	a0,a0,1612 # 80006160 <CONSOLE_STATUS+0x150>
    80003b1c:	00f4a023          	sw	a5,0(s1)
    80003b20:	00001097          	auipc	ra,0x1
    80003b24:	a48080e7          	jalr	-1464(ra) # 80004568 <__printf>
    80003b28:	0000006f          	j	80003b28 <system_main+0xd4>

0000000080003b2c <cpuid>:
    80003b2c:	ff010113          	addi	sp,sp,-16
    80003b30:	00813423          	sd	s0,8(sp)
    80003b34:	01010413          	addi	s0,sp,16
    80003b38:	00020513          	mv	a0,tp
    80003b3c:	00813403          	ld	s0,8(sp)
    80003b40:	0005051b          	sext.w	a0,a0
    80003b44:	01010113          	addi	sp,sp,16
    80003b48:	00008067          	ret

0000000080003b4c <mycpu>:
    80003b4c:	ff010113          	addi	sp,sp,-16
    80003b50:	00813423          	sd	s0,8(sp)
    80003b54:	01010413          	addi	s0,sp,16
    80003b58:	00020793          	mv	a5,tp
    80003b5c:	00813403          	ld	s0,8(sp)
    80003b60:	0007879b          	sext.w	a5,a5
    80003b64:	00779793          	slli	a5,a5,0x7
    80003b68:	00004517          	auipc	a0,0x4
    80003b6c:	09850513          	addi	a0,a0,152 # 80007c00 <cpus>
    80003b70:	00f50533          	add	a0,a0,a5
    80003b74:	01010113          	addi	sp,sp,16
    80003b78:	00008067          	ret

0000000080003b7c <userinit>:
    80003b7c:	ff010113          	addi	sp,sp,-16
    80003b80:	00813423          	sd	s0,8(sp)
    80003b84:	01010413          	addi	s0,sp,16
    80003b88:	00813403          	ld	s0,8(sp)
    80003b8c:	01010113          	addi	sp,sp,16
    80003b90:	ffffe317          	auipc	t1,0xffffe
    80003b94:	50830067          	jr	1288(t1) # 80002098 <main>

0000000080003b98 <either_copyout>:
    80003b98:	ff010113          	addi	sp,sp,-16
    80003b9c:	00813023          	sd	s0,0(sp)
    80003ba0:	00113423          	sd	ra,8(sp)
    80003ba4:	01010413          	addi	s0,sp,16
    80003ba8:	02051663          	bnez	a0,80003bd4 <either_copyout+0x3c>
    80003bac:	00058513          	mv	a0,a1
    80003bb0:	00060593          	mv	a1,a2
    80003bb4:	0006861b          	sext.w	a2,a3
    80003bb8:	00002097          	auipc	ra,0x2
    80003bbc:	c5c080e7          	jalr	-932(ra) # 80005814 <__memmove>
    80003bc0:	00813083          	ld	ra,8(sp)
    80003bc4:	00013403          	ld	s0,0(sp)
    80003bc8:	00000513          	li	a0,0
    80003bcc:	01010113          	addi	sp,sp,16
    80003bd0:	00008067          	ret
    80003bd4:	00002517          	auipc	a0,0x2
    80003bd8:	5cc50513          	addi	a0,a0,1484 # 800061a0 <CONSOLE_STATUS+0x190>
    80003bdc:	00001097          	auipc	ra,0x1
    80003be0:	930080e7          	jalr	-1744(ra) # 8000450c <panic>

0000000080003be4 <either_copyin>:
    80003be4:	ff010113          	addi	sp,sp,-16
    80003be8:	00813023          	sd	s0,0(sp)
    80003bec:	00113423          	sd	ra,8(sp)
    80003bf0:	01010413          	addi	s0,sp,16
    80003bf4:	02059463          	bnez	a1,80003c1c <either_copyin+0x38>
    80003bf8:	00060593          	mv	a1,a2
    80003bfc:	0006861b          	sext.w	a2,a3
    80003c00:	00002097          	auipc	ra,0x2
    80003c04:	c14080e7          	jalr	-1004(ra) # 80005814 <__memmove>
    80003c08:	00813083          	ld	ra,8(sp)
    80003c0c:	00013403          	ld	s0,0(sp)
    80003c10:	00000513          	li	a0,0
    80003c14:	01010113          	addi	sp,sp,16
    80003c18:	00008067          	ret
    80003c1c:	00002517          	auipc	a0,0x2
    80003c20:	5ac50513          	addi	a0,a0,1452 # 800061c8 <CONSOLE_STATUS+0x1b8>
    80003c24:	00001097          	auipc	ra,0x1
    80003c28:	8e8080e7          	jalr	-1816(ra) # 8000450c <panic>

0000000080003c2c <trapinit>:
    80003c2c:	ff010113          	addi	sp,sp,-16
    80003c30:	00813423          	sd	s0,8(sp)
    80003c34:	01010413          	addi	s0,sp,16
    80003c38:	00813403          	ld	s0,8(sp)
    80003c3c:	00002597          	auipc	a1,0x2
    80003c40:	5b458593          	addi	a1,a1,1460 # 800061f0 <CONSOLE_STATUS+0x1e0>
    80003c44:	00004517          	auipc	a0,0x4
    80003c48:	03c50513          	addi	a0,a0,60 # 80007c80 <tickslock>
    80003c4c:	01010113          	addi	sp,sp,16
    80003c50:	00001317          	auipc	t1,0x1
    80003c54:	5c830067          	jr	1480(t1) # 80005218 <initlock>

0000000080003c58 <trapinithart>:
    80003c58:	ff010113          	addi	sp,sp,-16
    80003c5c:	00813423          	sd	s0,8(sp)
    80003c60:	01010413          	addi	s0,sp,16
    80003c64:	00000797          	auipc	a5,0x0
    80003c68:	2fc78793          	addi	a5,a5,764 # 80003f60 <kernelvec>
    80003c6c:	10579073          	csrw	stvec,a5
    80003c70:	00813403          	ld	s0,8(sp)
    80003c74:	01010113          	addi	sp,sp,16
    80003c78:	00008067          	ret

0000000080003c7c <usertrap>:
    80003c7c:	ff010113          	addi	sp,sp,-16
    80003c80:	00813423          	sd	s0,8(sp)
    80003c84:	01010413          	addi	s0,sp,16
    80003c88:	00813403          	ld	s0,8(sp)
    80003c8c:	01010113          	addi	sp,sp,16
    80003c90:	00008067          	ret

0000000080003c94 <usertrapret>:
    80003c94:	ff010113          	addi	sp,sp,-16
    80003c98:	00813423          	sd	s0,8(sp)
    80003c9c:	01010413          	addi	s0,sp,16
    80003ca0:	00813403          	ld	s0,8(sp)
    80003ca4:	01010113          	addi	sp,sp,16
    80003ca8:	00008067          	ret

0000000080003cac <kerneltrap>:
    80003cac:	fe010113          	addi	sp,sp,-32
    80003cb0:	00813823          	sd	s0,16(sp)
    80003cb4:	00113c23          	sd	ra,24(sp)
    80003cb8:	00913423          	sd	s1,8(sp)
    80003cbc:	02010413          	addi	s0,sp,32
    80003cc0:	142025f3          	csrr	a1,scause
    80003cc4:	100027f3          	csrr	a5,sstatus
    80003cc8:	0027f793          	andi	a5,a5,2
    80003ccc:	10079c63          	bnez	a5,80003de4 <kerneltrap+0x138>
    80003cd0:	142027f3          	csrr	a5,scause
    80003cd4:	0207ce63          	bltz	a5,80003d10 <kerneltrap+0x64>
    80003cd8:	00002517          	auipc	a0,0x2
    80003cdc:	56050513          	addi	a0,a0,1376 # 80006238 <CONSOLE_STATUS+0x228>
    80003ce0:	00001097          	auipc	ra,0x1
    80003ce4:	888080e7          	jalr	-1912(ra) # 80004568 <__printf>
    80003ce8:	141025f3          	csrr	a1,sepc
    80003cec:	14302673          	csrr	a2,stval
    80003cf0:	00002517          	auipc	a0,0x2
    80003cf4:	55850513          	addi	a0,a0,1368 # 80006248 <CONSOLE_STATUS+0x238>
    80003cf8:	00001097          	auipc	ra,0x1
    80003cfc:	870080e7          	jalr	-1936(ra) # 80004568 <__printf>
    80003d00:	00002517          	auipc	a0,0x2
    80003d04:	56050513          	addi	a0,a0,1376 # 80006260 <CONSOLE_STATUS+0x250>
    80003d08:	00001097          	auipc	ra,0x1
    80003d0c:	804080e7          	jalr	-2044(ra) # 8000450c <panic>
    80003d10:	0ff7f713          	andi	a4,a5,255
    80003d14:	00900693          	li	a3,9
    80003d18:	04d70063          	beq	a4,a3,80003d58 <kerneltrap+0xac>
    80003d1c:	fff00713          	li	a4,-1
    80003d20:	03f71713          	slli	a4,a4,0x3f
    80003d24:	00170713          	addi	a4,a4,1
    80003d28:	fae798e3          	bne	a5,a4,80003cd8 <kerneltrap+0x2c>
    80003d2c:	00000097          	auipc	ra,0x0
    80003d30:	e00080e7          	jalr	-512(ra) # 80003b2c <cpuid>
    80003d34:	06050663          	beqz	a0,80003da0 <kerneltrap+0xf4>
    80003d38:	144027f3          	csrr	a5,sip
    80003d3c:	ffd7f793          	andi	a5,a5,-3
    80003d40:	14479073          	csrw	sip,a5
    80003d44:	01813083          	ld	ra,24(sp)
    80003d48:	01013403          	ld	s0,16(sp)
    80003d4c:	00813483          	ld	s1,8(sp)
    80003d50:	02010113          	addi	sp,sp,32
    80003d54:	00008067          	ret
    80003d58:	00000097          	auipc	ra,0x0
    80003d5c:	3cc080e7          	jalr	972(ra) # 80004124 <plic_claim>
    80003d60:	00a00793          	li	a5,10
    80003d64:	00050493          	mv	s1,a0
    80003d68:	06f50863          	beq	a0,a5,80003dd8 <kerneltrap+0x12c>
    80003d6c:	fc050ce3          	beqz	a0,80003d44 <kerneltrap+0x98>
    80003d70:	00050593          	mv	a1,a0
    80003d74:	00002517          	auipc	a0,0x2
    80003d78:	4a450513          	addi	a0,a0,1188 # 80006218 <CONSOLE_STATUS+0x208>
    80003d7c:	00000097          	auipc	ra,0x0
    80003d80:	7ec080e7          	jalr	2028(ra) # 80004568 <__printf>
    80003d84:	01013403          	ld	s0,16(sp)
    80003d88:	01813083          	ld	ra,24(sp)
    80003d8c:	00048513          	mv	a0,s1
    80003d90:	00813483          	ld	s1,8(sp)
    80003d94:	02010113          	addi	sp,sp,32
    80003d98:	00000317          	auipc	t1,0x0
    80003d9c:	3c430067          	jr	964(t1) # 8000415c <plic_complete>
    80003da0:	00004517          	auipc	a0,0x4
    80003da4:	ee050513          	addi	a0,a0,-288 # 80007c80 <tickslock>
    80003da8:	00001097          	auipc	ra,0x1
    80003dac:	494080e7          	jalr	1172(ra) # 8000523c <acquire>
    80003db0:	00003717          	auipc	a4,0x3
    80003db4:	dec70713          	addi	a4,a4,-532 # 80006b9c <ticks>
    80003db8:	00072783          	lw	a5,0(a4)
    80003dbc:	00004517          	auipc	a0,0x4
    80003dc0:	ec450513          	addi	a0,a0,-316 # 80007c80 <tickslock>
    80003dc4:	0017879b          	addiw	a5,a5,1
    80003dc8:	00f72023          	sw	a5,0(a4)
    80003dcc:	00001097          	auipc	ra,0x1
    80003dd0:	53c080e7          	jalr	1340(ra) # 80005308 <release>
    80003dd4:	f65ff06f          	j	80003d38 <kerneltrap+0x8c>
    80003dd8:	00001097          	auipc	ra,0x1
    80003ddc:	098080e7          	jalr	152(ra) # 80004e70 <uartintr>
    80003de0:	fa5ff06f          	j	80003d84 <kerneltrap+0xd8>
    80003de4:	00002517          	auipc	a0,0x2
    80003de8:	41450513          	addi	a0,a0,1044 # 800061f8 <CONSOLE_STATUS+0x1e8>
    80003dec:	00000097          	auipc	ra,0x0
    80003df0:	720080e7          	jalr	1824(ra) # 8000450c <panic>

0000000080003df4 <clockintr>:
    80003df4:	fe010113          	addi	sp,sp,-32
    80003df8:	00813823          	sd	s0,16(sp)
    80003dfc:	00913423          	sd	s1,8(sp)
    80003e00:	00113c23          	sd	ra,24(sp)
    80003e04:	02010413          	addi	s0,sp,32
    80003e08:	00004497          	auipc	s1,0x4
    80003e0c:	e7848493          	addi	s1,s1,-392 # 80007c80 <tickslock>
    80003e10:	00048513          	mv	a0,s1
    80003e14:	00001097          	auipc	ra,0x1
    80003e18:	428080e7          	jalr	1064(ra) # 8000523c <acquire>
    80003e1c:	00003717          	auipc	a4,0x3
    80003e20:	d8070713          	addi	a4,a4,-640 # 80006b9c <ticks>
    80003e24:	00072783          	lw	a5,0(a4)
    80003e28:	01013403          	ld	s0,16(sp)
    80003e2c:	01813083          	ld	ra,24(sp)
    80003e30:	00048513          	mv	a0,s1
    80003e34:	0017879b          	addiw	a5,a5,1
    80003e38:	00813483          	ld	s1,8(sp)
    80003e3c:	00f72023          	sw	a5,0(a4)
    80003e40:	02010113          	addi	sp,sp,32
    80003e44:	00001317          	auipc	t1,0x1
    80003e48:	4c430067          	jr	1220(t1) # 80005308 <release>

0000000080003e4c <devintr>:
    80003e4c:	142027f3          	csrr	a5,scause
    80003e50:	00000513          	li	a0,0
    80003e54:	0007c463          	bltz	a5,80003e5c <devintr+0x10>
    80003e58:	00008067          	ret
    80003e5c:	fe010113          	addi	sp,sp,-32
    80003e60:	00813823          	sd	s0,16(sp)
    80003e64:	00113c23          	sd	ra,24(sp)
    80003e68:	00913423          	sd	s1,8(sp)
    80003e6c:	02010413          	addi	s0,sp,32
    80003e70:	0ff7f713          	andi	a4,a5,255
    80003e74:	00900693          	li	a3,9
    80003e78:	04d70c63          	beq	a4,a3,80003ed0 <devintr+0x84>
    80003e7c:	fff00713          	li	a4,-1
    80003e80:	03f71713          	slli	a4,a4,0x3f
    80003e84:	00170713          	addi	a4,a4,1
    80003e88:	00e78c63          	beq	a5,a4,80003ea0 <devintr+0x54>
    80003e8c:	01813083          	ld	ra,24(sp)
    80003e90:	01013403          	ld	s0,16(sp)
    80003e94:	00813483          	ld	s1,8(sp)
    80003e98:	02010113          	addi	sp,sp,32
    80003e9c:	00008067          	ret
    80003ea0:	00000097          	auipc	ra,0x0
    80003ea4:	c8c080e7          	jalr	-884(ra) # 80003b2c <cpuid>
    80003ea8:	06050663          	beqz	a0,80003f14 <devintr+0xc8>
    80003eac:	144027f3          	csrr	a5,sip
    80003eb0:	ffd7f793          	andi	a5,a5,-3
    80003eb4:	14479073          	csrw	sip,a5
    80003eb8:	01813083          	ld	ra,24(sp)
    80003ebc:	01013403          	ld	s0,16(sp)
    80003ec0:	00813483          	ld	s1,8(sp)
    80003ec4:	00200513          	li	a0,2
    80003ec8:	02010113          	addi	sp,sp,32
    80003ecc:	00008067          	ret
    80003ed0:	00000097          	auipc	ra,0x0
    80003ed4:	254080e7          	jalr	596(ra) # 80004124 <plic_claim>
    80003ed8:	00a00793          	li	a5,10
    80003edc:	00050493          	mv	s1,a0
    80003ee0:	06f50663          	beq	a0,a5,80003f4c <devintr+0x100>
    80003ee4:	00100513          	li	a0,1
    80003ee8:	fa0482e3          	beqz	s1,80003e8c <devintr+0x40>
    80003eec:	00048593          	mv	a1,s1
    80003ef0:	00002517          	auipc	a0,0x2
    80003ef4:	32850513          	addi	a0,a0,808 # 80006218 <CONSOLE_STATUS+0x208>
    80003ef8:	00000097          	auipc	ra,0x0
    80003efc:	670080e7          	jalr	1648(ra) # 80004568 <__printf>
    80003f00:	00048513          	mv	a0,s1
    80003f04:	00000097          	auipc	ra,0x0
    80003f08:	258080e7          	jalr	600(ra) # 8000415c <plic_complete>
    80003f0c:	00100513          	li	a0,1
    80003f10:	f7dff06f          	j	80003e8c <devintr+0x40>
    80003f14:	00004517          	auipc	a0,0x4
    80003f18:	d6c50513          	addi	a0,a0,-660 # 80007c80 <tickslock>
    80003f1c:	00001097          	auipc	ra,0x1
    80003f20:	320080e7          	jalr	800(ra) # 8000523c <acquire>
    80003f24:	00003717          	auipc	a4,0x3
    80003f28:	c7870713          	addi	a4,a4,-904 # 80006b9c <ticks>
    80003f2c:	00072783          	lw	a5,0(a4)
    80003f30:	00004517          	auipc	a0,0x4
    80003f34:	d5050513          	addi	a0,a0,-688 # 80007c80 <tickslock>
    80003f38:	0017879b          	addiw	a5,a5,1
    80003f3c:	00f72023          	sw	a5,0(a4)
    80003f40:	00001097          	auipc	ra,0x1
    80003f44:	3c8080e7          	jalr	968(ra) # 80005308 <release>
    80003f48:	f65ff06f          	j	80003eac <devintr+0x60>
    80003f4c:	00001097          	auipc	ra,0x1
    80003f50:	f24080e7          	jalr	-220(ra) # 80004e70 <uartintr>
    80003f54:	fadff06f          	j	80003f00 <devintr+0xb4>
	...

0000000080003f60 <kernelvec>:
    80003f60:	f0010113          	addi	sp,sp,-256
    80003f64:	00113023          	sd	ra,0(sp)
    80003f68:	00213423          	sd	sp,8(sp)
    80003f6c:	00313823          	sd	gp,16(sp)
    80003f70:	00413c23          	sd	tp,24(sp)
    80003f74:	02513023          	sd	t0,32(sp)
    80003f78:	02613423          	sd	t1,40(sp)
    80003f7c:	02713823          	sd	t2,48(sp)
    80003f80:	02813c23          	sd	s0,56(sp)
    80003f84:	04913023          	sd	s1,64(sp)
    80003f88:	04a13423          	sd	a0,72(sp)
    80003f8c:	04b13823          	sd	a1,80(sp)
    80003f90:	04c13c23          	sd	a2,88(sp)
    80003f94:	06d13023          	sd	a3,96(sp)
    80003f98:	06e13423          	sd	a4,104(sp)
    80003f9c:	06f13823          	sd	a5,112(sp)
    80003fa0:	07013c23          	sd	a6,120(sp)
    80003fa4:	09113023          	sd	a7,128(sp)
    80003fa8:	09213423          	sd	s2,136(sp)
    80003fac:	09313823          	sd	s3,144(sp)
    80003fb0:	09413c23          	sd	s4,152(sp)
    80003fb4:	0b513023          	sd	s5,160(sp)
    80003fb8:	0b613423          	sd	s6,168(sp)
    80003fbc:	0b713823          	sd	s7,176(sp)
    80003fc0:	0b813c23          	sd	s8,184(sp)
    80003fc4:	0d913023          	sd	s9,192(sp)
    80003fc8:	0da13423          	sd	s10,200(sp)
    80003fcc:	0db13823          	sd	s11,208(sp)
    80003fd0:	0dc13c23          	sd	t3,216(sp)
    80003fd4:	0fd13023          	sd	t4,224(sp)
    80003fd8:	0fe13423          	sd	t5,232(sp)
    80003fdc:	0ff13823          	sd	t6,240(sp)
    80003fe0:	ccdff0ef          	jal	ra,80003cac <kerneltrap>
    80003fe4:	00013083          	ld	ra,0(sp)
    80003fe8:	00813103          	ld	sp,8(sp)
    80003fec:	01013183          	ld	gp,16(sp)
    80003ff0:	02013283          	ld	t0,32(sp)
    80003ff4:	02813303          	ld	t1,40(sp)
    80003ff8:	03013383          	ld	t2,48(sp)
    80003ffc:	03813403          	ld	s0,56(sp)
    80004000:	04013483          	ld	s1,64(sp)
    80004004:	04813503          	ld	a0,72(sp)
    80004008:	05013583          	ld	a1,80(sp)
    8000400c:	05813603          	ld	a2,88(sp)
    80004010:	06013683          	ld	a3,96(sp)
    80004014:	06813703          	ld	a4,104(sp)
    80004018:	07013783          	ld	a5,112(sp)
    8000401c:	07813803          	ld	a6,120(sp)
    80004020:	08013883          	ld	a7,128(sp)
    80004024:	08813903          	ld	s2,136(sp)
    80004028:	09013983          	ld	s3,144(sp)
    8000402c:	09813a03          	ld	s4,152(sp)
    80004030:	0a013a83          	ld	s5,160(sp)
    80004034:	0a813b03          	ld	s6,168(sp)
    80004038:	0b013b83          	ld	s7,176(sp)
    8000403c:	0b813c03          	ld	s8,184(sp)
    80004040:	0c013c83          	ld	s9,192(sp)
    80004044:	0c813d03          	ld	s10,200(sp)
    80004048:	0d013d83          	ld	s11,208(sp)
    8000404c:	0d813e03          	ld	t3,216(sp)
    80004050:	0e013e83          	ld	t4,224(sp)
    80004054:	0e813f03          	ld	t5,232(sp)
    80004058:	0f013f83          	ld	t6,240(sp)
    8000405c:	10010113          	addi	sp,sp,256
    80004060:	10200073          	sret
    80004064:	00000013          	nop
    80004068:	00000013          	nop
    8000406c:	00000013          	nop

0000000080004070 <timervec>:
    80004070:	34051573          	csrrw	a0,mscratch,a0
    80004074:	00b53023          	sd	a1,0(a0)
    80004078:	00c53423          	sd	a2,8(a0)
    8000407c:	00d53823          	sd	a3,16(a0)
    80004080:	01853583          	ld	a1,24(a0)
    80004084:	02053603          	ld	a2,32(a0)
    80004088:	0005b683          	ld	a3,0(a1)
    8000408c:	00c686b3          	add	a3,a3,a2
    80004090:	00d5b023          	sd	a3,0(a1)
    80004094:	00200593          	li	a1,2
    80004098:	14459073          	csrw	sip,a1
    8000409c:	01053683          	ld	a3,16(a0)
    800040a0:	00853603          	ld	a2,8(a0)
    800040a4:	00053583          	ld	a1,0(a0)
    800040a8:	34051573          	csrrw	a0,mscratch,a0
    800040ac:	30200073          	mret

00000000800040b0 <plicinit>:
    800040b0:	ff010113          	addi	sp,sp,-16
    800040b4:	00813423          	sd	s0,8(sp)
    800040b8:	01010413          	addi	s0,sp,16
    800040bc:	00813403          	ld	s0,8(sp)
    800040c0:	0c0007b7          	lui	a5,0xc000
    800040c4:	00100713          	li	a4,1
    800040c8:	02e7a423          	sw	a4,40(a5) # c000028 <_entry-0x73ffffd8>
    800040cc:	00e7a223          	sw	a4,4(a5)
    800040d0:	01010113          	addi	sp,sp,16
    800040d4:	00008067          	ret

00000000800040d8 <plicinithart>:
    800040d8:	ff010113          	addi	sp,sp,-16
    800040dc:	00813023          	sd	s0,0(sp)
    800040e0:	00113423          	sd	ra,8(sp)
    800040e4:	01010413          	addi	s0,sp,16
    800040e8:	00000097          	auipc	ra,0x0
    800040ec:	a44080e7          	jalr	-1468(ra) # 80003b2c <cpuid>
    800040f0:	0085171b          	slliw	a4,a0,0x8
    800040f4:	0c0027b7          	lui	a5,0xc002
    800040f8:	00e787b3          	add	a5,a5,a4
    800040fc:	40200713          	li	a4,1026
    80004100:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>
    80004104:	00813083          	ld	ra,8(sp)
    80004108:	00013403          	ld	s0,0(sp)
    8000410c:	00d5151b          	slliw	a0,a0,0xd
    80004110:	0c2017b7          	lui	a5,0xc201
    80004114:	00a78533          	add	a0,a5,a0
    80004118:	00052023          	sw	zero,0(a0)
    8000411c:	01010113          	addi	sp,sp,16
    80004120:	00008067          	ret

0000000080004124 <plic_claim>:
    80004124:	ff010113          	addi	sp,sp,-16
    80004128:	00813023          	sd	s0,0(sp)
    8000412c:	00113423          	sd	ra,8(sp)
    80004130:	01010413          	addi	s0,sp,16
    80004134:	00000097          	auipc	ra,0x0
    80004138:	9f8080e7          	jalr	-1544(ra) # 80003b2c <cpuid>
    8000413c:	00813083          	ld	ra,8(sp)
    80004140:	00013403          	ld	s0,0(sp)
    80004144:	00d5151b          	slliw	a0,a0,0xd
    80004148:	0c2017b7          	lui	a5,0xc201
    8000414c:	00a78533          	add	a0,a5,a0
    80004150:	00452503          	lw	a0,4(a0)
    80004154:	01010113          	addi	sp,sp,16
    80004158:	00008067          	ret

000000008000415c <plic_complete>:
    8000415c:	fe010113          	addi	sp,sp,-32
    80004160:	00813823          	sd	s0,16(sp)
    80004164:	00913423          	sd	s1,8(sp)
    80004168:	00113c23          	sd	ra,24(sp)
    8000416c:	02010413          	addi	s0,sp,32
    80004170:	00050493          	mv	s1,a0
    80004174:	00000097          	auipc	ra,0x0
    80004178:	9b8080e7          	jalr	-1608(ra) # 80003b2c <cpuid>
    8000417c:	01813083          	ld	ra,24(sp)
    80004180:	01013403          	ld	s0,16(sp)
    80004184:	00d5179b          	slliw	a5,a0,0xd
    80004188:	0c201737          	lui	a4,0xc201
    8000418c:	00f707b3          	add	a5,a4,a5
    80004190:	0097a223          	sw	s1,4(a5) # c201004 <_entry-0x73dfeffc>
    80004194:	00813483          	ld	s1,8(sp)
    80004198:	02010113          	addi	sp,sp,32
    8000419c:	00008067          	ret

00000000800041a0 <consolewrite>:
    800041a0:	fb010113          	addi	sp,sp,-80
    800041a4:	04813023          	sd	s0,64(sp)
    800041a8:	04113423          	sd	ra,72(sp)
    800041ac:	02913c23          	sd	s1,56(sp)
    800041b0:	03213823          	sd	s2,48(sp)
    800041b4:	03313423          	sd	s3,40(sp)
    800041b8:	03413023          	sd	s4,32(sp)
    800041bc:	01513c23          	sd	s5,24(sp)
    800041c0:	05010413          	addi	s0,sp,80
    800041c4:	06c05c63          	blez	a2,8000423c <consolewrite+0x9c>
    800041c8:	00060993          	mv	s3,a2
    800041cc:	00050a13          	mv	s4,a0
    800041d0:	00058493          	mv	s1,a1
    800041d4:	00000913          	li	s2,0
    800041d8:	fff00a93          	li	s5,-1
    800041dc:	01c0006f          	j	800041f8 <consolewrite+0x58>
    800041e0:	fbf44503          	lbu	a0,-65(s0)
    800041e4:	0019091b          	addiw	s2,s2,1
    800041e8:	00148493          	addi	s1,s1,1
    800041ec:	00001097          	auipc	ra,0x1
    800041f0:	a9c080e7          	jalr	-1380(ra) # 80004c88 <uartputc>
    800041f4:	03298063          	beq	s3,s2,80004214 <consolewrite+0x74>
    800041f8:	00048613          	mv	a2,s1
    800041fc:	00100693          	li	a3,1
    80004200:	000a0593          	mv	a1,s4
    80004204:	fbf40513          	addi	a0,s0,-65
    80004208:	00000097          	auipc	ra,0x0
    8000420c:	9dc080e7          	jalr	-1572(ra) # 80003be4 <either_copyin>
    80004210:	fd5518e3          	bne	a0,s5,800041e0 <consolewrite+0x40>
    80004214:	04813083          	ld	ra,72(sp)
    80004218:	04013403          	ld	s0,64(sp)
    8000421c:	03813483          	ld	s1,56(sp)
    80004220:	02813983          	ld	s3,40(sp)
    80004224:	02013a03          	ld	s4,32(sp)
    80004228:	01813a83          	ld	s5,24(sp)
    8000422c:	00090513          	mv	a0,s2
    80004230:	03013903          	ld	s2,48(sp)
    80004234:	05010113          	addi	sp,sp,80
    80004238:	00008067          	ret
    8000423c:	00000913          	li	s2,0
    80004240:	fd5ff06f          	j	80004214 <consolewrite+0x74>

0000000080004244 <consoleread>:
    80004244:	f9010113          	addi	sp,sp,-112
    80004248:	06813023          	sd	s0,96(sp)
    8000424c:	04913c23          	sd	s1,88(sp)
    80004250:	05213823          	sd	s2,80(sp)
    80004254:	05313423          	sd	s3,72(sp)
    80004258:	05413023          	sd	s4,64(sp)
    8000425c:	03513c23          	sd	s5,56(sp)
    80004260:	03613823          	sd	s6,48(sp)
    80004264:	03713423          	sd	s7,40(sp)
    80004268:	03813023          	sd	s8,32(sp)
    8000426c:	06113423          	sd	ra,104(sp)
    80004270:	01913c23          	sd	s9,24(sp)
    80004274:	07010413          	addi	s0,sp,112
    80004278:	00060b93          	mv	s7,a2
    8000427c:	00050913          	mv	s2,a0
    80004280:	00058c13          	mv	s8,a1
    80004284:	00060b1b          	sext.w	s6,a2
    80004288:	00004497          	auipc	s1,0x4
    8000428c:	a2048493          	addi	s1,s1,-1504 # 80007ca8 <cons>
    80004290:	00400993          	li	s3,4
    80004294:	fff00a13          	li	s4,-1
    80004298:	00a00a93          	li	s5,10
    8000429c:	05705e63          	blez	s7,800042f8 <consoleread+0xb4>
    800042a0:	09c4a703          	lw	a4,156(s1)
    800042a4:	0984a783          	lw	a5,152(s1)
    800042a8:	0007071b          	sext.w	a4,a4
    800042ac:	08e78463          	beq	a5,a4,80004334 <consoleread+0xf0>
    800042b0:	07f7f713          	andi	a4,a5,127
    800042b4:	00e48733          	add	a4,s1,a4
    800042b8:	01874703          	lbu	a4,24(a4) # c201018 <_entry-0x73dfefe8>
    800042bc:	0017869b          	addiw	a3,a5,1
    800042c0:	08d4ac23          	sw	a3,152(s1)
    800042c4:	00070c9b          	sext.w	s9,a4
    800042c8:	0b370663          	beq	a4,s3,80004374 <consoleread+0x130>
    800042cc:	00100693          	li	a3,1
    800042d0:	f9f40613          	addi	a2,s0,-97
    800042d4:	000c0593          	mv	a1,s8
    800042d8:	00090513          	mv	a0,s2
    800042dc:	f8e40fa3          	sb	a4,-97(s0)
    800042e0:	00000097          	auipc	ra,0x0
    800042e4:	8b8080e7          	jalr	-1864(ra) # 80003b98 <either_copyout>
    800042e8:	01450863          	beq	a0,s4,800042f8 <consoleread+0xb4>
    800042ec:	001c0c13          	addi	s8,s8,1
    800042f0:	fffb8b9b          	addiw	s7,s7,-1
    800042f4:	fb5c94e3          	bne	s9,s5,8000429c <consoleread+0x58>
    800042f8:	000b851b          	sext.w	a0,s7
    800042fc:	06813083          	ld	ra,104(sp)
    80004300:	06013403          	ld	s0,96(sp)
    80004304:	05813483          	ld	s1,88(sp)
    80004308:	05013903          	ld	s2,80(sp)
    8000430c:	04813983          	ld	s3,72(sp)
    80004310:	04013a03          	ld	s4,64(sp)
    80004314:	03813a83          	ld	s5,56(sp)
    80004318:	02813b83          	ld	s7,40(sp)
    8000431c:	02013c03          	ld	s8,32(sp)
    80004320:	01813c83          	ld	s9,24(sp)
    80004324:	40ab053b          	subw	a0,s6,a0
    80004328:	03013b03          	ld	s6,48(sp)
    8000432c:	07010113          	addi	sp,sp,112
    80004330:	00008067          	ret
    80004334:	00001097          	auipc	ra,0x1
    80004338:	1d8080e7          	jalr	472(ra) # 8000550c <push_on>
    8000433c:	0984a703          	lw	a4,152(s1)
    80004340:	09c4a783          	lw	a5,156(s1)
    80004344:	0007879b          	sext.w	a5,a5
    80004348:	fef70ce3          	beq	a4,a5,80004340 <consoleread+0xfc>
    8000434c:	00001097          	auipc	ra,0x1
    80004350:	234080e7          	jalr	564(ra) # 80005580 <pop_on>
    80004354:	0984a783          	lw	a5,152(s1)
    80004358:	07f7f713          	andi	a4,a5,127
    8000435c:	00e48733          	add	a4,s1,a4
    80004360:	01874703          	lbu	a4,24(a4)
    80004364:	0017869b          	addiw	a3,a5,1
    80004368:	08d4ac23          	sw	a3,152(s1)
    8000436c:	00070c9b          	sext.w	s9,a4
    80004370:	f5371ee3          	bne	a4,s3,800042cc <consoleread+0x88>
    80004374:	000b851b          	sext.w	a0,s7
    80004378:	f96bf2e3          	bgeu	s7,s6,800042fc <consoleread+0xb8>
    8000437c:	08f4ac23          	sw	a5,152(s1)
    80004380:	f7dff06f          	j	800042fc <consoleread+0xb8>

0000000080004384 <consputc>:
    80004384:	10000793          	li	a5,256
    80004388:	00f50663          	beq	a0,a5,80004394 <consputc+0x10>
    8000438c:	00001317          	auipc	t1,0x1
    80004390:	9f430067          	jr	-1548(t1) # 80004d80 <uartputc_sync>
    80004394:	ff010113          	addi	sp,sp,-16
    80004398:	00113423          	sd	ra,8(sp)
    8000439c:	00813023          	sd	s0,0(sp)
    800043a0:	01010413          	addi	s0,sp,16
    800043a4:	00800513          	li	a0,8
    800043a8:	00001097          	auipc	ra,0x1
    800043ac:	9d8080e7          	jalr	-1576(ra) # 80004d80 <uartputc_sync>
    800043b0:	02000513          	li	a0,32
    800043b4:	00001097          	auipc	ra,0x1
    800043b8:	9cc080e7          	jalr	-1588(ra) # 80004d80 <uartputc_sync>
    800043bc:	00013403          	ld	s0,0(sp)
    800043c0:	00813083          	ld	ra,8(sp)
    800043c4:	00800513          	li	a0,8
    800043c8:	01010113          	addi	sp,sp,16
    800043cc:	00001317          	auipc	t1,0x1
    800043d0:	9b430067          	jr	-1612(t1) # 80004d80 <uartputc_sync>

00000000800043d4 <consoleintr>:
    800043d4:	fe010113          	addi	sp,sp,-32
    800043d8:	00813823          	sd	s0,16(sp)
    800043dc:	00913423          	sd	s1,8(sp)
    800043e0:	01213023          	sd	s2,0(sp)
    800043e4:	00113c23          	sd	ra,24(sp)
    800043e8:	02010413          	addi	s0,sp,32
    800043ec:	00004917          	auipc	s2,0x4
    800043f0:	8bc90913          	addi	s2,s2,-1860 # 80007ca8 <cons>
    800043f4:	00050493          	mv	s1,a0
    800043f8:	00090513          	mv	a0,s2
    800043fc:	00001097          	auipc	ra,0x1
    80004400:	e40080e7          	jalr	-448(ra) # 8000523c <acquire>
    80004404:	02048c63          	beqz	s1,8000443c <consoleintr+0x68>
    80004408:	0a092783          	lw	a5,160(s2)
    8000440c:	09892703          	lw	a4,152(s2)
    80004410:	07f00693          	li	a3,127
    80004414:	40e7873b          	subw	a4,a5,a4
    80004418:	02e6e263          	bltu	a3,a4,8000443c <consoleintr+0x68>
    8000441c:	00d00713          	li	a4,13
    80004420:	04e48063          	beq	s1,a4,80004460 <consoleintr+0x8c>
    80004424:	07f7f713          	andi	a4,a5,127
    80004428:	00e90733          	add	a4,s2,a4
    8000442c:	0017879b          	addiw	a5,a5,1
    80004430:	0af92023          	sw	a5,160(s2)
    80004434:	00970c23          	sb	s1,24(a4)
    80004438:	08f92e23          	sw	a5,156(s2)
    8000443c:	01013403          	ld	s0,16(sp)
    80004440:	01813083          	ld	ra,24(sp)
    80004444:	00813483          	ld	s1,8(sp)
    80004448:	00013903          	ld	s2,0(sp)
    8000444c:	00004517          	auipc	a0,0x4
    80004450:	85c50513          	addi	a0,a0,-1956 # 80007ca8 <cons>
    80004454:	02010113          	addi	sp,sp,32
    80004458:	00001317          	auipc	t1,0x1
    8000445c:	eb030067          	jr	-336(t1) # 80005308 <release>
    80004460:	00a00493          	li	s1,10
    80004464:	fc1ff06f          	j	80004424 <consoleintr+0x50>

0000000080004468 <consoleinit>:
    80004468:	fe010113          	addi	sp,sp,-32
    8000446c:	00113c23          	sd	ra,24(sp)
    80004470:	00813823          	sd	s0,16(sp)
    80004474:	00913423          	sd	s1,8(sp)
    80004478:	02010413          	addi	s0,sp,32
    8000447c:	00004497          	auipc	s1,0x4
    80004480:	82c48493          	addi	s1,s1,-2004 # 80007ca8 <cons>
    80004484:	00048513          	mv	a0,s1
    80004488:	00002597          	auipc	a1,0x2
    8000448c:	de858593          	addi	a1,a1,-536 # 80006270 <CONSOLE_STATUS+0x260>
    80004490:	00001097          	auipc	ra,0x1
    80004494:	d88080e7          	jalr	-632(ra) # 80005218 <initlock>
    80004498:	00000097          	auipc	ra,0x0
    8000449c:	7ac080e7          	jalr	1964(ra) # 80004c44 <uartinit>
    800044a0:	01813083          	ld	ra,24(sp)
    800044a4:	01013403          	ld	s0,16(sp)
    800044a8:	00000797          	auipc	a5,0x0
    800044ac:	d9c78793          	addi	a5,a5,-612 # 80004244 <consoleread>
    800044b0:	0af4bc23          	sd	a5,184(s1)
    800044b4:	00000797          	auipc	a5,0x0
    800044b8:	cec78793          	addi	a5,a5,-788 # 800041a0 <consolewrite>
    800044bc:	0cf4b023          	sd	a5,192(s1)
    800044c0:	00813483          	ld	s1,8(sp)
    800044c4:	02010113          	addi	sp,sp,32
    800044c8:	00008067          	ret

00000000800044cc <console_read>:
    800044cc:	ff010113          	addi	sp,sp,-16
    800044d0:	00813423          	sd	s0,8(sp)
    800044d4:	01010413          	addi	s0,sp,16
    800044d8:	00813403          	ld	s0,8(sp)
    800044dc:	00004317          	auipc	t1,0x4
    800044e0:	88433303          	ld	t1,-1916(t1) # 80007d60 <devsw+0x10>
    800044e4:	01010113          	addi	sp,sp,16
    800044e8:	00030067          	jr	t1

00000000800044ec <console_write>:
    800044ec:	ff010113          	addi	sp,sp,-16
    800044f0:	00813423          	sd	s0,8(sp)
    800044f4:	01010413          	addi	s0,sp,16
    800044f8:	00813403          	ld	s0,8(sp)
    800044fc:	00004317          	auipc	t1,0x4
    80004500:	86c33303          	ld	t1,-1940(t1) # 80007d68 <devsw+0x18>
    80004504:	01010113          	addi	sp,sp,16
    80004508:	00030067          	jr	t1

000000008000450c <panic>:
    8000450c:	fe010113          	addi	sp,sp,-32
    80004510:	00113c23          	sd	ra,24(sp)
    80004514:	00813823          	sd	s0,16(sp)
    80004518:	00913423          	sd	s1,8(sp)
    8000451c:	02010413          	addi	s0,sp,32
    80004520:	00050493          	mv	s1,a0
    80004524:	00002517          	auipc	a0,0x2
    80004528:	d5450513          	addi	a0,a0,-684 # 80006278 <CONSOLE_STATUS+0x268>
    8000452c:	00004797          	auipc	a5,0x4
    80004530:	8c07ae23          	sw	zero,-1828(a5) # 80007e08 <pr+0x18>
    80004534:	00000097          	auipc	ra,0x0
    80004538:	034080e7          	jalr	52(ra) # 80004568 <__printf>
    8000453c:	00048513          	mv	a0,s1
    80004540:	00000097          	auipc	ra,0x0
    80004544:	028080e7          	jalr	40(ra) # 80004568 <__printf>
    80004548:	00002517          	auipc	a0,0x2
    8000454c:	d1050513          	addi	a0,a0,-752 # 80006258 <CONSOLE_STATUS+0x248>
    80004550:	00000097          	auipc	ra,0x0
    80004554:	018080e7          	jalr	24(ra) # 80004568 <__printf>
    80004558:	00100793          	li	a5,1
    8000455c:	00002717          	auipc	a4,0x2
    80004560:	64f72223          	sw	a5,1604(a4) # 80006ba0 <panicked>
    80004564:	0000006f          	j	80004564 <panic+0x58>

0000000080004568 <__printf>:
    80004568:	f3010113          	addi	sp,sp,-208
    8000456c:	08813023          	sd	s0,128(sp)
    80004570:	07313423          	sd	s3,104(sp)
    80004574:	09010413          	addi	s0,sp,144
    80004578:	05813023          	sd	s8,64(sp)
    8000457c:	08113423          	sd	ra,136(sp)
    80004580:	06913c23          	sd	s1,120(sp)
    80004584:	07213823          	sd	s2,112(sp)
    80004588:	07413023          	sd	s4,96(sp)
    8000458c:	05513c23          	sd	s5,88(sp)
    80004590:	05613823          	sd	s6,80(sp)
    80004594:	05713423          	sd	s7,72(sp)
    80004598:	03913c23          	sd	s9,56(sp)
    8000459c:	03a13823          	sd	s10,48(sp)
    800045a0:	03b13423          	sd	s11,40(sp)
    800045a4:	00004317          	auipc	t1,0x4
    800045a8:	84c30313          	addi	t1,t1,-1972 # 80007df0 <pr>
    800045ac:	01832c03          	lw	s8,24(t1)
    800045b0:	00b43423          	sd	a1,8(s0)
    800045b4:	00c43823          	sd	a2,16(s0)
    800045b8:	00d43c23          	sd	a3,24(s0)
    800045bc:	02e43023          	sd	a4,32(s0)
    800045c0:	02f43423          	sd	a5,40(s0)
    800045c4:	03043823          	sd	a6,48(s0)
    800045c8:	03143c23          	sd	a7,56(s0)
    800045cc:	00050993          	mv	s3,a0
    800045d0:	4a0c1663          	bnez	s8,80004a7c <__printf+0x514>
    800045d4:	60098c63          	beqz	s3,80004bec <__printf+0x684>
    800045d8:	0009c503          	lbu	a0,0(s3)
    800045dc:	00840793          	addi	a5,s0,8
    800045e0:	f6f43c23          	sd	a5,-136(s0)
    800045e4:	00000493          	li	s1,0
    800045e8:	22050063          	beqz	a0,80004808 <__printf+0x2a0>
    800045ec:	00002a37          	lui	s4,0x2
    800045f0:	00018ab7          	lui	s5,0x18
    800045f4:	000f4b37          	lui	s6,0xf4
    800045f8:	00989bb7          	lui	s7,0x989
    800045fc:	70fa0a13          	addi	s4,s4,1807 # 270f <_entry-0x7fffd8f1>
    80004600:	69fa8a93          	addi	s5,s5,1695 # 1869f <_entry-0x7ffe7961>
    80004604:	23fb0b13          	addi	s6,s6,575 # f423f <_entry-0x7ff0bdc1>
    80004608:	67fb8b93          	addi	s7,s7,1663 # 98967f <_entry-0x7f676981>
    8000460c:	00148c9b          	addiw	s9,s1,1
    80004610:	02500793          	li	a5,37
    80004614:	01998933          	add	s2,s3,s9
    80004618:	38f51263          	bne	a0,a5,8000499c <__printf+0x434>
    8000461c:	00094783          	lbu	a5,0(s2)
    80004620:	00078c9b          	sext.w	s9,a5
    80004624:	1e078263          	beqz	a5,80004808 <__printf+0x2a0>
    80004628:	0024849b          	addiw	s1,s1,2
    8000462c:	07000713          	li	a4,112
    80004630:	00998933          	add	s2,s3,s1
    80004634:	38e78a63          	beq	a5,a4,800049c8 <__printf+0x460>
    80004638:	20f76863          	bltu	a4,a5,80004848 <__printf+0x2e0>
    8000463c:	42a78863          	beq	a5,a0,80004a6c <__printf+0x504>
    80004640:	06400713          	li	a4,100
    80004644:	40e79663          	bne	a5,a4,80004a50 <__printf+0x4e8>
    80004648:	f7843783          	ld	a5,-136(s0)
    8000464c:	0007a603          	lw	a2,0(a5)
    80004650:	00878793          	addi	a5,a5,8
    80004654:	f6f43c23          	sd	a5,-136(s0)
    80004658:	42064a63          	bltz	a2,80004a8c <__printf+0x524>
    8000465c:	00a00713          	li	a4,10
    80004660:	02e677bb          	remuw	a5,a2,a4
    80004664:	00002d97          	auipc	s11,0x2
    80004668:	c3cd8d93          	addi	s11,s11,-964 # 800062a0 <digits>
    8000466c:	00900593          	li	a1,9
    80004670:	0006051b          	sext.w	a0,a2
    80004674:	00000c93          	li	s9,0
    80004678:	02079793          	slli	a5,a5,0x20
    8000467c:	0207d793          	srli	a5,a5,0x20
    80004680:	00fd87b3          	add	a5,s11,a5
    80004684:	0007c783          	lbu	a5,0(a5)
    80004688:	02e656bb          	divuw	a3,a2,a4
    8000468c:	f8f40023          	sb	a5,-128(s0)
    80004690:	14c5d863          	bge	a1,a2,800047e0 <__printf+0x278>
    80004694:	06300593          	li	a1,99
    80004698:	00100c93          	li	s9,1
    8000469c:	02e6f7bb          	remuw	a5,a3,a4
    800046a0:	02079793          	slli	a5,a5,0x20
    800046a4:	0207d793          	srli	a5,a5,0x20
    800046a8:	00fd87b3          	add	a5,s11,a5
    800046ac:	0007c783          	lbu	a5,0(a5)
    800046b0:	02e6d73b          	divuw	a4,a3,a4
    800046b4:	f8f400a3          	sb	a5,-127(s0)
    800046b8:	12a5f463          	bgeu	a1,a0,800047e0 <__printf+0x278>
    800046bc:	00a00693          	li	a3,10
    800046c0:	00900593          	li	a1,9
    800046c4:	02d777bb          	remuw	a5,a4,a3
    800046c8:	02079793          	slli	a5,a5,0x20
    800046cc:	0207d793          	srli	a5,a5,0x20
    800046d0:	00fd87b3          	add	a5,s11,a5
    800046d4:	0007c503          	lbu	a0,0(a5)
    800046d8:	02d757bb          	divuw	a5,a4,a3
    800046dc:	f8a40123          	sb	a0,-126(s0)
    800046e0:	48e5f263          	bgeu	a1,a4,80004b64 <__printf+0x5fc>
    800046e4:	06300513          	li	a0,99
    800046e8:	02d7f5bb          	remuw	a1,a5,a3
    800046ec:	02059593          	slli	a1,a1,0x20
    800046f0:	0205d593          	srli	a1,a1,0x20
    800046f4:	00bd85b3          	add	a1,s11,a1
    800046f8:	0005c583          	lbu	a1,0(a1)
    800046fc:	02d7d7bb          	divuw	a5,a5,a3
    80004700:	f8b401a3          	sb	a1,-125(s0)
    80004704:	48e57263          	bgeu	a0,a4,80004b88 <__printf+0x620>
    80004708:	3e700513          	li	a0,999
    8000470c:	02d7f5bb          	remuw	a1,a5,a3
    80004710:	02059593          	slli	a1,a1,0x20
    80004714:	0205d593          	srli	a1,a1,0x20
    80004718:	00bd85b3          	add	a1,s11,a1
    8000471c:	0005c583          	lbu	a1,0(a1)
    80004720:	02d7d7bb          	divuw	a5,a5,a3
    80004724:	f8b40223          	sb	a1,-124(s0)
    80004728:	46e57663          	bgeu	a0,a4,80004b94 <__printf+0x62c>
    8000472c:	02d7f5bb          	remuw	a1,a5,a3
    80004730:	02059593          	slli	a1,a1,0x20
    80004734:	0205d593          	srli	a1,a1,0x20
    80004738:	00bd85b3          	add	a1,s11,a1
    8000473c:	0005c583          	lbu	a1,0(a1)
    80004740:	02d7d7bb          	divuw	a5,a5,a3
    80004744:	f8b402a3          	sb	a1,-123(s0)
    80004748:	46ea7863          	bgeu	s4,a4,80004bb8 <__printf+0x650>
    8000474c:	02d7f5bb          	remuw	a1,a5,a3
    80004750:	02059593          	slli	a1,a1,0x20
    80004754:	0205d593          	srli	a1,a1,0x20
    80004758:	00bd85b3          	add	a1,s11,a1
    8000475c:	0005c583          	lbu	a1,0(a1)
    80004760:	02d7d7bb          	divuw	a5,a5,a3
    80004764:	f8b40323          	sb	a1,-122(s0)
    80004768:	3eeaf863          	bgeu	s5,a4,80004b58 <__printf+0x5f0>
    8000476c:	02d7f5bb          	remuw	a1,a5,a3
    80004770:	02059593          	slli	a1,a1,0x20
    80004774:	0205d593          	srli	a1,a1,0x20
    80004778:	00bd85b3          	add	a1,s11,a1
    8000477c:	0005c583          	lbu	a1,0(a1)
    80004780:	02d7d7bb          	divuw	a5,a5,a3
    80004784:	f8b403a3          	sb	a1,-121(s0)
    80004788:	42eb7e63          	bgeu	s6,a4,80004bc4 <__printf+0x65c>
    8000478c:	02d7f5bb          	remuw	a1,a5,a3
    80004790:	02059593          	slli	a1,a1,0x20
    80004794:	0205d593          	srli	a1,a1,0x20
    80004798:	00bd85b3          	add	a1,s11,a1
    8000479c:	0005c583          	lbu	a1,0(a1)
    800047a0:	02d7d7bb          	divuw	a5,a5,a3
    800047a4:	f8b40423          	sb	a1,-120(s0)
    800047a8:	42ebfc63          	bgeu	s7,a4,80004be0 <__printf+0x678>
    800047ac:	02079793          	slli	a5,a5,0x20
    800047b0:	0207d793          	srli	a5,a5,0x20
    800047b4:	00fd8db3          	add	s11,s11,a5
    800047b8:	000dc703          	lbu	a4,0(s11)
    800047bc:	00a00793          	li	a5,10
    800047c0:	00900c93          	li	s9,9
    800047c4:	f8e404a3          	sb	a4,-119(s0)
    800047c8:	00065c63          	bgez	a2,800047e0 <__printf+0x278>
    800047cc:	f9040713          	addi	a4,s0,-112
    800047d0:	00f70733          	add	a4,a4,a5
    800047d4:	02d00693          	li	a3,45
    800047d8:	fed70823          	sb	a3,-16(a4)
    800047dc:	00078c93          	mv	s9,a5
    800047e0:	f8040793          	addi	a5,s0,-128
    800047e4:	01978cb3          	add	s9,a5,s9
    800047e8:	f7f40d13          	addi	s10,s0,-129
    800047ec:	000cc503          	lbu	a0,0(s9)
    800047f0:	fffc8c93          	addi	s9,s9,-1
    800047f4:	00000097          	auipc	ra,0x0
    800047f8:	b90080e7          	jalr	-1136(ra) # 80004384 <consputc>
    800047fc:	ffac98e3          	bne	s9,s10,800047ec <__printf+0x284>
    80004800:	00094503          	lbu	a0,0(s2)
    80004804:	e00514e3          	bnez	a0,8000460c <__printf+0xa4>
    80004808:	1a0c1663          	bnez	s8,800049b4 <__printf+0x44c>
    8000480c:	08813083          	ld	ra,136(sp)
    80004810:	08013403          	ld	s0,128(sp)
    80004814:	07813483          	ld	s1,120(sp)
    80004818:	07013903          	ld	s2,112(sp)
    8000481c:	06813983          	ld	s3,104(sp)
    80004820:	06013a03          	ld	s4,96(sp)
    80004824:	05813a83          	ld	s5,88(sp)
    80004828:	05013b03          	ld	s6,80(sp)
    8000482c:	04813b83          	ld	s7,72(sp)
    80004830:	04013c03          	ld	s8,64(sp)
    80004834:	03813c83          	ld	s9,56(sp)
    80004838:	03013d03          	ld	s10,48(sp)
    8000483c:	02813d83          	ld	s11,40(sp)
    80004840:	0d010113          	addi	sp,sp,208
    80004844:	00008067          	ret
    80004848:	07300713          	li	a4,115
    8000484c:	1ce78a63          	beq	a5,a4,80004a20 <__printf+0x4b8>
    80004850:	07800713          	li	a4,120
    80004854:	1ee79e63          	bne	a5,a4,80004a50 <__printf+0x4e8>
    80004858:	f7843783          	ld	a5,-136(s0)
    8000485c:	0007a703          	lw	a4,0(a5)
    80004860:	00878793          	addi	a5,a5,8
    80004864:	f6f43c23          	sd	a5,-136(s0)
    80004868:	28074263          	bltz	a4,80004aec <__printf+0x584>
    8000486c:	00002d97          	auipc	s11,0x2
    80004870:	a34d8d93          	addi	s11,s11,-1484 # 800062a0 <digits>
    80004874:	00f77793          	andi	a5,a4,15
    80004878:	00fd87b3          	add	a5,s11,a5
    8000487c:	0007c683          	lbu	a3,0(a5)
    80004880:	00f00613          	li	a2,15
    80004884:	0007079b          	sext.w	a5,a4
    80004888:	f8d40023          	sb	a3,-128(s0)
    8000488c:	0047559b          	srliw	a1,a4,0x4
    80004890:	0047569b          	srliw	a3,a4,0x4
    80004894:	00000c93          	li	s9,0
    80004898:	0ee65063          	bge	a2,a4,80004978 <__printf+0x410>
    8000489c:	00f6f693          	andi	a3,a3,15
    800048a0:	00dd86b3          	add	a3,s11,a3
    800048a4:	0006c683          	lbu	a3,0(a3) # 2004000 <_entry-0x7dffc000>
    800048a8:	0087d79b          	srliw	a5,a5,0x8
    800048ac:	00100c93          	li	s9,1
    800048b0:	f8d400a3          	sb	a3,-127(s0)
    800048b4:	0cb67263          	bgeu	a2,a1,80004978 <__printf+0x410>
    800048b8:	00f7f693          	andi	a3,a5,15
    800048bc:	00dd86b3          	add	a3,s11,a3
    800048c0:	0006c583          	lbu	a1,0(a3)
    800048c4:	00f00613          	li	a2,15
    800048c8:	0047d69b          	srliw	a3,a5,0x4
    800048cc:	f8b40123          	sb	a1,-126(s0)
    800048d0:	0047d593          	srli	a1,a5,0x4
    800048d4:	28f67e63          	bgeu	a2,a5,80004b70 <__printf+0x608>
    800048d8:	00f6f693          	andi	a3,a3,15
    800048dc:	00dd86b3          	add	a3,s11,a3
    800048e0:	0006c503          	lbu	a0,0(a3)
    800048e4:	0087d813          	srli	a6,a5,0x8
    800048e8:	0087d69b          	srliw	a3,a5,0x8
    800048ec:	f8a401a3          	sb	a0,-125(s0)
    800048f0:	28b67663          	bgeu	a2,a1,80004b7c <__printf+0x614>
    800048f4:	00f6f693          	andi	a3,a3,15
    800048f8:	00dd86b3          	add	a3,s11,a3
    800048fc:	0006c583          	lbu	a1,0(a3)
    80004900:	00c7d513          	srli	a0,a5,0xc
    80004904:	00c7d69b          	srliw	a3,a5,0xc
    80004908:	f8b40223          	sb	a1,-124(s0)
    8000490c:	29067a63          	bgeu	a2,a6,80004ba0 <__printf+0x638>
    80004910:	00f6f693          	andi	a3,a3,15
    80004914:	00dd86b3          	add	a3,s11,a3
    80004918:	0006c583          	lbu	a1,0(a3)
    8000491c:	0107d813          	srli	a6,a5,0x10
    80004920:	0107d69b          	srliw	a3,a5,0x10
    80004924:	f8b402a3          	sb	a1,-123(s0)
    80004928:	28a67263          	bgeu	a2,a0,80004bac <__printf+0x644>
    8000492c:	00f6f693          	andi	a3,a3,15
    80004930:	00dd86b3          	add	a3,s11,a3
    80004934:	0006c683          	lbu	a3,0(a3)
    80004938:	0147d79b          	srliw	a5,a5,0x14
    8000493c:	f8d40323          	sb	a3,-122(s0)
    80004940:	21067663          	bgeu	a2,a6,80004b4c <__printf+0x5e4>
    80004944:	02079793          	slli	a5,a5,0x20
    80004948:	0207d793          	srli	a5,a5,0x20
    8000494c:	00fd8db3          	add	s11,s11,a5
    80004950:	000dc683          	lbu	a3,0(s11)
    80004954:	00800793          	li	a5,8
    80004958:	00700c93          	li	s9,7
    8000495c:	f8d403a3          	sb	a3,-121(s0)
    80004960:	00075c63          	bgez	a4,80004978 <__printf+0x410>
    80004964:	f9040713          	addi	a4,s0,-112
    80004968:	00f70733          	add	a4,a4,a5
    8000496c:	02d00693          	li	a3,45
    80004970:	fed70823          	sb	a3,-16(a4)
    80004974:	00078c93          	mv	s9,a5
    80004978:	f8040793          	addi	a5,s0,-128
    8000497c:	01978cb3          	add	s9,a5,s9
    80004980:	f7f40d13          	addi	s10,s0,-129
    80004984:	000cc503          	lbu	a0,0(s9)
    80004988:	fffc8c93          	addi	s9,s9,-1
    8000498c:	00000097          	auipc	ra,0x0
    80004990:	9f8080e7          	jalr	-1544(ra) # 80004384 <consputc>
    80004994:	ff9d18e3          	bne	s10,s9,80004984 <__printf+0x41c>
    80004998:	0100006f          	j	800049a8 <__printf+0x440>
    8000499c:	00000097          	auipc	ra,0x0
    800049a0:	9e8080e7          	jalr	-1560(ra) # 80004384 <consputc>
    800049a4:	000c8493          	mv	s1,s9
    800049a8:	00094503          	lbu	a0,0(s2)
    800049ac:	c60510e3          	bnez	a0,8000460c <__printf+0xa4>
    800049b0:	e40c0ee3          	beqz	s8,8000480c <__printf+0x2a4>
    800049b4:	00003517          	auipc	a0,0x3
    800049b8:	43c50513          	addi	a0,a0,1084 # 80007df0 <pr>
    800049bc:	00001097          	auipc	ra,0x1
    800049c0:	94c080e7          	jalr	-1716(ra) # 80005308 <release>
    800049c4:	e49ff06f          	j	8000480c <__printf+0x2a4>
    800049c8:	f7843783          	ld	a5,-136(s0)
    800049cc:	03000513          	li	a0,48
    800049d0:	01000d13          	li	s10,16
    800049d4:	00878713          	addi	a4,a5,8
    800049d8:	0007bc83          	ld	s9,0(a5)
    800049dc:	f6e43c23          	sd	a4,-136(s0)
    800049e0:	00000097          	auipc	ra,0x0
    800049e4:	9a4080e7          	jalr	-1628(ra) # 80004384 <consputc>
    800049e8:	07800513          	li	a0,120
    800049ec:	00000097          	auipc	ra,0x0
    800049f0:	998080e7          	jalr	-1640(ra) # 80004384 <consputc>
    800049f4:	00002d97          	auipc	s11,0x2
    800049f8:	8acd8d93          	addi	s11,s11,-1876 # 800062a0 <digits>
    800049fc:	03ccd793          	srli	a5,s9,0x3c
    80004a00:	00fd87b3          	add	a5,s11,a5
    80004a04:	0007c503          	lbu	a0,0(a5)
    80004a08:	fffd0d1b          	addiw	s10,s10,-1
    80004a0c:	004c9c93          	slli	s9,s9,0x4
    80004a10:	00000097          	auipc	ra,0x0
    80004a14:	974080e7          	jalr	-1676(ra) # 80004384 <consputc>
    80004a18:	fe0d12e3          	bnez	s10,800049fc <__printf+0x494>
    80004a1c:	f8dff06f          	j	800049a8 <__printf+0x440>
    80004a20:	f7843783          	ld	a5,-136(s0)
    80004a24:	0007bc83          	ld	s9,0(a5)
    80004a28:	00878793          	addi	a5,a5,8
    80004a2c:	f6f43c23          	sd	a5,-136(s0)
    80004a30:	000c9a63          	bnez	s9,80004a44 <__printf+0x4dc>
    80004a34:	1080006f          	j	80004b3c <__printf+0x5d4>
    80004a38:	001c8c93          	addi	s9,s9,1
    80004a3c:	00000097          	auipc	ra,0x0
    80004a40:	948080e7          	jalr	-1720(ra) # 80004384 <consputc>
    80004a44:	000cc503          	lbu	a0,0(s9)
    80004a48:	fe0518e3          	bnez	a0,80004a38 <__printf+0x4d0>
    80004a4c:	f5dff06f          	j	800049a8 <__printf+0x440>
    80004a50:	02500513          	li	a0,37
    80004a54:	00000097          	auipc	ra,0x0
    80004a58:	930080e7          	jalr	-1744(ra) # 80004384 <consputc>
    80004a5c:	000c8513          	mv	a0,s9
    80004a60:	00000097          	auipc	ra,0x0
    80004a64:	924080e7          	jalr	-1756(ra) # 80004384 <consputc>
    80004a68:	f41ff06f          	j	800049a8 <__printf+0x440>
    80004a6c:	02500513          	li	a0,37
    80004a70:	00000097          	auipc	ra,0x0
    80004a74:	914080e7          	jalr	-1772(ra) # 80004384 <consputc>
    80004a78:	f31ff06f          	j	800049a8 <__printf+0x440>
    80004a7c:	00030513          	mv	a0,t1
    80004a80:	00000097          	auipc	ra,0x0
    80004a84:	7bc080e7          	jalr	1980(ra) # 8000523c <acquire>
    80004a88:	b4dff06f          	j	800045d4 <__printf+0x6c>
    80004a8c:	40c0053b          	negw	a0,a2
    80004a90:	00a00713          	li	a4,10
    80004a94:	02e576bb          	remuw	a3,a0,a4
    80004a98:	00002d97          	auipc	s11,0x2
    80004a9c:	808d8d93          	addi	s11,s11,-2040 # 800062a0 <digits>
    80004aa0:	ff700593          	li	a1,-9
    80004aa4:	02069693          	slli	a3,a3,0x20
    80004aa8:	0206d693          	srli	a3,a3,0x20
    80004aac:	00dd86b3          	add	a3,s11,a3
    80004ab0:	0006c683          	lbu	a3,0(a3)
    80004ab4:	02e557bb          	divuw	a5,a0,a4
    80004ab8:	f8d40023          	sb	a3,-128(s0)
    80004abc:	10b65e63          	bge	a2,a1,80004bd8 <__printf+0x670>
    80004ac0:	06300593          	li	a1,99
    80004ac4:	02e7f6bb          	remuw	a3,a5,a4
    80004ac8:	02069693          	slli	a3,a3,0x20
    80004acc:	0206d693          	srli	a3,a3,0x20
    80004ad0:	00dd86b3          	add	a3,s11,a3
    80004ad4:	0006c683          	lbu	a3,0(a3)
    80004ad8:	02e7d73b          	divuw	a4,a5,a4
    80004adc:	00200793          	li	a5,2
    80004ae0:	f8d400a3          	sb	a3,-127(s0)
    80004ae4:	bca5ece3          	bltu	a1,a0,800046bc <__printf+0x154>
    80004ae8:	ce5ff06f          	j	800047cc <__printf+0x264>
    80004aec:	40e007bb          	negw	a5,a4
    80004af0:	00001d97          	auipc	s11,0x1
    80004af4:	7b0d8d93          	addi	s11,s11,1968 # 800062a0 <digits>
    80004af8:	00f7f693          	andi	a3,a5,15
    80004afc:	00dd86b3          	add	a3,s11,a3
    80004b00:	0006c583          	lbu	a1,0(a3)
    80004b04:	ff100613          	li	a2,-15
    80004b08:	0047d69b          	srliw	a3,a5,0x4
    80004b0c:	f8b40023          	sb	a1,-128(s0)
    80004b10:	0047d59b          	srliw	a1,a5,0x4
    80004b14:	0ac75e63          	bge	a4,a2,80004bd0 <__printf+0x668>
    80004b18:	00f6f693          	andi	a3,a3,15
    80004b1c:	00dd86b3          	add	a3,s11,a3
    80004b20:	0006c603          	lbu	a2,0(a3)
    80004b24:	00f00693          	li	a3,15
    80004b28:	0087d79b          	srliw	a5,a5,0x8
    80004b2c:	f8c400a3          	sb	a2,-127(s0)
    80004b30:	d8b6e4e3          	bltu	a3,a1,800048b8 <__printf+0x350>
    80004b34:	00200793          	li	a5,2
    80004b38:	e2dff06f          	j	80004964 <__printf+0x3fc>
    80004b3c:	00001c97          	auipc	s9,0x1
    80004b40:	744c8c93          	addi	s9,s9,1860 # 80006280 <CONSOLE_STATUS+0x270>
    80004b44:	02800513          	li	a0,40
    80004b48:	ef1ff06f          	j	80004a38 <__printf+0x4d0>
    80004b4c:	00700793          	li	a5,7
    80004b50:	00600c93          	li	s9,6
    80004b54:	e0dff06f          	j	80004960 <__printf+0x3f8>
    80004b58:	00700793          	li	a5,7
    80004b5c:	00600c93          	li	s9,6
    80004b60:	c69ff06f          	j	800047c8 <__printf+0x260>
    80004b64:	00300793          	li	a5,3
    80004b68:	00200c93          	li	s9,2
    80004b6c:	c5dff06f          	j	800047c8 <__printf+0x260>
    80004b70:	00300793          	li	a5,3
    80004b74:	00200c93          	li	s9,2
    80004b78:	de9ff06f          	j	80004960 <__printf+0x3f8>
    80004b7c:	00400793          	li	a5,4
    80004b80:	00300c93          	li	s9,3
    80004b84:	dddff06f          	j	80004960 <__printf+0x3f8>
    80004b88:	00400793          	li	a5,4
    80004b8c:	00300c93          	li	s9,3
    80004b90:	c39ff06f          	j	800047c8 <__printf+0x260>
    80004b94:	00500793          	li	a5,5
    80004b98:	00400c93          	li	s9,4
    80004b9c:	c2dff06f          	j	800047c8 <__printf+0x260>
    80004ba0:	00500793          	li	a5,5
    80004ba4:	00400c93          	li	s9,4
    80004ba8:	db9ff06f          	j	80004960 <__printf+0x3f8>
    80004bac:	00600793          	li	a5,6
    80004bb0:	00500c93          	li	s9,5
    80004bb4:	dadff06f          	j	80004960 <__printf+0x3f8>
    80004bb8:	00600793          	li	a5,6
    80004bbc:	00500c93          	li	s9,5
    80004bc0:	c09ff06f          	j	800047c8 <__printf+0x260>
    80004bc4:	00800793          	li	a5,8
    80004bc8:	00700c93          	li	s9,7
    80004bcc:	bfdff06f          	j	800047c8 <__printf+0x260>
    80004bd0:	00100793          	li	a5,1
    80004bd4:	d91ff06f          	j	80004964 <__printf+0x3fc>
    80004bd8:	00100793          	li	a5,1
    80004bdc:	bf1ff06f          	j	800047cc <__printf+0x264>
    80004be0:	00900793          	li	a5,9
    80004be4:	00800c93          	li	s9,8
    80004be8:	be1ff06f          	j	800047c8 <__printf+0x260>
    80004bec:	00001517          	auipc	a0,0x1
    80004bf0:	69c50513          	addi	a0,a0,1692 # 80006288 <CONSOLE_STATUS+0x278>
    80004bf4:	00000097          	auipc	ra,0x0
    80004bf8:	918080e7          	jalr	-1768(ra) # 8000450c <panic>

0000000080004bfc <printfinit>:
    80004bfc:	fe010113          	addi	sp,sp,-32
    80004c00:	00813823          	sd	s0,16(sp)
    80004c04:	00913423          	sd	s1,8(sp)
    80004c08:	00113c23          	sd	ra,24(sp)
    80004c0c:	02010413          	addi	s0,sp,32
    80004c10:	00003497          	auipc	s1,0x3
    80004c14:	1e048493          	addi	s1,s1,480 # 80007df0 <pr>
    80004c18:	00048513          	mv	a0,s1
    80004c1c:	00001597          	auipc	a1,0x1
    80004c20:	67c58593          	addi	a1,a1,1660 # 80006298 <CONSOLE_STATUS+0x288>
    80004c24:	00000097          	auipc	ra,0x0
    80004c28:	5f4080e7          	jalr	1524(ra) # 80005218 <initlock>
    80004c2c:	01813083          	ld	ra,24(sp)
    80004c30:	01013403          	ld	s0,16(sp)
    80004c34:	0004ac23          	sw	zero,24(s1)
    80004c38:	00813483          	ld	s1,8(sp)
    80004c3c:	02010113          	addi	sp,sp,32
    80004c40:	00008067          	ret

0000000080004c44 <uartinit>:
    80004c44:	ff010113          	addi	sp,sp,-16
    80004c48:	00813423          	sd	s0,8(sp)
    80004c4c:	01010413          	addi	s0,sp,16
    80004c50:	100007b7          	lui	a5,0x10000
    80004c54:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>
    80004c58:	f8000713          	li	a4,-128
    80004c5c:	00e781a3          	sb	a4,3(a5)
    80004c60:	00300713          	li	a4,3
    80004c64:	00e78023          	sb	a4,0(a5)
    80004c68:	000780a3          	sb	zero,1(a5)
    80004c6c:	00e781a3          	sb	a4,3(a5)
    80004c70:	00700693          	li	a3,7
    80004c74:	00d78123          	sb	a3,2(a5)
    80004c78:	00e780a3          	sb	a4,1(a5)
    80004c7c:	00813403          	ld	s0,8(sp)
    80004c80:	01010113          	addi	sp,sp,16
    80004c84:	00008067          	ret

0000000080004c88 <uartputc>:
    80004c88:	00002797          	auipc	a5,0x2
    80004c8c:	f187a783          	lw	a5,-232(a5) # 80006ba0 <panicked>
    80004c90:	00078463          	beqz	a5,80004c98 <uartputc+0x10>
    80004c94:	0000006f          	j	80004c94 <uartputc+0xc>
    80004c98:	fd010113          	addi	sp,sp,-48
    80004c9c:	02813023          	sd	s0,32(sp)
    80004ca0:	00913c23          	sd	s1,24(sp)
    80004ca4:	01213823          	sd	s2,16(sp)
    80004ca8:	01313423          	sd	s3,8(sp)
    80004cac:	02113423          	sd	ra,40(sp)
    80004cb0:	03010413          	addi	s0,sp,48
    80004cb4:	00002917          	auipc	s2,0x2
    80004cb8:	ef490913          	addi	s2,s2,-268 # 80006ba8 <uart_tx_r>
    80004cbc:	00093783          	ld	a5,0(s2)
    80004cc0:	00002497          	auipc	s1,0x2
    80004cc4:	ef048493          	addi	s1,s1,-272 # 80006bb0 <uart_tx_w>
    80004cc8:	0004b703          	ld	a4,0(s1)
    80004ccc:	02078693          	addi	a3,a5,32
    80004cd0:	00050993          	mv	s3,a0
    80004cd4:	02e69c63          	bne	a3,a4,80004d0c <uartputc+0x84>
    80004cd8:	00001097          	auipc	ra,0x1
    80004cdc:	834080e7          	jalr	-1996(ra) # 8000550c <push_on>
    80004ce0:	00093783          	ld	a5,0(s2)
    80004ce4:	0004b703          	ld	a4,0(s1)
    80004ce8:	02078793          	addi	a5,a5,32
    80004cec:	00e79463          	bne	a5,a4,80004cf4 <uartputc+0x6c>
    80004cf0:	0000006f          	j	80004cf0 <uartputc+0x68>
    80004cf4:	00001097          	auipc	ra,0x1
    80004cf8:	88c080e7          	jalr	-1908(ra) # 80005580 <pop_on>
    80004cfc:	00093783          	ld	a5,0(s2)
    80004d00:	0004b703          	ld	a4,0(s1)
    80004d04:	02078693          	addi	a3,a5,32
    80004d08:	fce688e3          	beq	a3,a4,80004cd8 <uartputc+0x50>
    80004d0c:	01f77693          	andi	a3,a4,31
    80004d10:	00003597          	auipc	a1,0x3
    80004d14:	10058593          	addi	a1,a1,256 # 80007e10 <uart_tx_buf>
    80004d18:	00d586b3          	add	a3,a1,a3
    80004d1c:	00170713          	addi	a4,a4,1
    80004d20:	01368023          	sb	s3,0(a3)
    80004d24:	00e4b023          	sd	a4,0(s1)
    80004d28:	10000637          	lui	a2,0x10000
    80004d2c:	02f71063          	bne	a4,a5,80004d4c <uartputc+0xc4>
    80004d30:	0340006f          	j	80004d64 <uartputc+0xdc>
    80004d34:	00074703          	lbu	a4,0(a4)
    80004d38:	00f93023          	sd	a5,0(s2)
    80004d3c:	00e60023          	sb	a4,0(a2) # 10000000 <_entry-0x70000000>
    80004d40:	00093783          	ld	a5,0(s2)
    80004d44:	0004b703          	ld	a4,0(s1)
    80004d48:	00f70e63          	beq	a4,a5,80004d64 <uartputc+0xdc>
    80004d4c:	00564683          	lbu	a3,5(a2)
    80004d50:	01f7f713          	andi	a4,a5,31
    80004d54:	00e58733          	add	a4,a1,a4
    80004d58:	0206f693          	andi	a3,a3,32
    80004d5c:	00178793          	addi	a5,a5,1
    80004d60:	fc069ae3          	bnez	a3,80004d34 <uartputc+0xac>
    80004d64:	02813083          	ld	ra,40(sp)
    80004d68:	02013403          	ld	s0,32(sp)
    80004d6c:	01813483          	ld	s1,24(sp)
    80004d70:	01013903          	ld	s2,16(sp)
    80004d74:	00813983          	ld	s3,8(sp)
    80004d78:	03010113          	addi	sp,sp,48
    80004d7c:	00008067          	ret

0000000080004d80 <uartputc_sync>:
    80004d80:	ff010113          	addi	sp,sp,-16
    80004d84:	00813423          	sd	s0,8(sp)
    80004d88:	01010413          	addi	s0,sp,16
    80004d8c:	00002717          	auipc	a4,0x2
    80004d90:	e1472703          	lw	a4,-492(a4) # 80006ba0 <panicked>
    80004d94:	02071663          	bnez	a4,80004dc0 <uartputc_sync+0x40>
    80004d98:	00050793          	mv	a5,a0
    80004d9c:	100006b7          	lui	a3,0x10000
    80004da0:	0056c703          	lbu	a4,5(a3) # 10000005 <_entry-0x6ffffffb>
    80004da4:	02077713          	andi	a4,a4,32
    80004da8:	fe070ce3          	beqz	a4,80004da0 <uartputc_sync+0x20>
    80004dac:	0ff7f793          	andi	a5,a5,255
    80004db0:	00f68023          	sb	a5,0(a3)
    80004db4:	00813403          	ld	s0,8(sp)
    80004db8:	01010113          	addi	sp,sp,16
    80004dbc:	00008067          	ret
    80004dc0:	0000006f          	j	80004dc0 <uartputc_sync+0x40>

0000000080004dc4 <uartstart>:
    80004dc4:	ff010113          	addi	sp,sp,-16
    80004dc8:	00813423          	sd	s0,8(sp)
    80004dcc:	01010413          	addi	s0,sp,16
    80004dd0:	00002617          	auipc	a2,0x2
    80004dd4:	dd860613          	addi	a2,a2,-552 # 80006ba8 <uart_tx_r>
    80004dd8:	00002517          	auipc	a0,0x2
    80004ddc:	dd850513          	addi	a0,a0,-552 # 80006bb0 <uart_tx_w>
    80004de0:	00063783          	ld	a5,0(a2)
    80004de4:	00053703          	ld	a4,0(a0)
    80004de8:	04f70263          	beq	a4,a5,80004e2c <uartstart+0x68>
    80004dec:	100005b7          	lui	a1,0x10000
    80004df0:	00003817          	auipc	a6,0x3
    80004df4:	02080813          	addi	a6,a6,32 # 80007e10 <uart_tx_buf>
    80004df8:	01c0006f          	j	80004e14 <uartstart+0x50>
    80004dfc:	0006c703          	lbu	a4,0(a3)
    80004e00:	00f63023          	sd	a5,0(a2)
    80004e04:	00e58023          	sb	a4,0(a1) # 10000000 <_entry-0x70000000>
    80004e08:	00063783          	ld	a5,0(a2)
    80004e0c:	00053703          	ld	a4,0(a0)
    80004e10:	00f70e63          	beq	a4,a5,80004e2c <uartstart+0x68>
    80004e14:	01f7f713          	andi	a4,a5,31
    80004e18:	00e806b3          	add	a3,a6,a4
    80004e1c:	0055c703          	lbu	a4,5(a1)
    80004e20:	00178793          	addi	a5,a5,1
    80004e24:	02077713          	andi	a4,a4,32
    80004e28:	fc071ae3          	bnez	a4,80004dfc <uartstart+0x38>
    80004e2c:	00813403          	ld	s0,8(sp)
    80004e30:	01010113          	addi	sp,sp,16
    80004e34:	00008067          	ret

0000000080004e38 <uartgetc>:
    80004e38:	ff010113          	addi	sp,sp,-16
    80004e3c:	00813423          	sd	s0,8(sp)
    80004e40:	01010413          	addi	s0,sp,16
    80004e44:	10000737          	lui	a4,0x10000
    80004e48:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80004e4c:	0017f793          	andi	a5,a5,1
    80004e50:	00078c63          	beqz	a5,80004e68 <uartgetc+0x30>
    80004e54:	00074503          	lbu	a0,0(a4)
    80004e58:	0ff57513          	andi	a0,a0,255
    80004e5c:	00813403          	ld	s0,8(sp)
    80004e60:	01010113          	addi	sp,sp,16
    80004e64:	00008067          	ret
    80004e68:	fff00513          	li	a0,-1
    80004e6c:	ff1ff06f          	j	80004e5c <uartgetc+0x24>

0000000080004e70 <uartintr>:
    80004e70:	100007b7          	lui	a5,0x10000
    80004e74:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80004e78:	0017f793          	andi	a5,a5,1
    80004e7c:	0a078463          	beqz	a5,80004f24 <uartintr+0xb4>
    80004e80:	fe010113          	addi	sp,sp,-32
    80004e84:	00813823          	sd	s0,16(sp)
    80004e88:	00913423          	sd	s1,8(sp)
    80004e8c:	00113c23          	sd	ra,24(sp)
    80004e90:	02010413          	addi	s0,sp,32
    80004e94:	100004b7          	lui	s1,0x10000
    80004e98:	0004c503          	lbu	a0,0(s1) # 10000000 <_entry-0x70000000>
    80004e9c:	0ff57513          	andi	a0,a0,255
    80004ea0:	fffff097          	auipc	ra,0xfffff
    80004ea4:	534080e7          	jalr	1332(ra) # 800043d4 <consoleintr>
    80004ea8:	0054c783          	lbu	a5,5(s1)
    80004eac:	0017f793          	andi	a5,a5,1
    80004eb0:	fe0794e3          	bnez	a5,80004e98 <uartintr+0x28>
    80004eb4:	00002617          	auipc	a2,0x2
    80004eb8:	cf460613          	addi	a2,a2,-780 # 80006ba8 <uart_tx_r>
    80004ebc:	00002517          	auipc	a0,0x2
    80004ec0:	cf450513          	addi	a0,a0,-780 # 80006bb0 <uart_tx_w>
    80004ec4:	00063783          	ld	a5,0(a2)
    80004ec8:	00053703          	ld	a4,0(a0)
    80004ecc:	04f70263          	beq	a4,a5,80004f10 <uartintr+0xa0>
    80004ed0:	100005b7          	lui	a1,0x10000
    80004ed4:	00003817          	auipc	a6,0x3
    80004ed8:	f3c80813          	addi	a6,a6,-196 # 80007e10 <uart_tx_buf>
    80004edc:	01c0006f          	j	80004ef8 <uartintr+0x88>
    80004ee0:	0006c703          	lbu	a4,0(a3)
    80004ee4:	00f63023          	sd	a5,0(a2)
    80004ee8:	00e58023          	sb	a4,0(a1) # 10000000 <_entry-0x70000000>
    80004eec:	00063783          	ld	a5,0(a2)
    80004ef0:	00053703          	ld	a4,0(a0)
    80004ef4:	00f70e63          	beq	a4,a5,80004f10 <uartintr+0xa0>
    80004ef8:	01f7f713          	andi	a4,a5,31
    80004efc:	00e806b3          	add	a3,a6,a4
    80004f00:	0055c703          	lbu	a4,5(a1)
    80004f04:	00178793          	addi	a5,a5,1
    80004f08:	02077713          	andi	a4,a4,32
    80004f0c:	fc071ae3          	bnez	a4,80004ee0 <uartintr+0x70>
    80004f10:	01813083          	ld	ra,24(sp)
    80004f14:	01013403          	ld	s0,16(sp)
    80004f18:	00813483          	ld	s1,8(sp)
    80004f1c:	02010113          	addi	sp,sp,32
    80004f20:	00008067          	ret
    80004f24:	00002617          	auipc	a2,0x2
    80004f28:	c8460613          	addi	a2,a2,-892 # 80006ba8 <uart_tx_r>
    80004f2c:	00002517          	auipc	a0,0x2
    80004f30:	c8450513          	addi	a0,a0,-892 # 80006bb0 <uart_tx_w>
    80004f34:	00063783          	ld	a5,0(a2)
    80004f38:	00053703          	ld	a4,0(a0)
    80004f3c:	04f70263          	beq	a4,a5,80004f80 <uartintr+0x110>
    80004f40:	100005b7          	lui	a1,0x10000
    80004f44:	00003817          	auipc	a6,0x3
    80004f48:	ecc80813          	addi	a6,a6,-308 # 80007e10 <uart_tx_buf>
    80004f4c:	01c0006f          	j	80004f68 <uartintr+0xf8>
    80004f50:	0006c703          	lbu	a4,0(a3)
    80004f54:	00f63023          	sd	a5,0(a2)
    80004f58:	00e58023          	sb	a4,0(a1) # 10000000 <_entry-0x70000000>
    80004f5c:	00063783          	ld	a5,0(a2)
    80004f60:	00053703          	ld	a4,0(a0)
    80004f64:	02f70063          	beq	a4,a5,80004f84 <uartintr+0x114>
    80004f68:	01f7f713          	andi	a4,a5,31
    80004f6c:	00e806b3          	add	a3,a6,a4
    80004f70:	0055c703          	lbu	a4,5(a1)
    80004f74:	00178793          	addi	a5,a5,1
    80004f78:	02077713          	andi	a4,a4,32
    80004f7c:	fc071ae3          	bnez	a4,80004f50 <uartintr+0xe0>
    80004f80:	00008067          	ret
    80004f84:	00008067          	ret

0000000080004f88 <kinit>:
    80004f88:	fc010113          	addi	sp,sp,-64
    80004f8c:	02913423          	sd	s1,40(sp)
    80004f90:	fffff7b7          	lui	a5,0xfffff
    80004f94:	00004497          	auipc	s1,0x4
    80004f98:	e9b48493          	addi	s1,s1,-357 # 80008e2f <end+0xfff>
    80004f9c:	02813823          	sd	s0,48(sp)
    80004fa0:	01313c23          	sd	s3,24(sp)
    80004fa4:	00f4f4b3          	and	s1,s1,a5
    80004fa8:	02113c23          	sd	ra,56(sp)
    80004fac:	03213023          	sd	s2,32(sp)
    80004fb0:	01413823          	sd	s4,16(sp)
    80004fb4:	01513423          	sd	s5,8(sp)
    80004fb8:	04010413          	addi	s0,sp,64
    80004fbc:	000017b7          	lui	a5,0x1
    80004fc0:	01100993          	li	s3,17
    80004fc4:	00f487b3          	add	a5,s1,a5
    80004fc8:	01b99993          	slli	s3,s3,0x1b
    80004fcc:	06f9e063          	bltu	s3,a5,8000502c <kinit+0xa4>
    80004fd0:	00003a97          	auipc	s5,0x3
    80004fd4:	e60a8a93          	addi	s5,s5,-416 # 80007e30 <end>
    80004fd8:	0754ec63          	bltu	s1,s5,80005050 <kinit+0xc8>
    80004fdc:	0734fa63          	bgeu	s1,s3,80005050 <kinit+0xc8>
    80004fe0:	00088a37          	lui	s4,0x88
    80004fe4:	fffa0a13          	addi	s4,s4,-1 # 87fff <_entry-0x7ff78001>
    80004fe8:	00002917          	auipc	s2,0x2
    80004fec:	bd090913          	addi	s2,s2,-1072 # 80006bb8 <kmem>
    80004ff0:	00ca1a13          	slli	s4,s4,0xc
    80004ff4:	0140006f          	j	80005008 <kinit+0x80>
    80004ff8:	000017b7          	lui	a5,0x1
    80004ffc:	00f484b3          	add	s1,s1,a5
    80005000:	0554e863          	bltu	s1,s5,80005050 <kinit+0xc8>
    80005004:	0534f663          	bgeu	s1,s3,80005050 <kinit+0xc8>
    80005008:	00001637          	lui	a2,0x1
    8000500c:	00100593          	li	a1,1
    80005010:	00048513          	mv	a0,s1
    80005014:	00000097          	auipc	ra,0x0
    80005018:	5e4080e7          	jalr	1508(ra) # 800055f8 <__memset>
    8000501c:	00093783          	ld	a5,0(s2)
    80005020:	00f4b023          	sd	a5,0(s1)
    80005024:	00993023          	sd	s1,0(s2)
    80005028:	fd4498e3          	bne	s1,s4,80004ff8 <kinit+0x70>
    8000502c:	03813083          	ld	ra,56(sp)
    80005030:	03013403          	ld	s0,48(sp)
    80005034:	02813483          	ld	s1,40(sp)
    80005038:	02013903          	ld	s2,32(sp)
    8000503c:	01813983          	ld	s3,24(sp)
    80005040:	01013a03          	ld	s4,16(sp)
    80005044:	00813a83          	ld	s5,8(sp)
    80005048:	04010113          	addi	sp,sp,64
    8000504c:	00008067          	ret
    80005050:	00001517          	auipc	a0,0x1
    80005054:	26850513          	addi	a0,a0,616 # 800062b8 <digits+0x18>
    80005058:	fffff097          	auipc	ra,0xfffff
    8000505c:	4b4080e7          	jalr	1204(ra) # 8000450c <panic>

0000000080005060 <freerange>:
    80005060:	fc010113          	addi	sp,sp,-64
    80005064:	000017b7          	lui	a5,0x1
    80005068:	02913423          	sd	s1,40(sp)
    8000506c:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80005070:	009504b3          	add	s1,a0,s1
    80005074:	fffff537          	lui	a0,0xfffff
    80005078:	02813823          	sd	s0,48(sp)
    8000507c:	02113c23          	sd	ra,56(sp)
    80005080:	03213023          	sd	s2,32(sp)
    80005084:	01313c23          	sd	s3,24(sp)
    80005088:	01413823          	sd	s4,16(sp)
    8000508c:	01513423          	sd	s5,8(sp)
    80005090:	01613023          	sd	s6,0(sp)
    80005094:	04010413          	addi	s0,sp,64
    80005098:	00a4f4b3          	and	s1,s1,a0
    8000509c:	00f487b3          	add	a5,s1,a5
    800050a0:	06f5e463          	bltu	a1,a5,80005108 <freerange+0xa8>
    800050a4:	00003a97          	auipc	s5,0x3
    800050a8:	d8ca8a93          	addi	s5,s5,-628 # 80007e30 <end>
    800050ac:	0954e263          	bltu	s1,s5,80005130 <freerange+0xd0>
    800050b0:	01100993          	li	s3,17
    800050b4:	01b99993          	slli	s3,s3,0x1b
    800050b8:	0734fc63          	bgeu	s1,s3,80005130 <freerange+0xd0>
    800050bc:	00058a13          	mv	s4,a1
    800050c0:	00002917          	auipc	s2,0x2
    800050c4:	af890913          	addi	s2,s2,-1288 # 80006bb8 <kmem>
    800050c8:	00002b37          	lui	s6,0x2
    800050cc:	0140006f          	j	800050e0 <freerange+0x80>
    800050d0:	000017b7          	lui	a5,0x1
    800050d4:	00f484b3          	add	s1,s1,a5
    800050d8:	0554ec63          	bltu	s1,s5,80005130 <freerange+0xd0>
    800050dc:	0534fa63          	bgeu	s1,s3,80005130 <freerange+0xd0>
    800050e0:	00001637          	lui	a2,0x1
    800050e4:	00100593          	li	a1,1
    800050e8:	00048513          	mv	a0,s1
    800050ec:	00000097          	auipc	ra,0x0
    800050f0:	50c080e7          	jalr	1292(ra) # 800055f8 <__memset>
    800050f4:	00093703          	ld	a4,0(s2)
    800050f8:	016487b3          	add	a5,s1,s6
    800050fc:	00e4b023          	sd	a4,0(s1)
    80005100:	00993023          	sd	s1,0(s2)
    80005104:	fcfa76e3          	bgeu	s4,a5,800050d0 <freerange+0x70>
    80005108:	03813083          	ld	ra,56(sp)
    8000510c:	03013403          	ld	s0,48(sp)
    80005110:	02813483          	ld	s1,40(sp)
    80005114:	02013903          	ld	s2,32(sp)
    80005118:	01813983          	ld	s3,24(sp)
    8000511c:	01013a03          	ld	s4,16(sp)
    80005120:	00813a83          	ld	s5,8(sp)
    80005124:	00013b03          	ld	s6,0(sp)
    80005128:	04010113          	addi	sp,sp,64
    8000512c:	00008067          	ret
    80005130:	00001517          	auipc	a0,0x1
    80005134:	18850513          	addi	a0,a0,392 # 800062b8 <digits+0x18>
    80005138:	fffff097          	auipc	ra,0xfffff
    8000513c:	3d4080e7          	jalr	980(ra) # 8000450c <panic>

0000000080005140 <kfree>:
    80005140:	fe010113          	addi	sp,sp,-32
    80005144:	00813823          	sd	s0,16(sp)
    80005148:	00113c23          	sd	ra,24(sp)
    8000514c:	00913423          	sd	s1,8(sp)
    80005150:	02010413          	addi	s0,sp,32
    80005154:	03451793          	slli	a5,a0,0x34
    80005158:	04079c63          	bnez	a5,800051b0 <kfree+0x70>
    8000515c:	00003797          	auipc	a5,0x3
    80005160:	cd478793          	addi	a5,a5,-812 # 80007e30 <end>
    80005164:	00050493          	mv	s1,a0
    80005168:	04f56463          	bltu	a0,a5,800051b0 <kfree+0x70>
    8000516c:	01100793          	li	a5,17
    80005170:	01b79793          	slli	a5,a5,0x1b
    80005174:	02f57e63          	bgeu	a0,a5,800051b0 <kfree+0x70>
    80005178:	00001637          	lui	a2,0x1
    8000517c:	00100593          	li	a1,1
    80005180:	00000097          	auipc	ra,0x0
    80005184:	478080e7          	jalr	1144(ra) # 800055f8 <__memset>
    80005188:	00002797          	auipc	a5,0x2
    8000518c:	a3078793          	addi	a5,a5,-1488 # 80006bb8 <kmem>
    80005190:	0007b703          	ld	a4,0(a5)
    80005194:	01813083          	ld	ra,24(sp)
    80005198:	01013403          	ld	s0,16(sp)
    8000519c:	00e4b023          	sd	a4,0(s1)
    800051a0:	0097b023          	sd	s1,0(a5)
    800051a4:	00813483          	ld	s1,8(sp)
    800051a8:	02010113          	addi	sp,sp,32
    800051ac:	00008067          	ret
    800051b0:	00001517          	auipc	a0,0x1
    800051b4:	10850513          	addi	a0,a0,264 # 800062b8 <digits+0x18>
    800051b8:	fffff097          	auipc	ra,0xfffff
    800051bc:	354080e7          	jalr	852(ra) # 8000450c <panic>

00000000800051c0 <kalloc>:
    800051c0:	fe010113          	addi	sp,sp,-32
    800051c4:	00813823          	sd	s0,16(sp)
    800051c8:	00913423          	sd	s1,8(sp)
    800051cc:	00113c23          	sd	ra,24(sp)
    800051d0:	02010413          	addi	s0,sp,32
    800051d4:	00002797          	auipc	a5,0x2
    800051d8:	9e478793          	addi	a5,a5,-1564 # 80006bb8 <kmem>
    800051dc:	0007b483          	ld	s1,0(a5)
    800051e0:	02048063          	beqz	s1,80005200 <kalloc+0x40>
    800051e4:	0004b703          	ld	a4,0(s1)
    800051e8:	00001637          	lui	a2,0x1
    800051ec:	00500593          	li	a1,5
    800051f0:	00048513          	mv	a0,s1
    800051f4:	00e7b023          	sd	a4,0(a5)
    800051f8:	00000097          	auipc	ra,0x0
    800051fc:	400080e7          	jalr	1024(ra) # 800055f8 <__memset>
    80005200:	01813083          	ld	ra,24(sp)
    80005204:	01013403          	ld	s0,16(sp)
    80005208:	00048513          	mv	a0,s1
    8000520c:	00813483          	ld	s1,8(sp)
    80005210:	02010113          	addi	sp,sp,32
    80005214:	00008067          	ret

0000000080005218 <initlock>:
    80005218:	ff010113          	addi	sp,sp,-16
    8000521c:	00813423          	sd	s0,8(sp)
    80005220:	01010413          	addi	s0,sp,16
    80005224:	00813403          	ld	s0,8(sp)
    80005228:	00b53423          	sd	a1,8(a0)
    8000522c:	00052023          	sw	zero,0(a0)
    80005230:	00053823          	sd	zero,16(a0)
    80005234:	01010113          	addi	sp,sp,16
    80005238:	00008067          	ret

000000008000523c <acquire>:
    8000523c:	fe010113          	addi	sp,sp,-32
    80005240:	00813823          	sd	s0,16(sp)
    80005244:	00913423          	sd	s1,8(sp)
    80005248:	00113c23          	sd	ra,24(sp)
    8000524c:	01213023          	sd	s2,0(sp)
    80005250:	02010413          	addi	s0,sp,32
    80005254:	00050493          	mv	s1,a0
    80005258:	10002973          	csrr	s2,sstatus
    8000525c:	100027f3          	csrr	a5,sstatus
    80005260:	ffd7f793          	andi	a5,a5,-3
    80005264:	10079073          	csrw	sstatus,a5
    80005268:	fffff097          	auipc	ra,0xfffff
    8000526c:	8e4080e7          	jalr	-1820(ra) # 80003b4c <mycpu>
    80005270:	07852783          	lw	a5,120(a0)
    80005274:	06078e63          	beqz	a5,800052f0 <acquire+0xb4>
    80005278:	fffff097          	auipc	ra,0xfffff
    8000527c:	8d4080e7          	jalr	-1836(ra) # 80003b4c <mycpu>
    80005280:	07852783          	lw	a5,120(a0)
    80005284:	0004a703          	lw	a4,0(s1)
    80005288:	0017879b          	addiw	a5,a5,1
    8000528c:	06f52c23          	sw	a5,120(a0)
    80005290:	04071063          	bnez	a4,800052d0 <acquire+0x94>
    80005294:	00100713          	li	a4,1
    80005298:	00070793          	mv	a5,a4
    8000529c:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800052a0:	0007879b          	sext.w	a5,a5
    800052a4:	fe079ae3          	bnez	a5,80005298 <acquire+0x5c>
    800052a8:	0ff0000f          	fence
    800052ac:	fffff097          	auipc	ra,0xfffff
    800052b0:	8a0080e7          	jalr	-1888(ra) # 80003b4c <mycpu>
    800052b4:	01813083          	ld	ra,24(sp)
    800052b8:	01013403          	ld	s0,16(sp)
    800052bc:	00a4b823          	sd	a0,16(s1)
    800052c0:	00013903          	ld	s2,0(sp)
    800052c4:	00813483          	ld	s1,8(sp)
    800052c8:	02010113          	addi	sp,sp,32
    800052cc:	00008067          	ret
    800052d0:	0104b903          	ld	s2,16(s1)
    800052d4:	fffff097          	auipc	ra,0xfffff
    800052d8:	878080e7          	jalr	-1928(ra) # 80003b4c <mycpu>
    800052dc:	faa91ce3          	bne	s2,a0,80005294 <acquire+0x58>
    800052e0:	00001517          	auipc	a0,0x1
    800052e4:	fe050513          	addi	a0,a0,-32 # 800062c0 <digits+0x20>
    800052e8:	fffff097          	auipc	ra,0xfffff
    800052ec:	224080e7          	jalr	548(ra) # 8000450c <panic>
    800052f0:	00195913          	srli	s2,s2,0x1
    800052f4:	fffff097          	auipc	ra,0xfffff
    800052f8:	858080e7          	jalr	-1960(ra) # 80003b4c <mycpu>
    800052fc:	00197913          	andi	s2,s2,1
    80005300:	07252e23          	sw	s2,124(a0)
    80005304:	f75ff06f          	j	80005278 <acquire+0x3c>

0000000080005308 <release>:
    80005308:	fe010113          	addi	sp,sp,-32
    8000530c:	00813823          	sd	s0,16(sp)
    80005310:	00113c23          	sd	ra,24(sp)
    80005314:	00913423          	sd	s1,8(sp)
    80005318:	01213023          	sd	s2,0(sp)
    8000531c:	02010413          	addi	s0,sp,32
    80005320:	00052783          	lw	a5,0(a0)
    80005324:	00079a63          	bnez	a5,80005338 <release+0x30>
    80005328:	00001517          	auipc	a0,0x1
    8000532c:	fa050513          	addi	a0,a0,-96 # 800062c8 <digits+0x28>
    80005330:	fffff097          	auipc	ra,0xfffff
    80005334:	1dc080e7          	jalr	476(ra) # 8000450c <panic>
    80005338:	01053903          	ld	s2,16(a0)
    8000533c:	00050493          	mv	s1,a0
    80005340:	fffff097          	auipc	ra,0xfffff
    80005344:	80c080e7          	jalr	-2036(ra) # 80003b4c <mycpu>
    80005348:	fea910e3          	bne	s2,a0,80005328 <release+0x20>
    8000534c:	0004b823          	sd	zero,16(s1)
    80005350:	0ff0000f          	fence
    80005354:	0f50000f          	fence	iorw,ow
    80005358:	0804a02f          	amoswap.w	zero,zero,(s1)
    8000535c:	ffffe097          	auipc	ra,0xffffe
    80005360:	7f0080e7          	jalr	2032(ra) # 80003b4c <mycpu>
    80005364:	100027f3          	csrr	a5,sstatus
    80005368:	0027f793          	andi	a5,a5,2
    8000536c:	04079a63          	bnez	a5,800053c0 <release+0xb8>
    80005370:	07852783          	lw	a5,120(a0)
    80005374:	02f05e63          	blez	a5,800053b0 <release+0xa8>
    80005378:	fff7871b          	addiw	a4,a5,-1
    8000537c:	06e52c23          	sw	a4,120(a0)
    80005380:	00071c63          	bnez	a4,80005398 <release+0x90>
    80005384:	07c52783          	lw	a5,124(a0)
    80005388:	00078863          	beqz	a5,80005398 <release+0x90>
    8000538c:	100027f3          	csrr	a5,sstatus
    80005390:	0027e793          	ori	a5,a5,2
    80005394:	10079073          	csrw	sstatus,a5
    80005398:	01813083          	ld	ra,24(sp)
    8000539c:	01013403          	ld	s0,16(sp)
    800053a0:	00813483          	ld	s1,8(sp)
    800053a4:	00013903          	ld	s2,0(sp)
    800053a8:	02010113          	addi	sp,sp,32
    800053ac:	00008067          	ret
    800053b0:	00001517          	auipc	a0,0x1
    800053b4:	f3850513          	addi	a0,a0,-200 # 800062e8 <digits+0x48>
    800053b8:	fffff097          	auipc	ra,0xfffff
    800053bc:	154080e7          	jalr	340(ra) # 8000450c <panic>
    800053c0:	00001517          	auipc	a0,0x1
    800053c4:	f1050513          	addi	a0,a0,-240 # 800062d0 <digits+0x30>
    800053c8:	fffff097          	auipc	ra,0xfffff
    800053cc:	144080e7          	jalr	324(ra) # 8000450c <panic>

00000000800053d0 <holding>:
    800053d0:	00052783          	lw	a5,0(a0)
    800053d4:	00079663          	bnez	a5,800053e0 <holding+0x10>
    800053d8:	00000513          	li	a0,0
    800053dc:	00008067          	ret
    800053e0:	fe010113          	addi	sp,sp,-32
    800053e4:	00813823          	sd	s0,16(sp)
    800053e8:	00913423          	sd	s1,8(sp)
    800053ec:	00113c23          	sd	ra,24(sp)
    800053f0:	02010413          	addi	s0,sp,32
    800053f4:	01053483          	ld	s1,16(a0)
    800053f8:	ffffe097          	auipc	ra,0xffffe
    800053fc:	754080e7          	jalr	1876(ra) # 80003b4c <mycpu>
    80005400:	01813083          	ld	ra,24(sp)
    80005404:	01013403          	ld	s0,16(sp)
    80005408:	40a48533          	sub	a0,s1,a0
    8000540c:	00153513          	seqz	a0,a0
    80005410:	00813483          	ld	s1,8(sp)
    80005414:	02010113          	addi	sp,sp,32
    80005418:	00008067          	ret

000000008000541c <push_off>:
    8000541c:	fe010113          	addi	sp,sp,-32
    80005420:	00813823          	sd	s0,16(sp)
    80005424:	00113c23          	sd	ra,24(sp)
    80005428:	00913423          	sd	s1,8(sp)
    8000542c:	02010413          	addi	s0,sp,32
    80005430:	100024f3          	csrr	s1,sstatus
    80005434:	100027f3          	csrr	a5,sstatus
    80005438:	ffd7f793          	andi	a5,a5,-3
    8000543c:	10079073          	csrw	sstatus,a5
    80005440:	ffffe097          	auipc	ra,0xffffe
    80005444:	70c080e7          	jalr	1804(ra) # 80003b4c <mycpu>
    80005448:	07852783          	lw	a5,120(a0)
    8000544c:	02078663          	beqz	a5,80005478 <push_off+0x5c>
    80005450:	ffffe097          	auipc	ra,0xffffe
    80005454:	6fc080e7          	jalr	1788(ra) # 80003b4c <mycpu>
    80005458:	07852783          	lw	a5,120(a0)
    8000545c:	01813083          	ld	ra,24(sp)
    80005460:	01013403          	ld	s0,16(sp)
    80005464:	0017879b          	addiw	a5,a5,1
    80005468:	06f52c23          	sw	a5,120(a0)
    8000546c:	00813483          	ld	s1,8(sp)
    80005470:	02010113          	addi	sp,sp,32
    80005474:	00008067          	ret
    80005478:	0014d493          	srli	s1,s1,0x1
    8000547c:	ffffe097          	auipc	ra,0xffffe
    80005480:	6d0080e7          	jalr	1744(ra) # 80003b4c <mycpu>
    80005484:	0014f493          	andi	s1,s1,1
    80005488:	06952e23          	sw	s1,124(a0)
    8000548c:	fc5ff06f          	j	80005450 <push_off+0x34>

0000000080005490 <pop_off>:
    80005490:	ff010113          	addi	sp,sp,-16
    80005494:	00813023          	sd	s0,0(sp)
    80005498:	00113423          	sd	ra,8(sp)
    8000549c:	01010413          	addi	s0,sp,16
    800054a0:	ffffe097          	auipc	ra,0xffffe
    800054a4:	6ac080e7          	jalr	1708(ra) # 80003b4c <mycpu>
    800054a8:	100027f3          	csrr	a5,sstatus
    800054ac:	0027f793          	andi	a5,a5,2
    800054b0:	04079663          	bnez	a5,800054fc <pop_off+0x6c>
    800054b4:	07852783          	lw	a5,120(a0)
    800054b8:	02f05a63          	blez	a5,800054ec <pop_off+0x5c>
    800054bc:	fff7871b          	addiw	a4,a5,-1
    800054c0:	06e52c23          	sw	a4,120(a0)
    800054c4:	00071c63          	bnez	a4,800054dc <pop_off+0x4c>
    800054c8:	07c52783          	lw	a5,124(a0)
    800054cc:	00078863          	beqz	a5,800054dc <pop_off+0x4c>
    800054d0:	100027f3          	csrr	a5,sstatus
    800054d4:	0027e793          	ori	a5,a5,2
    800054d8:	10079073          	csrw	sstatus,a5
    800054dc:	00813083          	ld	ra,8(sp)
    800054e0:	00013403          	ld	s0,0(sp)
    800054e4:	01010113          	addi	sp,sp,16
    800054e8:	00008067          	ret
    800054ec:	00001517          	auipc	a0,0x1
    800054f0:	dfc50513          	addi	a0,a0,-516 # 800062e8 <digits+0x48>
    800054f4:	fffff097          	auipc	ra,0xfffff
    800054f8:	018080e7          	jalr	24(ra) # 8000450c <panic>
    800054fc:	00001517          	auipc	a0,0x1
    80005500:	dd450513          	addi	a0,a0,-556 # 800062d0 <digits+0x30>
    80005504:	fffff097          	auipc	ra,0xfffff
    80005508:	008080e7          	jalr	8(ra) # 8000450c <panic>

000000008000550c <push_on>:
    8000550c:	fe010113          	addi	sp,sp,-32
    80005510:	00813823          	sd	s0,16(sp)
    80005514:	00113c23          	sd	ra,24(sp)
    80005518:	00913423          	sd	s1,8(sp)
    8000551c:	02010413          	addi	s0,sp,32
    80005520:	100024f3          	csrr	s1,sstatus
    80005524:	100027f3          	csrr	a5,sstatus
    80005528:	0027e793          	ori	a5,a5,2
    8000552c:	10079073          	csrw	sstatus,a5
    80005530:	ffffe097          	auipc	ra,0xffffe
    80005534:	61c080e7          	jalr	1564(ra) # 80003b4c <mycpu>
    80005538:	07852783          	lw	a5,120(a0)
    8000553c:	02078663          	beqz	a5,80005568 <push_on+0x5c>
    80005540:	ffffe097          	auipc	ra,0xffffe
    80005544:	60c080e7          	jalr	1548(ra) # 80003b4c <mycpu>
    80005548:	07852783          	lw	a5,120(a0)
    8000554c:	01813083          	ld	ra,24(sp)
    80005550:	01013403          	ld	s0,16(sp)
    80005554:	0017879b          	addiw	a5,a5,1
    80005558:	06f52c23          	sw	a5,120(a0)
    8000555c:	00813483          	ld	s1,8(sp)
    80005560:	02010113          	addi	sp,sp,32
    80005564:	00008067          	ret
    80005568:	0014d493          	srli	s1,s1,0x1
    8000556c:	ffffe097          	auipc	ra,0xffffe
    80005570:	5e0080e7          	jalr	1504(ra) # 80003b4c <mycpu>
    80005574:	0014f493          	andi	s1,s1,1
    80005578:	06952e23          	sw	s1,124(a0)
    8000557c:	fc5ff06f          	j	80005540 <push_on+0x34>

0000000080005580 <pop_on>:
    80005580:	ff010113          	addi	sp,sp,-16
    80005584:	00813023          	sd	s0,0(sp)
    80005588:	00113423          	sd	ra,8(sp)
    8000558c:	01010413          	addi	s0,sp,16
    80005590:	ffffe097          	auipc	ra,0xffffe
    80005594:	5bc080e7          	jalr	1468(ra) # 80003b4c <mycpu>
    80005598:	100027f3          	csrr	a5,sstatus
    8000559c:	0027f793          	andi	a5,a5,2
    800055a0:	04078463          	beqz	a5,800055e8 <pop_on+0x68>
    800055a4:	07852783          	lw	a5,120(a0)
    800055a8:	02f05863          	blez	a5,800055d8 <pop_on+0x58>
    800055ac:	fff7879b          	addiw	a5,a5,-1
    800055b0:	06f52c23          	sw	a5,120(a0)
    800055b4:	07853783          	ld	a5,120(a0)
    800055b8:	00079863          	bnez	a5,800055c8 <pop_on+0x48>
    800055bc:	100027f3          	csrr	a5,sstatus
    800055c0:	ffd7f793          	andi	a5,a5,-3
    800055c4:	10079073          	csrw	sstatus,a5
    800055c8:	00813083          	ld	ra,8(sp)
    800055cc:	00013403          	ld	s0,0(sp)
    800055d0:	01010113          	addi	sp,sp,16
    800055d4:	00008067          	ret
    800055d8:	00001517          	auipc	a0,0x1
    800055dc:	d3850513          	addi	a0,a0,-712 # 80006310 <digits+0x70>
    800055e0:	fffff097          	auipc	ra,0xfffff
    800055e4:	f2c080e7          	jalr	-212(ra) # 8000450c <panic>
    800055e8:	00001517          	auipc	a0,0x1
    800055ec:	d0850513          	addi	a0,a0,-760 # 800062f0 <digits+0x50>
    800055f0:	fffff097          	auipc	ra,0xfffff
    800055f4:	f1c080e7          	jalr	-228(ra) # 8000450c <panic>

00000000800055f8 <__memset>:
    800055f8:	ff010113          	addi	sp,sp,-16
    800055fc:	00813423          	sd	s0,8(sp)
    80005600:	01010413          	addi	s0,sp,16
    80005604:	1a060e63          	beqz	a2,800057c0 <__memset+0x1c8>
    80005608:	40a007b3          	neg	a5,a0
    8000560c:	0077f793          	andi	a5,a5,7
    80005610:	00778693          	addi	a3,a5,7
    80005614:	00b00813          	li	a6,11
    80005618:	0ff5f593          	andi	a1,a1,255
    8000561c:	fff6071b          	addiw	a4,a2,-1
    80005620:	1b06e663          	bltu	a3,a6,800057cc <__memset+0x1d4>
    80005624:	1cd76463          	bltu	a4,a3,800057ec <__memset+0x1f4>
    80005628:	1a078e63          	beqz	a5,800057e4 <__memset+0x1ec>
    8000562c:	00b50023          	sb	a1,0(a0)
    80005630:	00100713          	li	a4,1
    80005634:	1ae78463          	beq	a5,a4,800057dc <__memset+0x1e4>
    80005638:	00b500a3          	sb	a1,1(a0)
    8000563c:	00200713          	li	a4,2
    80005640:	1ae78a63          	beq	a5,a4,800057f4 <__memset+0x1fc>
    80005644:	00b50123          	sb	a1,2(a0)
    80005648:	00300713          	li	a4,3
    8000564c:	18e78463          	beq	a5,a4,800057d4 <__memset+0x1dc>
    80005650:	00b501a3          	sb	a1,3(a0)
    80005654:	00400713          	li	a4,4
    80005658:	1ae78263          	beq	a5,a4,800057fc <__memset+0x204>
    8000565c:	00b50223          	sb	a1,4(a0)
    80005660:	00500713          	li	a4,5
    80005664:	1ae78063          	beq	a5,a4,80005804 <__memset+0x20c>
    80005668:	00b502a3          	sb	a1,5(a0)
    8000566c:	00700713          	li	a4,7
    80005670:	18e79e63          	bne	a5,a4,8000580c <__memset+0x214>
    80005674:	00b50323          	sb	a1,6(a0)
    80005678:	00700e93          	li	t4,7
    8000567c:	00859713          	slli	a4,a1,0x8
    80005680:	00e5e733          	or	a4,a1,a4
    80005684:	01059e13          	slli	t3,a1,0x10
    80005688:	01c76e33          	or	t3,a4,t3
    8000568c:	01859313          	slli	t1,a1,0x18
    80005690:	006e6333          	or	t1,t3,t1
    80005694:	02059893          	slli	a7,a1,0x20
    80005698:	40f60e3b          	subw	t3,a2,a5
    8000569c:	011368b3          	or	a7,t1,a7
    800056a0:	02859813          	slli	a6,a1,0x28
    800056a4:	0108e833          	or	a6,a7,a6
    800056a8:	03059693          	slli	a3,a1,0x30
    800056ac:	003e589b          	srliw	a7,t3,0x3
    800056b0:	00d866b3          	or	a3,a6,a3
    800056b4:	03859713          	slli	a4,a1,0x38
    800056b8:	00389813          	slli	a6,a7,0x3
    800056bc:	00f507b3          	add	a5,a0,a5
    800056c0:	00e6e733          	or	a4,a3,a4
    800056c4:	000e089b          	sext.w	a7,t3
    800056c8:	00f806b3          	add	a3,a6,a5
    800056cc:	00e7b023          	sd	a4,0(a5)
    800056d0:	00878793          	addi	a5,a5,8
    800056d4:	fed79ce3          	bne	a5,a3,800056cc <__memset+0xd4>
    800056d8:	ff8e7793          	andi	a5,t3,-8
    800056dc:	0007871b          	sext.w	a4,a5
    800056e0:	01d787bb          	addw	a5,a5,t4
    800056e4:	0ce88e63          	beq	a7,a4,800057c0 <__memset+0x1c8>
    800056e8:	00f50733          	add	a4,a0,a5
    800056ec:	00b70023          	sb	a1,0(a4)
    800056f0:	0017871b          	addiw	a4,a5,1
    800056f4:	0cc77663          	bgeu	a4,a2,800057c0 <__memset+0x1c8>
    800056f8:	00e50733          	add	a4,a0,a4
    800056fc:	00b70023          	sb	a1,0(a4)
    80005700:	0027871b          	addiw	a4,a5,2
    80005704:	0ac77e63          	bgeu	a4,a2,800057c0 <__memset+0x1c8>
    80005708:	00e50733          	add	a4,a0,a4
    8000570c:	00b70023          	sb	a1,0(a4)
    80005710:	0037871b          	addiw	a4,a5,3
    80005714:	0ac77663          	bgeu	a4,a2,800057c0 <__memset+0x1c8>
    80005718:	00e50733          	add	a4,a0,a4
    8000571c:	00b70023          	sb	a1,0(a4)
    80005720:	0047871b          	addiw	a4,a5,4
    80005724:	08c77e63          	bgeu	a4,a2,800057c0 <__memset+0x1c8>
    80005728:	00e50733          	add	a4,a0,a4
    8000572c:	00b70023          	sb	a1,0(a4)
    80005730:	0057871b          	addiw	a4,a5,5
    80005734:	08c77663          	bgeu	a4,a2,800057c0 <__memset+0x1c8>
    80005738:	00e50733          	add	a4,a0,a4
    8000573c:	00b70023          	sb	a1,0(a4)
    80005740:	0067871b          	addiw	a4,a5,6
    80005744:	06c77e63          	bgeu	a4,a2,800057c0 <__memset+0x1c8>
    80005748:	00e50733          	add	a4,a0,a4
    8000574c:	00b70023          	sb	a1,0(a4)
    80005750:	0077871b          	addiw	a4,a5,7
    80005754:	06c77663          	bgeu	a4,a2,800057c0 <__memset+0x1c8>
    80005758:	00e50733          	add	a4,a0,a4
    8000575c:	00b70023          	sb	a1,0(a4)
    80005760:	0087871b          	addiw	a4,a5,8
    80005764:	04c77e63          	bgeu	a4,a2,800057c0 <__memset+0x1c8>
    80005768:	00e50733          	add	a4,a0,a4
    8000576c:	00b70023          	sb	a1,0(a4)
    80005770:	0097871b          	addiw	a4,a5,9
    80005774:	04c77663          	bgeu	a4,a2,800057c0 <__memset+0x1c8>
    80005778:	00e50733          	add	a4,a0,a4
    8000577c:	00b70023          	sb	a1,0(a4)
    80005780:	00a7871b          	addiw	a4,a5,10
    80005784:	02c77e63          	bgeu	a4,a2,800057c0 <__memset+0x1c8>
    80005788:	00e50733          	add	a4,a0,a4
    8000578c:	00b70023          	sb	a1,0(a4)
    80005790:	00b7871b          	addiw	a4,a5,11
    80005794:	02c77663          	bgeu	a4,a2,800057c0 <__memset+0x1c8>
    80005798:	00e50733          	add	a4,a0,a4
    8000579c:	00b70023          	sb	a1,0(a4)
    800057a0:	00c7871b          	addiw	a4,a5,12
    800057a4:	00c77e63          	bgeu	a4,a2,800057c0 <__memset+0x1c8>
    800057a8:	00e50733          	add	a4,a0,a4
    800057ac:	00b70023          	sb	a1,0(a4)
    800057b0:	00d7879b          	addiw	a5,a5,13
    800057b4:	00c7f663          	bgeu	a5,a2,800057c0 <__memset+0x1c8>
    800057b8:	00f507b3          	add	a5,a0,a5
    800057bc:	00b78023          	sb	a1,0(a5)
    800057c0:	00813403          	ld	s0,8(sp)
    800057c4:	01010113          	addi	sp,sp,16
    800057c8:	00008067          	ret
    800057cc:	00b00693          	li	a3,11
    800057d0:	e55ff06f          	j	80005624 <__memset+0x2c>
    800057d4:	00300e93          	li	t4,3
    800057d8:	ea5ff06f          	j	8000567c <__memset+0x84>
    800057dc:	00100e93          	li	t4,1
    800057e0:	e9dff06f          	j	8000567c <__memset+0x84>
    800057e4:	00000e93          	li	t4,0
    800057e8:	e95ff06f          	j	8000567c <__memset+0x84>
    800057ec:	00000793          	li	a5,0
    800057f0:	ef9ff06f          	j	800056e8 <__memset+0xf0>
    800057f4:	00200e93          	li	t4,2
    800057f8:	e85ff06f          	j	8000567c <__memset+0x84>
    800057fc:	00400e93          	li	t4,4
    80005800:	e7dff06f          	j	8000567c <__memset+0x84>
    80005804:	00500e93          	li	t4,5
    80005808:	e75ff06f          	j	8000567c <__memset+0x84>
    8000580c:	00600e93          	li	t4,6
    80005810:	e6dff06f          	j	8000567c <__memset+0x84>

0000000080005814 <__memmove>:
    80005814:	ff010113          	addi	sp,sp,-16
    80005818:	00813423          	sd	s0,8(sp)
    8000581c:	01010413          	addi	s0,sp,16
    80005820:	0e060863          	beqz	a2,80005910 <__memmove+0xfc>
    80005824:	fff6069b          	addiw	a3,a2,-1
    80005828:	0006881b          	sext.w	a6,a3
    8000582c:	0ea5e863          	bltu	a1,a0,8000591c <__memmove+0x108>
    80005830:	00758713          	addi	a4,a1,7
    80005834:	00a5e7b3          	or	a5,a1,a0
    80005838:	40a70733          	sub	a4,a4,a0
    8000583c:	0077f793          	andi	a5,a5,7
    80005840:	00f73713          	sltiu	a4,a4,15
    80005844:	00174713          	xori	a4,a4,1
    80005848:	0017b793          	seqz	a5,a5
    8000584c:	00e7f7b3          	and	a5,a5,a4
    80005850:	10078863          	beqz	a5,80005960 <__memmove+0x14c>
    80005854:	00900793          	li	a5,9
    80005858:	1107f463          	bgeu	a5,a6,80005960 <__memmove+0x14c>
    8000585c:	0036581b          	srliw	a6,a2,0x3
    80005860:	fff8081b          	addiw	a6,a6,-1
    80005864:	02081813          	slli	a6,a6,0x20
    80005868:	01d85893          	srli	a7,a6,0x1d
    8000586c:	00858813          	addi	a6,a1,8
    80005870:	00058793          	mv	a5,a1
    80005874:	00050713          	mv	a4,a0
    80005878:	01088833          	add	a6,a7,a6
    8000587c:	0007b883          	ld	a7,0(a5)
    80005880:	00878793          	addi	a5,a5,8
    80005884:	00870713          	addi	a4,a4,8
    80005888:	ff173c23          	sd	a7,-8(a4)
    8000588c:	ff0798e3          	bne	a5,a6,8000587c <__memmove+0x68>
    80005890:	ff867713          	andi	a4,a2,-8
    80005894:	02071793          	slli	a5,a4,0x20
    80005898:	0207d793          	srli	a5,a5,0x20
    8000589c:	00f585b3          	add	a1,a1,a5
    800058a0:	40e686bb          	subw	a3,a3,a4
    800058a4:	00f507b3          	add	a5,a0,a5
    800058a8:	06e60463          	beq	a2,a4,80005910 <__memmove+0xfc>
    800058ac:	0005c703          	lbu	a4,0(a1)
    800058b0:	00e78023          	sb	a4,0(a5)
    800058b4:	04068e63          	beqz	a3,80005910 <__memmove+0xfc>
    800058b8:	0015c603          	lbu	a2,1(a1)
    800058bc:	00100713          	li	a4,1
    800058c0:	00c780a3          	sb	a2,1(a5)
    800058c4:	04e68663          	beq	a3,a4,80005910 <__memmove+0xfc>
    800058c8:	0025c603          	lbu	a2,2(a1)
    800058cc:	00200713          	li	a4,2
    800058d0:	00c78123          	sb	a2,2(a5)
    800058d4:	02e68e63          	beq	a3,a4,80005910 <__memmove+0xfc>
    800058d8:	0035c603          	lbu	a2,3(a1)
    800058dc:	00300713          	li	a4,3
    800058e0:	00c781a3          	sb	a2,3(a5)
    800058e4:	02e68663          	beq	a3,a4,80005910 <__memmove+0xfc>
    800058e8:	0045c603          	lbu	a2,4(a1)
    800058ec:	00400713          	li	a4,4
    800058f0:	00c78223          	sb	a2,4(a5)
    800058f4:	00e68e63          	beq	a3,a4,80005910 <__memmove+0xfc>
    800058f8:	0055c603          	lbu	a2,5(a1)
    800058fc:	00500713          	li	a4,5
    80005900:	00c782a3          	sb	a2,5(a5)
    80005904:	00e68663          	beq	a3,a4,80005910 <__memmove+0xfc>
    80005908:	0065c703          	lbu	a4,6(a1)
    8000590c:	00e78323          	sb	a4,6(a5)
    80005910:	00813403          	ld	s0,8(sp)
    80005914:	01010113          	addi	sp,sp,16
    80005918:	00008067          	ret
    8000591c:	02061713          	slli	a4,a2,0x20
    80005920:	02075713          	srli	a4,a4,0x20
    80005924:	00e587b3          	add	a5,a1,a4
    80005928:	f0f574e3          	bgeu	a0,a5,80005830 <__memmove+0x1c>
    8000592c:	02069613          	slli	a2,a3,0x20
    80005930:	02065613          	srli	a2,a2,0x20
    80005934:	fff64613          	not	a2,a2
    80005938:	00e50733          	add	a4,a0,a4
    8000593c:	00c78633          	add	a2,a5,a2
    80005940:	fff7c683          	lbu	a3,-1(a5)
    80005944:	fff78793          	addi	a5,a5,-1
    80005948:	fff70713          	addi	a4,a4,-1
    8000594c:	00d70023          	sb	a3,0(a4)
    80005950:	fec798e3          	bne	a5,a2,80005940 <__memmove+0x12c>
    80005954:	00813403          	ld	s0,8(sp)
    80005958:	01010113          	addi	sp,sp,16
    8000595c:	00008067          	ret
    80005960:	02069713          	slli	a4,a3,0x20
    80005964:	02075713          	srli	a4,a4,0x20
    80005968:	00170713          	addi	a4,a4,1
    8000596c:	00e50733          	add	a4,a0,a4
    80005970:	00050793          	mv	a5,a0
    80005974:	0005c683          	lbu	a3,0(a1)
    80005978:	00178793          	addi	a5,a5,1
    8000597c:	00158593          	addi	a1,a1,1
    80005980:	fed78fa3          	sb	a3,-1(a5)
    80005984:	fee798e3          	bne	a5,a4,80005974 <__memmove+0x160>
    80005988:	f89ff06f          	j	80005910 <__memmove+0xfc>
	...
