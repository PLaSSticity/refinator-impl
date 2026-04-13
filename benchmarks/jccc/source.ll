; ModuleID = 'source.ll'
source_filename = "source.c"
target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-unknown-linux-gnu"

%struct.Lexer = type { ptr, [256 x i8], [1 x i8], i64, i32, i32, i32, [5 x %struct.Token], i32 }
%struct.Token = type { i32, [256 x i8], i32, [256 x i8], i32, i32 }
%struct.Hashmap = type { ptr, i32, i32 }
%struct.BucketNode = type { ptr, ptr, ptr }
%struct.List = type { ptr, ptr, i32 }
%struct.ListBlock = type { ptr, i32, i32, ptr }

@registers_in_use = dso_local global i32 0, align 4
@sp_offset = dso_local global i32 0, align 4
@r_start_main.start = internal global [256 x i8] c".global _start\0A_start:\0A\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00", align 1
@rsp_offset = dso_local global i32 0, align 4
@start_main.start = internal global [256 x i8] c"global _start\0Asection .text\0A\0A_start:\0A\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00", align 1
@end_main.end = internal global [256 x i8] c"\09mov rax, 60\09mov rdi, 0\09syscall\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00", align 1
@.str = private unnamed_addr constant [36 x i8] c"\09mov rax, 60\0A\09mov rdi, %d\0A\09syscall\0A\00", align 1
@op_strs = internal global [4 x ptr] [ptr @.str.157, ptr @.str.158, ptr @.str.159, ptr null], align 8
@.str.1 = private unnamed_addr constant [14 x i8] c"\09%s rax, rdi\0A\00", align 1
@start_func.start = internal global [256 x i8] c"\09sub rsp, 32\09mov [rsp], r12\09mov [rsp+8], r13\09mov [rsp+16], r14\09mov [rsp+24], r15\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00", align 1
@end_func.end = internal global [256 x i8] c"\09mov r12, [rsp]\09mov r13, [rsp+8]\09mov r14, [rsp+16]\09mov r15, [rsp+24]\09add rsp, 32\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00", align 1
@.str.2 = private unnamed_addr constant [18 x i8] c"\09mov [rsp+%d], %d\00", align 1
@__func__.test_init_int_literal = private unnamed_addr constant [22 x i8] c"test_init_int_literal\00", align 1
@.str.3 = private unnamed_addr constant [18 x i8] c"\09mov [rsp+8], 100\00", align 1
@.str.4 = private unnamed_addr constant [30 x i8] c"%s:%u: failed assertion `%s'\0A\00", align 1
@.str.5 = private unnamed_addr constant [26 x i8] c"src/codegen/x86/codegen.c\00", align 1
@.str.6 = private unnamed_addr constant [56 x i8] c"strcmp(init_int_literal(100), \22\09mov [rsp+8], 100\22) == 0\00", align 1
@__func__.test_op_on_rax_with_rdi = private unnamed_addr constant [24 x i8] c"test_op_on_rax_with_rdi\00", align 1
@.str.7 = private unnamed_addr constant [15 x i8] c"\09add rax, rdi\0A\00", align 1
@.str.8 = private unnamed_addr constant [36 x i8] c"strcmp(out, \22\09add rax, rdi\\n\22) == 0\00", align 1
@.str.9 = private unnamed_addr constant [15 x i8] c"\09mov rax, rdi\0A\00", align 1
@.str.10 = private unnamed_addr constant [37 x i8] c"strcmp(out2, \22\09mov rax, rdi\\n\22) == 0\00", align 1
@__func__.test_x86 = private unnamed_addr constant [9 x i8] c"test_x86\00", align 1
@single_char_tokens = dso_local global [15 x i8] c"(){}[];~#,.:?~\00", align 1
@.str.11 = private unnamed_addr constant [2 x i8] c"-\00", align 1
@.str.12 = private unnamed_addr constant [2 x i8] c"+\00", align 1
@.str.13 = private unnamed_addr constant [2 x i8] c"*\00", align 1
@.str.14 = private unnamed_addr constant [2 x i8] c"/\00", align 1
@.str.15 = private unnamed_addr constant [2 x i8] c"=\00", align 1
@.str.16 = private unnamed_addr constant [2 x i8] c":\00", align 1
@.str.17 = private unnamed_addr constant [2 x i8] c"%\00", align 1
@.str.18 = private unnamed_addr constant [2 x i8] c"&\00", align 1
@.str.19 = private unnamed_addr constant [3 x i8] c"&&\00", align 1
@.str.20 = private unnamed_addr constant [2 x i8] c"|\00", align 1
@.str.21 = private unnamed_addr constant [3 x i8] c"||\00", align 1
@.str.22 = private unnamed_addr constant [3 x i8] c"-=\00", align 1
@.str.23 = private unnamed_addr constant [3 x i8] c"+=\00", align 1
@.str.24 = private unnamed_addr constant [3 x i8] c"++\00", align 1
@.str.25 = private unnamed_addr constant [3 x i8] c"--\00", align 1
@.str.26 = private unnamed_addr constant [3 x i8] c"/=\00", align 1
@.str.27 = private unnamed_addr constant [3 x i8] c"*=\00", align 1
@.str.28 = private unnamed_addr constant [3 x i8] c"%=\00", align 1
@.str.29 = private unnamed_addr constant [3 x i8] c"&=\00", align 1
@.str.30 = private unnamed_addr constant [3 x i8] c"|=\00", align 1
@.str.31 = private unnamed_addr constant [4 x i8] c"&&=\00", align 1
@.str.32 = private unnamed_addr constant [4 x i8] c"||=\00", align 1
@.str.33 = private unnamed_addr constant [2 x i8] c">\00", align 1
@.str.34 = private unnamed_addr constant [2 x i8] c"<\00", align 1
@.str.35 = private unnamed_addr constant [3 x i8] c"<=\00", align 1
@.str.36 = private unnamed_addr constant [3 x i8] c">=\00", align 1
@.str.37 = private unnamed_addr constant [3 x i8] c"<<\00", align 1
@.str.38 = private unnamed_addr constant [3 x i8] c">>\00", align 1
@.str.39 = private unnamed_addr constant [2 x i8] c"!\00", align 1
@.str.40 = private unnamed_addr constant [3 x i8] c"==\00", align 1
@.str.41 = private unnamed_addr constant [3 x i8] c"!=\00", align 1
@.str.42 = private unnamed_addr constant [2 x i8] c"^\00", align 1
@.str.43 = private unnamed_addr constant [3 x i8] c"^=\00", align 1
@.str.44 = private unnamed_addr constant [3 x i8] c"->\00", align 1
@.str.45 = private unnamed_addr constant [4 x i8] c"<<=\00", align 1
@.str.46 = private unnamed_addr constant [4 x i8] c">>=\00", align 1
@operator_strings = dso_local global [37 x ptr] [ptr @.str.11, ptr @.str.12, ptr @.str.13, ptr @.str.14, ptr @.str.15, ptr @.str.16, ptr @.str.17, ptr @.str.18, ptr @.str.19, ptr @.str.20, ptr @.str.21, ptr @.str.22, ptr @.str.23, ptr @.str.24, ptr @.str.25, ptr @.str.26, ptr @.str.27, ptr @.str.28, ptr @.str.29, ptr @.str.30, ptr @.str.31, ptr @.str.32, ptr @.str.33, ptr @.str.34, ptr @.str.35, ptr @.str.36, ptr @.str.37, ptr @.str.38, ptr @.str.39, ptr @.str.40, ptr @.str.41, ptr @.str.42, ptr @.str.43, ptr @.str.44, ptr @.str.45, ptr @.str.46, ptr null], align 8
@.str.47 = private unnamed_addr constant [17 x i8] c"l->position >= 0\00", align 1
@.str.48 = private unnamed_addr constant [16 x i8] c"src/lexer/lex.c\00", align 1
@__PRETTY_FUNCTION__.lexer_ungetchar = private unnamed_addr constant [29 x i8] c"int lexer_ungetchar(Lexer *)\00", align 1
@real_lex.eof = internal global [14 x i8] c"[end of file]\00", align 1
@stderr = external global ptr, align 8
@.str.49 = private unnamed_addr constant [6 x i8] c"\1B[%dm\00", align 1
@.str.50 = private unnamed_addr constant [64 x i8] c"Error: jccc: internal error: did not skip whitespace correctly\0A\00", align 1
@.str.51 = private unnamed_addr constant [5 x i8] c"\1B[0m\00", align 1
@real_lex.nline = internal global [10 x i8] c"[newline]\00", align 1
@.str.52 = private unnamed_addr constant [54 x i8] c"Error: jccc: identifier too long, over %d characters\0A\00", align 1
@.str.53 = private unnamed_addr constant [51 x i8] c"Error: jccc: identifier began with the following:\0A\00", align 1
@.str.54 = private unnamed_addr constant [19 x i8] c"Error: jccc: %.*s\0A\00", align 1
@.str.55 = private unnamed_addr constant [63 x i8] c"Error: jccc: lexer unable to identify token starting with: %c\0A\00", align 1
@.str.56 = private unnamed_addr constant [69 x i8] c"Error: jccc: internal: tried to unlex more than %d tokens at a time\0A\00", align 1
@.str.57 = private unnamed_addr constant [5 x i8] c"auto\00", align 1
@.str.58 = private unnamed_addr constant [6 x i8] c"break\00", align 1
@.str.59 = private unnamed_addr constant [9 x i8] c"continue\00", align 1
@.str.60 = private unnamed_addr constant [6 x i8] c"const\00", align 1
@.str.61 = private unnamed_addr constant [5 x i8] c"case\00", align 1
@.str.62 = private unnamed_addr constant [5 x i8] c"char\00", align 1
@.str.63 = private unnamed_addr constant [3 x i8] c"do\00", align 1
@.str.64 = private unnamed_addr constant [7 x i8] c"double\00", align 1
@.str.65 = private unnamed_addr constant [8 x i8] c"default\00", align 1
@.str.66 = private unnamed_addr constant [5 x i8] c"enum\00", align 1
@.str.67 = private unnamed_addr constant [5 x i8] c"else\00", align 1
@.str.68 = private unnamed_addr constant [7 x i8] c"extern\00", align 1
@.str.69 = private unnamed_addr constant [6 x i8] c"float\00", align 1
@.str.70 = private unnamed_addr constant [4 x i8] c"for\00", align 1
@.str.71 = private unnamed_addr constant [5 x i8] c"goto\00", align 1
@.str.72 = private unnamed_addr constant [4 x i8] c"int\00", align 1
@.str.73 = private unnamed_addr constant [3 x i8] c"if\00", align 1
@.str.74 = private unnamed_addr constant [5 x i8] c"long\00", align 1
@.str.75 = private unnamed_addr constant [7 x i8] c"return\00", align 1
@.str.76 = private unnamed_addr constant [9 x i8] c"register\00", align 1
@.str.77 = private unnamed_addr constant [7 x i8] c"struct\00", align 1
@.str.78 = private unnamed_addr constant [7 x i8] c"signed\00", align 1
@.str.79 = private unnamed_addr constant [7 x i8] c"sizeof\00", align 1
@.str.80 = private unnamed_addr constant [7 x i8] c"static\00", align 1
@.str.81 = private unnamed_addr constant [6 x i8] c"short\00", align 1
@.str.82 = private unnamed_addr constant [7 x i8] c"switch\00", align 1
@.str.83 = private unnamed_addr constant [8 x i8] c"typedef\00", align 1
@.str.84 = private unnamed_addr constant [6 x i8] c"union\00", align 1
@.str.85 = private unnamed_addr constant [9 x i8] c"unsigned\00", align 1
@.str.86 = private unnamed_addr constant [5 x i8] c"void\00", align 1
@.str.87 = private unnamed_addr constant [9 x i8] c"volatile\00", align 1
@.str.88 = private unnamed_addr constant [6 x i8] c"while\00", align 1
@ttype_names = internal global [85 x ptr] [ptr @.str.99, ptr @.str.160, ptr @.str.161, ptr @.str.162, ptr @.str.163, ptr @.str.164, ptr @.str.165, ptr @.str.166, ptr @.str.167, ptr @.str.168, ptr @.str.169, ptr @.str.170, ptr @.str.171, ptr @.str.172, ptr @.str.173, ptr @.str.174, ptr @.str.11, ptr @.str.12, ptr @.str.13, ptr @.str.14, ptr @.str.15, ptr @.str.16, ptr @.str.17, ptr @.str.18, ptr @.str.19, ptr @.str.20, ptr @.str.21, ptr @.str.22, ptr @.str.23, ptr @.str.24, ptr @.str.25, ptr @.str.26, ptr @.str.27, ptr @.str.28, ptr @.str.29, ptr @.str.30, ptr @.str.31, ptr @.str.32, ptr @.str.33, ptr @.str.34, ptr @.str.35, ptr @.str.36, ptr @.str.37, ptr @.str.38, ptr @.str.39, ptr @.str.175, ptr @.str.40, ptr @.str.41, ptr @.str.42, ptr @.str.43, ptr @.str.44, ptr @.str.45, ptr @.str.46, ptr @.str.57, ptr @.str.58, ptr @.str.62, ptr @.str.60, ptr @.str.61, ptr @.str.59, ptr @.str.64, ptr @.str.63, ptr @.str.65, ptr @.str.66, ptr @.str.67, ptr @.str.68, ptr @.str.69, ptr @.str.70, ptr @.str.71, ptr @.str.73, ptr @.str.72, ptr @.str.74, ptr @.str.75, ptr @.str.76, ptr @.str.80, ptr @.str.82, ptr @.str.81, ptr @.str.78, ptr @.str.77, ptr @.str.79, ptr @.str.83, ptr @.str.85, ptr @.str.84, ptr @.str.86, ptr @.str.87, ptr @.str.88], align 8
@__func__.test_ttype_many_chars = private unnamed_addr constant [22 x i8] c"test_ttype_many_chars\00", align 1
@.str.89 = private unnamed_addr constant [4 x i8] c"foo\00", align 1
@.str.90 = private unnamed_addr constant [41 x i8] c"ttype_many_chars(\22foo\22) == TT_IDENTIFIER\00", align 1
@.str.91 = private unnamed_addr constant [40 x i8] c"ttype_many_chars(\22struct\22) == TT_STRUCT\00", align 1
@.str.92 = private unnamed_addr constant [38 x i8] c"ttype_many_chars(\22while\22) == TT_WHILE\00", align 1
@__func__.test_ttype_one_char = private unnamed_addr constant [20 x i8] c"test_ttype_one_char\00", align 1
@.str.93 = private unnamed_addr constant [37 x i8] c"ttype_one_char('a') == TT_IDENTIFIER\00", align 1
@.str.94 = private unnamed_addr constant [34 x i8] c"ttype_one_char('1') == TT_LITERAL\00", align 1
@.str.95 = private unnamed_addr constant [31 x i8] c"ttype_one_char('+') == TT_PLUS\00", align 1
@.str.96 = private unnamed_addr constant [32 x i8] c"ttype_one_char('-') == TT_MINUS\00", align 1
@.str.97 = private unnamed_addr constant [34 x i8] c"ttype_one_char('>') == TT_GREATER\00", align 1
@.str.98 = private unnamed_addr constant [31 x i8] c"ttype_one_char('~') == TT_BNOT\00", align 1
@__func__.test_ttype_name = private unnamed_addr constant [16 x i8] c"test_ttype_name\00", align 1
@.str.99 = private unnamed_addr constant [8 x i8] c"literal\00", align 1
@.str.100 = private unnamed_addr constant [47 x i8] c"strcmp(ttype_name(TT_LITERAL), \22literal\22) == 0\00", align 1
@.str.101 = private unnamed_addr constant [38 x i8] c"strcmp(ttype_name(TT_PLUS), \22+\22) == 0\00", align 1
@.str.102 = private unnamed_addr constant [45 x i8] c"strcmp(ttype_name(TT_SIZEOF), \22sizeof\22) == 0\00", align 1
@.str.103 = private unnamed_addr constant [43 x i8] c"strcmp(ttype_name(TT_WHILE), \22while\22) == 0\00", align 1
@__func__.test_ttype_from_string = private unnamed_addr constant [23 x i8] c"test_ttype_from_string\00", align 1
@.str.104 = private unnamed_addr constant [34 x i8] c"ttype_from_string(\22+\22) == TT_PLUS\00", align 1
@.str.105 = private unnamed_addr constant [36 x i8] c"ttype_from_string(\22=\22) == TT_ASSIGN\00", align 1
@.str.106 = private unnamed_addr constant [2 x i8] c"1\00", align 1
@.str.107 = private unnamed_addr constant [37 x i8] c"ttype_from_string(\221\22) == TT_LITERAL\00", align 1
@.str.108 = private unnamed_addr constant [4 x i8] c"1.2\00", align 1
@.str.109 = private unnamed_addr constant [39 x i8] c"ttype_from_string(\221.2\22) == TT_LITERAL\00", align 1
@.str.110 = private unnamed_addr constant [3 x i8] c"1u\00", align 1
@.str.111 = private unnamed_addr constant [38 x i8] c"ttype_from_string(\221u\22) == TT_LITERAL\00", align 1
@.str.112 = private unnamed_addr constant [5 x i8] c"1.2f\00", align 1
@.str.113 = private unnamed_addr constant [40 x i8] c"ttype_from_string(\221.2f\22) == TT_LITERAL\00", align 1
@.str.114 = private unnamed_addr constant [4 x i8] c"1.f\00", align 1
@.str.115 = private unnamed_addr constant [39 x i8] c"ttype_from_string(\221.f\22) == TT_LITERAL\00", align 1
@.str.116 = private unnamed_addr constant [9 x i8] c"\22Planck\22\00", align 1
@.str.117 = private unnamed_addr constant [46 x i8] c"ttype_from_string(\22\\\22Planck\\\22\22) == TT_LITERAL\00", align 1
@.str.118 = private unnamed_addr constant [11 x i8] c"'Language'\00", align 1
@.str.119 = private unnamed_addr constant [46 x i8] c"ttype_from_string(\22'Language'\22) == TT_LITERAL\00", align 1
@.str.120 = private unnamed_addr constant [5 x i8] c"Jaba\00", align 1
@.str.121 = private unnamed_addr constant [43 x i8] c"ttype_from_string(\22Jaba\22) == TT_IDENTIFIER\00", align 1
@.str.122 = private unnamed_addr constant [5 x i8] c"cat_\00", align 1
@.str.123 = private unnamed_addr constant [43 x i8] c"ttype_from_string(\22cat_\22) == TT_IDENTIFIER\00", align 1
@.str.124 = private unnamed_addr constant [2 x i8] c"(\00", align 1
@.str.125 = private unnamed_addr constant [36 x i8] c"ttype_from_string(\22(\22) == TT_OPAREN\00", align 1
@.str.126 = private unnamed_addr constant [2 x i8] c"}\00", align 1
@.str.127 = private unnamed_addr constant [36 x i8] c"ttype_from_string(\22}\22) == TT_CBRACE\00", align 1
@.str.128 = private unnamed_addr constant [2 x i8] c";\00", align 1
@.str.129 = private unnamed_addr constant [34 x i8] c"ttype_from_string(\22;\22) == TT_SEMI\00", align 1
@__func__.test_lexer = private unnamed_addr constant [11 x i8] c"test_lexer\00", align 1
@.str.130 = private unnamed_addr constant [2 x i8] c"r\00", align 1
@.str.131 = private unnamed_addr constant [32 x i8] c"Error: jccc: File %s not found\0A\00", align 1
@.str.132 = private unnamed_addr constant [45 x i8] c"Contents: %20s, type: %20s, position: %d/%d\0A\00", align 1
@.str.133 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@.str.134 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.135 = private unnamed_addr constant [36 x i8] c"Error: jccc: Wrong closing brace.\0A\0A\00", align 1
@.str.136 = private unnamed_addr constant [38 x i8] c"Error: jccc: Return value is wrong.\0A\0A\00", align 1
@.str.137 = private unnamed_addr constant [41 x i8] c"Error: jccc: Wrong main function body.\0A\0A\00", align 1
@.str.138 = private unnamed_addr constant [42 x i8] c"Error: jccc: Not correct main function.\0A\0A\00", align 1
@__func__.test_hash_init = private unnamed_addr constant [15 x i8] c"test_hash_init\00", align 1
@.str.139 = private unnamed_addr constant [19 x i8] c"src/util/hashmap.c\00", align 1
@.str.140 = private unnamed_addr constant [13 x i8] c"h->size == 0\00", align 1
@.str.141 = private unnamed_addr constant [14 x i8] c"h->cap == 100\00", align 1
@__func__.test_hash_init_and_store = private unnamed_addr constant [25 x i8] c"test_hash_init_and_store\00", align 1
@__const.test_hash_init_and_store.name = private unnamed_addr constant [5 x i8] c"jake\00", align 1
@__const.test_hash_init_and_store.key = private unnamed_addr constant [5 x i8] c"test\00", align 1
@.str.142 = private unnamed_addr constant [10 x i8] c"ret != -1\00", align 1
@.str.143 = private unnamed_addr constant [25 x i8] c"strcmp(b->key, key) == 0\00", align 1
@.str.144 = private unnamed_addr constant [13 x i8] c"h->size == 1\00", align 1
@__func__.test_hash_set_and_get = private unnamed_addr constant [22 x i8] c"test_hash_set_and_get\00", align 1
@__const.test_hash_set_and_get.key = private unnamed_addr constant [10 x i8] c"test\00\00\00\00\00\00", align 1
@.str.145 = private unnamed_addr constant [5 x i8] c"test\00", align 1
@.str.146 = private unnamed_addr constant [5 x i8] c"jake\00", align 1
@.str.147 = private unnamed_addr constant [32 x i8] c"strcmp(got->value, \22jake\22) == 0\00", align 1
@__func__.test_hash_set_and_double_get = private unnamed_addr constant [29 x i8] c"test_hash_set_and_double_get\00", align 1
@__const.test_hash_set_and_double_get.key = private unnamed_addr constant [10 x i8] c"test\00\00\00\00\00\00", align 1
@.str.148 = private unnamed_addr constant [50 x i8] c"Error: jccc: internal: failed to allocate memory\0A\00", align 1
@.str.149 = private unnamed_addr constant [52 x i8] c"Error: jccc: internal: list index %d out of bounds\0A\00", align 1
@basic_100_test.BS = internal global i32 10, align 4
@basic_100_test.TS = internal global i32 100, align 4
@.str.150 = private unnamed_addr constant [21 x i8] c"src/util/test_list.c\00", align 1
@.str.151 = private unnamed_addr constant [24 x i8] c"lget_element(l, i) == i\00", align 1
@__func__.test_list = private unnamed_addr constant [10 x i8] c"test_list\00", align 1
@__func__.test_util = private unnamed_addr constant [10 x i8] c"test_util\00", align 1
@.str.152 = private unnamed_addr constant [20 x i8] c"Running tests from \00", align 1
@stdout = external global ptr, align 8
@.str.153 = private unnamed_addr constant [5 x i8] c"\22%s\22\00", align 1
@.str.154 = private unnamed_addr constant [6 x i8] c" ...\0A\00", align 1
@.str.155 = private unnamed_addr constant [22 x i8] c"Concluded tests from \00", align 1
@.str.156 = private unnamed_addr constant [9 x i8] c"Running \00", align 1
@.str.157 = private unnamed_addr constant [4 x i8] c"add\00", align 1
@.str.158 = private unnamed_addr constant [4 x i8] c"sub\00", align 1
@.str.159 = private unnamed_addr constant [4 x i8] c"mov\00", align 1
@.str.160 = private unnamed_addr constant [11 x i8] c"identifier\00", align 1
@.str.161 = private unnamed_addr constant [11 x i8] c"open paren\00", align 1
@.str.162 = private unnamed_addr constant [12 x i8] c"close paren\00", align 1
@.str.163 = private unnamed_addr constant [11 x i8] c"open brace\00", align 1
@.str.164 = private unnamed_addr constant [12 x i8] c"close brace\00", align 1
@.str.165 = private unnamed_addr constant [13 x i8] c"open bracket\00", align 1
@.str.166 = private unnamed_addr constant [14 x i8] c"close bracket\00", align 1
@.str.167 = private unnamed_addr constant [10 x i8] c"semicolon\00", align 1
@.str.168 = private unnamed_addr constant [9 x i8] c"no token\00", align 1
@.str.169 = private unnamed_addr constant [12 x i8] c"end of file\00", align 1
@.str.170 = private unnamed_addr constant [8 x i8] c"newline\00", align 1
@.str.171 = private unnamed_addr constant [6 x i8] c"pound\00", align 1
@.str.172 = private unnamed_addr constant [2 x i8] c".\00", align 1
@.str.173 = private unnamed_addr constant [2 x i8] c",\00", align 1
@.str.174 = private unnamed_addr constant [2 x i8] c"?\00", align 1
@.str.175 = private unnamed_addr constant [2 x i8] c"~\00", align 1
@.str.176 = private unnamed_addr constant [53 x i8] c"Error: jccc: internal: list index was negative (%d)\0A\00", align 1

; Function Attrs: nounwind uwtable
define dso_local void @r_code_gen_init() #0 {
entry:
  store i32 0, ptr @registers_in_use, align 4, !tbaa !6
  store i32 0, ptr @sp_offset, align 4, !tbaa !6
  ret void
}

; Function Attrs: nounwind uwtable
define dso_local ptr @r_start_main() #0 {
entry:
  ret ptr @r_start_main.start
}

; Function Attrs: nounwind uwtable
define dso_local void @code_gen_init() #0 {
entry:
  store i32 0, ptr @registers_in_use, align 4, !tbaa !6
  store i32 0, ptr @rsp_offset, align 4, !tbaa !6
  ret void
}

; Function Attrs: nounwind uwtable
define dso_local i32 @ttype_to_op(i32 noundef %t) #0 {
entry:
  switch i32 %t, label %sw.default [
    i32 17, label %sw.bb
    i32 16, label %sw.bb1
  ]

sw.bb:                                            ; preds = %entry
  br label %return

sw.bb1:                                           ; preds = %entry
  br label %return

sw.default:                                       ; preds = %entry
  br label %return

return:                                           ; preds = %sw.default, %sw.bb1, %sw.bb
  %retval.0 = phi i32 [ 3, %sw.default ], [ 1, %sw.bb1 ], [ 0, %sw.bb ]
  ret i32 %retval.0
}

; Function Attrs: nounwind uwtable
define dso_local ptr @start_main() #0 {
entry:
  ret ptr @start_main.start
}

; Function Attrs: nounwind uwtable
define dso_local ptr @end_main() #0 {
entry:
  ret ptr @end_main.end
}

; Function Attrs: nounwind uwtable
define dso_local ptr @end_main_custom_return(i32 noundef %val) #0 {
entry:
  %call = call noalias ptr @malloc(i64 noundef 256) #11
  %call1 = call i32 (ptr, ptr, ...) @sprintf(ptr noundef %call, ptr noundef @.str, i32 noundef %val) #12
  ret ptr %call
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: nounwind allocsize(0)
declare noalias ptr @malloc(i64 noundef) #2

; Function Attrs: nounwind
declare i32 @sprintf(ptr noundef, ptr noundef, ...) #3

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: nounwind uwtable
define dso_local ptr @op_on_rax_with_rdi(i32 noundef %op) #0 {
entry:
  %call = call noalias ptr @malloc(i64 noundef 256) #11
  %idxprom = zext i32 %op to i64
  %arrayidx = getelementptr inbounds [4 x ptr], ptr @op_strs, i64 0, i64 %idxprom
  %0 = load ptr, ptr %arrayidx, align 8, !tbaa !10
  %call1 = call i32 (ptr, ptr, ...) @sprintf(ptr noundef %call, ptr noundef @.str.1, ptr noundef %0) #12
  ret ptr %call
}

; Function Attrs: nounwind uwtable
define dso_local ptr @start_func() #0 {
entry:
  ret ptr @start_func.start
}

; Function Attrs: nounwind uwtable
define dso_local ptr @end_func() #0 {
entry:
  ret ptr @end_func.end
}

; Function Attrs: nounwind uwtable
define dso_local ptr @init_int_literal(i32 noundef %val) #0 {
entry:
  %0 = load i32, ptr @rsp_offset, align 4, !tbaa !6
  %add = add i32 %0, 8
  store i32 %add, ptr @rsp_offset, align 4, !tbaa !6
  %call = call noalias ptr @malloc(i64 noundef 256) #11
  %1 = load i32, ptr @rsp_offset, align 4, !tbaa !6
  %call1 = call i32 (ptr, ptr, ...) @sprintf(ptr noundef %call, ptr noundef @.str.2, i32 noundef %1, i32 noundef %val) #12
  ret ptr %call
}

; Function Attrs: nounwind uwtable
define dso_local i32 @test_init_int_literal() #0 {
entry:
  call void @testing_single_test_internal(ptr noundef @__func__.test_init_int_literal)
  call void @code_gen_init()
  %call = call ptr @init_int_literal(i32 noundef 100)
  %call1 = call i32 @strcmp(ptr noundef %call, ptr noundef @.str.3) #13
  %cmp = icmp eq i32 %call1, 0
  br i1 %cmp, label %cond.true, label %cond.false

cond.true:                                        ; preds = %entry
  br label %cond.end

cond.false:                                       ; preds = %entry
  %call2 = call i32 (ptr, ...) @printf(ptr noundef @.str.4, ptr noundef @.str.5, i32 noundef 113, ptr noundef @.str.6)
  br label %cond.end

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi i32 [ 0, %cond.true ], [ 0, %cond.false ]
  ret i32 0
}

; Function Attrs: nounwind uwtable
define dso_local void @testing_single_test_internal(ptr noundef %func_name) #0 {
entry:
  %call = call i32 (ptr, ...) @printf(ptr noundef @.str.156)
  %0 = load ptr, ptr @stdout, align 8, !tbaa !10
  %call1 = call i32 @fflush(ptr noundef %0)
  br label %do.body

do.body:                                          ; preds = %entry
  %1 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call2 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %1, ptr noundef @.str.49, i32 noundef 32)
  %2 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call3 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %2, ptr noundef @.str.153, ptr noundef %func_name)
  %3 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call4 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %3, ptr noundef @.str.51)
  br label %do.end

do.end:                                           ; preds = %do.body
  %call5 = call i32 (ptr, ...) @printf(ptr noundef @.str.134)
  ret void
}

; Function Attrs: nounwind willreturn memory(read)
declare i32 @strcmp(ptr noundef, ptr noundef) #4

declare i32 @printf(ptr noundef, ...) #5

; Function Attrs: nounwind uwtable
define dso_local i32 @test_op_on_rax_with_rdi() #0 {
entry:
  call void @testing_single_test_internal(ptr noundef @__func__.test_op_on_rax_with_rdi)
  %call = call ptr @op_on_rax_with_rdi(i32 noundef 0)
  %call1 = call i32 @strcmp(ptr noundef %call, ptr noundef @.str.7) #13
  %cmp = icmp eq i32 %call1, 0
  br i1 %cmp, label %cond.true, label %cond.false

cond.true:                                        ; preds = %entry
  br label %cond.end

cond.false:                                       ; preds = %entry
  %call2 = call i32 (ptr, ...) @printf(ptr noundef @.str.4, ptr noundef @.str.5, i32 noundef 122, ptr noundef @.str.8)
  br label %cond.end

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi i32 [ 0, %cond.true ], [ 0, %cond.false ]
  %call3 = call ptr @op_on_rax_with_rdi(i32 noundef 2)
  %call4 = call i32 @strcmp(ptr noundef %call3, ptr noundef @.str.9) #13
  %cmp5 = icmp eq i32 %call4, 0
  br i1 %cmp5, label %cond.true6, label %cond.false7

cond.true6:                                       ; preds = %cond.end
  br label %cond.end9

cond.false7:                                      ; preds = %cond.end
  %call8 = call i32 (ptr, ...) @printf(ptr noundef @.str.4, ptr noundef @.str.5, i32 noundef 125, ptr noundef @.str.10)
  br label %cond.end9

cond.end9:                                        ; preds = %cond.false7, %cond.true6
  %cond10 = phi i32 [ 0, %cond.true6 ], [ 0, %cond.false7 ]
  ret i32 0
}

; Function Attrs: nounwind uwtable
define dso_local i32 @test_x86() #0 {
entry:
  call void @testing_setup_internal(ptr noundef @__func__.test_x86)
  %call = call i32 @test_init_int_literal()
  %call1 = call i32 @test_op_on_rax_with_rdi()
  call void @testing_cleanup_internal(ptr noundef @__func__.test_x86)
  ret i32 0
}

; Function Attrs: nounwind uwtable
define dso_local void @testing_setup_internal(ptr noundef %func_name) #0 {
entry:
  %call = call i32 (ptr, ...) @printf(ptr noundef @.str.152)
  %0 = load ptr, ptr @stdout, align 8, !tbaa !10
  %call1 = call i32 @fflush(ptr noundef %0)
  br label %do.body

do.body:                                          ; preds = %entry
  %1 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call2 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %1, ptr noundef @.str.49, i32 noundef 32)
  %2 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call3 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %2, ptr noundef @.str.153, ptr noundef %func_name)
  %3 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call4 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %3, ptr noundef @.str.51)
  br label %do.end

do.end:                                           ; preds = %do.body
  %call5 = call i32 (ptr, ...) @printf(ptr noundef @.str.154)
  ret void
}

; Function Attrs: nounwind uwtable
define dso_local void @testing_cleanup_internal(ptr noundef %func_name) #0 {
entry:
  %call = call i32 (ptr, ...) @printf(ptr noundef @.str.155)
  %0 = load ptr, ptr @stdout, align 8, !tbaa !10
  %call1 = call i32 @fflush(ptr noundef %0)
  br label %do.body

do.body:                                          ; preds = %entry
  %1 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call2 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %1, ptr noundef @.str.49, i32 noundef 32)
  %2 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call3 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %2, ptr noundef @.str.153, ptr noundef %func_name)
  %3 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call4 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %3, ptr noundef @.str.51)
  br label %do.end

do.end:                                           ; preds = %do.body
  %call5 = call i32 (ptr, ...) @printf(ptr noundef @.str.134)
  ret void
}

; Function Attrs: nounwind uwtable
define dso_local i32 @in_string(i8 noundef %c, ptr noundef %s) #0 {
entry:
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %d.0 = phi ptr [ %s, %entry ], [ %incdec.ptr, %for.inc ]
  %0 = load i8, ptr %d.0, align 1, !tbaa !12
  %tobool = icmp ne i8 %0, 0
  br i1 %tobool, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %cleanup

for.body:                                         ; preds = %for.cond
  %1 = load i8, ptr %d.0, align 1, !tbaa !12
  %conv = zext i8 %1 to i32
  %conv1 = zext i8 %c to i32
  %cmp = icmp eq i32 %conv, %conv1
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %for.body
  br label %cleanup

if.end:                                           ; preds = %for.body
  br label %for.inc

for.inc:                                          ; preds = %if.end
  %incdec.ptr = getelementptr inbounds i8, ptr %d.0, i32 1
  br label %for.cond, !llvm.loop !13

cleanup:                                          ; preds = %if.then, %for.cond.cleanup
  %cleanup.dest.slot.0 = phi i32 [ 1, %if.then ], [ 2, %for.cond.cleanup ]
  switch i32 %cleanup.dest.slot.0, label %unreachable [
    i32 2, label %for.end
    i32 1, label %return
  ]

for.end:                                          ; preds = %cleanup
  br label %return

return:                                           ; preds = %for.end, %cleanup
  %retval.1 = phi i32 [ 1, %cleanup ], [ 0, %for.end ]
  ret i32 %retval.1

unreachable:                                      ; preds = %cleanup
  unreachable
}

; Function Attrs: nounwind uwtable
define dso_local i32 @starts_operator(i8 noundef %c) #0 {
entry:
  %conv = zext i8 %c to i32
  switch i32 %conv, label %sw.default [
    i32 45, label %sw.bb
    i32 43, label %sw.bb
    i32 42, label %sw.bb
    i32 47, label %sw.bb
    i32 61, label %sw.bb
    i32 58, label %sw.bb
    i32 37, label %sw.bb
    i32 38, label %sw.bb
    i32 124, label %sw.bb
    i32 60, label %sw.bb
    i32 62, label %sw.bb
    i32 33, label %sw.bb
    i32 126, label %sw.bb
    i32 94, label %sw.bb
  ]

sw.bb:                                            ; preds = %entry, %entry, %entry, %entry, %entry, %entry, %entry, %entry, %entry, %entry, %entry, %entry, %entry, %entry
  br label %return

sw.default:                                       ; preds = %entry
  br label %return

return:                                           ; preds = %sw.default, %sw.bb
  %retval.0 = phi i32 [ 0, %sw.default ], [ 1, %sw.bb ]
  ret i32 %retval.0
}

; Function Attrs: nounwind uwtable
define dso_local i32 @valid_operator_sequence(ptr noundef %op) #0 {
entry:
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %top.0 = phi ptr [ @operator_strings, %entry ], [ %incdec.ptr, %for.inc ]
  %0 = load ptr, ptr %top.0, align 8, !tbaa !10
  %tobool = icmp ne ptr %0, null
  br i1 %tobool, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %cleanup

for.body:                                         ; preds = %for.cond
  %1 = load ptr, ptr %top.0, align 8, !tbaa !10
  %call = call i32 @strcmp(ptr noundef %1, ptr noundef %op) #13
  %tobool1 = icmp ne i32 %call, 0
  br i1 %tobool1, label %if.end, label %if.then

if.then:                                          ; preds = %for.body
  br label %cleanup

if.end:                                           ; preds = %for.body
  br label %for.inc

for.inc:                                          ; preds = %if.end
  %incdec.ptr = getelementptr inbounds ptr, ptr %top.0, i32 1
  br label %for.cond, !llvm.loop !16

cleanup:                                          ; preds = %if.then, %for.cond.cleanup
  %cleanup.dest.slot.0 = phi i32 [ 1, %if.then ], [ 2, %for.cond.cleanup ]
  switch i32 %cleanup.dest.slot.0, label %unreachable [
    i32 2, label %for.end
    i32 1, label %return
  ]

for.end:                                          ; preds = %cleanup
  br label %return

return:                                           ; preds = %for.end, %cleanup
  %retval.1 = phi i32 [ 1, %cleanup ], [ 0, %for.end ]
  ret i32 %retval.1

unreachable:                                      ; preds = %cleanup
  unreachable
}

; Function Attrs: nounwind uwtable
define dso_local i32 @is_valid_numeric_or_id_char(i8 noundef %c) #0 {
entry:
  %conv = zext i8 %c to i32
  %cmp = icmp eq i32 %conv, 95
  br i1 %cmp, label %lor.end, label %lor.rhs

lor.rhs:                                          ; preds = %entry
  %conv2 = zext i8 %c to i32
  %cmp3 = icmp eq i32 %conv2, 46
  br label %lor.end

lor.end:                                          ; preds = %lor.rhs, %entry
  %0 = phi i1 [ true, %entry ], [ %cmp3, %lor.rhs ]
  %lor.ext = zext i1 %0 to i32
  ret i32 %lor.ext
}

; Function Attrs: nounwind uwtable
define dso_local i32 @lexer_getchar(ptr noundef %l) #0 {
entry:
  %position = getelementptr inbounds %struct.Lexer, ptr %l, i32 0, i32 3
  %0 = load i64, ptr %position, align 8, !tbaa !17
  %inc = add nsw i64 %0, 1
  store i64 %inc, ptr %position, align 8, !tbaa !17
  %column = getelementptr inbounds %struct.Lexer, ptr %l, i32 0, i32 5
  %1 = load i32, ptr %column, align 4, !tbaa !20
  %last_column = getelementptr inbounds %struct.Lexer, ptr %l, i32 0, i32 4
  store i32 %1, ptr %last_column, align 8, !tbaa !21
  %fp = getelementptr inbounds %struct.Lexer, ptr %l, i32 0, i32 0
  %2 = load ptr, ptr %fp, align 8, !tbaa !22
  %call = call i32 @getc(ptr noundef %2)
  %conv = trunc i32 %call to i8
  %buffer = getelementptr inbounds %struct.Lexer, ptr %l, i32 0, i32 2
  %arrayidx = getelementptr inbounds [1 x i8], ptr %buffer, i64 0, i64 0
  store i8 %conv, ptr %arrayidx, align 8, !tbaa !12
  %buffer1 = getelementptr inbounds %struct.Lexer, ptr %l, i32 0, i32 2
  %arrayidx2 = getelementptr inbounds [1 x i8], ptr %buffer1, i64 0, i64 0
  %3 = load i8, ptr %arrayidx2, align 8, !tbaa !12
  %conv3 = zext i8 %3 to i32
  %cmp = icmp eq i32 %conv3, 10
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %line = getelementptr inbounds %struct.Lexer, ptr %l, i32 0, i32 6
  %4 = load i32, ptr %line, align 8, !tbaa !23
  %inc5 = add nsw i32 %4, 1
  store i32 %inc5, ptr %line, align 8, !tbaa !23
  %column6 = getelementptr inbounds %struct.Lexer, ptr %l, i32 0, i32 5
  store i32 0, ptr %column6, align 4, !tbaa !20
  br label %if.end

if.else:                                          ; preds = %entry
  %column7 = getelementptr inbounds %struct.Lexer, ptr %l, i32 0, i32 5
  %5 = load i32, ptr %column7, align 4, !tbaa !20
  %inc8 = add nsw i32 %5, 1
  store i32 %inc8, ptr %column7, align 4, !tbaa !20
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %buffer9 = getelementptr inbounds %struct.Lexer, ptr %l, i32 0, i32 2
  %arrayidx10 = getelementptr inbounds [1 x i8], ptr %buffer9, i64 0, i64 0
  %6 = load i8, ptr %arrayidx10, align 8, !tbaa !12
  %conv11 = zext i8 %6 to i32
  ret i32 %conv11
}

declare i32 @getc(ptr noundef) #5

; Function Attrs: nounwind uwtable
define dso_local i32 @lexer_ungetchar(ptr noundef %l) #0 {
entry:
  %position = getelementptr inbounds %struct.Lexer, ptr %l, i32 0, i32 3
  %0 = load i64, ptr %position, align 8, !tbaa !17
  %cmp = icmp sge i64 %0, 0
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  br label %if.end

if.else:                                          ; preds = %entry
  call void @__assert_fail(ptr noundef @.str.47, ptr noundef @.str.48, i32 noundef 102, ptr noundef @__PRETTY_FUNCTION__.lexer_ungetchar) #14
  unreachable

if.end:                                           ; preds = %if.then
  %position1 = getelementptr inbounds %struct.Lexer, ptr %l, i32 0, i32 3
  %1 = load i64, ptr %position1, align 8, !tbaa !17
  %dec = add nsw i64 %1, -1
  store i64 %dec, ptr %position1, align 8, !tbaa !17
  %last_column = getelementptr inbounds %struct.Lexer, ptr %l, i32 0, i32 4
  %2 = load i32, ptr %last_column, align 8, !tbaa !21
  %column = getelementptr inbounds %struct.Lexer, ptr %l, i32 0, i32 5
  store i32 %2, ptr %column, align 4, !tbaa !20
  %buffer = getelementptr inbounds %struct.Lexer, ptr %l, i32 0, i32 2
  %arrayidx = getelementptr inbounds [1 x i8], ptr %buffer, i64 0, i64 0
  %3 = load i8, ptr %arrayidx, align 8, !tbaa !12
  %conv = zext i8 %3 to i32
  %cmp2 = icmp eq i32 %conv, 10
  br i1 %cmp2, label %if.then4, label %if.end6

if.then4:                                         ; preds = %if.end
  %line = getelementptr inbounds %struct.Lexer, ptr %l, i32 0, i32 6
  %4 = load i32, ptr %line, align 8, !tbaa !23
  %dec5 = add nsw i32 %4, -1
  store i32 %dec5, ptr %line, align 8, !tbaa !23
  br label %if.end6

if.end6:                                          ; preds = %if.then4, %if.end
  %buffer7 = getelementptr inbounds %struct.Lexer, ptr %l, i32 0, i32 2
  %arrayidx8 = getelementptr inbounds [1 x i8], ptr %buffer7, i64 0, i64 0
  %5 = load i8, ptr %arrayidx8, align 8, !tbaa !12
  %conv9 = zext i8 %5 to i32
  %fp = getelementptr inbounds %struct.Lexer, ptr %l, i32 0, i32 0
  %6 = load ptr, ptr %fp, align 8, !tbaa !22
  %call = call i32 @ungetc(i32 noundef %conv9, ptr noundef %6)
  ret i32 1
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #6

declare i32 @ungetc(i32 noundef, ptr noundef) #5

; Function Attrs: nounwind uwtable
define dso_local i32 @lex(ptr noundef %l, ptr noundef %t) #0 {
entry:
  br label %for.cond

for.cond:                                         ; preds = %if.end, %entry
  %call = call i32 @real_lex(ptr noundef %l, ptr noundef %t)
  %type = getelementptr inbounds %struct.Token, ptr %t, i32 0, i32 0
  %0 = load i32, ptr %type, align 4, !tbaa !24
  %cmp = icmp ne i32 %0, 11
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %for.cond
  br label %for.end

if.end:                                           ; preds = %for.cond
  br label %for.cond, !llvm.loop !26

for.end:                                          ; preds = %if.then
  ret i32 0
}

; Function Attrs: nounwind uwtable
define dso_local i32 @real_lex(ptr noundef %l, ptr noundef %t) #0 {
entry:
  %unlexed_count = getelementptr inbounds %struct.Lexer, ptr %l, i32 0, i32 8
  %0 = load i32, ptr %unlexed_count, align 4, !tbaa !27
  %cmp = icmp ugt i32 %0, 0
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %unlexed_count1 = getelementptr inbounds %struct.Lexer, ptr %l, i32 0, i32 8
  %1 = load i32, ptr %unlexed_count1, align 4, !tbaa !27
  %dec = add i32 %1, -1
  store i32 %dec, ptr %unlexed_count1, align 4, !tbaa !27
  %unlexed = getelementptr inbounds %struct.Lexer, ptr %l, i32 0, i32 7
  %unlexed_count2 = getelementptr inbounds %struct.Lexer, ptr %l, i32 0, i32 8
  %2 = load i32, ptr %unlexed_count2, align 4, !tbaa !27
  %idxprom = zext i32 %2 to i64
  %arrayidx = getelementptr inbounds [5 x %struct.Token], ptr %unlexed, i64 0, i64 %idxprom
  call void @llvm.memcpy.p0.p0.i64(ptr align 4 %t, ptr align 4 %arrayidx, i64 528, i1 false)
  br label %return

if.end:                                           ; preds = %entry
  %call = call i32 @skip_to_token(ptr noundef %l)
  %call3 = call i32 @lexer_getchar(ptr noundef %l)
  %contents = getelementptr inbounds %struct.Token, ptr %t, i32 0, i32 1
  %arraydecay = getelementptr inbounds [256 x i8], ptr %contents, i64 0, i64 0
  call void @llvm.memset.p0.i64(ptr align 4 %arraydecay, i8 0, i64 256, i1 false)
  %source_file = getelementptr inbounds %struct.Token, ptr %t, i32 0, i32 3
  %arraydecay4 = getelementptr inbounds [256 x i8], ptr %source_file, i64 0, i64 0
  %current_file = getelementptr inbounds %struct.Lexer, ptr %l, i32 0, i32 1
  call void @llvm.memcpy.p0.p0.i64(ptr align 4 %arraydecay4, ptr align 8 %current_file, i64 256, i1 false)
  %cmp5 = icmp eq i32 %call3, -1
  br i1 %cmp5, label %if.then6, label %if.end13

if.then6:                                         ; preds = %if.end
  %contents7 = getelementptr inbounds %struct.Token, ptr %t, i32 0, i32 1
  %arraydecay8 = getelementptr inbounds [256 x i8], ptr %contents7, i64 0, i64 0
  %call9 = call ptr @strcpy(ptr noundef %arraydecay8, ptr noundef @real_lex.eof) #12
  %call10 = call i64 @strlen(ptr noundef @real_lex.eof) #13
  %conv = trunc i64 %call10 to i32
  %length = getelementptr inbounds %struct.Token, ptr %t, i32 0, i32 2
  store i32 %conv, ptr %length, align 4, !tbaa !28
  %type = getelementptr inbounds %struct.Token, ptr %t, i32 0, i32 0
  store i32 10, ptr %type, align 4, !tbaa !24
  %line = getelementptr inbounds %struct.Lexer, ptr %l, i32 0, i32 6
  %3 = load i32, ptr %line, align 8, !tbaa !23
  %line11 = getelementptr inbounds %struct.Token, ptr %t, i32 0, i32 4
  store i32 %3, ptr %line11, align 4, !tbaa !29
  %column = getelementptr inbounds %struct.Lexer, ptr %l, i32 0, i32 5
  %4 = load i32, ptr %column, align 4, !tbaa !20
  %column12 = getelementptr inbounds %struct.Token, ptr %t, i32 0, i32 5
  store i32 %4, ptr %column12, align 4, !tbaa !30
  br label %cleanup140

if.end13:                                         ; preds = %if.end
  %cmp14 = icmp eq i32 %call3, 32
  br i1 %cmp14, label %if.then18, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %if.end13
  %cmp16 = icmp eq i32 %call3, 9
  br i1 %cmp16, label %if.then18, label %if.end22

if.then18:                                        ; preds = %lor.lhs.false, %if.end13
  br label %do.body

do.body:                                          ; preds = %if.then18
  %5 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call19 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %5, ptr noundef @.str.49, i32 noundef 31)
  %6 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call20 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %6, ptr noundef @.str.50)
  %7 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call21 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %7, ptr noundef @.str.51)
  br label %do.cond

do.cond:                                          ; preds = %do.body
  br label %do.end

do.end:                                           ; preds = %do.cond
  br label %cleanup140

if.end22:                                         ; preds = %lor.lhs.false
  %cmp23 = icmp eq i32 %call3, 10
  br i1 %cmp23, label %if.then25, label %if.end37

if.then25:                                        ; preds = %if.end22
  %contents26 = getelementptr inbounds %struct.Token, ptr %t, i32 0, i32 1
  %arraydecay27 = getelementptr inbounds [256 x i8], ptr %contents26, i64 0, i64 0
  %call28 = call ptr @strcpy(ptr noundef %arraydecay27, ptr noundef @real_lex.nline) #12
  %call29 = call i64 @strlen(ptr noundef @real_lex.nline) #13
  %conv30 = trunc i64 %call29 to i32
  %length31 = getelementptr inbounds %struct.Token, ptr %t, i32 0, i32 2
  store i32 %conv30, ptr %length31, align 4, !tbaa !28
  %type32 = getelementptr inbounds %struct.Token, ptr %t, i32 0, i32 0
  store i32 11, ptr %type32, align 4, !tbaa !24
  %line33 = getelementptr inbounds %struct.Lexer, ptr %l, i32 0, i32 6
  %8 = load i32, ptr %line33, align 8, !tbaa !23
  %line34 = getelementptr inbounds %struct.Token, ptr %t, i32 0, i32 4
  store i32 %8, ptr %line34, align 4, !tbaa !29
  %column35 = getelementptr inbounds %struct.Lexer, ptr %l, i32 0, i32 5
  %9 = load i32, ptr %column35, align 4, !tbaa !20
  %column36 = getelementptr inbounds %struct.Token, ptr %t, i32 0, i32 5
  store i32 %9, ptr %column36, align 4, !tbaa !30
  br label %cleanup140

if.end37:                                         ; preds = %if.end22
  %conv38 = trunc i32 %call3 to i8
  %contents39 = getelementptr inbounds %struct.Token, ptr %t, i32 0, i32 1
  %inc = add nsw i32 0, 1
  %idxprom40 = sext i32 0 to i64
  %arrayidx41 = getelementptr inbounds [256 x i8], ptr %contents39, i64 0, i64 %idxprom40
  store i8 %conv38, ptr %arrayidx41, align 1, !tbaa !12
  %conv42 = trunc i32 %call3 to i8
  %call43 = call i32 @in_string(i8 noundef %conv42, ptr noundef @single_char_tokens)
  %tobool = icmp ne i32 %call43, 0
  br i1 %tobool, label %if.then44, label %if.end53

if.then44:                                        ; preds = %if.end37
  %length45 = getelementptr inbounds %struct.Token, ptr %t, i32 0, i32 2
  store i32 %inc, ptr %length45, align 4, !tbaa !28
  %conv46 = trunc i32 %call3 to i8
  %call47 = call i32 @ttype_one_char(i8 noundef %conv46)
  %type48 = getelementptr inbounds %struct.Token, ptr %t, i32 0, i32 0
  store i32 %call47, ptr %type48, align 4, !tbaa !24
  %line49 = getelementptr inbounds %struct.Lexer, ptr %l, i32 0, i32 6
  %10 = load i32, ptr %line49, align 8, !tbaa !23
  %line50 = getelementptr inbounds %struct.Token, ptr %t, i32 0, i32 4
  store i32 %10, ptr %line50, align 4, !tbaa !29
  %column51 = getelementptr inbounds %struct.Lexer, ptr %l, i32 0, i32 5
  %11 = load i32, ptr %column51, align 4, !tbaa !20
  %column52 = getelementptr inbounds %struct.Token, ptr %t, i32 0, i32 5
  store i32 %11, ptr %column52, align 4, !tbaa !30
  br label %cleanup139

if.end53:                                         ; preds = %if.end37
  %conv54 = trunc i32 %call3 to i8
  %call55 = call i32 @is_valid_numeric_or_id_char(i8 noundef %conv54)
  %tobool56 = icmp ne i32 %call55, 0
  br i1 %tobool56, label %if.then57, label %if.end106

if.then57:                                        ; preds = %if.end53
  %line58 = getelementptr inbounds %struct.Lexer, ptr %l, i32 0, i32 6
  %12 = load i32, ptr %line58, align 8, !tbaa !23
  %column59 = getelementptr inbounds %struct.Lexer, ptr %l, i32 0, i32 5
  %13 = load i32, ptr %column59, align 4, !tbaa !20
  br label %for.cond

for.cond:                                         ; preds = %if.end89, %if.then57
  %pos.0 = phi i32 [ %inc, %if.then57 ], [ %inc92, %if.end89 ]
  %call60 = call i32 @lexer_getchar(ptr noundef %l)
  %conv61 = trunc i32 %call60 to i8
  %call62 = call i32 @is_valid_numeric_or_id_char(i8 noundef %conv61)
  %tobool63 = icmp ne i32 %call62, 0
  br i1 %tobool63, label %if.end65, label %if.then64

if.then64:                                        ; preds = %for.cond
  br label %for.end

if.end65:                                         ; preds = %for.cond
  %cmp66 = icmp sge i32 %pos.0, 255
  br i1 %cmp66, label %if.then68, label %if.end89

if.then68:                                        ; preds = %if.end65
  br label %do.body69

do.body69:                                        ; preds = %if.then68
  %14 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call70 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %14, ptr noundef @.str.49, i32 noundef 31)
  %15 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call71 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %15, ptr noundef @.str.52, i32 noundef 256)
  %16 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call72 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %16, ptr noundef @.str.51)
  br label %do.cond73

do.cond73:                                        ; preds = %do.body69
  br label %do.end74

do.end74:                                         ; preds = %do.cond73
  br label %do.body75

do.body75:                                        ; preds = %do.end74
  %17 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call76 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %17, ptr noundef @.str.49, i32 noundef 31)
  %18 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call77 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %18, ptr noundef @.str.53)
  %19 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call78 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %19, ptr noundef @.str.51)
  br label %do.cond79

do.cond79:                                        ; preds = %do.body75
  br label %do.end80

do.end80:                                         ; preds = %do.cond79
  br label %do.body81

do.body81:                                        ; preds = %do.end80
  %20 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call82 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %20, ptr noundef @.str.49, i32 noundef 31)
  %21 = load ptr, ptr @stderr, align 8, !tbaa !10
  %contents83 = getelementptr inbounds %struct.Token, ptr %t, i32 0, i32 1
  %arraydecay84 = getelementptr inbounds [256 x i8], ptr %contents83, i64 0, i64 0
  %call85 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %21, ptr noundef @.str.54, i32 noundef 256, ptr noundef %arraydecay84)
  %22 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call86 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %22, ptr noundef @.str.51)
  br label %do.cond87

do.cond87:                                        ; preds = %do.body81
  br label %do.end88

do.end88:                                         ; preds = %do.cond87
  br label %cleanup

if.end89:                                         ; preds = %if.end65
  %conv90 = trunc i32 %call60 to i8
  %contents91 = getelementptr inbounds %struct.Token, ptr %t, i32 0, i32 1
  %inc92 = add nsw i32 %pos.0, 1
  %idxprom93 = sext i32 %pos.0 to i64
  %arrayidx94 = getelementptr inbounds [256 x i8], ptr %contents91, i64 0, i64 %idxprom93
  store i8 %conv90, ptr %arrayidx94, align 1, !tbaa !12
  br label %for.cond, !llvm.loop !31

for.end:                                          ; preds = %if.then64
  %call95 = call i32 @lexer_ungetchar(ptr noundef %l)
  %contents96 = getelementptr inbounds %struct.Token, ptr %t, i32 0, i32 1
  %idxprom97 = sext i32 %pos.0 to i64
  %arrayidx98 = getelementptr inbounds [256 x i8], ptr %contents96, i64 0, i64 %idxprom97
  store i8 0, ptr %arrayidx98, align 1, !tbaa !12
  %contents99 = getelementptr inbounds %struct.Token, ptr %t, i32 0, i32 1
  %arraydecay100 = getelementptr inbounds [256 x i8], ptr %contents99, i64 0, i64 0
  %call101 = call i32 @ttype_many_chars(ptr noundef %arraydecay100)
  %type102 = getelementptr inbounds %struct.Token, ptr %t, i32 0, i32 0
  store i32 %call101, ptr %type102, align 4, !tbaa !24
  %length103 = getelementptr inbounds %struct.Token, ptr %t, i32 0, i32 2
  store i32 %pos.0, ptr %length103, align 4, !tbaa !28
  %line104 = getelementptr inbounds %struct.Token, ptr %t, i32 0, i32 4
  store i32 %12, ptr %line104, align 4, !tbaa !29
  %column105 = getelementptr inbounds %struct.Token, ptr %t, i32 0, i32 5
  store i32 %13, ptr %column105, align 4, !tbaa !30
  br label %cleanup

if.end106:                                        ; preds = %if.end53
  %conv107 = trunc i32 %call3 to i8
  %call108 = call i32 @starts_operator(i8 noundef %conv107)
  %tobool109 = icmp ne i32 %call108, 0
  br i1 %tobool109, label %if.then110, label %if.end130

if.then110:                                       ; preds = %if.end106
  br label %while.cond

while.cond:                                       ; preds = %while.body, %if.then110
  %pos.1 = phi i32 [ %inc, %if.then110 ], [ %inc118, %while.body ]
  %contents111 = getelementptr inbounds %struct.Token, ptr %t, i32 0, i32 1
  %arraydecay112 = getelementptr inbounds [256 x i8], ptr %contents111, i64 0, i64 0
  %call113 = call i32 @valid_operator_sequence(ptr noundef %arraydecay112)
  %tobool114 = icmp ne i32 %call113, 0
  br i1 %tobool114, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %call115 = call i32 @lexer_getchar(ptr noundef %l)
  %conv116 = trunc i32 %call115 to i8
  %contents117 = getelementptr inbounds %struct.Token, ptr %t, i32 0, i32 1
  %inc118 = add nsw i32 %pos.1, 1
  %idxprom119 = sext i32 %pos.1 to i64
  %arrayidx120 = getelementptr inbounds [256 x i8], ptr %contents117, i64 0, i64 %idxprom119
  store i8 %conv116, ptr %arrayidx120, align 1, !tbaa !12
  br label %while.cond, !llvm.loop !32

while.end:                                        ; preds = %while.cond
  %call121 = call i32 @lexer_ungetchar(ptr noundef %l)
  %contents122 = getelementptr inbounds %struct.Token, ptr %t, i32 0, i32 1
  %sub = sub nsw i32 %pos.1, 1
  %idxprom123 = sext i32 %sub to i64
  %arrayidx124 = getelementptr inbounds [256 x i8], ptr %contents122, i64 0, i64 %idxprom123
  store i8 0, ptr %arrayidx124, align 1, !tbaa !12
  %contents125 = getelementptr inbounds %struct.Token, ptr %t, i32 0, i32 1
  %arraydecay126 = getelementptr inbounds [256 x i8], ptr %contents125, i64 0, i64 0
  %call127 = call i32 @ttype_from_string(ptr noundef %arraydecay126)
  %type128 = getelementptr inbounds %struct.Token, ptr %t, i32 0, i32 0
  store i32 %call127, ptr %type128, align 4, !tbaa !24
  %length129 = getelementptr inbounds %struct.Token, ptr %t, i32 0, i32 2
  store i32 %pos.1, ptr %length129, align 4, !tbaa !28
  br label %cleanup

if.end130:                                        ; preds = %if.end106
  br label %do.body131

do.body131:                                       ; preds = %if.end130
  %23 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call132 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %23, ptr noundef @.str.49, i32 noundef 31)
  %24 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call133 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %24, ptr noundef @.str.55, i32 noundef %call3)
  %25 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call134 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %25, ptr noundef @.str.51)
  br label %do.cond135

do.cond135:                                       ; preds = %do.body131
  br label %do.end136

do.end136:                                        ; preds = %do.cond135
  br label %cleanup

cleanup:                                          ; preds = %do.end136, %while.end, %for.end, %do.end88
  %retval.0 = phi i32 [ -1, %do.end88 ], [ 0, %for.end ], [ 0, %while.end ], [ 0, %do.end136 ]
  br label %cleanup139

cleanup139:                                       ; preds = %cleanup, %if.then44
  %retval.1 = phi i32 [ 0, %if.then44 ], [ %retval.0, %cleanup ]
  br label %cleanup140

cleanup140:                                       ; preds = %cleanup139, %if.then25, %do.end, %if.then6
  %retval.2 = phi i32 [ 0, %if.then6 ], [ -1, %do.end ], [ 0, %if.then25 ], [ %retval.1, %cleanup139 ]
  br label %return

return:                                           ; preds = %cleanup140, %if.then
  %retval.3 = phi i32 [ 0, %if.then ], [ %retval.2, %cleanup140 ]
  ret i32 %retval.3
}

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias nocapture writeonly, ptr noalias nocapture readonly, i64, i1 immarg) #7

; Function Attrs: nounwind uwtable
define dso_local i32 @skip_to_token(ptr noundef %l) #0 {
entry:
  %call = call i32 @lexer_getchar(ptr noundef %l)
  %conv = trunc i32 %call to i8
  %conv1 = zext i8 %conv to i32
  %cmp = icmp ne i32 %conv1, -1
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %conv3 = zext i8 %conv to i32
  %cmp4 = icmp eq i32 %conv3, 32
  br i1 %cmp4, label %if.end, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %if.then
  %conv6 = zext i8 %conv to i32
  %cmp7 = icmp eq i32 %conv6, 9
  br i1 %cmp7, label %if.end, label %lor.lhs.false9

lor.lhs.false9:                                   ; preds = %lor.lhs.false
  %conv10 = zext i8 %conv to i32
  %cmp11 = icmp eq i32 %conv10, 47
  br i1 %cmp11, label %if.end, label %if.then13

if.then13:                                        ; preds = %lor.lhs.false9
  %call14 = call i32 @lexer_ungetchar(ptr noundef %l)
  br label %cleanup

if.end:                                           ; preds = %lor.lhs.false9, %lor.lhs.false, %if.then
  br label %if.end15

if.else:                                          ; preds = %entry
  br label %cleanup

if.end15:                                         ; preds = %if.end
  br label %while.cond

while.cond:                                       ; preds = %if.end102, %if.end15
  %pass.0 = phi i32 [ 0, %if.end15 ], [ %sub, %if.end102 ]
  %in_block.0 = phi i32 [ 0, %if.end15 ], [ %in_block.3, %if.end102 ]
  %prev.0 = phi i8 [ %conv, %if.end15 ], [ %conv17, %if.end102 ]
  %call16 = call i32 @lexer_getchar(ptr noundef %l)
  %conv17 = trunc i32 %call16 to i8
  %conv18 = zext i8 %conv17 to i32
  %cmp19 = icmp ne i32 %conv18, -1
  br i1 %cmp19, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %conv21 = zext i8 %conv17 to i32
  %cmp22 = icmp eq i32 %conv21, 47
  br i1 %cmp22, label %land.lhs.true, label %if.else31

land.lhs.true:                                    ; preds = %while.body
  %conv24 = zext i8 %prev.0 to i32
  %cmp25 = icmp eq i32 %conv24, 47
  br i1 %cmp25, label %land.lhs.true27, label %if.else31

land.lhs.true27:                                  ; preds = %land.lhs.true
  %cmp28 = icmp eq i32 %in_block.0, 0
  br i1 %cmp28, label %if.then30, label %if.else31

if.then30:                                        ; preds = %land.lhs.true27
  br label %if.end85

if.else31:                                        ; preds = %land.lhs.true27, %land.lhs.true, %while.body
  %conv32 = zext i8 %conv17 to i32
  %cmp33 = icmp eq i32 %conv32, 42
  br i1 %cmp33, label %land.lhs.true35, label %if.else43

land.lhs.true35:                                  ; preds = %if.else31
  %conv36 = zext i8 %prev.0 to i32
  %cmp37 = icmp eq i32 %conv36, 47
  br i1 %cmp37, label %land.lhs.true39, label %if.else43

land.lhs.true39:                                  ; preds = %land.lhs.true35
  %cmp40 = icmp eq i32 %in_block.0, 0
  br i1 %cmp40, label %if.then42, label %if.else43

if.then42:                                        ; preds = %land.lhs.true39
  br label %if.end84

if.else43:                                        ; preds = %land.lhs.true39, %land.lhs.true35, %if.else31
  %cmp44 = icmp eq i32 %in_block.0, 1
  br i1 %cmp44, label %land.lhs.true46, label %lor.lhs.false50

land.lhs.true46:                                  ; preds = %if.else43
  %conv47 = zext i8 %conv17 to i32
  %cmp48 = icmp eq i32 %conv47, 10
  br i1 %cmp48, label %if.then64, label %lor.lhs.false50

lor.lhs.false50:                                  ; preds = %land.lhs.true46, %if.else43
  %cmp51 = icmp eq i32 %in_block.0, 2
  br i1 %cmp51, label %land.lhs.true53, label %if.else65

land.lhs.true53:                                  ; preds = %lor.lhs.false50
  %conv54 = zext i8 %conv17 to i32
  %cmp55 = icmp eq i32 %conv54, 47
  br i1 %cmp55, label %land.lhs.true57, label %if.else65

land.lhs.true57:                                  ; preds = %land.lhs.true53
  %conv58 = zext i8 %prev.0 to i32
  %cmp59 = icmp eq i32 %conv58, 42
  br i1 %cmp59, label %land.lhs.true61, label %if.else65

land.lhs.true61:                                  ; preds = %land.lhs.true57
  %cmp62 = icmp sle i32 %pass.0, 0
  br i1 %cmp62, label %if.then64, label %if.else65

if.then64:                                        ; preds = %land.lhs.true61, %land.lhs.true46
  br label %if.end83

if.else65:                                        ; preds = %land.lhs.true61, %land.lhs.true57, %land.lhs.true53, %lor.lhs.false50
  %conv66 = zext i8 %prev.0 to i32
  %cmp67 = icmp eq i32 %conv66, 47
  br i1 %cmp67, label %land.lhs.true69, label %if.end82

land.lhs.true69:                                  ; preds = %if.else65
  %conv70 = zext i8 %conv17 to i32
  %cmp71 = icmp eq i32 %conv70, 42
  br i1 %cmp71, label %if.end82, label %lor.lhs.false73

lor.lhs.false73:                                  ; preds = %land.lhs.true69
  %conv74 = zext i8 %conv17 to i32
  %cmp75 = icmp eq i32 %conv74, 47
  br i1 %cmp75, label %if.end82, label %land.lhs.true77

land.lhs.true77:                                  ; preds = %lor.lhs.false73
  %cmp78 = icmp eq i32 %in_block.0, 0
  br i1 %cmp78, label %if.then80, label %if.end82

if.then80:                                        ; preds = %land.lhs.true77
  %call81 = call i32 @lexer_ungetchar(ptr noundef %l)
  br label %cleanup

if.end82:                                         ; preds = %land.lhs.true77, %lor.lhs.false73, %land.lhs.true69, %if.else65
  br label %if.end83

if.end83:                                         ; preds = %if.end82, %if.then64
  %in_block.1 = phi i32 [ 0, %if.then64 ], [ %in_block.0, %if.end82 ]
  br label %if.end84

if.end84:                                         ; preds = %if.end83, %if.then42
  %pass.1 = phi i32 [ 2, %if.then42 ], [ %pass.0, %if.end83 ]
  %in_block.2 = phi i32 [ 2, %if.then42 ], [ %in_block.1, %if.end83 ]
  br label %if.end85

if.end85:                                         ; preds = %if.end84, %if.then30
  %pass.2 = phi i32 [ %pass.0, %if.then30 ], [ %pass.1, %if.end84 ]
  %in_block.3 = phi i32 [ 1, %if.then30 ], [ %in_block.2, %if.end84 ]
  %conv86 = zext i8 %conv17 to i32
  %cmp87 = icmp eq i32 %conv86, 32
  br i1 %cmp87, label %if.end102, label %lor.lhs.false89

lor.lhs.false89:                                  ; preds = %if.end85
  %conv90 = zext i8 %conv17 to i32
  %cmp91 = icmp eq i32 %conv90, 9
  br i1 %cmp91, label %if.end102, label %lor.lhs.false93

lor.lhs.false93:                                  ; preds = %lor.lhs.false89
  %conv94 = zext i8 %conv17 to i32
  %cmp95 = icmp eq i32 %conv94, 47
  br i1 %cmp95, label %if.end102, label %land.lhs.true97

land.lhs.true97:                                  ; preds = %lor.lhs.false93
  %cmp98 = icmp eq i32 %in_block.3, 0
  br i1 %cmp98, label %if.then100, label %if.end102

if.then100:                                       ; preds = %land.lhs.true97
  %call101 = call i32 @lexer_ungetchar(ptr noundef %l)
  br label %cleanup

if.end102:                                        ; preds = %land.lhs.true97, %lor.lhs.false93, %lor.lhs.false89, %if.end85
  %sub = sub nsw i32 %pass.2, 1
  br label %while.cond, !llvm.loop !33

while.end:                                        ; preds = %while.cond
  br label %cleanup

cleanup:                                          ; preds = %while.end, %if.then100, %if.then80, %if.else, %if.then13
  %retval.0 = phi i32 [ 0, %if.then100 ], [ 0, %if.then80 ], [ -1, %while.end ], [ 0, %if.then13 ], [ -1, %if.else ]
  ret i32 %retval.0
}

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr nocapture writeonly, i8, i64, i1 immarg) #8

; Function Attrs: nounwind
declare ptr @strcpy(ptr noundef, ptr noundef) #3

; Function Attrs: nounwind willreturn memory(read)
declare i64 @strlen(ptr noundef) #4

declare i32 @fprintf(ptr noundef, ptr noundef, ...) #5

; Function Attrs: nounwind uwtable
define dso_local i32 @ttype_one_char(i8 noundef %c) #0 {
entry:
  %conv = zext i8 %c to i32
  switch i32 %conv, label %sw.default [
    i32 40, label %sw.bb
    i32 41, label %sw.bb1
    i32 123, label %sw.bb2
    i32 125, label %sw.bb3
    i32 91, label %sw.bb4
    i32 93, label %sw.bb5
    i32 59, label %sw.bb6
    i32 46, label %sw.bb7
    i32 44, label %sw.bb8
    i32 45, label %sw.bb9
    i32 43, label %sw.bb10
    i32 42, label %sw.bb11
    i32 47, label %sw.bb12
    i32 61, label %sw.bb13
    i32 58, label %sw.bb14
    i32 37, label %sw.bb15
    i32 38, label %sw.bb16
    i32 124, label %sw.bb17
    i32 62, label %sw.bb18
    i32 60, label %sw.bb19
    i32 33, label %sw.bb20
    i32 126, label %sw.bb21
    i32 94, label %sw.bb22
    i32 35, label %sw.bb23
    i32 63, label %sw.bb24
  ]

sw.bb:                                            ; preds = %entry
  br label %return

sw.bb1:                                           ; preds = %entry
  br label %return

sw.bb2:                                           ; preds = %entry
  br label %return

sw.bb3:                                           ; preds = %entry
  br label %return

sw.bb4:                                           ; preds = %entry
  br label %return

sw.bb5:                                           ; preds = %entry
  br label %return

sw.bb6:                                           ; preds = %entry
  br label %return

sw.bb7:                                           ; preds = %entry
  br label %return

sw.bb8:                                           ; preds = %entry
  br label %return

sw.bb9:                                           ; preds = %entry
  br label %return

sw.bb10:                                          ; preds = %entry
  br label %return

sw.bb11:                                          ; preds = %entry
  br label %return

sw.bb12:                                          ; preds = %entry
  br label %return

sw.bb13:                                          ; preds = %entry
  br label %return

sw.bb14:                                          ; preds = %entry
  br label %return

sw.bb15:                                          ; preds = %entry
  br label %return

sw.bb16:                                          ; preds = %entry
  br label %return

sw.bb17:                                          ; preds = %entry
  br label %return

sw.bb18:                                          ; preds = %entry
  br label %return

sw.bb19:                                          ; preds = %entry
  br label %return

sw.bb20:                                          ; preds = %entry
  br label %return

sw.bb21:                                          ; preds = %entry
  br label %return

sw.bb22:                                          ; preds = %entry
  br label %return

sw.bb23:                                          ; preds = %entry
  br label %return

sw.bb24:                                          ; preds = %entry
  br label %return

sw.default:                                       ; preds = %entry
  br label %return

return:                                           ; preds = %sw.default, %sw.bb24, %sw.bb23, %sw.bb22, %sw.bb21, %sw.bb20, %sw.bb19, %sw.bb18, %sw.bb17, %sw.bb16, %sw.bb15, %sw.bb14, %sw.bb13, %sw.bb12, %sw.bb11, %sw.bb10, %sw.bb9, %sw.bb8, %sw.bb7, %sw.bb6, %sw.bb5, %sw.bb4, %sw.bb3, %sw.bb2, %sw.bb1, %sw.bb
  %retval.0 = phi i32 [ 0, %sw.default ], [ 15, %sw.bb24 ], [ 12, %sw.bb23 ], [ 48, %sw.bb22 ], [ 45, %sw.bb21 ], [ 44, %sw.bb20 ], [ 39, %sw.bb19 ], [ 38, %sw.bb18 ], [ 25, %sw.bb17 ], [ 23, %sw.bb16 ], [ 22, %sw.bb15 ], [ 21, %sw.bb14 ], [ 20, %sw.bb13 ], [ 19, %sw.bb12 ], [ 18, %sw.bb11 ], [ 17, %sw.bb10 ], [ 16, %sw.bb9 ], [ 14, %sw.bb8 ], [ 13, %sw.bb7 ], [ 8, %sw.bb6 ], [ 7, %sw.bb5 ], [ 6, %sw.bb4 ], [ 5, %sw.bb3 ], [ 4, %sw.bb2 ], [ 3, %sw.bb1 ], [ 2, %sw.bb ]
  ret i32 %retval.0
}

; Function Attrs: nounwind uwtable
define dso_local i32 @ttype_many_chars(ptr noundef %contents) #0 {
entry:
  %call = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.57) #13
  %tobool = icmp ne i32 %call, 0
  br i1 %tobool, label %if.else, label %if.then

if.then:                                          ; preds = %entry
  br label %return

if.else:                                          ; preds = %entry
  %call1 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.58) #13
  %tobool2 = icmp ne i32 %call1, 0
  br i1 %tobool2, label %if.else4, label %if.then3

if.then3:                                         ; preds = %if.else
  br label %return

if.else4:                                         ; preds = %if.else
  %call5 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.59) #13
  %tobool6 = icmp ne i32 %call5, 0
  br i1 %tobool6, label %if.else8, label %if.then7

if.then7:                                         ; preds = %if.else4
  br label %return

if.else8:                                         ; preds = %if.else4
  %call9 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.60) #13
  %tobool10 = icmp ne i32 %call9, 0
  br i1 %tobool10, label %if.else12, label %if.then11

if.then11:                                        ; preds = %if.else8
  br label %return

if.else12:                                        ; preds = %if.else8
  %call13 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.61) #13
  %tobool14 = icmp ne i32 %call13, 0
  br i1 %tobool14, label %if.else16, label %if.then15

if.then15:                                        ; preds = %if.else12
  br label %return

if.else16:                                        ; preds = %if.else12
  %call17 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.62) #13
  %tobool18 = icmp ne i32 %call17, 0
  br i1 %tobool18, label %if.else20, label %if.then19

if.then19:                                        ; preds = %if.else16
  br label %return

if.else20:                                        ; preds = %if.else16
  %call21 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.63) #13
  %tobool22 = icmp ne i32 %call21, 0
  br i1 %tobool22, label %if.else24, label %if.then23

if.then23:                                        ; preds = %if.else20
  br label %return

if.else24:                                        ; preds = %if.else20
  %call25 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.64) #13
  %tobool26 = icmp ne i32 %call25, 0
  br i1 %tobool26, label %if.else28, label %if.then27

if.then27:                                        ; preds = %if.else24
  br label %return

if.else28:                                        ; preds = %if.else24
  %call29 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.65) #13
  %tobool30 = icmp ne i32 %call29, 0
  br i1 %tobool30, label %if.else32, label %if.then31

if.then31:                                        ; preds = %if.else28
  br label %return

if.else32:                                        ; preds = %if.else28
  %call33 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.66) #13
  %tobool34 = icmp ne i32 %call33, 0
  br i1 %tobool34, label %if.else36, label %if.then35

if.then35:                                        ; preds = %if.else32
  br label %return

if.else36:                                        ; preds = %if.else32
  %call37 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.67) #13
  %tobool38 = icmp ne i32 %call37, 0
  br i1 %tobool38, label %if.else40, label %if.then39

if.then39:                                        ; preds = %if.else36
  br label %return

if.else40:                                        ; preds = %if.else36
  %call41 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.68) #13
  %tobool42 = icmp ne i32 %call41, 0
  br i1 %tobool42, label %if.else44, label %if.then43

if.then43:                                        ; preds = %if.else40
  br label %return

if.else44:                                        ; preds = %if.else40
  %call45 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.69) #13
  %tobool46 = icmp ne i32 %call45, 0
  br i1 %tobool46, label %if.else48, label %if.then47

if.then47:                                        ; preds = %if.else44
  br label %return

if.else48:                                        ; preds = %if.else44
  %call49 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.70) #13
  %tobool50 = icmp ne i32 %call49, 0
  br i1 %tobool50, label %if.else52, label %if.then51

if.then51:                                        ; preds = %if.else48
  br label %return

if.else52:                                        ; preds = %if.else48
  %call53 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.71) #13
  %tobool54 = icmp ne i32 %call53, 0
  br i1 %tobool54, label %if.else56, label %if.then55

if.then55:                                        ; preds = %if.else52
  br label %return

if.else56:                                        ; preds = %if.else52
  %call57 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.72) #13
  %tobool58 = icmp ne i32 %call57, 0
  br i1 %tobool58, label %if.else60, label %if.then59

if.then59:                                        ; preds = %if.else56
  br label %return

if.else60:                                        ; preds = %if.else56
  %call61 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.73) #13
  %tobool62 = icmp ne i32 %call61, 0
  br i1 %tobool62, label %if.else64, label %if.then63

if.then63:                                        ; preds = %if.else60
  br label %return

if.else64:                                        ; preds = %if.else60
  %call65 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.74) #13
  %tobool66 = icmp ne i32 %call65, 0
  br i1 %tobool66, label %if.else68, label %if.then67

if.then67:                                        ; preds = %if.else64
  br label %return

if.else68:                                        ; preds = %if.else64
  %call69 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.75) #13
  %tobool70 = icmp ne i32 %call69, 0
  br i1 %tobool70, label %if.else72, label %if.then71

if.then71:                                        ; preds = %if.else68
  br label %return

if.else72:                                        ; preds = %if.else68
  %call73 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.76) #13
  %tobool74 = icmp ne i32 %call73, 0
  br i1 %tobool74, label %if.else76, label %if.then75

if.then75:                                        ; preds = %if.else72
  br label %return

if.else76:                                        ; preds = %if.else72
  %call77 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.77) #13
  %tobool78 = icmp ne i32 %call77, 0
  br i1 %tobool78, label %if.else80, label %if.then79

if.then79:                                        ; preds = %if.else76
  br label %return

if.else80:                                        ; preds = %if.else76
  %call81 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.78) #13
  %tobool82 = icmp ne i32 %call81, 0
  br i1 %tobool82, label %if.else84, label %if.then83

if.then83:                                        ; preds = %if.else80
  br label %return

if.else84:                                        ; preds = %if.else80
  %call85 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.79) #13
  %tobool86 = icmp ne i32 %call85, 0
  br i1 %tobool86, label %if.else88, label %if.then87

if.then87:                                        ; preds = %if.else84
  br label %return

if.else88:                                        ; preds = %if.else84
  %call89 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.80) #13
  %tobool90 = icmp ne i32 %call89, 0
  br i1 %tobool90, label %if.else92, label %if.then91

if.then91:                                        ; preds = %if.else88
  br label %return

if.else92:                                        ; preds = %if.else88
  %call93 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.81) #13
  %tobool94 = icmp ne i32 %call93, 0
  br i1 %tobool94, label %if.else96, label %if.then95

if.then95:                                        ; preds = %if.else92
  br label %return

if.else96:                                        ; preds = %if.else92
  %call97 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.82) #13
  %tobool98 = icmp ne i32 %call97, 0
  br i1 %tobool98, label %if.else100, label %if.then99

if.then99:                                        ; preds = %if.else96
  br label %return

if.else100:                                       ; preds = %if.else96
  %call101 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.83) #13
  %tobool102 = icmp ne i32 %call101, 0
  br i1 %tobool102, label %if.else104, label %if.then103

if.then103:                                       ; preds = %if.else100
  br label %return

if.else104:                                       ; preds = %if.else100
  %call105 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.84) #13
  %tobool106 = icmp ne i32 %call105, 0
  br i1 %tobool106, label %if.else108, label %if.then107

if.then107:                                       ; preds = %if.else104
  br label %return

if.else108:                                       ; preds = %if.else104
  %call109 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.85) #13
  %tobool110 = icmp ne i32 %call109, 0
  br i1 %tobool110, label %if.else112, label %if.then111

if.then111:                                       ; preds = %if.else108
  br label %return

if.else112:                                       ; preds = %if.else108
  %call113 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.86) #13
  %tobool114 = icmp ne i32 %call113, 0
  br i1 %tobool114, label %if.else116, label %if.then115

if.then115:                                       ; preds = %if.else112
  br label %return

if.else116:                                       ; preds = %if.else112
  %call117 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.87) #13
  %tobool118 = icmp ne i32 %call117, 0
  br i1 %tobool118, label %if.else120, label %if.then119

if.then119:                                       ; preds = %if.else116
  br label %return

if.else120:                                       ; preds = %if.else116
  %call121 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.88) #13
  %tobool122 = icmp ne i32 %call121, 0
  br i1 %tobool122, label %if.else124, label %if.then123

if.then123:                                       ; preds = %if.else120
  br label %return

if.else124:                                       ; preds = %if.else120
  %call125 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.19) #13
  %tobool126 = icmp ne i32 %call125, 0
  br i1 %tobool126, label %if.else128, label %if.then127

if.then127:                                       ; preds = %if.else124
  br label %return

if.else128:                                       ; preds = %if.else124
  %call129 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.21) #13
  %tobool130 = icmp ne i32 %call129, 0
  br i1 %tobool130, label %if.else132, label %if.then131

if.then131:                                       ; preds = %if.else128
  br label %return

if.else132:                                       ; preds = %if.else128
  %call133 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.22) #13
  %tobool134 = icmp ne i32 %call133, 0
  br i1 %tobool134, label %if.else136, label %if.then135

if.then135:                                       ; preds = %if.else132
  br label %return

if.else136:                                       ; preds = %if.else132
  %call137 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.23) #13
  %tobool138 = icmp ne i32 %call137, 0
  br i1 %tobool138, label %if.else140, label %if.then139

if.then139:                                       ; preds = %if.else136
  br label %return

if.else140:                                       ; preds = %if.else136
  %call141 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.24) #13
  %tobool142 = icmp ne i32 %call141, 0
  br i1 %tobool142, label %if.else144, label %if.then143

if.then143:                                       ; preds = %if.else140
  br label %return

if.else144:                                       ; preds = %if.else140
  %call145 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.25) #13
  %tobool146 = icmp ne i32 %call145, 0
  br i1 %tobool146, label %if.else148, label %if.then147

if.then147:                                       ; preds = %if.else144
  br label %return

if.else148:                                       ; preds = %if.else144
  %call149 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.26) #13
  %tobool150 = icmp ne i32 %call149, 0
  br i1 %tobool150, label %if.else152, label %if.then151

if.then151:                                       ; preds = %if.else148
  br label %return

if.else152:                                       ; preds = %if.else148
  %call153 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.27) #13
  %tobool154 = icmp ne i32 %call153, 0
  br i1 %tobool154, label %if.else156, label %if.then155

if.then155:                                       ; preds = %if.else152
  br label %return

if.else156:                                       ; preds = %if.else152
  %call157 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.28) #13
  %tobool158 = icmp ne i32 %call157, 0
  br i1 %tobool158, label %if.else160, label %if.then159

if.then159:                                       ; preds = %if.else156
  br label %return

if.else160:                                       ; preds = %if.else156
  %call161 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.29) #13
  %tobool162 = icmp ne i32 %call161, 0
  br i1 %tobool162, label %if.else164, label %if.then163

if.then163:                                       ; preds = %if.else160
  br label %return

if.else164:                                       ; preds = %if.else160
  %call165 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.30) #13
  %tobool166 = icmp ne i32 %call165, 0
  br i1 %tobool166, label %if.else168, label %if.then167

if.then167:                                       ; preds = %if.else164
  br label %return

if.else168:                                       ; preds = %if.else164
  %call169 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.31) #13
  %tobool170 = icmp ne i32 %call169, 0
  br i1 %tobool170, label %if.else172, label %if.then171

if.then171:                                       ; preds = %if.else168
  br label %return

if.else172:                                       ; preds = %if.else168
  %call173 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.32) #13
  %tobool174 = icmp ne i32 %call173, 0
  br i1 %tobool174, label %if.else176, label %if.then175

if.then175:                                       ; preds = %if.else172
  br label %return

if.else176:                                       ; preds = %if.else172
  %call177 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.35) #13
  %tobool178 = icmp ne i32 %call177, 0
  br i1 %tobool178, label %if.else180, label %if.then179

if.then179:                                       ; preds = %if.else176
  br label %return

if.else180:                                       ; preds = %if.else176
  %call181 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.36) #13
  %tobool182 = icmp ne i32 %call181, 0
  br i1 %tobool182, label %if.else184, label %if.then183

if.then183:                                       ; preds = %if.else180
  br label %return

if.else184:                                       ; preds = %if.else180
  %call185 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.37) #13
  %tobool186 = icmp ne i32 %call185, 0
  br i1 %tobool186, label %if.else188, label %if.then187

if.then187:                                       ; preds = %if.else184
  br label %return

if.else188:                                       ; preds = %if.else184
  %call189 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.38) #13
  %tobool190 = icmp ne i32 %call189, 0
  br i1 %tobool190, label %if.else192, label %if.then191

if.then191:                                       ; preds = %if.else188
  br label %return

if.else192:                                       ; preds = %if.else188
  %call193 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.40) #13
  %tobool194 = icmp ne i32 %call193, 0
  br i1 %tobool194, label %if.else196, label %if.then195

if.then195:                                       ; preds = %if.else192
  br label %return

if.else196:                                       ; preds = %if.else192
  %call197 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.43) #13
  %tobool198 = icmp ne i32 %call197, 0
  br i1 %tobool198, label %if.else200, label %if.then199

if.then199:                                       ; preds = %if.else196
  br label %return

if.else200:                                       ; preds = %if.else196
  %call201 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.44) #13
  %tobool202 = icmp ne i32 %call201, 0
  br i1 %tobool202, label %if.else204, label %if.then203

if.then203:                                       ; preds = %if.else200
  br label %return

if.else204:                                       ; preds = %if.else200
  %call205 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.45) #13
  %tobool206 = icmp ne i32 %call205, 0
  br i1 %tobool206, label %if.else208, label %if.then207

if.then207:                                       ; preds = %if.else204
  br label %return

if.else208:                                       ; preds = %if.else204
  %call209 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.46) #13
  %tobool210 = icmp ne i32 %call209, 0
  br i1 %tobool210, label %if.else212, label %if.then211

if.then211:                                       ; preds = %if.else208
  br label %return

if.else212:                                       ; preds = %if.else208
  %call213 = call i32 @strcmp(ptr noundef %contents, ptr noundef @.str.41) #13
  %tobool214 = icmp ne i32 %call213, 0
  br i1 %tobool214, label %if.end, label %if.then215

if.then215:                                       ; preds = %if.else212
  br label %return

if.end:                                           ; preds = %if.else212
  br label %if.end216

if.end216:                                        ; preds = %if.end
  br label %if.end217

if.end217:                                        ; preds = %if.end216
  br label %if.end218

if.end218:                                        ; preds = %if.end217
  br label %if.end219

if.end219:                                        ; preds = %if.end218
  br label %if.end220

if.end220:                                        ; preds = %if.end219
  br label %if.end221

if.end221:                                        ; preds = %if.end220
  br label %if.end222

if.end222:                                        ; preds = %if.end221
  br label %if.end223

if.end223:                                        ; preds = %if.end222
  br label %if.end224

if.end224:                                        ; preds = %if.end223
  br label %if.end225

if.end225:                                        ; preds = %if.end224
  br label %if.end226

if.end226:                                        ; preds = %if.end225
  br label %if.end227

if.end227:                                        ; preds = %if.end226
  br label %if.end228

if.end228:                                        ; preds = %if.end227
  br label %if.end229

if.end229:                                        ; preds = %if.end228
  br label %if.end230

if.end230:                                        ; preds = %if.end229
  br label %if.end231

if.end231:                                        ; preds = %if.end230
  br label %if.end232

if.end232:                                        ; preds = %if.end231
  br label %if.end233

if.end233:                                        ; preds = %if.end232
  br label %if.end234

if.end234:                                        ; preds = %if.end233
  br label %if.end235

if.end235:                                        ; preds = %if.end234
  br label %if.end236

if.end236:                                        ; preds = %if.end235
  br label %if.end237

if.end237:                                        ; preds = %if.end236
  br label %if.end238

if.end238:                                        ; preds = %if.end237
  br label %if.end239

if.end239:                                        ; preds = %if.end238
  br label %if.end240

if.end240:                                        ; preds = %if.end239
  br label %if.end241

if.end241:                                        ; preds = %if.end240
  br label %if.end242

if.end242:                                        ; preds = %if.end241
  br label %if.end243

if.end243:                                        ; preds = %if.end242
  br label %if.end244

if.end244:                                        ; preds = %if.end243
  br label %if.end245

if.end245:                                        ; preds = %if.end244
  br label %if.end246

if.end246:                                        ; preds = %if.end245
  br label %if.end247

if.end247:                                        ; preds = %if.end246
  br label %if.end248

if.end248:                                        ; preds = %if.end247
  br label %if.end249

if.end249:                                        ; preds = %if.end248
  br label %if.end250

if.end250:                                        ; preds = %if.end249
  br label %if.end251

if.end251:                                        ; preds = %if.end250
  br label %if.end252

if.end252:                                        ; preds = %if.end251
  br label %if.end253

if.end253:                                        ; preds = %if.end252
  br label %if.end254

if.end254:                                        ; preds = %if.end253
  br label %if.end255

if.end255:                                        ; preds = %if.end254
  br label %if.end256

if.end256:                                        ; preds = %if.end255
  br label %if.end257

if.end257:                                        ; preds = %if.end256
  br label %if.end258

if.end258:                                        ; preds = %if.end257
  br label %if.end259

if.end259:                                        ; preds = %if.end258
  br label %if.end260

if.end260:                                        ; preds = %if.end259
  br label %if.end261

if.end261:                                        ; preds = %if.end260
  br label %if.end262

if.end262:                                        ; preds = %if.end261
  br label %if.end263

if.end263:                                        ; preds = %if.end262
  br label %if.end264

if.end264:                                        ; preds = %if.end263
  br label %if.end265

if.end265:                                        ; preds = %if.end264
  br label %if.end266

if.end266:                                        ; preds = %if.end265
  br label %if.end267

if.end267:                                        ; preds = %if.end266
  br label %if.end268

if.end268:                                        ; preds = %if.end267
  br label %if.end269

if.end269:                                        ; preds = %if.end268
  %cmp = icmp eq ptr %contents, null
  br i1 %cmp, label %if.then270, label %if.end271

if.then270:                                       ; preds = %if.end269
  br label %cleanup330

if.end271:                                        ; preds = %if.end269
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.end271
  %i.0 = phi i32 [ 0, %if.end271 ], [ %inc312, %for.inc ]
  %count_us.0 = phi i32 [ 0, %if.end271 ], [ %count_us.2, %for.inc ]
  %count_fs.0 = phi i32 [ 0, %if.end271 ], [ %count_fs.2, %for.inc ]
  %all_numeric.0 = phi i32 [ 1, %if.end271 ], [ %all_numeric.2, %for.inc ]
  %retval.0 = phi i32 [ undef, %if.end271 ], [ %retval.1, %for.inc ]
  %idxprom = sext i32 %i.0 to i64
  %arrayidx = getelementptr inbounds i8, ptr %contents, i64 %idxprom
  %0 = load i8, ptr %arrayidx, align 1, !tbaa !12
  %conv = zext i8 %0 to i32
  %cmp272 = icmp ne i32 %conv, 0
  br i1 %cmp272, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %idxprom274 = sext i32 %i.0 to i64
  %arrayidx275 = getelementptr inbounds i8, ptr %contents, i64 %idxprom274
  %1 = load i8, ptr %arrayidx275, align 1, !tbaa !12
  %conv276 = zext i8 %1 to i32
  %cmp277 = icmp eq i32 %conv276, 46
  br i1 %cmp277, label %if.then279, label %if.end280

if.then279:                                       ; preds = %for.body
  br label %cleanup

if.end280:                                        ; preds = %for.body
  %conv281 = zext i8 %1 to i32
  %cmp282 = icmp eq i32 %conv281, 102
  br i1 %cmp282, label %if.then284, label %if.end285

if.then284:                                       ; preds = %if.end280
  %inc = add nsw i32 %count_fs.0, 1
  br label %if.end285

if.end285:                                        ; preds = %if.then284, %if.end280
  %count_fs.1 = phi i32 [ %inc, %if.then284 ], [ %count_fs.0, %if.end280 ]
  %conv286 = zext i8 %1 to i32
  %cmp287 = icmp eq i32 %conv286, 117
  br i1 %cmp287, label %if.then289, label %if.end291

if.then289:                                       ; preds = %if.end285
  %inc290 = add nsw i32 %count_us.0, 1
  br label %if.end291

if.end291:                                        ; preds = %if.then289, %if.end285
  %count_us.1 = phi i32 [ %inc290, %if.then289 ], [ %count_us.0, %if.end285 ]
  %conv292 = zext i8 %1 to i32
  %cmp293 = icmp sgt i32 %conv292, 57
  br i1 %cmp293, label %land.lhs.true, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %if.end291
  %conv295 = zext i8 %1 to i32
  %cmp296 = icmp slt i32 %conv295, 48
  br i1 %cmp296, label %land.lhs.true, label %if.end302

land.lhs.true:                                    ; preds = %lor.lhs.false, %if.end291
  %conv298 = zext i8 %1 to i32
  %cmp299 = icmp ne i32 %conv298, 117
  br i1 %cmp299, label %if.then301, label %if.end302

if.then301:                                       ; preds = %land.lhs.true
  br label %if.end302

if.end302:                                        ; preds = %if.then301, %land.lhs.true, %lor.lhs.false
  %all_numeric.1 = phi i32 [ 0, %if.then301 ], [ %all_numeric.0, %land.lhs.true ], [ %all_numeric.0, %lor.lhs.false ]
  %conv303 = zext i8 %1 to i32
  %cmp304 = icmp eq i32 %conv303, 39
  br i1 %cmp304, label %if.then310, label %lor.lhs.false306

lor.lhs.false306:                                 ; preds = %if.end302
  %conv307 = zext i8 %1 to i32
  %cmp308 = icmp eq i32 %conv307, 34
  br i1 %cmp308, label %if.then310, label %if.end311

if.then310:                                       ; preds = %lor.lhs.false306, %if.end302
  br label %cleanup

if.end311:                                        ; preds = %lor.lhs.false306
  br label %cleanup

cleanup:                                          ; preds = %if.end311, %if.then310, %if.then279
  %count_us.2 = phi i32 [ %count_us.0, %if.then279 ], [ %count_us.1, %if.then310 ], [ %count_us.1, %if.end311 ]
  %count_fs.2 = phi i32 [ %count_fs.0, %if.then279 ], [ %count_fs.1, %if.then310 ], [ %count_fs.1, %if.end311 ]
  %all_numeric.2 = phi i32 [ %all_numeric.0, %if.then279 ], [ %all_numeric.1, %if.then310 ], [ %all_numeric.1, %if.end311 ]
  %cleanup.dest.slot.0 = phi i32 [ 1, %if.then279 ], [ 1, %if.then310 ], [ 0, %if.end311 ]
  %retval.1 = phi i32 [ 0, %if.then279 ], [ 0, %if.then310 ], [ %retval.0, %if.end311 ]
  switch i32 %cleanup.dest.slot.0, label %cleanup330 [
    i32 0, label %cleanup.cont
  ]

cleanup.cont:                                     ; preds = %cleanup
  br label %for.inc

for.inc:                                          ; preds = %cleanup.cont
  %inc312 = add nsw i32 %i.0, 1
  br label %for.cond, !llvm.loop !34

for.end:                                          ; preds = %for.cond
  %tobool313 = icmp ne i32 %all_numeric.0, 0
  br i1 %tobool313, label %if.then314, label %if.end329

if.then314:                                       ; preds = %for.end
  %cmp315 = icmp eq i32 %count_us.0, 1
  br i1 %cmp315, label %land.lhs.true317, label %if.end324

land.lhs.true317:                                 ; preds = %if.then314
  %sub = sub nsw i32 %i.0, 1
  %idxprom318 = sext i32 %sub to i64
  %arrayidx319 = getelementptr inbounds i8, ptr %contents, i64 %idxprom318
  %2 = load i8, ptr %arrayidx319, align 1, !tbaa !12
  %conv320 = zext i8 %2 to i32
  %cmp321 = icmp eq i32 %conv320, 117
  br i1 %cmp321, label %if.then323, label %if.end324

if.then323:                                       ; preds = %land.lhs.true317
  br label %cleanup330

if.end324:                                        ; preds = %land.lhs.true317, %if.then314
  %cmp325 = icmp eq i32 %count_us.0, 0
  br i1 %cmp325, label %if.then327, label %if.end328

if.then327:                                       ; preds = %if.end324
  br label %cleanup330

if.end328:                                        ; preds = %if.end324
  br label %if.end329

if.end329:                                        ; preds = %if.end328, %for.end
  br label %cleanup330

cleanup330:                                       ; preds = %if.end329, %if.then327, %if.then323, %cleanup, %if.then270
  %retval.2 = phi i32 [ 9, %if.then270 ], [ %retval.1, %cleanup ], [ 0, %if.then323 ], [ 0, %if.then327 ], [ 1, %if.end329 ]
  br label %return

return:                                           ; preds = %cleanup330, %if.then215, %if.then211, %if.then207, %if.then203, %if.then199, %if.then195, %if.then191, %if.then187, %if.then183, %if.then179, %if.then175, %if.then171, %if.then167, %if.then163, %if.then159, %if.then155, %if.then151, %if.then147, %if.then143, %if.then139, %if.then135, %if.then131, %if.then127, %if.then123, %if.then119, %if.then115, %if.then111, %if.then107, %if.then103, %if.then99, %if.then95, %if.then91, %if.then87, %if.then83, %if.then79, %if.then75, %if.then71, %if.then67, %if.then63, %if.then59, %if.then55, %if.then51, %if.then47, %if.then43, %if.then39, %if.then35, %if.then31, %if.then27, %if.then23, %if.then19, %if.then15, %if.then11, %if.then7, %if.then3, %if.then
  %retval.3 = phi i32 [ %retval.2, %cleanup330 ], [ 47, %if.then215 ], [ 52, %if.then211 ], [ 51, %if.then207 ], [ 50, %if.then203 ], [ 49, %if.then199 ], [ 46, %if.then195 ], [ 43, %if.then191 ], [ 42, %if.then187 ], [ 41, %if.then183 ], [ 40, %if.then179 ], [ 37, %if.then175 ], [ 36, %if.then171 ], [ 35, %if.then167 ], [ 34, %if.then163 ], [ 33, %if.then159 ], [ 32, %if.then155 ], [ 31, %if.then151 ], [ 30, %if.then147 ], [ 29, %if.then143 ], [ 28, %if.then139 ], [ 27, %if.then135 ], [ 26, %if.then131 ], [ 24, %if.then127 ], [ 84, %if.then123 ], [ 83, %if.then119 ], [ 82, %if.then115 ], [ 80, %if.then111 ], [ 81, %if.then107 ], [ 79, %if.then103 ], [ 74, %if.then99 ], [ 75, %if.then95 ], [ 73, %if.then91 ], [ 78, %if.then87 ], [ 76, %if.then83 ], [ 77, %if.then79 ], [ 72, %if.then75 ], [ 71, %if.then71 ], [ 70, %if.then67 ], [ 68, %if.then63 ], [ 69, %if.then59 ], [ 67, %if.then55 ], [ 66, %if.then51 ], [ 65, %if.then47 ], [ 64, %if.then43 ], [ 63, %if.then39 ], [ 62, %if.then35 ], [ 61, %if.then31 ], [ 59, %if.then27 ], [ 60, %if.then23 ], [ 55, %if.then19 ], [ 57, %if.then15 ], [ 56, %if.then11 ], [ 58, %if.then7 ], [ 54, %if.then3 ], [ 53, %if.then ]
  ret i32 %retval.3
}

; Function Attrs: nounwind uwtable
define dso_local i32 @ttype_from_string(ptr noundef %contents) #0 {
entry:
  %call = call i64 @strlen(ptr noundef %contents) #13
  %conv = trunc i64 %call to i32
  %cmp = icmp eq i32 %conv, 1
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %arrayidx = getelementptr inbounds i8, ptr %contents, i64 0
  %0 = load i8, ptr %arrayidx, align 1, !tbaa !12
  %call2 = call i32 @ttype_one_char(i8 noundef %0)
  br label %cleanup

if.end:                                           ; preds = %entry
  %call3 = call i32 @ttype_many_chars(ptr noundef %contents)
  br label %cleanup

cleanup:                                          ; preds = %if.end, %if.then
  %retval.0 = phi i32 [ %call2, %if.then ], [ %call3, %if.end ]
  ret i32 %retval.0
}

; Function Attrs: nounwind uwtable
define dso_local i32 @unlex(ptr noundef %l, ptr noundef %t) #0 {
entry:
  %unlexed_count = getelementptr inbounds %struct.Lexer, ptr %l, i32 0, i32 8
  %0 = load i32, ptr %unlexed_count, align 4, !tbaa !27
  %cmp = icmp uge i32 %0, 5
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  br label %do.body

do.body:                                          ; preds = %if.then
  %1 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %1, ptr noundef @.str.49, i32 noundef 31)
  %2 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call1 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %2, ptr noundef @.str.56, i32 noundef 5)
  %3 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call2 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %3, ptr noundef @.str.51)
  br label %do.end

do.end:                                           ; preds = %do.body
  br label %return

if.end:                                           ; preds = %entry
  %unlexed = getelementptr inbounds %struct.Lexer, ptr %l, i32 0, i32 7
  %unlexed_count3 = getelementptr inbounds %struct.Lexer, ptr %l, i32 0, i32 8
  %4 = load i32, ptr %unlexed_count3, align 4, !tbaa !27
  %idxprom = zext i32 %4 to i64
  %arrayidx = getelementptr inbounds [5 x %struct.Token], ptr %unlexed, i64 0, i64 %idxprom
  call void @llvm.memcpy.p0.p0.i64(ptr align 4 %arrayidx, ptr align 4 %t, i64 528, i1 false)
  %unlexed_count4 = getelementptr inbounds %struct.Lexer, ptr %l, i32 0, i32 8
  %5 = load i32, ptr %unlexed_count4, align 4, !tbaa !27
  %inc = add i32 %5, 1
  store i32 %inc, ptr %unlexed_count4, align 4, !tbaa !27
  br label %return

return:                                           ; preds = %if.end, %do.end
  %retval.0 = phi i32 [ -1, %do.end ], [ 0, %if.end ]
  ret i32 %retval.0
}

; Function Attrs: nounwind uwtable
define dso_local ptr @ttype_name(i32 noundef %tt) #0 {
entry:
  %idxprom = zext i32 %tt to i64
  %arrayidx = getelementptr inbounds [85 x ptr], ptr @ttype_names, i64 0, i64 %idxprom
  %0 = load ptr, ptr %arrayidx, align 8, !tbaa !10
  ret ptr %0
}

; Function Attrs: nounwind uwtable
define dso_local i32 @test_ttype_many_chars() #0 {
entry:
  call void @testing_single_test_internal(ptr noundef @__func__.test_ttype_many_chars)
  %call = call i32 @ttype_many_chars(ptr noundef @.str.89)
  %cmp = icmp eq i32 %call, 1
  br i1 %cmp, label %cond.true, label %cond.false

cond.true:                                        ; preds = %entry
  br label %cond.end

cond.false:                                       ; preds = %entry
  %call1 = call i32 (ptr, ...) @printf(ptr noundef @.str.4, ptr noundef @.str.48, i32 noundef 659, ptr noundef @.str.90)
  br label %cond.end

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi i32 [ 0, %cond.true ], [ 0, %cond.false ]
  %call2 = call i32 @ttype_many_chars(ptr noundef @.str.77)
  %cmp3 = icmp eq i32 %call2, 77
  br i1 %cmp3, label %cond.true4, label %cond.false5

cond.true4:                                       ; preds = %cond.end
  br label %cond.end7

cond.false5:                                      ; preds = %cond.end
  %call6 = call i32 (ptr, ...) @printf(ptr noundef @.str.4, ptr noundef @.str.48, i32 noundef 660, ptr noundef @.str.91)
  br label %cond.end7

cond.end7:                                        ; preds = %cond.false5, %cond.true4
  %cond8 = phi i32 [ 0, %cond.true4 ], [ 0, %cond.false5 ]
  %call9 = call i32 @ttype_many_chars(ptr noundef @.str.88)
  %cmp10 = icmp eq i32 %call9, 84
  br i1 %cmp10, label %cond.true11, label %cond.false12

cond.true11:                                      ; preds = %cond.end7
  br label %cond.end14

cond.false12:                                     ; preds = %cond.end7
  %call13 = call i32 (ptr, ...) @printf(ptr noundef @.str.4, ptr noundef @.str.48, i32 noundef 661, ptr noundef @.str.92)
  br label %cond.end14

cond.end14:                                       ; preds = %cond.false12, %cond.true11
  %cond15 = phi i32 [ 0, %cond.true11 ], [ 0, %cond.false12 ]
  ret i32 0
}

; Function Attrs: nounwind uwtable
define dso_local i32 @test_ttype_one_char() #0 {
entry:
  call void @testing_single_test_internal(ptr noundef @__func__.test_ttype_one_char)
  %call = call i32 @ttype_one_char(i8 noundef 97)
  %cmp = icmp eq i32 %call, 1
  br i1 %cmp, label %cond.true, label %cond.false

cond.true:                                        ; preds = %entry
  br label %cond.end

cond.false:                                       ; preds = %entry
  %call1 = call i32 (ptr, ...) @printf(ptr noundef @.str.4, ptr noundef @.str.48, i32 noundef 670, ptr noundef @.str.93)
  br label %cond.end

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi i32 [ 0, %cond.true ], [ 0, %cond.false ]
  %call2 = call i32 @ttype_one_char(i8 noundef 49)
  %cmp3 = icmp eq i32 %call2, 0
  br i1 %cmp3, label %cond.true4, label %cond.false5

cond.true4:                                       ; preds = %cond.end
  br label %cond.end7

cond.false5:                                      ; preds = %cond.end
  %call6 = call i32 (ptr, ...) @printf(ptr noundef @.str.4, ptr noundef @.str.48, i32 noundef 671, ptr noundef @.str.94)
  br label %cond.end7

cond.end7:                                        ; preds = %cond.false5, %cond.true4
  %cond8 = phi i32 [ 0, %cond.true4 ], [ 0, %cond.false5 ]
  %call9 = call i32 @ttype_one_char(i8 noundef 43)
  %cmp10 = icmp eq i32 %call9, 17
  br i1 %cmp10, label %cond.true11, label %cond.false12

cond.true11:                                      ; preds = %cond.end7
  br label %cond.end14

cond.false12:                                     ; preds = %cond.end7
  %call13 = call i32 (ptr, ...) @printf(ptr noundef @.str.4, ptr noundef @.str.48, i32 noundef 673, ptr noundef @.str.95)
  br label %cond.end14

cond.end14:                                       ; preds = %cond.false12, %cond.true11
  %cond15 = phi i32 [ 0, %cond.true11 ], [ 0, %cond.false12 ]
  %call16 = call i32 @ttype_one_char(i8 noundef 45)
  %cmp17 = icmp eq i32 %call16, 16
  br i1 %cmp17, label %cond.true18, label %cond.false19

cond.true18:                                      ; preds = %cond.end14
  br label %cond.end21

cond.false19:                                     ; preds = %cond.end14
  %call20 = call i32 (ptr, ...) @printf(ptr noundef @.str.4, ptr noundef @.str.48, i32 noundef 674, ptr noundef @.str.96)
  br label %cond.end21

cond.end21:                                       ; preds = %cond.false19, %cond.true18
  %cond22 = phi i32 [ 0, %cond.true18 ], [ 0, %cond.false19 ]
  %call23 = call i32 @ttype_one_char(i8 noundef 62)
  %cmp24 = icmp eq i32 %call23, 38
  br i1 %cmp24, label %cond.true25, label %cond.false26

cond.true25:                                      ; preds = %cond.end21
  br label %cond.end28

cond.false26:                                     ; preds = %cond.end21
  %call27 = call i32 (ptr, ...) @printf(ptr noundef @.str.4, ptr noundef @.str.48, i32 noundef 675, ptr noundef @.str.97)
  br label %cond.end28

cond.end28:                                       ; preds = %cond.false26, %cond.true25
  %cond29 = phi i32 [ 0, %cond.true25 ], [ 0, %cond.false26 ]
  %call30 = call i32 @ttype_one_char(i8 noundef 126)
  %cmp31 = icmp eq i32 %call30, 45
  br i1 %cmp31, label %cond.true32, label %cond.false33

cond.true32:                                      ; preds = %cond.end28
  br label %cond.end35

cond.false33:                                     ; preds = %cond.end28
  %call34 = call i32 (ptr, ...) @printf(ptr noundef @.str.4, ptr noundef @.str.48, i32 noundef 676, ptr noundef @.str.98)
  br label %cond.end35

cond.end35:                                       ; preds = %cond.false33, %cond.true32
  %cond36 = phi i32 [ 0, %cond.true32 ], [ 0, %cond.false33 ]
  ret i32 0
}

; Function Attrs: nounwind uwtable
define dso_local i32 @test_ttype_name() #0 {
entry:
  call void @testing_single_test_internal(ptr noundef @__func__.test_ttype_name)
  %call = call ptr @ttype_name(i32 noundef 0)
  %call1 = call i32 @strcmp(ptr noundef %call, ptr noundef @.str.99) #13
  %cmp = icmp eq i32 %call1, 0
  br i1 %cmp, label %cond.true, label %cond.false

cond.true:                                        ; preds = %entry
  br label %cond.end

cond.false:                                       ; preds = %entry
  %call2 = call i32 (ptr, ...) @printf(ptr noundef @.str.4, ptr noundef @.str.48, i32 noundef 684, ptr noundef @.str.100)
  br label %cond.end

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi i32 [ 0, %cond.true ], [ 0, %cond.false ]
  %call3 = call ptr @ttype_name(i32 noundef 17)
  %call4 = call i32 @strcmp(ptr noundef %call3, ptr noundef @.str.12) #13
  %cmp5 = icmp eq i32 %call4, 0
  br i1 %cmp5, label %cond.true6, label %cond.false7

cond.true6:                                       ; preds = %cond.end
  br label %cond.end9

cond.false7:                                      ; preds = %cond.end
  %call8 = call i32 (ptr, ...) @printf(ptr noundef @.str.4, ptr noundef @.str.48, i32 noundef 685, ptr noundef @.str.101)
  br label %cond.end9

cond.end9:                                        ; preds = %cond.false7, %cond.true6
  %cond10 = phi i32 [ 0, %cond.true6 ], [ 0, %cond.false7 ]
  %call11 = call ptr @ttype_name(i32 noundef 78)
  %call12 = call i32 @strcmp(ptr noundef %call11, ptr noundef @.str.79) #13
  %cmp13 = icmp eq i32 %call12, 0
  br i1 %cmp13, label %cond.true14, label %cond.false15

cond.true14:                                      ; preds = %cond.end9
  br label %cond.end17

cond.false15:                                     ; preds = %cond.end9
  %call16 = call i32 (ptr, ...) @printf(ptr noundef @.str.4, ptr noundef @.str.48, i32 noundef 686, ptr noundef @.str.102)
  br label %cond.end17

cond.end17:                                       ; preds = %cond.false15, %cond.true14
  %cond18 = phi i32 [ 0, %cond.true14 ], [ 0, %cond.false15 ]
  %call19 = call ptr @ttype_name(i32 noundef 84)
  %call20 = call i32 @strcmp(ptr noundef %call19, ptr noundef @.str.88) #13
  %cmp21 = icmp eq i32 %call20, 0
  br i1 %cmp21, label %cond.true22, label %cond.false23

cond.true22:                                      ; preds = %cond.end17
  br label %cond.end25

cond.false23:                                     ; preds = %cond.end17
  %call24 = call i32 (ptr, ...) @printf(ptr noundef @.str.4, ptr noundef @.str.48, i32 noundef 687, ptr noundef @.str.103)
  br label %cond.end25

cond.end25:                                       ; preds = %cond.false23, %cond.true22
  %cond26 = phi i32 [ 0, %cond.true22 ], [ 0, %cond.false23 ]
  ret i32 0
}

; Function Attrs: nounwind uwtable
define dso_local i32 @test_ttype_from_string() #0 {
entry:
  call void @testing_single_test_internal(ptr noundef @__func__.test_ttype_from_string)
  %call = call i32 @ttype_from_string(ptr noundef @.str.12)
  %cmp = icmp eq i32 %call, 17
  br i1 %cmp, label %cond.true, label %cond.false

cond.true:                                        ; preds = %entry
  br label %cond.end

cond.false:                                       ; preds = %entry
  %call1 = call i32 (ptr, ...) @printf(ptr noundef @.str.4, ptr noundef @.str.48, i32 noundef 695, ptr noundef @.str.104)
  br label %cond.end

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi i32 [ 0, %cond.true ], [ 0, %cond.false ]
  %call2 = call i32 @ttype_from_string(ptr noundef @.str.15)
  %cmp3 = icmp eq i32 %call2, 20
  br i1 %cmp3, label %cond.true4, label %cond.false5

cond.true4:                                       ; preds = %cond.end
  br label %cond.end7

cond.false5:                                      ; preds = %cond.end
  %call6 = call i32 (ptr, ...) @printf(ptr noundef @.str.4, ptr noundef @.str.48, i32 noundef 696, ptr noundef @.str.105)
  br label %cond.end7

cond.end7:                                        ; preds = %cond.false5, %cond.true4
  %cond8 = phi i32 [ 0, %cond.true4 ], [ 0, %cond.false5 ]
  %call9 = call i32 @ttype_from_string(ptr noundef @.str.106)
  %cmp10 = icmp eq i32 %call9, 0
  br i1 %cmp10, label %cond.true11, label %cond.false12

cond.true11:                                      ; preds = %cond.end7
  br label %cond.end14

cond.false12:                                     ; preds = %cond.end7
  %call13 = call i32 (ptr, ...) @printf(ptr noundef @.str.4, ptr noundef @.str.48, i32 noundef 698, ptr noundef @.str.107)
  br label %cond.end14

cond.end14:                                       ; preds = %cond.false12, %cond.true11
  %cond15 = phi i32 [ 0, %cond.true11 ], [ 0, %cond.false12 ]
  %call16 = call i32 @ttype_from_string(ptr noundef @.str.108)
  %cmp17 = icmp eq i32 %call16, 0
  br i1 %cmp17, label %cond.true18, label %cond.false19

cond.true18:                                      ; preds = %cond.end14
  br label %cond.end21

cond.false19:                                     ; preds = %cond.end14
  %call20 = call i32 (ptr, ...) @printf(ptr noundef @.str.4, ptr noundef @.str.48, i32 noundef 699, ptr noundef @.str.109)
  br label %cond.end21

cond.end21:                                       ; preds = %cond.false19, %cond.true18
  %cond22 = phi i32 [ 0, %cond.true18 ], [ 0, %cond.false19 ]
  %call23 = call i32 @ttype_from_string(ptr noundef @.str.110)
  %cmp24 = icmp eq i32 %call23, 0
  br i1 %cmp24, label %cond.true25, label %cond.false26

cond.true25:                                      ; preds = %cond.end21
  br label %cond.end28

cond.false26:                                     ; preds = %cond.end21
  %call27 = call i32 (ptr, ...) @printf(ptr noundef @.str.4, ptr noundef @.str.48, i32 noundef 701, ptr noundef @.str.111)
  br label %cond.end28

cond.end28:                                       ; preds = %cond.false26, %cond.true25
  %cond29 = phi i32 [ 0, %cond.true25 ], [ 0, %cond.false26 ]
  %call30 = call i32 @ttype_from_string(ptr noundef @.str.112)
  %cmp31 = icmp eq i32 %call30, 0
  br i1 %cmp31, label %cond.true32, label %cond.false33

cond.true32:                                      ; preds = %cond.end28
  br label %cond.end35

cond.false33:                                     ; preds = %cond.end28
  %call34 = call i32 (ptr, ...) @printf(ptr noundef @.str.4, ptr noundef @.str.48, i32 noundef 702, ptr noundef @.str.113)
  br label %cond.end35

cond.end35:                                       ; preds = %cond.false33, %cond.true32
  %cond36 = phi i32 [ 0, %cond.true32 ], [ 0, %cond.false33 ]
  %call37 = call i32 @ttype_from_string(ptr noundef @.str.114)
  %cmp38 = icmp eq i32 %call37, 0
  br i1 %cmp38, label %cond.true39, label %cond.false40

cond.true39:                                      ; preds = %cond.end35
  br label %cond.end42

cond.false40:                                     ; preds = %cond.end35
  %call41 = call i32 (ptr, ...) @printf(ptr noundef @.str.4, ptr noundef @.str.48, i32 noundef 703, ptr noundef @.str.115)
  br label %cond.end42

cond.end42:                                       ; preds = %cond.false40, %cond.true39
  %cond43 = phi i32 [ 0, %cond.true39 ], [ 0, %cond.false40 ]
  %call44 = call i32 @ttype_from_string(ptr noundef @.str.116)
  %cmp45 = icmp eq i32 %call44, 0
  br i1 %cmp45, label %cond.true46, label %cond.false47

cond.true46:                                      ; preds = %cond.end42
  br label %cond.end49

cond.false47:                                     ; preds = %cond.end42
  %call48 = call i32 (ptr, ...) @printf(ptr noundef @.str.4, ptr noundef @.str.48, i32 noundef 705, ptr noundef @.str.117)
  br label %cond.end49

cond.end49:                                       ; preds = %cond.false47, %cond.true46
  %cond50 = phi i32 [ 0, %cond.true46 ], [ 0, %cond.false47 ]
  %call51 = call i32 @ttype_from_string(ptr noundef @.str.118)
  %cmp52 = icmp eq i32 %call51, 0
  br i1 %cmp52, label %cond.true53, label %cond.false54

cond.true53:                                      ; preds = %cond.end49
  br label %cond.end56

cond.false54:                                     ; preds = %cond.end49
  %call55 = call i32 (ptr, ...) @printf(ptr noundef @.str.4, ptr noundef @.str.48, i32 noundef 706, ptr noundef @.str.119)
  br label %cond.end56

cond.end56:                                       ; preds = %cond.false54, %cond.true53
  %cond57 = phi i32 [ 0, %cond.true53 ], [ 0, %cond.false54 ]
  %call58 = call i32 @ttype_from_string(ptr noundef @.str.120)
  %cmp59 = icmp eq i32 %call58, 1
  br i1 %cmp59, label %cond.true60, label %cond.false61

cond.true60:                                      ; preds = %cond.end56
  br label %cond.end63

cond.false61:                                     ; preds = %cond.end56
  %call62 = call i32 (ptr, ...) @printf(ptr noundef @.str.4, ptr noundef @.str.48, i32 noundef 708, ptr noundef @.str.121)
  br label %cond.end63

cond.end63:                                       ; preds = %cond.false61, %cond.true60
  %cond64 = phi i32 [ 0, %cond.true60 ], [ 0, %cond.false61 ]
  %call65 = call i32 @ttype_from_string(ptr noundef @.str.122)
  %cmp66 = icmp eq i32 %call65, 1
  br i1 %cmp66, label %cond.true67, label %cond.false68

cond.true67:                                      ; preds = %cond.end63
  br label %cond.end70

cond.false68:                                     ; preds = %cond.end63
  %call69 = call i32 (ptr, ...) @printf(ptr noundef @.str.4, ptr noundef @.str.48, i32 noundef 709, ptr noundef @.str.123)
  br label %cond.end70

cond.end70:                                       ; preds = %cond.false68, %cond.true67
  %cond71 = phi i32 [ 0, %cond.true67 ], [ 0, %cond.false68 ]
  %call72 = call i32 @ttype_from_string(ptr noundef @.str.124)
  %cmp73 = icmp eq i32 %call72, 2
  br i1 %cmp73, label %cond.true74, label %cond.false75

cond.true74:                                      ; preds = %cond.end70
  br label %cond.end77

cond.false75:                                     ; preds = %cond.end70
  %call76 = call i32 (ptr, ...) @printf(ptr noundef @.str.4, ptr noundef @.str.48, i32 noundef 711, ptr noundef @.str.125)
  br label %cond.end77

cond.end77:                                       ; preds = %cond.false75, %cond.true74
  %cond78 = phi i32 [ 0, %cond.true74 ], [ 0, %cond.false75 ]
  %call79 = call i32 @ttype_from_string(ptr noundef @.str.126)
  %cmp80 = icmp eq i32 %call79, 5
  br i1 %cmp80, label %cond.true81, label %cond.false82

cond.true81:                                      ; preds = %cond.end77
  br label %cond.end84

cond.false82:                                     ; preds = %cond.end77
  %call83 = call i32 (ptr, ...) @printf(ptr noundef @.str.4, ptr noundef @.str.48, i32 noundef 712, ptr noundef @.str.127)
  br label %cond.end84

cond.end84:                                       ; preds = %cond.false82, %cond.true81
  %cond85 = phi i32 [ 0, %cond.true81 ], [ 0, %cond.false82 ]
  %call86 = call i32 @ttype_from_string(ptr noundef @.str.128)
  %cmp87 = icmp eq i32 %call86, 8
  br i1 %cmp87, label %cond.true88, label %cond.false89

cond.true88:                                      ; preds = %cond.end84
  br label %cond.end91

cond.false89:                                     ; preds = %cond.end84
  %call90 = call i32 (ptr, ...) @printf(ptr noundef @.str.4, ptr noundef @.str.48, i32 noundef 714, ptr noundef @.str.129)
  br label %cond.end91

cond.end91:                                       ; preds = %cond.false89, %cond.true88
  %cond92 = phi i32 [ 0, %cond.true88 ], [ 0, %cond.false89 ]
  ret i32 0
}

; Function Attrs: nounwind uwtable
define dso_local i32 @test_lexer() #0 {
entry:
  call void @testing_setup_internal(ptr noundef @__func__.test_lexer)
  %call = call i32 @test_ttype_name()
  %call1 = call i32 @test_ttype_from_string()
  %call2 = call i32 @test_ttype_many_chars()
  %call3 = call i32 @test_ttype_one_char()
  call void @testing_cleanup_internal(ptr noundef @__func__.test_lexer)
  ret i32 0
}

; Function Attrs: nounwind uwtable
define dso_local i32 @parse(ptr noundef %filename) #0 {
entry:
  %lexer = alloca %struct.Lexer, align 8
  %t = alloca %struct.Token, align 4
  call void @llvm.lifetime.start.p0(i64 2936, ptr %lexer) #12
  %call = call noalias ptr @fopen(ptr noundef %filename, ptr noundef @.str.130)
  %tobool = icmp ne ptr %call, null
  br i1 %tobool, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  br label %do.body

do.body:                                          ; preds = %if.then
  %0 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call1 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %0, ptr noundef @.str.49, i32 noundef 31)
  %1 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call2 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %1, ptr noundef @.str.131, ptr noundef %filename)
  %2 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call3 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %2, ptr noundef @.str.51)
  br label %do.cond

do.cond:                                          ; preds = %do.body
  br label %do.end

do.end:                                           ; preds = %do.cond
  br label %cleanup122

if.end:                                           ; preds = %entry
  %fp4 = getelementptr inbounds %struct.Lexer, ptr %lexer, i32 0, i32 0
  store ptr %call, ptr %fp4, align 8, !tbaa !22
  %unlexed_count = getelementptr inbounds %struct.Lexer, ptr %lexer, i32 0, i32 8
  store i32 0, ptr %unlexed_count, align 4, !tbaa !27
  %line = getelementptr inbounds %struct.Lexer, ptr %lexer, i32 0, i32 6
  store i32 1, ptr %line, align 8, !tbaa !23
  %column = getelementptr inbounds %struct.Lexer, ptr %lexer, i32 0, i32 5
  store i32 1, ptr %column, align 4, !tbaa !20
  call void @llvm.lifetime.start.p0(i64 528, ptr %t) #12
  %conv = sext i32 16 to i64
  %mul = mul i64 %conv, 528
  %call5 = call noalias ptr @malloc(i64 noundef %mul) #11
  br label %do.body6

do.body6:                                         ; preds = %do.cond22, %if.end
  %i.0 = phi i32 [ 0, %if.end ], [ %inc, %do.cond22 ]
  %buffer_size.0 = phi i32 [ 16, %if.end ], [ %buffer_size.1, %do.cond22 ]
  %tokens.0 = phi ptr [ %call5, %if.end ], [ %tokens.1, %do.cond22 ]
  %call7 = call i32 @lex(ptr noundef %lexer, ptr noundef %t)
  %tobool8 = icmp ne i32 %call7, 0
  br i1 %tobool8, label %if.then9, label %if.end10

if.then9:                                         ; preds = %do.body6
  br label %cleanup

if.end10:                                         ; preds = %do.body6
  %cmp = icmp sle i32 %buffer_size.0, %i.0
  br i1 %cmp, label %if.then12, label %if.end17

if.then12:                                        ; preds = %if.end10
  %mul13 = mul nsw i32 %buffer_size.0, 2
  %conv14 = sext i32 %mul13 to i64
  %mul15 = mul i64 %conv14, 528
  %call16 = call noalias ptr @malloc(i64 noundef %mul15) #11
  br label %if.end17

if.end17:                                         ; preds = %if.then12, %if.end10
  %buffer_size.1 = phi i32 [ %mul13, %if.then12 ], [ %buffer_size.0, %if.end10 ]
  %tokens.1 = phi ptr [ %call16, %if.then12 ], [ %tokens.0, %if.end10 ]
  %idxprom = sext i32 %i.0 to i64
  %arrayidx = getelementptr inbounds %struct.Token, ptr %tokens.1, i64 %idxprom
  call void @llvm.memcpy.p0.p0.i64(ptr align 4 %arrayidx, ptr align 4 %t, i64 528, i1 false), !tbaa.struct !35
  %contents = getelementptr inbounds %struct.Token, ptr %t, i32 0, i32 1
  %arraydecay = getelementptr inbounds [256 x i8], ptr %contents, i64 0, i64 0
  %type = getelementptr inbounds %struct.Token, ptr %t, i32 0, i32 0
  %3 = load i32, ptr %type, align 4, !tbaa !24
  %call18 = call ptr @ttype_name(i32 noundef %3)
  %line19 = getelementptr inbounds %struct.Token, ptr %t, i32 0, i32 4
  %4 = load i32, ptr %line19, align 4, !tbaa !29
  %column20 = getelementptr inbounds %struct.Token, ptr %t, i32 0, i32 5
  %5 = load i32, ptr %column20, align 4, !tbaa !30
  %call21 = call i32 (ptr, ...) @printf(ptr noundef @.str.132, ptr noundef %arraydecay, ptr noundef %call18, i32 noundef %4, i32 noundef %5)
  %inc = add nsw i32 %i.0, 1
  br label %do.cond22

do.cond22:                                        ; preds = %if.end17
  %type23 = getelementptr inbounds %struct.Token, ptr %t, i32 0, i32 0
  %6 = load i32, ptr %type23, align 4, !tbaa !24
  %cmp24 = icmp ne i32 %6, 10
  br i1 %cmp24, label %do.body6, label %do.end26, !llvm.loop !36

do.end26:                                         ; preds = %do.cond22
  %arrayidx27 = getelementptr inbounds %struct.Token, ptr %tokens.1, i64 0
  %type28 = getelementptr inbounds %struct.Token, ptr %arrayidx27, i32 0, i32 0
  %7 = load i32, ptr %type28, align 4, !tbaa !24
  %cmp29 = icmp eq i32 %7, 69
  br i1 %cmp29, label %land.lhs.true, label %if.else110

land.lhs.true:                                    ; preds = %do.end26
  %arrayidx31 = getelementptr inbounds %struct.Token, ptr %tokens.1, i64 1
  %type32 = getelementptr inbounds %struct.Token, ptr %arrayidx31, i32 0, i32 0
  %8 = load i32, ptr %type32, align 4, !tbaa !24
  %cmp33 = icmp eq i32 %8, 1
  br i1 %cmp33, label %land.lhs.true35, label %if.else110

land.lhs.true35:                                  ; preds = %land.lhs.true
  %arrayidx36 = getelementptr inbounds %struct.Token, ptr %tokens.1, i64 1
  %contents37 = getelementptr inbounds %struct.Token, ptr %arrayidx36, i32 0, i32 1
  %arraydecay38 = getelementptr inbounds [256 x i8], ptr %contents37, i64 0, i64 0
  %call39 = call i32 @strcmp(ptr noundef %arraydecay38, ptr noundef @.str.133) #13
  %cmp40 = icmp eq i32 %call39, 0
  br i1 %cmp40, label %if.then42, label %if.else110

if.then42:                                        ; preds = %land.lhs.true35
  %arrayidx43 = getelementptr inbounds %struct.Token, ptr %tokens.1, i64 2
  %type44 = getelementptr inbounds %struct.Token, ptr %arrayidx43, i32 0, i32 0
  %9 = load i32, ptr %type44, align 4, !tbaa !24
  %cmp45 = icmp eq i32 %9, 2
  br i1 %cmp45, label %land.lhs.true47, label %if.else102

land.lhs.true47:                                  ; preds = %if.then42
  %arrayidx48 = getelementptr inbounds %struct.Token, ptr %tokens.1, i64 3
  %type49 = getelementptr inbounds %struct.Token, ptr %arrayidx48, i32 0, i32 0
  %10 = load i32, ptr %type49, align 4, !tbaa !24
  %cmp50 = icmp eq i32 %10, 3
  br i1 %cmp50, label %land.lhs.true52, label %if.else102

land.lhs.true52:                                  ; preds = %land.lhs.true47
  %arrayidx53 = getelementptr inbounds %struct.Token, ptr %tokens.1, i64 4
  %type54 = getelementptr inbounds %struct.Token, ptr %arrayidx53, i32 0, i32 0
  %11 = load i32, ptr %type54, align 4, !tbaa !24
  %cmp55 = icmp eq i32 %11, 4
  br i1 %cmp55, label %if.then57, label %if.else102

if.then57:                                        ; preds = %land.lhs.true52
  %arrayidx58 = getelementptr inbounds %struct.Token, ptr %tokens.1, i64 5
  %type59 = getelementptr inbounds %struct.Token, ptr %arrayidx58, i32 0, i32 0
  %12 = load i32, ptr %type59, align 4, !tbaa !24
  %cmp60 = icmp eq i32 %12, 71
  br i1 %cmp60, label %land.lhs.true62, label %if.else94

land.lhs.true62:                                  ; preds = %if.then57
  %arrayidx63 = getelementptr inbounds %struct.Token, ptr %tokens.1, i64 6
  %type64 = getelementptr inbounds %struct.Token, ptr %arrayidx63, i32 0, i32 0
  %13 = load i32, ptr %type64, align 4, !tbaa !24
  %cmp65 = icmp eq i32 %13, 0
  br i1 %cmp65, label %land.lhs.true67, label %if.else94

land.lhs.true67:                                  ; preds = %land.lhs.true62
  %arrayidx68 = getelementptr inbounds %struct.Token, ptr %tokens.1, i64 7
  %type69 = getelementptr inbounds %struct.Token, ptr %arrayidx68, i32 0, i32 0
  %14 = load i32, ptr %type69, align 4, !tbaa !24
  %cmp70 = icmp eq i32 %14, 8
  br i1 %cmp70, label %if.then72, label %if.else94

if.then72:                                        ; preds = %land.lhs.true67
  %arrayidx73 = getelementptr inbounds %struct.Token, ptr %tokens.1, i64 8
  %type74 = getelementptr inbounds %struct.Token, ptr %arrayidx73, i32 0, i32 0
  %15 = load i32, ptr %type74, align 4, !tbaa !24
  %cmp75 = icmp eq i32 %15, 5
  br i1 %cmp75, label %if.then77, label %if.else

if.then77:                                        ; preds = %if.then72
  %call78 = call i32 (ptr, ...) @printf(ptr noundef @.str.134)
  %call79 = call ptr @start_main()
  %call80 = call i32 (ptr, ...) @printf(ptr noundef %call79)
  %arrayidx81 = getelementptr inbounds %struct.Token, ptr %tokens.1, i64 6
  %contents82 = getelementptr inbounds %struct.Token, ptr %arrayidx81, i32 0, i32 1
  %arraydecay83 = getelementptr inbounds [256 x i8], ptr %contents82, i64 0, i64 0
  %call84 = call i32 @atoi(ptr noundef %arraydecay83) #13
  %call85 = call ptr @end_main_custom_return(i32 noundef %call84)
  %call86 = call i32 (ptr, ...) @printf(ptr noundef %call85)
  br label %if.end93

if.else:                                          ; preds = %if.then72
  br label %do.body87

do.body87:                                        ; preds = %if.else
  %16 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call88 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %16, ptr noundef @.str.49, i32 noundef 31)
  %17 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call89 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %17, ptr noundef @.str.135)
  %18 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call90 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %18, ptr noundef @.str.51)
  br label %do.cond91

do.cond91:                                        ; preds = %do.body87
  br label %do.end92

do.end92:                                         ; preds = %do.cond91
  br label %if.end93

if.end93:                                         ; preds = %do.end92, %if.then77
  br label %if.end101

if.else94:                                        ; preds = %land.lhs.true67, %land.lhs.true62, %if.then57
  br label %do.body95

do.body95:                                        ; preds = %if.else94
  %19 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call96 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %19, ptr noundef @.str.49, i32 noundef 31)
  %20 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call97 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %20, ptr noundef @.str.136)
  %21 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call98 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %21, ptr noundef @.str.51)
  br label %do.cond99

do.cond99:                                        ; preds = %do.body95
  br label %do.end100

do.end100:                                        ; preds = %do.cond99
  br label %if.end101

if.end101:                                        ; preds = %do.end100, %if.end93
  br label %if.end109

if.else102:                                       ; preds = %land.lhs.true52, %land.lhs.true47, %if.then42
  br label %do.body103

do.body103:                                       ; preds = %if.else102
  %22 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call104 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %22, ptr noundef @.str.49, i32 noundef 31)
  %23 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call105 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %23, ptr noundef @.str.137)
  %24 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call106 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %24, ptr noundef @.str.51)
  br label %do.cond107

do.cond107:                                       ; preds = %do.body103
  br label %do.end108

do.end108:                                        ; preds = %do.cond107
  br label %if.end109

if.end109:                                        ; preds = %do.end108, %if.end101
  br label %if.end117

if.else110:                                       ; preds = %land.lhs.true35, %land.lhs.true, %do.end26
  br label %do.body111

do.body111:                                       ; preds = %if.else110
  %25 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call112 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %25, ptr noundef @.str.49, i32 noundef 31)
  %26 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call113 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %26, ptr noundef @.str.138)
  %27 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call114 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %27, ptr noundef @.str.51)
  br label %do.cond115

do.cond115:                                       ; preds = %do.body111
  br label %do.end116

do.end116:                                        ; preds = %do.cond115
  br label %if.end117

if.end117:                                        ; preds = %do.end116, %if.end109
  %call118 = call i32 @fclose(ptr noundef %call)
  br label %cleanup

cleanup:                                          ; preds = %if.end117, %if.then9
  %retval.0 = phi i32 [ 1, %if.then9 ], [ 0, %if.end117 ]
  call void @llvm.lifetime.end.p0(i64 528, ptr %t) #12
  br label %cleanup122

cleanup122:                                       ; preds = %cleanup, %do.end
  %retval.1 = phi i32 [ %retval.0, %cleanup ], [ 1, %do.end ]
  call void @llvm.lifetime.end.p0(i64 2936, ptr %lexer) #12
  ret i32 %retval.1
}

declare noalias ptr @fopen(ptr noundef, ptr noundef) #5

; Function Attrs: inlinehint nounwind willreturn memory(read) uwtable
define available_externally i32 @atoi(ptr noundef nonnull %__nptr) #9 {
entry:
  %call = call i64 @strtol(ptr noundef %__nptr, ptr noundef null, i32 noundef 10) #12
  %conv = trunc i64 %call to i32
  ret i32 %conv
}

declare i32 @fclose(ptr noundef) #5

; Function Attrs: nounwind uwtable
define dso_local i32 @parse_simple_main_func() #0 {
entry:
  ret i32 undef
}

; Function Attrs: nounwind uwtable
define dso_local i32 @parse_expr(ptr noundef %l, ptr noundef %ex) #0 {
entry:
  ret i32 undef
}

; Function Attrs: nounwind uwtable
define dso_local i32 @parse_funccall(ptr noundef %l, ptr noundef %ex) #0 {
entry:
  ret i32 undef
}

; Function Attrs: nounwind uwtable
define dso_local i32 @parse_blockstmt(ptr noundef %l, ptr noundef %bs) #0 {
entry:
  ret i32 undef
}

; Function Attrs: nounwind uwtable
define dso_local i32 @parse_funcdecl(ptr noundef %l, ptr noundef %fd) #0 {
entry:
  ret i32 undef
}

; Function Attrs: nounwind uwtable
define dso_local i32 @make_cst(ptr noundef %l, ptr noundef %tree) #0 {
entry:
  ret i32 undef
}

; Function Attrs: nounwind uwtable
define dso_local i32 @fnva1(ptr noundef %value) #0 {
entry:
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %h.0 = phi i64 [ 16777619, %entry ], [ %mul, %while.body ]
  %value.addr.0 = phi ptr [ %value, %entry ], [ %incdec.ptr, %while.body ]
  %0 = load i8, ptr %value.addr.0, align 1, !tbaa !12
  %conv = zext i8 %0 to i32
  %cmp = icmp ne i32 %conv, 0
  br i1 %cmp, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %1 = load i8, ptr %value.addr.0, align 1, !tbaa !12
  %conv2 = zext i8 %1 to i64
  %xor = xor i64 %h.0, %conv2
  %mul = mul i64 %xor, 2166136261
  %incdec.ptr = getelementptr inbounds i8, ptr %value.addr.0, i32 1
  br label %while.cond, !llvm.loop !37

while.end:                                        ; preds = %while.cond
  %conv3 = trunc i64 %h.0 to i32
  ret i32 %conv3
}

; Function Attrs: nounwind uwtable
define dso_local i32 @equal_key(ptr noundef %a, ptr noundef %b) #0 {
entry:
  %call = call i32 @strcmp(ptr noundef %a, ptr noundef %b) #13
  %cmp = icmp eq i32 %call, 0
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

; Function Attrs: nounwind uwtable
define dso_local ptr @create_hashmap(i32 noundef %capacity) #0 {
entry:
  %call = call noalias ptr @malloc(i64 noundef 16) #11
  %conv = sext i32 %capacity to i64
  %call1 = call noalias ptr @calloc(i64 noundef %conv, i64 noundef 8) #15
  %buckets = getelementptr inbounds %struct.Hashmap, ptr %call, i32 0, i32 0
  store ptr %call1, ptr %buckets, align 8, !tbaa !38
  %size = getelementptr inbounds %struct.Hashmap, ptr %call, i32 0, i32 1
  store i32 0, ptr %size, align 8, !tbaa !40
  %cap = getelementptr inbounds %struct.Hashmap, ptr %call, i32 0, i32 2
  store i32 %capacity, ptr %cap, align 4, !tbaa !41
  ret ptr %call
}

; Function Attrs: nounwind allocsize(0,1)
declare noalias ptr @calloc(i64 noundef, i64 noundef) #10

; Function Attrs: nounwind uwtable
define dso_local void @destroy_hashmap(ptr noundef %h) #0 {
entry:
  %buckets = getelementptr inbounds %struct.Hashmap, ptr %h, i32 0, i32 0
  %0 = load ptr, ptr %buckets, align 8, !tbaa !38
  call void @free(ptr noundef %0) #12
  call void @free(ptr noundef %h) #12
  ret void
}

; Function Attrs: nounwind
declare void @free(ptr noundef) #3

; Function Attrs: nounwind uwtable
define dso_local ptr @create_bucket(ptr noundef %key, ptr noundef %value) #0 {
entry:
  %call = call noalias ptr @malloc(i64 noundef 24) #11
  %key1 = getelementptr inbounds %struct.BucketNode, ptr %call, i32 0, i32 0
  store ptr %key, ptr %key1, align 8, !tbaa !42
  %value2 = getelementptr inbounds %struct.BucketNode, ptr %call, i32 0, i32 1
  store ptr %value, ptr %value2, align 8, !tbaa !44
  %next = getelementptr inbounds %struct.BucketNode, ptr %call, i32 0, i32 2
  store ptr null, ptr %next, align 8, !tbaa !45
  ret ptr %call
}

; Function Attrs: nounwind uwtable
define dso_local ptr @hm_get(ptr noundef %h, ptr noundef %key) #0 {
entry:
  %call = call i32 @fnva1(ptr noundef %key)
  %cap = getelementptr inbounds %struct.Hashmap, ptr %h, i32 0, i32 2
  %0 = load i32, ptr %cap, align 4, !tbaa !41
  %rem = urem i32 %call, %0
  %buckets = getelementptr inbounds %struct.Hashmap, ptr %h, i32 0, i32 0
  %1 = load ptr, ptr %buckets, align 8, !tbaa !38
  %idxprom = zext i32 %rem to i64
  %arrayidx = getelementptr inbounds ptr, ptr %1, i64 %idxprom
  %2 = load ptr, ptr %arrayidx, align 8, !tbaa !10
  %cmp = icmp eq ptr %2, null
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  br label %cleanup

if.end:                                           ; preds = %entry
  %key1 = getelementptr inbounds %struct.BucketNode, ptr %2, i32 0, i32 0
  %3 = load ptr, ptr %key1, align 8, !tbaa !42
  %call2 = call i32 @equal_key(ptr noundef %3, ptr noundef %key)
  %tobool = icmp ne i32 %call2, 0
  br i1 %tobool, label %if.then3, label %if.end4

if.then3:                                         ; preds = %if.end
  br label %cleanup

if.end4:                                          ; preds = %if.end
  br label %cleanup

cleanup:                                          ; preds = %if.end4, %if.then3, %if.then
  %retval.0 = phi ptr [ null, %if.then ], [ %2, %if.then3 ], [ null, %if.end4 ]
  ret ptr %retval.0
}

; Function Attrs: nounwind uwtable
define dso_local i32 @hm_set(ptr noundef %h, ptr noundef %key, ptr noundef %value) #0 {
entry:
  %call = call i32 @fnva1(ptr noundef %key)
  %cap = getelementptr inbounds %struct.Hashmap, ptr %h, i32 0, i32 2
  %0 = load i32, ptr %cap, align 4, !tbaa !41
  %rem = urem i32 %call, %0
  %buckets = getelementptr inbounds %struct.Hashmap, ptr %h, i32 0, i32 0
  %1 = load ptr, ptr %buckets, align 8, !tbaa !38
  %idxprom = zext i32 %rem to i64
  %arrayidx = getelementptr inbounds ptr, ptr %1, i64 %idxprom
  %2 = load ptr, ptr %arrayidx, align 8, !tbaa !10
  %cmp = icmp eq ptr %2, null
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %size = getelementptr inbounds %struct.Hashmap, ptr %h, i32 0, i32 1
  %3 = load i32, ptr %size, align 8, !tbaa !40
  %cap1 = getelementptr inbounds %struct.Hashmap, ptr %h, i32 0, i32 2
  %4 = load i32, ptr %cap1, align 4, !tbaa !41
  %cmp2 = icmp eq i32 %3, %4
  br i1 %cmp2, label %if.then3, label %if.end

if.then3:                                         ; preds = %if.then
  call void @double_cap(ptr noundef %h)
  br label %if.end

if.end:                                           ; preds = %if.then3, %if.then
  %size4 = getelementptr inbounds %struct.Hashmap, ptr %h, i32 0, i32 1
  %5 = load i32, ptr %size4, align 8, !tbaa !40
  %inc = add nsw i32 %5, 1
  store i32 %inc, ptr %size4, align 8, !tbaa !40
  %call5 = call noalias ptr @malloc(i64 noundef 8) #11
  %buckets6 = getelementptr inbounds %struct.Hashmap, ptr %h, i32 0, i32 0
  %6 = load ptr, ptr %buckets6, align 8, !tbaa !38
  %idxprom7 = zext i32 %rem to i64
  %arrayidx8 = getelementptr inbounds ptr, ptr %6, i64 %idxprom7
  store ptr %call5, ptr %arrayidx8, align 8, !tbaa !10
  %buckets9 = getelementptr inbounds %struct.Hashmap, ptr %h, i32 0, i32 0
  %7 = load ptr, ptr %buckets9, align 8, !tbaa !38
  %idxprom10 = zext i32 %rem to i64
  %arrayidx11 = getelementptr inbounds ptr, ptr %7, i64 %idxprom10
  %8 = load ptr, ptr %arrayidx11, align 8, !tbaa !10
  %key12 = getelementptr inbounds %struct.BucketNode, ptr %8, i32 0, i32 0
  store ptr %key, ptr %key12, align 8, !tbaa !42
  %buckets13 = getelementptr inbounds %struct.Hashmap, ptr %h, i32 0, i32 0
  %9 = load ptr, ptr %buckets13, align 8, !tbaa !38
  %idxprom14 = zext i32 %rem to i64
  %arrayidx15 = getelementptr inbounds ptr, ptr %9, i64 %idxprom14
  %10 = load ptr, ptr %arrayidx15, align 8, !tbaa !10
  %value16 = getelementptr inbounds %struct.BucketNode, ptr %10, i32 0, i32 1
  store ptr %value, ptr %value16, align 8, !tbaa !44
  %buckets17 = getelementptr inbounds %struct.Hashmap, ptr %h, i32 0, i32 0
  %11 = load ptr, ptr %buckets17, align 8, !tbaa !38
  %idxprom18 = zext i32 %rem to i64
  %arrayidx19 = getelementptr inbounds ptr, ptr %11, i64 %idxprom18
  %12 = load ptr, ptr %arrayidx19, align 8, !tbaa !10
  %next = getelementptr inbounds %struct.BucketNode, ptr %12, i32 0, i32 2
  store ptr null, ptr %next, align 8, !tbaa !45
  br label %cleanup

if.else:                                          ; preds = %entry
  br label %cleanup

cleanup:                                          ; preds = %if.else, %if.end
  %retval.0 = phi i32 [ 0, %if.end ], [ -1, %if.else ]
  ret i32 %retval.0
}

; Function Attrs: nounwind uwtable
define dso_local void @double_cap(ptr noundef %h) #0 {
entry:
  %cap = getelementptr inbounds %struct.Hashmap, ptr %h, i32 0, i32 2
  %0 = load i32, ptr %cap, align 4, !tbaa !41
  %mul = mul nsw i32 %0, 2
  %conv = sext i32 %mul to i64
  %call = call noalias ptr @calloc(i64 noundef %conv, i64 noundef 8) #15
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i.0 = phi i32 [ 0, %entry ], [ %inc, %for.inc ]
  %cap1 = getelementptr inbounds %struct.Hashmap, ptr %h, i32 0, i32 2
  %1 = load i32, ptr %cap1, align 4, !tbaa !41
  %cmp = icmp slt i32 %i.0, %1
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %for.end

for.body:                                         ; preds = %for.cond
  %buckets = getelementptr inbounds %struct.Hashmap, ptr %h, i32 0, i32 0
  %2 = load ptr, ptr %buckets, align 8, !tbaa !38
  %idxprom = sext i32 %i.0 to i64
  %arrayidx = getelementptr inbounds ptr, ptr %2, i64 %idxprom
  %3 = load ptr, ptr %arrayidx, align 8, !tbaa !10
  %cmp3 = icmp ne ptr %3, null
  br i1 %cmp3, label %if.then, label %if.end

if.then:                                          ; preds = %for.body
  %buckets5 = getelementptr inbounds %struct.Hashmap, ptr %h, i32 0, i32 0
  %4 = load ptr, ptr %buckets5, align 8, !tbaa !38
  %idxprom6 = sext i32 %i.0 to i64
  %arrayidx7 = getelementptr inbounds ptr, ptr %4, i64 %idxprom6
  %5 = load ptr, ptr %arrayidx7, align 8, !tbaa !10
  %key = getelementptr inbounds %struct.BucketNode, ptr %5, i32 0, i32 0
  %6 = load ptr, ptr %key, align 8, !tbaa !42
  %call8 = call i32 @fnva1(ptr noundef %6)
  %cap9 = getelementptr inbounds %struct.Hashmap, ptr %h, i32 0, i32 2
  %7 = load i32, ptr %cap9, align 4, !tbaa !41
  %rem = urem i32 %call8, %7
  %idxprom10 = zext i32 %rem to i64
  %arrayidx11 = getelementptr inbounds ptr, ptr %call, i64 %idxprom10
  store ptr %5, ptr %arrayidx11, align 8, !tbaa !10
  br label %if.end

if.end:                                           ; preds = %if.then, %for.body
  br label %for.inc

for.inc:                                          ; preds = %if.end
  %inc = add nsw i32 %i.0, 1
  br label %for.cond, !llvm.loop !46

for.end:                                          ; preds = %for.cond.cleanup
  %buckets12 = getelementptr inbounds %struct.Hashmap, ptr %h, i32 0, i32 0
  store ptr %call, ptr %buckets12, align 8, !tbaa !38
  %cap13 = getelementptr inbounds %struct.Hashmap, ptr %h, i32 0, i32 2
  %8 = load i32, ptr %cap13, align 4, !tbaa !41
  %mul14 = mul nsw i32 %8, 2
  %cap15 = getelementptr inbounds %struct.Hashmap, ptr %h, i32 0, i32 2
  store i32 %mul14, ptr %cap15, align 4, !tbaa !41
  ret void
}

; Function Attrs: nounwind uwtable
define dso_local i32 @test_hash_init() #0 {
entry:
  call void @testing_single_test_internal(ptr noundef @__func__.test_hash_init)
  %call = call ptr @create_hashmap(i32 noundef 100)
  %size = getelementptr inbounds %struct.Hashmap, ptr %call, i32 0, i32 1
  %0 = load i32, ptr %size, align 8, !tbaa !40
  %cmp = icmp eq i32 %0, 0
  br i1 %cmp, label %cond.true, label %cond.false

cond.true:                                        ; preds = %entry
  br label %cond.end

cond.false:                                       ; preds = %entry
  %call1 = call i32 (ptr, ...) @printf(ptr noundef @.str.4, ptr noundef @.str.139, i32 noundef 114, ptr noundef @.str.140)
  br label %cond.end

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi i32 [ 0, %cond.true ], [ 0, %cond.false ]
  %cap = getelementptr inbounds %struct.Hashmap, ptr %call, i32 0, i32 2
  %1 = load i32, ptr %cap, align 4, !tbaa !41
  %cmp2 = icmp eq i32 %1, 100
  br i1 %cmp2, label %cond.true3, label %cond.false4

cond.true3:                                       ; preds = %cond.end
  br label %cond.end6

cond.false4:                                      ; preds = %cond.end
  %call5 = call i32 (ptr, ...) @printf(ptr noundef @.str.4, ptr noundef @.str.139, i32 noundef 115, ptr noundef @.str.141)
  br label %cond.end6

cond.end6:                                        ; preds = %cond.false4, %cond.true3
  %cond7 = phi i32 [ 0, %cond.true3 ], [ 0, %cond.false4 ]
  ret i32 undef
}

; Function Attrs: nounwind uwtable
define dso_local i32 @test_hash_init_and_store() #0 {
entry:
  %name = alloca [5 x i8], align 1
  %key = alloca [5 x i8], align 1
  call void @testing_single_test_internal(ptr noundef @__func__.test_hash_init_and_store)
  %call = call ptr @create_hashmap(i32 noundef 100)
  %size = getelementptr inbounds %struct.Hashmap, ptr %call, i32 0, i32 1
  %0 = load i32, ptr %size, align 8, !tbaa !40
  %cmp = icmp eq i32 %0, 0
  br i1 %cmp, label %cond.true, label %cond.false

cond.true:                                        ; preds = %entry
  br label %cond.end

cond.false:                                       ; preds = %entry
  %call1 = call i32 (ptr, ...) @printf(ptr noundef @.str.4, ptr noundef @.str.139, i32 noundef 122, ptr noundef @.str.140)
  br label %cond.end

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi i32 [ 0, %cond.true ], [ 0, %cond.false ]
  %cap = getelementptr inbounds %struct.Hashmap, ptr %call, i32 0, i32 2
  %1 = load i32, ptr %cap, align 4, !tbaa !41
  %cmp2 = icmp eq i32 %1, 100
  br i1 %cmp2, label %cond.true3, label %cond.false4

cond.true3:                                       ; preds = %cond.end
  br label %cond.end6

cond.false4:                                      ; preds = %cond.end
  %call5 = call i32 (ptr, ...) @printf(ptr noundef @.str.4, ptr noundef @.str.139, i32 noundef 123, ptr noundef @.str.141)
  br label %cond.end6

cond.end6:                                        ; preds = %cond.false4, %cond.true3
  %cond7 = phi i32 [ 0, %cond.true3 ], [ 0, %cond.false4 ]
  call void @llvm.lifetime.start.p0(i64 5, ptr %name) #12
  call void @llvm.memcpy.p0.p0.i64(ptr align 1 %name, ptr align 1 @__const.test_hash_init_and_store.name, i64 5, i1 false)
  call void @llvm.lifetime.start.p0(i64 5, ptr %key) #12
  call void @llvm.memcpy.p0.p0.i64(ptr align 1 %key, ptr align 1 @__const.test_hash_init_and_store.key, i64 5, i1 false)
  %arraydecay = getelementptr inbounds [5 x i8], ptr %key, i64 0, i64 0
  %arraydecay8 = getelementptr inbounds [5 x i8], ptr %name, i64 0, i64 0
  %call9 = call i32 @hm_set(ptr noundef %call, ptr noundef %arraydecay, ptr noundef %arraydecay8)
  %cmp10 = icmp ne i32 %call9, -1
  br i1 %cmp10, label %cond.true11, label %cond.false12

cond.true11:                                      ; preds = %cond.end6
  br label %cond.end14

cond.false12:                                     ; preds = %cond.end6
  %call13 = call i32 (ptr, ...) @printf(ptr noundef @.str.4, ptr noundef @.str.139, i32 noundef 129, ptr noundef @.str.142)
  br label %cond.end14

cond.end14:                                       ; preds = %cond.false12, %cond.true11
  %cond15 = phi i32 [ 0, %cond.true11 ], [ 0, %cond.false12 ]
  %arraydecay16 = getelementptr inbounds [5 x i8], ptr %key, i64 0, i64 0
  %call17 = call i32 @fnva1(ptr noundef %arraydecay16)
  %cap18 = getelementptr inbounds %struct.Hashmap, ptr %call, i32 0, i32 2
  %2 = load i32, ptr %cap18, align 4, !tbaa !41
  %rem = urem i32 %call17, %2
  %conv = zext i32 %rem to i64
  %buckets = getelementptr inbounds %struct.Hashmap, ptr %call, i32 0, i32 0
  %3 = load ptr, ptr %buckets, align 8, !tbaa !38
  %arrayidx = getelementptr inbounds ptr, ptr %3, i64 %conv
  %4 = load ptr, ptr %arrayidx, align 8, !tbaa !10
  %key19 = getelementptr inbounds %struct.BucketNode, ptr %4, i32 0, i32 0
  %5 = load ptr, ptr %key19, align 8, !tbaa !42
  %arraydecay20 = getelementptr inbounds [5 x i8], ptr %key, i64 0, i64 0
  %call21 = call i32 @strcmp(ptr noundef %5, ptr noundef %arraydecay20) #13
  %cmp22 = icmp eq i32 %call21, 0
  br i1 %cmp22, label %cond.true24, label %cond.false25

cond.true24:                                      ; preds = %cond.end14
  br label %cond.end27

cond.false25:                                     ; preds = %cond.end14
  %call26 = call i32 (ptr, ...) @printf(ptr noundef @.str.4, ptr noundef @.str.139, i32 noundef 133, ptr noundef @.str.143)
  br label %cond.end27

cond.end27:                                       ; preds = %cond.false25, %cond.true24
  %cond28 = phi i32 [ 0, %cond.true24 ], [ 0, %cond.false25 ]
  %size29 = getelementptr inbounds %struct.Hashmap, ptr %call, i32 0, i32 1
  %6 = load i32, ptr %size29, align 8, !tbaa !40
  %cmp30 = icmp eq i32 %6, 1
  br i1 %cmp30, label %cond.true32, label %cond.false33

cond.true32:                                      ; preds = %cond.end27
  br label %cond.end35

cond.false33:                                     ; preds = %cond.end27
  %call34 = call i32 (ptr, ...) @printf(ptr noundef @.str.4, ptr noundef @.str.139, i32 noundef 135, ptr noundef @.str.144)
  br label %cond.end35

cond.end35:                                       ; preds = %cond.false33, %cond.true32
  %cond36 = phi i32 [ 0, %cond.true32 ], [ 0, %cond.false33 ]
  %cap37 = getelementptr inbounds %struct.Hashmap, ptr %call, i32 0, i32 2
  %7 = load i32, ptr %cap37, align 4, !tbaa !41
  %cmp38 = icmp eq i32 %7, 100
  br i1 %cmp38, label %cond.true40, label %cond.false41

cond.true40:                                      ; preds = %cond.end35
  br label %cond.end43

cond.false41:                                     ; preds = %cond.end35
  %call42 = call i32 (ptr, ...) @printf(ptr noundef @.str.4, ptr noundef @.str.139, i32 noundef 136, ptr noundef @.str.141)
  br label %cond.end43

cond.end43:                                       ; preds = %cond.false41, %cond.true40
  %cond44 = phi i32 [ 0, %cond.true40 ], [ 0, %cond.false41 ]
  call void @llvm.lifetime.end.p0(i64 5, ptr %key) #12
  call void @llvm.lifetime.end.p0(i64 5, ptr %name) #12
  ret i32 undef
}

; Function Attrs: nounwind uwtable
define dso_local i32 @test_hash_set_and_get() #0 {
entry:
  %name = alloca [100 x i8], align 1
  %key = alloca [10 x i8], align 1
  call void @testing_single_test_internal(ptr noundef @__func__.test_hash_set_and_get)
  %call = call ptr @create_hashmap(i32 noundef 100)
  call void @llvm.lifetime.start.p0(i64 100, ptr %name) #12
  call void @llvm.memset.p0.i64(ptr align 1 %name, i8 0, i64 100, i1 false)
  %0 = getelementptr inbounds [100 x i8], ptr %name, i32 0, i32 0
  store i8 106, ptr %0, align 1
  %1 = getelementptr inbounds [100 x i8], ptr %name, i32 0, i32 1
  store i8 97, ptr %1, align 1
  %2 = getelementptr inbounds [100 x i8], ptr %name, i32 0, i32 2
  store i8 107, ptr %2, align 1
  %3 = getelementptr inbounds [100 x i8], ptr %name, i32 0, i32 3
  store i8 101, ptr %3, align 1
  call void @llvm.lifetime.start.p0(i64 10, ptr %key) #12
  call void @llvm.memcpy.p0.p0.i64(ptr align 1 %key, ptr align 1 @__const.test_hash_set_and_get.key, i64 10, i1 false)
  %arraydecay = getelementptr inbounds [10 x i8], ptr %key, i64 0, i64 0
  %arraydecay1 = getelementptr inbounds [100 x i8], ptr %name, i64 0, i64 0
  %call2 = call i32 @hm_set(ptr noundef %call, ptr noundef %arraydecay, ptr noundef %arraydecay1)
  %cmp = icmp ne i32 %call2, -1
  br i1 %cmp, label %cond.true, label %cond.false

cond.true:                                        ; preds = %entry
  br label %cond.end

cond.false:                                       ; preds = %entry
  %call3 = call i32 (ptr, ...) @printf(ptr noundef @.str.4, ptr noundef @.str.139, i32 noundef 147, ptr noundef @.str.142)
  br label %cond.end

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi i32 [ 0, %cond.true ], [ 0, %cond.false ]
  %call4 = call ptr @hm_get(ptr noundef %call, ptr noundef @.str.145)
  %value = getelementptr inbounds %struct.BucketNode, ptr %call4, i32 0, i32 1
  %4 = load ptr, ptr %value, align 8, !tbaa !44
  %call5 = call i32 @strcmp(ptr noundef %4, ptr noundef @.str.146) #13
  %cmp6 = icmp eq i32 %call5, 0
  br i1 %cmp6, label %cond.true7, label %cond.false8

cond.true7:                                       ; preds = %cond.end
  br label %cond.end10

cond.false8:                                      ; preds = %cond.end
  %call9 = call i32 (ptr, ...) @printf(ptr noundef @.str.4, ptr noundef @.str.139, i32 noundef 150, ptr noundef @.str.147)
  br label %cond.end10

cond.end10:                                       ; preds = %cond.false8, %cond.true7
  %cond11 = phi i32 [ 0, %cond.true7 ], [ 0, %cond.false8 ]
  call void @llvm.lifetime.end.p0(i64 10, ptr %key) #12
  call void @llvm.lifetime.end.p0(i64 100, ptr %name) #12
  ret i32 0
}

; Function Attrs: nounwind uwtable
define dso_local i32 @test_hash_set_and_double_get() #0 {
entry:
  %name = alloca [100 x i8], align 1
  %key = alloca [10 x i8], align 1
  call void @testing_single_test_internal(ptr noundef @__func__.test_hash_set_and_double_get)
  %call = call ptr @create_hashmap(i32 noundef 100)
  call void @llvm.lifetime.start.p0(i64 100, ptr %name) #12
  call void @llvm.memset.p0.i64(ptr align 1 %name, i8 0, i64 100, i1 false)
  %0 = getelementptr inbounds [100 x i8], ptr %name, i32 0, i32 0
  store i8 106, ptr %0, align 1
  %1 = getelementptr inbounds [100 x i8], ptr %name, i32 0, i32 1
  store i8 97, ptr %1, align 1
  %2 = getelementptr inbounds [100 x i8], ptr %name, i32 0, i32 2
  store i8 107, ptr %2, align 1
  %3 = getelementptr inbounds [100 x i8], ptr %name, i32 0, i32 3
  store i8 101, ptr %3, align 1
  call void @llvm.lifetime.start.p0(i64 10, ptr %key) #12
  call void @llvm.memcpy.p0.p0.i64(ptr align 1 %key, ptr align 1 @__const.test_hash_set_and_double_get.key, i64 10, i1 false)
  %arraydecay = getelementptr inbounds [10 x i8], ptr %key, i64 0, i64 0
  %arraydecay1 = getelementptr inbounds [100 x i8], ptr %name, i64 0, i64 0
  %call2 = call i32 @hm_set(ptr noundef %call, ptr noundef %arraydecay, ptr noundef %arraydecay1)
  %cmp = icmp ne i32 %call2, -1
  br i1 %cmp, label %cond.true, label %cond.false

cond.true:                                        ; preds = %entry
  br label %cond.end

cond.false:                                       ; preds = %entry
  %call3 = call i32 (ptr, ...) @printf(ptr noundef @.str.4, ptr noundef @.str.139, i32 noundef 163, ptr noundef @.str.142)
  br label %cond.end

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi i32 [ 0, %cond.true ], [ 0, %cond.false ]
  call void @double_cap(ptr noundef %call)
  %call4 = call ptr @hm_get(ptr noundef %call, ptr noundef @.str.145)
  %value = getelementptr inbounds %struct.BucketNode, ptr %call4, i32 0, i32 1
  %4 = load ptr, ptr %value, align 8, !tbaa !44
  %call5 = call i32 @strcmp(ptr noundef %4, ptr noundef @.str.146) #13
  %cmp6 = icmp eq i32 %call5, 0
  br i1 %cmp6, label %cond.true7, label %cond.false8

cond.true7:                                       ; preds = %cond.end
  br label %cond.end10

cond.false8:                                      ; preds = %cond.end
  %call9 = call i32 (ptr, ...) @printf(ptr noundef @.str.4, ptr noundef @.str.139, i32 noundef 168, ptr noundef @.str.147)
  br label %cond.end10

cond.end10:                                       ; preds = %cond.false8, %cond.true7
  %cond11 = phi i32 [ 0, %cond.true7 ], [ 0, %cond.false8 ]
  call void @llvm.lifetime.end.p0(i64 10, ptr %key) #12
  call void @llvm.lifetime.end.p0(i64 100, ptr %name) #12
  ret i32 0
}

; Function Attrs: nounwind uwtable
define dso_local ptr @create_list(i32 noundef %blocksize) #0 {
entry:
  %call = call noalias ptr @malloc(i64 noundef 24) #11
  %tobool = icmp ne ptr %call, null
  br i1 %tobool, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  br label %do.body

do.body:                                          ; preds = %if.then
  %0 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call1 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %0, ptr noundef @.str.49, i32 noundef 31)
  %1 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call2 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %1, ptr noundef @.str.148)
  %2 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call3 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %2, ptr noundef @.str.51)
  br label %do.cond

do.cond:                                          ; preds = %do.body
  br label %do.end

do.end:                                           ; preds = %do.cond
  br label %cleanup

if.end:                                           ; preds = %entry
  %blocksize4 = getelementptr inbounds %struct.List, ptr %call, i32 0, i32 2
  store i32 %blocksize, ptr %blocksize4, align 8, !tbaa !47
  %tail = getelementptr inbounds %struct.List, ptr %call, i32 0, i32 1
  store ptr null, ptr %tail, align 8, !tbaa !49
  %head = getelementptr inbounds %struct.List, ptr %call, i32 0, i32 0
  store ptr null, ptr %head, align 8, !tbaa !50
  br label %cleanup

cleanup:                                          ; preds = %if.end, %do.end
  %retval.0 = phi ptr [ %call, %if.end ], [ null, %do.end ]
  ret ptr %retval.0
}

; Function Attrs: nounwind uwtable
define dso_local i32 @destroy_list(ptr noundef %l) #0 {
entry:
  %head = getelementptr inbounds %struct.List, ptr %l, i32 0, i32 0
  %0 = load ptr, ptr %head, align 8, !tbaa !50
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %lb.0 = phi ptr [ %0, %entry ], [ %1, %while.body ]
  %tobool = icmp ne ptr %lb.0, null
  br i1 %tobool, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %next1 = getelementptr inbounds %struct.ListBlock, ptr %lb.0, i32 0, i32 3
  %1 = load ptr, ptr %next1, align 8, !tbaa !51
  %array = getelementptr inbounds %struct.ListBlock, ptr %lb.0, i32 0, i32 0
  %2 = load ptr, ptr %array, align 8, !tbaa !53
  call void @free(ptr noundef %2) #12
  call void @free(ptr noundef %lb.0) #12
  br label %while.cond, !llvm.loop !54

while.end:                                        ; preds = %while.cond
  call void @free(ptr noundef %l) #12
  ret i32 0
}

; Function Attrs: nounwind uwtable
define dso_local i32 @lget_element(ptr noundef %l, i32 noundef %index) #0 {
entry:
  %i = alloca i32, align 4
  %lb = alloca ptr, align 8
  call void @llvm.lifetime.start.p0(i64 4, ptr %i) #12
  store i32 %index, ptr %i, align 4, !tbaa !6
  call void @llvm.lifetime.start.p0(i64 8, ptr %lb) #12
  %call = call i32 @lfind_index(ptr noundef %l, ptr noundef %lb, ptr noundef %i)
  %0 = load i32, ptr %i, align 4, !tbaa !6
  %1 = load ptr, ptr %lb, align 8, !tbaa !10
  %full = getelementptr inbounds %struct.ListBlock, ptr %1, i32 0, i32 2
  %2 = load i32, ptr %full, align 4, !tbaa !55
  %cmp = icmp sge i32 %0, %2
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  br label %do.body

do.body:                                          ; preds = %if.then
  %3 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call1 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %3, ptr noundef @.str.49, i32 noundef 31)
  %4 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call2 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %4, ptr noundef @.str.149, i32 noundef %index)
  %5 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call3 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %5, ptr noundef @.str.51)
  br label %do.cond

do.cond:                                          ; preds = %do.body
  br label %do.end

do.end:                                           ; preds = %do.cond
  br label %cleanup

if.end:                                           ; preds = %entry
  %6 = load ptr, ptr %lb, align 8, !tbaa !10
  %array = getelementptr inbounds %struct.ListBlock, ptr %6, i32 0, i32 0
  %7 = load ptr, ptr %array, align 8, !tbaa !53
  %8 = load i32, ptr %i, align 4, !tbaa !6
  %idxprom = sext i32 %8 to i64
  %arrayidx = getelementptr inbounds i32, ptr %7, i64 %idxprom
  %9 = load i32, ptr %arrayidx, align 4, !tbaa !6
  br label %cleanup

cleanup:                                          ; preds = %if.end, %do.end
  %retval.0 = phi i32 [ -1, %do.end ], [ %9, %if.end ]
  call void @llvm.lifetime.end.p0(i64 8, ptr %lb) #12
  call void @llvm.lifetime.end.p0(i64 4, ptr %i) #12
  ret i32 %retval.0
}

; Function Attrs: nounwind uwtable
define internal i32 @lfind_index(ptr noundef %l, ptr noundef %lb, ptr noundef %i) #0 {
entry:
  %head = getelementptr inbounds %struct.List, ptr %l, i32 0, i32 0
  %0 = load ptr, ptr %head, align 8, !tbaa !50
  store ptr %0, ptr %lb, align 8, !tbaa !10
  %1 = load i32, ptr %i, align 4, !tbaa !6
  %cmp = icmp slt i32 %1, 0
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  br label %do.body

do.body:                                          ; preds = %if.then
  %2 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %2, ptr noundef @.str.49, i32 noundef 31)
  %3 = load ptr, ptr @stderr, align 8, !tbaa !10
  %4 = load i32, ptr %i, align 4, !tbaa !6
  %call1 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %3, ptr noundef @.str.176, i32 noundef %4)
  %5 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call2 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %5, ptr noundef @.str.51)
  br label %do.end

do.end:                                           ; preds = %do.body
  br label %return

if.end:                                           ; preds = %entry
  br label %while.cond

while.cond:                                       ; preds = %if.end11, %if.end
  %6 = load i32, ptr %i, align 4, !tbaa !6
  %7 = load ptr, ptr %lb, align 8, !tbaa !10
  %size = getelementptr inbounds %struct.ListBlock, ptr %7, i32 0, i32 1
  %8 = load i32, ptr %size, align 8, !tbaa !56
  %cmp3 = icmp sge i32 %6, %8
  br i1 %cmp3, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %tobool = icmp ne ptr %lb, null
  br i1 %tobool, label %if.then4, label %if.else

if.then4:                                         ; preds = %while.body
  %9 = load ptr, ptr %lb, align 8, !tbaa !10
  %next = getelementptr inbounds %struct.ListBlock, ptr %9, i32 0, i32 3
  %10 = load ptr, ptr %next, align 8, !tbaa !51
  store ptr %10, ptr %lb, align 8, !tbaa !10
  %11 = load ptr, ptr %lb, align 8, !tbaa !10
  %size5 = getelementptr inbounds %struct.ListBlock, ptr %11, i32 0, i32 1
  %12 = load i32, ptr %size5, align 8, !tbaa !56
  %13 = load i32, ptr %i, align 4, !tbaa !6
  %sub = sub nsw i32 %13, %12
  store i32 %sub, ptr %i, align 4, !tbaa !6
  br label %if.end11

if.else:                                          ; preds = %while.body
  br label %do.body6

do.body6:                                         ; preds = %if.else
  %14 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call7 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %14, ptr noundef @.str.49, i32 noundef 31)
  %15 = load ptr, ptr @stderr, align 8, !tbaa !10
  %16 = load i32, ptr %i, align 4, !tbaa !6
  %call8 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %15, ptr noundef @.str.149, i32 noundef %16)
  %17 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call9 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %17, ptr noundef @.str.51)
  br label %do.end10

do.end10:                                         ; preds = %do.body6
  br label %return

if.end11:                                         ; preds = %if.then4
  br label %while.cond, !llvm.loop !57

while.end:                                        ; preds = %while.cond
  br label %return

return:                                           ; preds = %while.end, %do.end10, %do.end
  %retval.0 = phi i32 [ -1, %do.end ], [ -1, %do.end10 ], [ 0, %while.end ]
  ret i32 %retval.0
}

; Function Attrs: nounwind uwtable
define dso_local i32 @lset_element(ptr noundef %l, i32 noundef %index, i32 noundef %value) #0 {
entry:
  %i = alloca i32, align 4
  %lb = alloca ptr, align 8
  call void @llvm.lifetime.start.p0(i64 4, ptr %i) #12
  store i32 %index, ptr %i, align 4, !tbaa !6
  call void @llvm.lifetime.start.p0(i64 8, ptr %lb) #12
  %call = call i32 @lfind_index(ptr noundef %l, ptr noundef %lb, ptr noundef %i)
  %tobool = icmp ne i32 %call, 0
  br i1 %tobool, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  br label %cleanup

if.end:                                           ; preds = %entry
  %0 = load i32, ptr %i, align 4, !tbaa !6
  %1 = load ptr, ptr %lb, align 8, !tbaa !10
  %full = getelementptr inbounds %struct.ListBlock, ptr %1, i32 0, i32 2
  %2 = load i32, ptr %full, align 4, !tbaa !55
  %cmp = icmp sge i32 %0, %2
  br i1 %cmp, label %if.then1, label %if.end5

if.then1:                                         ; preds = %if.end
  br label %do.body

do.body:                                          ; preds = %if.then1
  %3 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call2 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %3, ptr noundef @.str.49, i32 noundef 31)
  %4 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call3 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %4, ptr noundef @.str.149, i32 noundef %index)
  %5 = load ptr, ptr @stderr, align 8, !tbaa !10
  %call4 = call i32 (ptr, ptr, ...) @fprintf(ptr noundef %5, ptr noundef @.str.51)
  br label %do.cond

do.cond:                                          ; preds = %do.body
  br label %do.end

do.end:                                           ; preds = %do.cond
  br label %cleanup

if.end5:                                          ; preds = %if.end
  %6 = load ptr, ptr %lb, align 8, !tbaa !10
  %array = getelementptr inbounds %struct.ListBlock, ptr %6, i32 0, i32 0
  %7 = load ptr, ptr %array, align 8, !tbaa !53
  %8 = load i32, ptr %i, align 4, !tbaa !6
  %idxprom = sext i32 %8 to i64
  %arrayidx = getelementptr inbounds i32, ptr %7, i64 %idxprom
  store i32 %value, ptr %arrayidx, align 4, !tbaa !6
  br label %cleanup

cleanup:                                          ; preds = %if.end5, %do.end, %if.then
  %retval.0 = phi i32 [ %call, %if.then ], [ -1, %do.end ], [ 0, %if.end5 ]
  call void @llvm.lifetime.end.p0(i64 8, ptr %lb) #12
  call void @llvm.lifetime.end.p0(i64 4, ptr %i) #12
  ret i32 %retval.0
}

; Function Attrs: nounwind uwtable
define dso_local i32 @ladd_element(ptr noundef %l, i32 noundef %element) #0 {
entry:
  %head = getelementptr inbounds %struct.List, ptr %l, i32 0, i32 0
  %0 = load ptr, ptr %head, align 8, !tbaa !50
  %cmp = icmp eq ptr %0, null
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %call = call ptr @new_block(ptr noundef %l)
  %tail = getelementptr inbounds %struct.List, ptr %l, i32 0, i32 1
  store ptr %call, ptr %tail, align 8, !tbaa !49
  %tail1 = getelementptr inbounds %struct.List, ptr %l, i32 0, i32 1
  %1 = load ptr, ptr %tail1, align 8, !tbaa !49
  %head2 = getelementptr inbounds %struct.List, ptr %l, i32 0, i32 0
  store ptr %1, ptr %head2, align 8, !tbaa !50
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %tail3 = getelementptr inbounds %struct.List, ptr %l, i32 0, i32 1
  %2 = load ptr, ptr %tail3, align 8, !tbaa !49
  %full = getelementptr inbounds %struct.ListBlock, ptr %2, i32 0, i32 2
  %3 = load i32, ptr %full, align 4, !tbaa !55
  %size = getelementptr inbounds %struct.ListBlock, ptr %2, i32 0, i32 1
  %4 = load i32, ptr %size, align 8, !tbaa !56
  %cmp4 = icmp slt i32 %3, %4
  br i1 %cmp4, label %if.then5, label %if.else

if.then5:                                         ; preds = %if.end
  %array = getelementptr inbounds %struct.ListBlock, ptr %2, i32 0, i32 0
  %5 = load ptr, ptr %array, align 8, !tbaa !53
  %full6 = getelementptr inbounds %struct.ListBlock, ptr %2, i32 0, i32 2
  %6 = load i32, ptr %full6, align 4, !tbaa !55
  %inc = add nsw i32 %6, 1
  store i32 %inc, ptr %full6, align 4, !tbaa !55
  %idxprom = sext i32 %6 to i64
  %arrayidx = getelementptr inbounds i32, ptr %5, i64 %idxprom
  store i32 %element, ptr %arrayidx, align 4, !tbaa !6
  br label %if.end16

if.else:                                          ; preds = %if.end
  %call7 = call ptr @new_block(ptr noundef %l)
  %tail8 = getelementptr inbounds %struct.List, ptr %l, i32 0, i32 1
  store ptr %call7, ptr %tail8, align 8, !tbaa !49
  %tail9 = getelementptr inbounds %struct.List, ptr %l, i32 0, i32 1
  %7 = load ptr, ptr %tail9, align 8, !tbaa !49
  %next = getelementptr inbounds %struct.ListBlock, ptr %2, i32 0, i32 3
  store ptr %7, ptr %next, align 8, !tbaa !51
  %next10 = getelementptr inbounds %struct.ListBlock, ptr %2, i32 0, i32 3
  %8 = load ptr, ptr %next10, align 8, !tbaa !51
  %array11 = getelementptr inbounds %struct.ListBlock, ptr %8, i32 0, i32 0
  %9 = load ptr, ptr %array11, align 8, !tbaa !53
  %full12 = getelementptr inbounds %struct.ListBlock, ptr %8, i32 0, i32 2
  %10 = load i32, ptr %full12, align 4, !tbaa !55
  %inc13 = add nsw i32 %10, 1
  store i32 %inc13, ptr %full12, align 4, !tbaa !55
  %idxprom14 = sext i32 %10 to i64
  %arrayidx15 = getelementptr inbounds i32, ptr %9, i64 %idxprom14
  store i32 %element, ptr %arrayidx15, align 4, !tbaa !6
  br label %if.end16

if.end16:                                         ; preds = %if.else, %if.then5
  ret i32 0
}

; Function Attrs: nounwind uwtable
define internal ptr @new_block(ptr noundef %l) #0 {
entry:
  %call = call noalias ptr @malloc(i64 noundef 24) #11
  %cmp = icmp eq ptr %call, null
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  br label %cleanup

if.end:                                           ; preds = %entry
  %blocksize = getelementptr inbounds %struct.List, ptr %l, i32 0, i32 2
  %0 = load i32, ptr %blocksize, align 8, !tbaa !47
  %conv = sext i32 %0 to i64
  %mul = mul i64 %conv, 8
  %call1 = call noalias ptr @malloc(i64 noundef %mul) #11
  %array = getelementptr inbounds %struct.ListBlock, ptr %call, i32 0, i32 0
  store ptr %call1, ptr %array, align 8, !tbaa !53
  %array2 = getelementptr inbounds %struct.ListBlock, ptr %call, i32 0, i32 0
  %1 = load ptr, ptr %array2, align 8, !tbaa !53
  %cmp3 = icmp eq ptr %1, null
  br i1 %cmp3, label %if.then5, label %if.end6

if.then5:                                         ; preds = %if.end
  call void @free(ptr noundef %call) #12
  br label %cleanup

if.end6:                                          ; preds = %if.end
  %full = getelementptr inbounds %struct.ListBlock, ptr %call, i32 0, i32 2
  store i32 0, ptr %full, align 4, !tbaa !55
  %blocksize7 = getelementptr inbounds %struct.List, ptr %l, i32 0, i32 2
  %2 = load i32, ptr %blocksize7, align 8, !tbaa !47
  %size = getelementptr inbounds %struct.ListBlock, ptr %call, i32 0, i32 1
  store i32 %2, ptr %size, align 8, !tbaa !56
  %next = getelementptr inbounds %struct.ListBlock, ptr %call, i32 0, i32 3
  store ptr null, ptr %next, align 8, !tbaa !51
  br label %cleanup

cleanup:                                          ; preds = %if.end6, %if.then5, %if.then
  %retval.0 = phi ptr [ null, %if.then ], [ null, %if.then5 ], [ %call, %if.end6 ]
  ret ptr %retval.0
}

; Function Attrs: nounwind uwtable
define dso_local i32 @basic_100_test() #0 {
entry:
  %0 = load i32, ptr @basic_100_test.BS, align 4, !tbaa !6
  %call = call ptr @create_list(i32 noundef %0)
  %tobool = icmp ne ptr %call, null
  br i1 %tobool, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  br label %cleanup

if.end:                                           ; preds = %entry
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %if.end
  %i.0 = phi i32 [ 0, %if.end ], [ %inc, %for.inc ]
  %1 = load i32, ptr @basic_100_test.TS, align 4, !tbaa !6
  %cmp = icmp slt i32 %i.0, %1
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  br label %for.end

for.body:                                         ; preds = %for.cond
  %call1 = call i32 @ladd_element(ptr noundef %call, i32 noundef %i.0)
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %inc = add nsw i32 %i.0, 1
  br label %for.cond, !llvm.loop !58

for.end:                                          ; preds = %for.cond.cleanup
  br label %for.cond3

for.cond3:                                        ; preds = %for.inc10, %for.end
  %i2.0 = phi i32 [ 0, %for.end ], [ %inc11, %for.inc10 ]
  %2 = load i32, ptr @basic_100_test.TS, align 4, !tbaa !6
  %cmp4 = icmp slt i32 %i2.0, %2
  br i1 %cmp4, label %for.body6, label %for.cond.cleanup5

for.cond.cleanup5:                                ; preds = %for.cond3
  br label %for.end12

for.body6:                                        ; preds = %for.cond3
  %call7 = call i32 @lget_element(ptr noundef %call, i32 noundef %i2.0)
  %cmp8 = icmp eq i32 %call7, %i2.0
  br i1 %cmp8, label %cond.true, label %cond.false

cond.true:                                        ; preds = %for.body6
  br label %cond.end

cond.false:                                       ; preds = %for.body6
  %call9 = call i32 (ptr, ...) @printf(ptr noundef @.str.4, ptr noundef @.str.150, i32 noundef 18, ptr noundef @.str.151)
  br label %cond.end

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi i32 [ 0, %cond.true ], [ 0, %cond.false ]
  br label %for.inc10

for.inc10:                                        ; preds = %cond.end
  %inc11 = add nsw i32 %i2.0, 1
  br label %for.cond3, !llvm.loop !59

for.end12:                                        ; preds = %for.cond.cleanup5
  %call13 = call i32 @destroy_list(ptr noundef %call)
  br label %cleanup

cleanup:                                          ; preds = %for.end12, %if.then
  ret i32 0
}

; Function Attrs: nounwind uwtable
define dso_local i32 @test_list() #0 {
entry:
  call void @testing_setup_internal(ptr noundef @__func__.test_list)
  %call = call i32 @basic_100_test()
  call void @testing_cleanup_internal(ptr noundef @__func__.test_list)
  ret i32 0
}

; Function Attrs: nounwind uwtable
define dso_local i32 @test_util() #0 {
entry:
  call void @testing_setup_internal(ptr noundef @__func__.test_util)
  %call = call i32 @test_hash_init()
  %call1 = call i32 @test_hash_init_and_store()
  %call2 = call i32 @test_hash_set_and_get()
  %call3 = call i32 @test_hash_set_and_double_get()
  call void @testing_cleanup_internal(ptr noundef @__func__.test_util)
  ret i32 0
}

declare i32 @fflush(ptr noundef) #5

; Function Attrs: nounwind uwtable
define dso_local i32 @main() #0 {
entry:
  %call = call i32 @test_lexer()
  %call1 = call i32 @test_x86()
  %call2 = call i32 @test_list()
  %call3 = call i32 @test_util()
  ret i32 0
}

; Function Attrs: nounwind
declare i64 @strtol(ptr noundef, ptr noundef, i32 noundef) #3

attributes #0 = { nounwind uwtable "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+fp-armv8,+neon,+outline-atomics,+v8a,-fmv" }
attributes #1 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { nounwind allocsize(0) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+fp-armv8,+neon,+outline-atomics,+v8a,-fmv" }
attributes #3 = { nounwind "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+fp-armv8,+neon,+outline-atomics,+v8a,-fmv" }
attributes #4 = { nounwind willreturn memory(read) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+fp-armv8,+neon,+outline-atomics,+v8a,-fmv" }
attributes #5 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+fp-armv8,+neon,+outline-atomics,+v8a,-fmv" }
attributes #6 = { noreturn nounwind "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+fp-armv8,+neon,+outline-atomics,+v8a,-fmv" }
attributes #7 = { nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #8 = { nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #9 = { inlinehint nounwind willreturn memory(read) uwtable "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+fp-armv8,+neon,+outline-atomics,+v8a,-fmv" }
attributes #10 = { nounwind allocsize(0,1) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+fp-armv8,+neon,+outline-atomics,+v8a,-fmv" }
attributes #11 = { nounwind allocsize(0) }
attributes #12 = { nounwind }
attributes #13 = { nounwind willreturn memory(read) }
attributes #14 = { noreturn nounwind }
attributes #15 = { nounwind allocsize(0,1) }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{i32 7, !"frame-pointer", i32 1}
!5 = !{!"Ubuntu clang version 17.0.6 (9ubuntu1)"}
!6 = !{!7, !7, i64 0}
!7 = !{!"int", !8, i64 0}
!8 = !{!"omnipotent char", !9, i64 0}
!9 = !{!"Simple C/C++ TBAA"}
!10 = !{!11, !11, i64 0}
!11 = !{!"any pointer", !8, i64 0}
!12 = !{!8, !8, i64 0}
!13 = distinct !{!13, !14, !15}
!14 = !{!"llvm.loop.mustprogress"}
!15 = !{!"llvm.loop.unroll.disable"}
!16 = distinct !{!16, !14, !15}
!17 = !{!18, !19, i64 272}
!18 = !{!"", !11, i64 0, !8, i64 8, !8, i64 264, !19, i64 272, !7, i64 280, !7, i64 284, !7, i64 288, !8, i64 292, !7, i64 2932}
!19 = !{!"long", !8, i64 0}
!20 = !{!18, !7, i64 284}
!21 = !{!18, !7, i64 280}
!22 = !{!18, !11, i64 0}
!23 = !{!18, !7, i64 288}
!24 = !{!25, !8, i64 0}
!25 = !{!"", !8, i64 0, !8, i64 4, !7, i64 260, !8, i64 264, !7, i64 520, !7, i64 524}
!26 = distinct !{!26, !15}
!27 = !{!18, !7, i64 2932}
!28 = !{!25, !7, i64 260}
!29 = !{!25, !7, i64 520}
!30 = !{!25, !7, i64 524}
!31 = distinct !{!31, !15}
!32 = distinct !{!32, !14, !15}
!33 = distinct !{!33, !14, !15}
!34 = distinct !{!34, !14, !15}
!35 = !{i64 0, i64 4, !12, i64 4, i64 256, !12, i64 260, i64 4, !6, i64 264, i64 256, !12, i64 520, i64 4, !6, i64 524, i64 4, !6}
!36 = distinct !{!36, !14, !15}
!37 = distinct !{!37, !14, !15}
!38 = !{!39, !11, i64 0}
!39 = !{!"Hashmap", !11, i64 0, !7, i64 8, !7, i64 12}
!40 = !{!39, !7, i64 8}
!41 = !{!39, !7, i64 12}
!42 = !{!43, !11, i64 0}
!43 = !{!"BucketNode", !11, i64 0, !11, i64 8, !11, i64 16}
!44 = !{!43, !11, i64 8}
!45 = !{!43, !11, i64 16}
!46 = distinct !{!46, !14, !15}
!47 = !{!48, !7, i64 16}
!48 = !{!"List", !11, i64 0, !11, i64 8, !7, i64 16}
!49 = !{!48, !11, i64 8}
!50 = !{!48, !11, i64 0}
!51 = !{!52, !11, i64 16}
!52 = !{!"ListBlock", !11, i64 0, !7, i64 8, !7, i64 12, !11, i64 16}
!53 = !{!52, !11, i64 0}
!54 = distinct !{!54, !14, !15}
!55 = !{!52, !7, i64 12}
!56 = !{!52, !7, i64 8}
!57 = distinct !{!57, !14, !15}
!58 = distinct !{!58, !14, !15}
!59 = distinct !{!59, !14, !15}
