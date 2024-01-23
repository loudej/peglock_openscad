


ifneq ("$(shell where openscad)","") 
OPENSCAD=openscad
else
OPENSCAD="C:\Program Files\Openscad\openscad.exe"
endif

OPENSCAD_FLAGS=

MODELS=peglock_attachment peglock_attachment_smaller peglock_base peglock_base_smaller

all: $(patsubst %,images/%.png,$(MODELS)) $(patsubst %,models/%.stl,$(MODELS))

images models:
	mkdir $@

images/%.png: %.scad peglock_modules.scad | images
	$(OPENSCAD) $(OPENSCAD_FLAGS) -o $@ $<

models/%.stl: %.scad peglock_modules.scad | models
	$(OPENSCAD) $(OPENSCAD_FLAGS) -o $@ $<
