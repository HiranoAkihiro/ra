FC = gfortran
FFLAGS   = -O2 -fbounds-check -fbacktrace -Wuninitialized -ffpe-trap=invalid,zero,overflow

SRC_DIR = ./src/module_fort
OBJ_DIR = ./obj
INCLUDE = ./include
SLIB_DIR = ./sobj
SLIB = libfort.so
TARGET = $(addprefix $(SLIB_DIR)/, $(SLIB))
SRC = utils.f90 io.f90 mesomesh_gen.f90 mesomesh_gen_wrapper.f90
SOURCES = $(addprefix $(SRC_DIR)/, $(SRC))
OBJS = $(subst $(SRC_DIR), $(OBJ_DIR), $(SOURCES:.f90=.o))

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.f90
	$(FC) $(FFLAGS) -c $< -J $(INCLUDE) -I $(INCLUDE) -o $@

$(TARGET): $(OBJS)
	$(FC) -shared -o $@ $^

clean:
	rm -f $(OBJ_DIR)/*.o $(INCLUDE)/*.mod $(TARGET)

.PHONY: clean