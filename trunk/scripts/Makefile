include ../config.mk

ZIP	= ../prc_consortium.tgz
ERF	= ../prc_consortium.erf
HAK	= ../prc_consortium.hak


2DAS	= ~~~2das~~~
GFXS	= ~~~gfxs~~~
OTHERS	= ~~~others~~~
SCRIPTS	= ~~~scripts~~~
OBJS	= $(SCRIPTS:.nss=.ncs)

all:	scripts pack

scripts: $(OBJS)

pack: scripts
	@echo -n 'Packing erf file..'
	@$(ERFCOMPILER) -c $(ERF) $(SCRIPTS) $(OBJS)
	@echo '.done'
	@echo -n 'Packing hak file..'
	@$(ERFCOMPILER) -c $(HAK) $(2DAS) $(OTHERS) $(GFXS)
	@echo '.done'

clean:
	@rm -f $(OBJS) $(ZIP) $(ERF) $(HAK) *.ndb

# NOTE: It really should be $(OBJS) instead of *.ncs but this causes problems with include files
install: scripts
	@echo 'Copying 2das, gfx, scripts and others to override and tlk to tlk directory...'
	@cp -f *.ncs $(NWN_OVERRIDE)
	@cp -f $(2DAS) $(NWN_OVERRIDE)
	@cp -f $(GFXS) $(NWN_OVERRIDE)
	@cp -f $(OTHERS) $(NWN_OVERRIDE)
	@cp -f $(2DAS) $(NWN_OVERRIDE)
	@cp -f ../tlk/prc_consortium.tlk $(NWN_TLK)
	@echo 'Done.'

%.ncs: %.nss
	$(NSSCOMPILER) $*.nss
