BeginPackage["AST`"]

ParseString::usage = "ParseString[string] returns an abstract syntax tree by interpreting string as WL input. \
Note: If there are multiple expressions in string, then only the last expression is returned. \
ParseString[string, h] wraps the output with h and allows multiple expressions to be returned."

ParseFile::usage = "ParseFile[file] returns an abstract syntax tree by interpreting file as WL input."

TokenizeString::usage = "TokenizeString[string] returns a list of tokens by interpreting string as WL input."

TokenizeFile::usage = "TokenizeFile[file] returns a list of tokens by interpreting file as WL input."


ConcreteParseString::usage = "ConcreteParseString[string] returns a concrete syntax tree by interpreting string as WL input."

ConcreteParseFile::usage = "ConcreteParseFile[file] returns a concrete syntax tree by interpreting file as WL input."




ToInputFormString::usage = "ToInputFormString[concrete] returns a string representation of concrete."
ToFullFormString::usage = "ToFullFormString[abstract] returns a string representation of abstract."

CSTToBoxes
BoxesToCST

ToNode
FromNode

DeclarationName



PrefixOperatorToSymbol
PostfixOperatorToSymbol
BinaryOperatorToSymbol
InfixOperatorToSymbol
TernaryOperatorsToSymbol
GroupOpenerToSymbol
GroupOpenerToCloser
GroupCloserToSymbol
GroupOpenerToMissingCloserSymbol
GroupCloserToMissingOpenerSymbol


SymbolToPrefixOperatorString
SymbolToPostfixOperatorString
SymbolToBinaryOperatorString
SymbolToInfixOperatorString
SymbolToTernaryOperatorString
SymbolToGroupPair
SymbolToTernaryPair



(*

There are some System symbols that are only created when expressions are parsed:

e.g., HermitianConjugate and ImplicitPlus are System symbols that do not exist until expressions
are parsed:

In[1]:= Names["HermitianConjugate"]
Out[1]= {}
In[2]:= ToExpression["a\\[HermitianConjugate]",InputForm,Hold]//FullForm
Out[2]//FullForm= Hold[ConjugateTranspose[a]]
In[3]:= Names["HermitianConjugate"]
Out[3]= {HermitianConjugate}

In[1]:= Names["ImplicitPlus"]
Out[1]= {}
In[2]:= ToExpression["a\\[ImplicitPlus]b",InputForm,Hold]//FullForm
Out[2]//FullForm= Hold[Plus[a,b]]
In[3]:= Names["ImplicitPlus"]
Out[3]= {ImplicitPlus}

These are not documented symbols, so they are apparently side-effects of parsing.

We want to avoid any confusion about this, so we introduce our own symbols here:
AST`PostfixHermitianConjugate and AST`BinaryImplicitPlus

Some examples of these System symbols that are introduced only after parsing:
HermitianConjugate
ImplicitPlus
InvisiblePrefixScriptBase
InvisiblePostfixScriptBase

*)

(*Token*)
Token


(*Character*)
WLCharacter


(* atom symbols *)
(*InternalEmpty*)
OptionalDefault
PatternBlank
PatternBlankSequence
PatternBlankNullSequence
OptionalDefaultPattern

(* operator symbols *)
PrefixLinearSyntaxBang
PrefixInvisiblePrefixScriptBase

PostfixHermitianConjugate
PostfixInvisiblePostfixScriptBase

BinarySlashSlash
BinaryAt
BinaryInvisibleApplication
BinaryAtAtAt

InfixImplicitPlus
ImplicitTimes
InfixInvisibleTimes
InfixTimes

TernaryTilde
TernarySlashColon

(* group symbols *)
(*List*)
GroupMissingOpenerList
GroupMissingCloserList

(*Association*)
GroupMissingOpenerAssociation
GroupMissingCloserAssociation

(*AngleBracket*)
GroupMissingOpenerAngleBracket
GroupMissingCloserAngleBracket

(*Ceiling*)
GroupMissingOpenerCeiling
GroupMissingCloserCeiling

(*Floor*)
GroupMissingOpenerFloor
GroupMissingCloserFloor

GroupDoubleBracket
GroupMissingOpenerDoubleBracket
GroupMissingCloserDoubleBracket

GroupSquare
GroupMissingOpenerSquare
GroupMissingCloserSquare

(*BracketingBar*)
GroupMissingOpenerBracketingBar
GroupMissingCloserBracketingBar

(*DoubleBracketingBar*)
GroupMissingOpenerDoubleBracketingBar
GroupMissingCloserDoubleBracketingBar

GroupParen
GroupMissingOpenerParen
GroupMissingCloserParen

GroupLinearSyntaxParen
GroupMissingOpenerLinearSyntaxParen
GroupMissingCloserLinearSyntaxParen



(* option symbols *)
Source
(*
Used to report f[,] or "\[Alpa]" as an option, e.g. SyntaxIssues -> {SyntaxIssue[], SyntaxIssue[]}
*)
SyntaxIssues
SyntaxIssue




(* node symbols *)
SymbolNode
StringNode
NumberNode
SlotNode
SlotSequenceNode
OutNode
(*InternalEmptyNode*)
PrefixNode
BinaryNode
TernaryNode
InfixNode
PostfixNode
GroupNode
CallNode

BlankNode
BlankSequenceNode
BlankNullSequenceNode
OptionalDefaultNode
PatternBlankNode
PatternBlankSequenceNode
PatternBlankNullSequenceNode
OptionalDefaultPatternNode

(*
InternalTokenNode represents a token in a linear syntax expression
When parsing linear syntax expressions, all tokens are simply kept unparsed
*)
InternalTokenNode

InternalAllNode
InternalDotNode
InternalNullNode
InternalOneNode

FileNode
HoldNode

SyntaxErrorNode
CallMissingCloserNode


InternalInvalid




Begin["`Private`"]

Needs["AST`Abstract`"]
Needs["AST`Boxes`"]
Needs["AST`DeclarationName`"]
Needs["AST`Node`"]
Needs["AST`Symbol`"]
Needs["AST`ToInputFormString`"]
Needs["AST`ToFullFormString`"]
Needs["AST`Utils`"]
Needs["PacletManager`"]


$lib := $lib = FindLibrary["libwl-ast"]


concreteParseStringFunc := concreteParseStringFunc =
	Catch[
	Module[{loaded},
		loaded = LibraryFunctionLoad[$lib, "ConcreteParseString", LinkObject, LinkObject];
		If[FailureQ[loaded]
			Throw[loaded]
		];

		If[Head[loaded] =!= LibraryFunction
			Throw[Failure["LibraryFunctionLoad", <|"Result"->loaded|>]]
		];

		loaded
	]]

concreteParseFileFunc := concreteParseFileFunc =
	Catch[
	Module[{loaded},
		loaded = LibraryFunctionLoad[$lib, "ConcreteParseFile", LinkObject, LinkObject];
		If[FailureQ[loaded]
			Throw[loaded]
		];

		If[Head[loaded] =!= LibraryFunction
			Throw[Failure["LibraryFunctionLoad", <|"Result"->loaded|>]]
		];

		loaded
	]]


ConcreteParseString[s_String, h_:Automatic] :=
	concreteParseString[s, h]

TokenizeString[s_String] :=
	concreteParseString[s, List, "Tokenize"->True]


Options[concreteParseString] = {
	"Tokenize" -> False
}

concreteParseString[sIn_String, hIn_, OptionsPattern[]] :=
Catch[
Module[{s = sIn, h = hIn, res, tokenize},

	If[h === Automatic,
		h = Last
	];

	tokenize = OptionValue["Tokenize"];

	res = concreteParseStringFunc[s, False, False];

	If[FailureQ[res],
		Throw[res]
	];

	h[res]
]]

(*
may return:
a node
or Null if input was an empty string
or something FailureQ if e.g., no permission to run wl-ast
*)
ParseString[s_String, h_:Automatic] :=
Catch[
Module[{parse, ast},
	parse = ConcreteParseString[s, h];

	If[FailureQ[parse],
		Throw[parse]
	];

	ast = Abstract[parse];

	ast
]]


(*
ConcreteParseFile[full_String] returns a FileNode AST or a Failure object
*)
ConcreteParseFile[full_String, h_:Automatic] :=
	concreteParseFile[full, h]

TokenizeFile[full_String] :=
	concreteParseFile[full, List, "Tokenize"->True]



Options[concreteParseFile] = {
	"Tokenize" -> False
}


concreteParseFile[file_String, hIn_, OptionsPattern[]] :=
Catch[
Module[{h, full, strm, b, nonASCII, pos, res, skipFirstLine = False, shebangWarn = False, data, issues, tokenize, firstLine, start, end, children},

	h = hIn;

	(*
	The <||> will be filled in with Source later
	*)
	If[hIn === Automatic,
		h = Function[FileNode[File, {##}, <||>]]
	];

	tokenize = OptionValue["Tokenize"];

	(*
	We want to expand anything like ~ before passing to external process

	FindFile does a better job than AbsoluteFileName because it can handle things like "Foo`" also
	*)
	full = FindFile[file];
	If[FailureQ[full],
		Throw[Failure["FindFileFailed", <|"FileName"->file|>]]
	];

	(*
	figure out if first line is special
	*)
	If[FileByteCount[full] > 0,
		Quiet[
			(*
			Importing a file containing only \n gives a slew of different messages and fails
			bug 363161
			Remove this Quiet when bug is resolved
			*)
			firstLine = Import[full, {"Lines", 1}];
			If[FailureQ[firstLine],
				firstLine = "";
			]
		];
		Which[
			(* special encoded file format *)
			StringMatchQ[firstLine, "(*!1"~~("A"|"B"|"C"|"D"|"H"|"I"|"N"|"O")~~"!*)mcm"],
			Throw[Failure["EncodedFile", <|"FileName"->full|>]]
			,
			(* wl script *)
			StringStartsQ[firstLine, "#!"],
			skipFirstLine = True
			,
			(* looks like a script; warn *)
			StringStartsQ[firstLine, "#"],
			shebangWarn = True;
		];
	];

	res = concreteParseFileFunc[s, False, skipFirstLine];

	If[FailureQ[res],
		If[res === $Failed,
			Throw[res]
		];
		res = Failure[res[[1]], Join[res[[2]], <|"FileName"->full|>]];
		Throw[res]
	];

	(*
	Fill in Source for FileNode now
	*)
	If[hIn === Automatic,
		children = res[[2]];
		(* a file with only newlines would be FileNode[File, {Null}, <||>] *)
		If[children =!= {Null},
			start = First[children][[3]][Source][[1]];
			end = Last[children][[3]][Source][[2]];
			data = res[[3]];
			AssociateTo[data, Source -> {start, end}];
			res[[3]] = data;
		];
	];

	If[shebangWarn,
		data = res[[3]];
		issues = Lookup[data, SyntaxIssues, {}];
		AppendTo[issues, SyntaxIssue["Shebang", "# on first line looks like #! shebang", "Remark", <|Source->{{1, 1}, {1, 1}}|>]];
		AssociateTo[data, SyntaxIssues -> issues];
		res[[3]] = data;
	];

	h[res]
]]

ParseFile[file_String, h_:Automatic] :=
Catch[
Module[{parse, ast},

	parse = ConcreteParseFile[file, h];

	If[FailureQ[parse],
		Throw[parse]
	];

	ast = Abstract[parse];

	ast
]]



End[]

EndPackage[]
