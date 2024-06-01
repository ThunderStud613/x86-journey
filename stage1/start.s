.code16
.global stage2_start
.extern stage2_main




stage2_start:
	cli
	hlt
	jmp stage2_start
