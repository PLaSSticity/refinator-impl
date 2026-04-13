#include "codegen/RISCV/codegen.c"
#include "codegen/RISCV/codegen.h"
#include "codegen/x86/codegen.c"
#include "codegen/x86/codegen.h"
#include "codegen/x86/test_x86.c"
#include "codegen/x86/test_x86.h"
#include "lexer/lex.c"
#include "lexer/lex.h"
#include "lexer/test_lexer.c"
#include "lexer/test_lexer.h"
#include "lexer/token.h"
#include "parser/cst.h"
#include "parser/parse.c"
#include "parser/parse.h"
#include "util/hashmap.c"
#include "util/hashmap.h"
#include "util/list.c"
#include "util/list.h"
#include "util/out.h"
#include "util/test_list.c"
#include "util/test_list.h"
#include "util/test_util.c"
#include "util/test_util.h"
#include "testing/test_utils.c"
#include "testing/test_utils.h"
#include "testing/tassert.h"

int main()
{
	test_lexer();
	test_x86();
	test_list();
	test_util();

	return 0;
}
