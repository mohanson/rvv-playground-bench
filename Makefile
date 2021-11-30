RISCV = ~/app/riscv_rvv
RISCV_RUNNER = ~/src/ckb-vm/target/release/examples/int64
RVV_AS = ~/src/rvv-playground/target/debug/rvv-as

bench_uint:
	cd bench_uint && \
	cargo build --release --target riscv64imac-unknown-none-elf && \
	time $(RISCV_RUNNER) target/riscv64imac-unknown-none-elf/release/bench_uint

bench_uint_rvv:
	cd bench_uint_rvv && \
	$(RVV_AS) vmul_vv.s > vmul_vv_emit.s && \
	$(RISCV)/bin/riscv64-unknown-elf-gcc -Os -c vmul_vv_emit.s -o vmul_vv.o && \
	$(RISCV)/bin/riscv64-unknown-elf-gcc -Os -o vmul_vv.bin vmul_vv.c vmul_vv.o && \
	time $(RISCV_RUNNER) vmul_vv.bin

fmt:
	clang-format --style="{ColumnLimit: 240}" -i ./bench_uint_rvv/vmul_vv.c

.PHONY: bench_uint bench_uint_rvv fmt
