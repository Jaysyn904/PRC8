include ../config.mk

NWN_BIN     ?= $(NWN_DIR)/bin/linux-x86/nwmain-linux
NWN_MODULES ?= $(NWN_DIR)/modules/
NWN_LOGS    ?= $(NWN_DIR)/logs/
TEST_MODULE ?= PRC8_Tester
TEST_RUNNER ?=

SCRIPTS  = ~~~scripts~~~
OBJS     = $(SCRIPTS:.nss=.ncs)
INCLUDES = $(wildcard *.nss)

all:	scripts

scripts: $(OBJS)

install: scripts
	@mkdir -p "$(NWN_OVERRIDE)" "$(NWN_MODULES)" "$(NWN_LOGS)"
	@cp -f $(OBJS) "$(NWN_OVERRIDE)"
	@if [ -f "../CompiledResources/$(TEST_MODULE).mod" ]; then \
		cp -f "../CompiledResources/$(TEST_MODULE).mod" "$(NWN_MODULES)/$(TEST_MODULE).mod"; \
	fi

test: install
	@rm -f "$(NWN_LOGS)/nwclientLog1.txt"
	@cd "$(dir $(NWN_BIN))" && $(TEST_RUNNER) "./$(notdir $(NWN_BIN))" +TestNewModule "$(TEST_MODULE)" >/dev/null 2>&1 & \
	NWPID=$$!; \
	for iter in $$(seq 1 50); do \
		if [ -f "$(NWN_LOGS)/nwclientLog1.txt" ] && grep -q "\[HARNESS\] SUMMARY:" "$(NWN_LOGS)/nwclientLog1.txt"; then \
			break; \
		fi; \
		sleep 1; \
	done; \
	kill -9 $$NWPID 2>/dev/null || true; \
	pkill -9 "$(notdir $(NWN_BIN))" 2>/dev/null || true; \
	rm -f $(patsubst %.ncs,"$(NWN_OVERRIDE)/%.ncs",$(OBJS))
	@grep -E "\[HARNESS\]|\[PASS\]|\[FAIL\]" "$(NWN_LOGS)/nwclientLog1.txt"
	@grep -q "FAIL=0" "$(NWN_LOGS)/nwclientLog1.txt" && ! grep -q "\[FAIL\]" "$(NWN_LOGS)/nwclientLog1.txt"

clean:
	@rm -f $(OBJS) *.ndb

%.ncs: %.nss $(INCLUDES)
	$(NSSCOMPILER) $*.nss
