FC = mpif90
FFLAGS   = -O2 -fbounds-check -fbacktrace -Wuninitialized -ffpe-trap=invalid,zero,overflow

# monolis_utils library
MONOLIS_UTILS_DIR = ./submodule/monolis_utils
MONOLIS_UTILS_INC = -I $(MONOLIS_UTILS_DIR)/include
MONOLIS_UTILS_LIB = -L$(MONOLIS_UTILS_DIR)/lib -lmonolis_utils

SRC_DIR = ./src/module_fort
OBJ_DIR = ./obj
INCLUDE = ./include
SLIB_DIR = ./sobj
SLIB = libfort.so
TARGET = $(addprefix $(SLIB_DIR)/, $(SLIB))
SRC = utils.f90 io.f90 debug.f90 v3_init_placement.f90 mesomesh_gen.f90 wrapper.f90
SOURCES = $(addprefix $(SRC_DIR)/, $(SRC))
OBJS = $(subst $(SRC_DIR), $(OBJ_DIR), $(SOURCES:.f90=.o))

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.f90
	$(FC) $(FFLAGS) -c $< -J $(INCLUDE) -I $(INCLUDE) $(MONOLIS_UTILS_INC) -o $@

$(TARGET): $(OBJS)
	$(FC) -shared -o $@ $^ $(MONOLIS_UTILS_LIB)

clean:
	rm -f $(OBJ_DIR)/*.o $(INCLUDE)/*.mod $(TARGET)

.PHONY: clean