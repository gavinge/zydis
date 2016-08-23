unit untInstructionEditor;

interface

uses
  System.Classes, System.Generics.Collections, SynCrossPlatformJSON;

type
  TInstructionEditor = class;
  TInstructionDefinition = class;
  TDefinitionContainer = class;

  TExtInstructionMode = (
    imNeutral,
    imRequire64BitMode,
    imExclude64BitMode
  );

  TExtMandatoryPrefix = (
    mpNone,
    mpPrefix66,
    mpPrefixF3,
    mpPrefixF2
  );

  TExtModrmMod = (
    mdNeutral,
    mdMemory,
    mdRegister
  );

  TExtModrmReg = (
    rgNeutral,
    rg0,
    rg1,
    rg2,
    rg3,
    rg4,
    rg5,
    rg6,
    rg7
  );

  TExtModrmRm = (
    rmNeutral,
    rm0,
    rm1,
    rm2,
    rm3,
    rm4,
    rm5,
    rm6,
    rm7
  );

  TExtOperandSize = (
    osNeutral,
    os16Bit,
    os32Bit
  );

  TExtAddressSize = (
    asNeutral,
    as16Bit,
    as32Bit,
    as64Bit
  );

  TExtBitFilter = (
    bfRexW,
    bfVexL,
    bfEvexL2,
    bfEvexB
  );

  TExtBitFilters = set of TExtBitFilter;

  TOpcodeExtensions = class(TPersistent)
  strict private
    FDefinition: TInstructionDefinition;
  strict private
    FMode: TExtInstructionMode;
    FMandatoryPrefix: TExtMandatoryPrefix;
    FModrmMod: TExtModrmMod;
    FModrmReg: TExtModrmReg;
    FModrmRm: TExtModrmRm;
    FOperandSize: TExtOperandSize;
    FAddressSize: TExtAddressSize;
    FBitFilters: TExtBitFilters;
  strict private
    procedure SetMode(const Value: TExtInstructionMode); inline;
    procedure SetMandatoryPrefix(const Value: TExtMandatoryPrefix); inline;
    procedure SetModrmMod(const Value: TExtModrmMod); inline;
    procedure SetModrmReg(const Value: TExtModrmReg); inline;
    procedure SetModrmRm(const Value: TExtModrmRm); inline;
    procedure SetOperandSize(const Value: TExtOperandSize); inline;
    procedure SetAddressSize(const Value: TExtAddressSize); inline;
    procedure SetBitFilters(const Value: TExtBitFilters); inline;
  private
    procedure Changed; inline;
  private
    procedure LoadFromJSON(JSON: PJSONVariantData; const FieldName: String);
    procedure SaveToJSON(JSON: PJSONVariantData; const FieldName: String);
    procedure SetPrefix(const Value: TExtMandatoryPrefix);
  protected
    procedure AssignTo(Dest: TPersistent); override;
  protected
    constructor Create(Definition: TInstructionDefinition);
  public
    function Equals(const Value: TOpcodeExtensions): Boolean; reintroduce;
  published
    property Mode: TExtInstructionMode read FMode write SetMode default imNeutral;
    property MandatoryPrefix: TExtMandatoryPrefix read FMandatoryPrefix write
      SetMandatoryPrefix default mpNone;
    property ModrmMod: TExtModrmMod read FModrmMod write SetModrmMod default mdNeutral;
    property ModrmReg: TExtModrmReg read FModrmReg write SetModrmReg default rgNeutral;
    property ModrmRm: TExtModrmRm read FModrmRm write SetModrmRm default rmNeutral;
    property OperandSize: TExtOperandSize read FOperandSize write SetOperandSize default osNeutral;
    property AddressSize: TExtAddressSize read FAddressSize write SetAddressSize default asNeutral;
    property BitFilters: TExtBitFilters read FBitFilters write SetBitFilters default [];
  end;

  TCPUIDFeatureFlag = (
    cf3DNOW,
    cfADX,
    cfAESNI,
    cfAVX,
    cfAVX2,
    cfAVX512BW,
    cfAVX512CD,
    cfAVX512DQ,
    cfAVX512ER,
    cfAVX512F,
    cfAVX512PF,
    cfAVX512VL,
    cfBMI1,
    cfBMI2,
    cfCMOV,
    cfCMPXCHG16B,
    cfF16C,
    cfFMA,
    cfFMA4,
    cfFSGSBASE,
    cfHLE,
    cfLZCNT,
    cfMMX,
    cfMOVBE,
    cfMPX,
    cfPCLMUL,
    cfPOPCNT,
    cfPREFETCHW,
    cfRDRAND,
    cfRDSEED,
    cfRTM,
    cfSHA,
    cfSSE1,
    cfSSE2,
    cfSSE3,
    cfSSE41,
    cfSSE42,
    cfSSE4A,
    cfSSSE3,
    cfTBM,
    cfTSX,
    cfXOP,
    cfFXSR,
    cfLAHFSAHF,
    cfXSAVE,
    cfXSAVES,
    cfXSAVEC,
    cfXSAVEOPT,
    cfMFENCE,
    cfVBMI,
    cfIFMA
  );

  TCPUIDFeatureFlagSet = set of TCPUIDFeatureFlag;

  TCPUIDFeatureFlags = class(TPersistent)
  strict private
    FDefinition: TInstructionDefinition;
    FFeatureFlags: TCPUIDFeatureFlagSet;
  strict private
    procedure SetFeatureFlags(const Value: TCPUIDFeatureFlagSet); inline;
  strict private
    procedure Changed; inline;
  private
    procedure LoadFromJSON(JSON: PJSONVariantData; const FieldName: String);
    procedure SaveToJSON(JSON: PJSONVariantData; const FieldName: String);
  protected
    procedure AssignTo(Dest: TPersistent); override;
  protected
    constructor Create(Definition: TInstructionDefinition);
  public
    function Equals(const Value: TCPUIDFeatureFlags): Boolean; reintroduce;
  public
    property FeatureFlags: TCPUIDFeatureFlagSet read FFeatureFlags write SetFeatureFlags;
  end;

  TX86Register = (
    regNone,
    // General purpose registers 64-bit
    regRAX,    regRCX,    regRDX,   regRBX,    regRSP,   regRBP,   regRSI,   regRDI,
    regR8,     regR9,     regR10,   regR11,    regR12,   regR13,   regR14,   regR15,
    // General purpose registers 32-bit
    regEAX,    regECX,    regEDX,   regEBX,    regESP,   regEBP,   regESI,   regEDI,
    regR8D,    regr9D,    regR10D,  regR11D,   regR12D,  regR13D,  regR14D,  regR15D,
    // General purpose registers 16-bit
    regAX,     regCX,     regDX,    regBX,     regSP,    regBP,    regSI,    regDI,
    regR8W,    regR9W,    regR10W,  regR11W,   regR12W,  regR13W,  regR14W,  regR15W,
    // General purpose registers  8-bit
    regAL,     regCL,     regDL,    regBL,     regAH,    regCH,    regDH,    regBH,
    regSPL,    regBPL,    regSIL,   regDIL,
    regR8B,    regR9B,    regR10B,  regR11B,   regR12B,  regR13B,  regR14B,  regR15B,
    // Floating point legacy registers
    regST0,    regST1,    regST2,   regST3,    regST4,   regST5,   regST6,   regST7,
    // Floating point multimedia registers
    regMM0,    regMM1,    regMM2,   regMM3,    regMM4,   regMM5,   regMM6,   regMM7,
    // Floating point vector registers 512-bit
    regZMM0,   regZMM1,   regZMM2,  regZMM3,   regZMM4,  regZMM5,  regZMM6,  regZMM7,
    regZMM8,   regZMM9,   regZMM10, regZMM11,  regZMM12, regZMM13, regZMM14, regZMM15,
    regZMM16,  regZMM17,  regZMM18, regZMM19,  regZMM20, regZMM21, regZMM22, regZMM23,
    regZMM24,  regZMM25,  regZMM26, regZMM27,  regZMM28, regZMM29, regZMM30, regZMM31,
    // Floating point vector registers 256-bit
    regYMM0,   regYMM1,   regYMM2,  regYMM3,   regYMM4,  regYMM5,  regYMM6,  regYMM7,
    regYMM8,   regYMM9,   regYMM10, regYMM11,  regYMM12, regYMM13, regYMM14, regYMM15,
    regYMM16,  regYMM17,  regYMM18, regYMM19,  regYMM20, regYMM21, regYMM22, regYMM23,
    regYMM24,  regYMM25,  regYMM26, regYMM27,  regYMM28, regYMM29, regYMM30, regYMM31,
    // Floating point vector registers 128-bit
    regXMM0,   regXMM1,   regXMM2,  regXMM3,   regXMM4,  regXMM5,  regXMM6,  regXMM7,
    regXMM8,   regXMM9,   regXMM10, regXMM11,  regXMM12, regXMM13, regXMM14, regXMM15,
    regXMM16,  regXMM17,  regXMM18, regXMM19,  regXMM20, regXMM21, regXMM22, regXMM23,
    regXMM24,  regXMM25,  regXMM26, regXMM27,  regXMM28, regXMM29, regXMM30, regXMM31,
    // Special registers
    regRFLAGS, regEFLAGS, regFLAGS, regRIP,    regEIP,   regIP,
    // Segment registers
    regES,     regCS,     regSS,    regDS,     regGS,    regFS,
    // Control registers
    regCR0,    regCR1,    regCR2,   regCR3,    regCR4,   regCR5,   regCR6,   regCR7,
    regCR8,    regCR9,    regCR10,  regCR11,   regCR12,  regCR13,  regCR14,  regCR15,
    // Debug registers
    regDR0,    regDR1,    regDR2,   regDR3,    regDR4,   regDR5,   regDR6,   regDR7,
    regDR8,    regDR9,    regDR10,  regDR11,   regDR12,  regDR13,  regDR14,  regDR15,
    // Mask registers
    regK0,     regK1,     regK2,    regK3,     regK4,    regK5,    regK6,    regK7,
    // Bounds registers
    regBND0,   regBND1,   regBND2,  regBND3
  );

  TX86RegisterSet = set of TX86Register;

  TX86Registers = class(TPersistent)
  strict private
    FDefinition: TInstructionDefinition;
    FRegisters: TX86RegisterSet;
  strict private
    procedure SetRegisters(const Value: TX86RegisterSet); inline;
  strict private
    procedure Changed; inline;
  private
    procedure LoadFromJSON(JSON: PJSONVariantData; const FieldName: String);
    procedure SaveToJSON(JSON: PJSONVariantData; const FieldName: String);
  protected
    procedure AssignTo(Dest: TPersistent); override;
  protected
    constructor Create(Definition: TInstructionDefinition);
  public
    function Equals(const Value: TX86Registers): Boolean; reintroduce;
  public
    property Registers: TX86RegisterSet read FRegisters write SetRegisters;
  end;

  TX86FlagValue = (
    fvUnused,
    fvTested,
    fvModified,
    fvReset,
    fvSet,
    fvUndefined,
    fvPriorValue
  );

  TX86Flags = class(TPersistent)
  strict private
    FDefinition: TInstructionDefinition;
  strict private
    FCF: TX86FlagValue;
    FPF: TX86FlagValue;
    FAF: TX86FlagValue;
    FZF: TX86FlagValue;
    FSF: TX86FlagValue;
    FTF: TX86FlagValue;
    FIF: TX86FlagValue;
    FDF: TX86FlagValue;
    FOF: TX86FlagValue;
    FRF: TX86FlagValue;
    FVM: TX86FlagValue;
    FAC: TX86FlagValue;
    FVIF: TX86FlagValue;
    FVIP: TX86FlagValue;
    FID: TX86FlagValue;
  strict private
    procedure SetCF(const Value: TX86FlagValue); inline;
    procedure SetPF(const Value: TX86FlagValue); inline;
    procedure SetAF(const Value: TX86FlagValue); inline;
    procedure SetZF(const Value: TX86FlagValue); inline;
    procedure SetSF(const Value: TX86FlagValue); inline;
    procedure SetTF(const Value: TX86FlagValue); inline;
    procedure SetIF(const Value: TX86FlagValue); inline;
    procedure SetDF(const Value: TX86FlagValue); inline;
    procedure SetOF(const Value: TX86FlagValue); inline;
    procedure SetRF(const Value: TX86FlagValue); inline;
    procedure SetVM(const Value: TX86FlagValue); inline;
    procedure SetAC(const Value: TX86FlagValue); inline;
    procedure SetVIF(const Value: TX86FlagValue); inline;
    procedure SetVIP(const Value: TX86FlagValue); inline;
    procedure SetID(const Value: TX86FlagValue); inline;
  strict private
    procedure Changed; inline;
  private
    procedure LoadFromJSON(JSON: PJSONVariantData; const FieldName: String);
    procedure SaveToJSON(JSON: PJSONVariantData; const FieldName: String);
  protected
    procedure AssignTo(Dest: TPersistent); override;
  protected
    constructor Create(Definition: TInstructionDefinition);
  public
    function Equals(const Value: TX86Flags): Boolean; reintroduce;
  published
    { FLAGS }
    property FlagCF: TX86FlagValue read FCF write SetCF default fvUnused;
    property FlagPF: TX86FlagValue read FPF write SetPF default fvUnused;
    property FlagAF: TX86FlagValue read FAF write SetAF default fvUnused;
    property FlagZF: TX86FlagValue read FZF write SetZF default fvUnused;
    property FlagSF: TX86FlagValue read FSF write SetSF default fvUnused;
    property FlagTF: TX86FlagValue read FTF write SetTF default fvUnused;
    property FlagIF: TX86FlagValue read FIF write SetIF default fvUnused;
    property FlagDF: TX86FlagValue read FDF write SetDF default fvUnused;
    property FlagOF: TX86FlagValue read FOF write SetOF default fvUnused;
    { EFLAGS }
    property FlagRF: TX86FlagValue read FRF write SetRF default fvUnused;
    property FlagVM: TX86FlagValue read FVM write SetVM default fvUnused;
    property FlagAC: TX86FlagValue read FAC write SetAC default fvUnused;
    property FlagVIF: TX86FlagValue read FVIF write SetVIF default fvUnused;
    property FlagVIP: TX86FlagValue read FVIP write SetVIP default fvUnused;
    property FlagID: TX86FlagValue read FID write SetID default fvUnused;
  end;

  TInstructionOperands = class;

  TOperandType = (
    optUnused,
    optGPR8,
    optGPR16,
    optGPR32,
    optGPR64,
    optFPR,
    optVR64,
    optVR128,
    optVR256,
    optVR512,
    optCR,
    optDR,
    optSREG,
    optMSKR,
    optBNDR,
    optMem,
    optMem8,
    optMem16,
    optMem32,
    optMem64,
    optMem80,
    optMem128,
    optMem256,
    optMem512,
    optMem32Bcst2,
    optMem32Bcst4,
    optMem32Bcst8,
    optMem32Bcst16,
    optMem64Bcst2,
    optMem64Bcst4,
    optMem64Bcst8,
    optMem64Bcst16,
    optMem32VSIBX,
    optMem32VSIBY,
    optMem32VSIBZ,
    optMem64VSIBX,
    optMem64VSIBY,
    optMem64VSIBZ,
    optMem1616,
    optMem1632,
    optMem1664,
    optMem112,
    optMem224,
    optImm8,
    optImm8U,
    optImm16,
    optImm32,
    optImm64,
    optRel8,
    optRel16,
    optRel32,
    optRel64,
    optPtr1616,
    optPtr1632,
    optPtr1664,
    optMoffs16,
    optMoffs32,
    optMoffs64,
    optSrcIndex8,
    optSrcIndex16,
    optSrcIndex32,
    optSrcIndex64,
    optDstIndex8,
    optDstIndex16,
    optDstIndex32,
    optDstIndex64,
    optFixed1,
    optFixedAL,
    optFixedCL,
    optFixedAX,
    optFixedDX,
    optFixedEAX,
    optFixedRAX,
    optFixedST0,
    optFixedES,
    optFixedSS,
    optFixedCS,
    optFixedDS,
    optFixedFS,
    optFixedGS
  );

  TOperandEncoding = (
    opeNone,
    opeModrmReg,
    opeModrmRm,
    opeModrmRmCD1,
    opeModrmRmCD2,
    opeModrmRmCD4,
    opeModrmRmCD8,
    opeModrmRmCD16,
    opeModrmRmCD32,
    opeModrmRmCD64,
    opeOpcodeBits,
    opeVexVVVV,
    opeEvexAAA,
    opeImm8,
    opeImm16,
    opeImm32,
    opeImm64
  );

  TOperandAccessMode = (
    opaRead,
    opaWrite,
    opaReadWrite
  );

  TInstructionOperand = class(TPersistent)
  strict private
    FOperands: TInstructionOperands;
    FType: TOperandType;
    FEncoding: TOperandEncoding;
    FAccessMode: TOperandAccessMode;
  strict private
    function GetConflictState: Boolean;
    procedure SetType(const Value: TOperandType); inline;
    procedure SetEncoding(const Value: TOperandEncoding); inline;
    procedure SetAccessMode(const Value: TOperandAccessMode); inline;
  strict private
    procedure Changed; inline;
  private
    procedure LoadFromJSON(JSON: PJSONVariantData; const FieldName: String);
    procedure SaveToJSON(JSON: PJSONVariantData; const FieldName: String);
  protected
    procedure AssignTo(Dest: TPersistent); override;
  protected
    constructor Create(Operands: TInstructionOperands);
  public
    function Equals(const Value: TInstructionOperand): Boolean; reintroduce;
  public
    function GetDescription(IncludeAccessMode: Boolean = true): String;
  public
    property HasConflicts: Boolean read GetConflictState;
  published
    property OperandType: TOperandType read FType write SetType default optUnused;
    property Encoding: TOperandEncoding read FEncoding write SetEncoding default opeNone;
    property AccessMode: TOperandAccessMode read FAccessMode write SetAccessMode default opaRead;
  end;

  TInstructionOperands = class(TPersistent)
  strict private
    FDefinition: TInstructionDefinition;
    FOperandA: TInstructionOperand;
    FOperandB: TInstructionOperand;
    FOperandC: TInstructionOperand;
    FOperandD: TInstructionOperand;
  strict private
    function GetConflictState: Boolean;
  private
    procedure Changed; inline;
  private
    function GetOperandById(Id: Integer): TInstructionOperand; inline;
  private
    procedure LoadFromJSON(JSON: PJSONVariantData; const FieldName: String);
    procedure SaveToJSON(JSON: PJSONVariantData; const FieldName: String);
  protected
    procedure AssignTo(Dest: TPersistent); override;
  protected
    constructor Create(Definition: TInstructionDefinition);
  public
    function Equals(const Value: TInstructionOperands): Boolean; reintroduce;
  public
    destructor Destroy; override;
  public
    property HasConflicts: Boolean read GetConflictState;
  published
    property OperandA: TInstructionOperand read FOperandA;
    property OperandB: TInstructionOperand read FOperandB;
    property OperandC: TInstructionOperand read FOperandC;
    property OperandD: TInstructionOperand read FOperandD;
  end;

  TInstructionDefinitionConflict = (
    // This conflict is enforced by the user
    idcForcedConflict,
    // The instruction-operands configuration is invalid
    idcOperands
  );
  TInstructionDefinitionConflicts = set of TInstructionDefinitionConflict;

  TInstructionEncoding = (
    ieDefault,
    ie3DNow,
    ieXOP,
    ieVEX,
    ieEVEX
  );

  TOpcodeMap = (
    omDefault,
    om0F,
    om0F38,
    om0F3A,
    omXOP8,
    omXOP9,
    omXOPA
  );

  TOpcodeByte = type Byte;

  TInstructionDefinitionFlag = (
    ifForceConflict,
    ifAcceptsLock,
    ifAcceptsREP,
    ifAcceptsXACQUIRE,
    ifAcceptsXRELEASE,
    ifAcceptsEVEXAAA,
    ifAcceptsEVEXZ,
    ifHasEVEXBC,
    ifHasEVEXRC,
    ifHasEVEXSAE
  );
  TInstructionDefinitionFlags = set of TInstructionDefinitionFlag;

  TInstructionDefinition = class(TPersistent)
  strict private
    FEditor: TInstructionEditor;
    FParent: TDefinitionContainer;
    FConflicts: TInstructionDefinitionConflicts;
    FData: Pointer;
    FUpdateCount: Integer;
    FDoUpdatePosition: Boolean;
    FDoUpdateValues: Boolean;
  strict private
    FMnemonic: String;
    FEncoding: TInstructionEncoding;
    FOpcodeMap: TOpcodeMap;
    FOpcode: TOpcodeByte;
    FExtensions: TOpcodeExtensions;
    FCPUID: TCPUIDFeatureFlags;
    FOperands: TInstructionOperands;
    FFlags: TInstructionDefinitionFlags;
    FImplicitRead: TX86Registers;
    FImplicitWrite: TX86Registers;
    FX86Flags: TX86Flags;
    FEVEXCD8Scale: Cardinal;
    FComment: String;
  strict private
    function GetConflictState: Boolean; inline;
    procedure SetMnemonic(const Value: String); inline;
    procedure SetEncoding(const Value: TInstructionEncoding); inline;
    procedure SetOpcodeMap(const Value: TOpcodeMap); inline;
    procedure SetOpcode(const Value: TOpcodeByte); inline;
    procedure SetFlags(const Value: TInstructionDefinitionFlags); inline;
    procedure SetComment(const Value: String); inline;
  strict private
    procedure UpdateConflictFlags;
  private
    procedure UpdatePosition; inline;
    procedure UpdateValues; inline;
    procedure SetParent(Parent: TDefinitionContainer); inline;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    procedure BeginUpdate; inline;
    procedure Update; inline;
    procedure EndUpdate; inline;
  public
    function Equals(const Value: TInstructionDefinition): Boolean; reintroduce;
  public
    procedure LoadFromJSON(JSON: PJSONVariantData);
    procedure SaveToJSON(JSON: PJSONVariantData);
  public
    constructor Create(Editor: TInstructionEditor; const Mnemonic: String);
    destructor Destroy; override;
  public
    property Editor: TInstructionEditor read FEditor;
    property Parent: TDefinitionContainer read FParent;
    property HasConflicts: Boolean read GetConflictState;
    property Data: Pointer read FData write FData;
  published
    property Mnemonic: String read FMnemonic write SetMnemonic;
    property Encoding: TInstructionEncoding read FEncoding write SetEncoding default ieDefault;
    property OpcodeMap: TOpcodeMap read FOpcodeMap write SetOpcodeMap default omDefault;
    property Opcode: TOpcodeByte read FOpcode write SetOpcode;
    property OpcodeExtensions: TOpcodeExtensions read FExtensions;
    property CPUID: TCPUIDFeatureFlags read FCPUID;
    property Operands: TInstructionOperands read FOperands;
    property Flags: TInstructionDefinitionFlags read FFlags write SetFlags;
    property ImplicitRead: TX86Registers read FImplicitRead;
    property ImplicitWrite: TX86Registers read FImplicitWrite;
    property X86Flags: TX86Flags read FX86Flags;
    property EVEXCD8Scale: Cardinal read FEVEXCD8Scale default 0;
    property Comment: String read FComment write SetComment;
    property Conflicts: TInstructionDefinitionConflicts read FConflicts;
  end;

  TInstructionFilterFlag = (
    // This is the root table
    iffIsRootTable,
    // This is a static filter that should not be removed.
    // Warning: Never create static tables as child of non-static ones. The code assumes that the
    //          parent of a static-table is always another static table.
    iffIsStaticFilter,
    // This is a definition container and not an actual filter
    iffIsDefinitionContainer
  );
  TInstructionFilterFlags = set of TInstructionFilterFlag;

  TNeutralElementType = (
    // The neutral "zero" element is not supported
    netNotAvailable,
    // The neutral "zero" element is supported and used as a placeholder. The filter will signal a
    // conflict, if the neutral element AND at least one regular value is set.
    netPlaceholder,
    // The neutral "zero" element is supported and can be used as a regular value
    netValue
  );

  TInstructionFilterConflict = (
    // This filter is affected by a conflict of one or more child-filters
    ifcInheritedConflict,
    // This definition-container holds more than one instruction definition
    ifcDefinitionCount,
    // The neutral element and at least one regular value is set
    ifcNeutralElement
  );
  TInstructionFilterConflicts = set of TInstructionFilterConflict;

  TInstructionFilterClass = class of TInstructionFilter;

  PInstructionFilterList = ^TInstructionFilterList;
  TInstructionFilterList = array of TInstructionFilterClass;

  TInstructionFilter = class(TPersistent)
  strict private
    FEditor: TInstructionEditor;
    FParent: TInstructionFilter;
    FItems: TArray<TInstructionFilter>;
    FDefinitions: TList<TInstructionDefinition>;
    FConflicts: TInstructionFilterConflicts;
    FInheritedConflicts: Integer;
    FItemCount: Integer;
    FData: Pointer;
  strict private
    FFilterFlags: TInstructionFilterFlags;
  strict private
    function GetItem(const Index: Integer): TInstructionFilter; inline;
    function GetDefinition(const Index: Integer): TInstructionDefinition; inline;
    function GetDefinitionCount: Integer; inline;
    function GetConflictState: Boolean; inline;
    procedure SetParent(Parent: TInstructionFilter); inline;
    procedure SetConflicts(const Value: TInstructionFilterConflicts); inline;
  strict private
    procedure Changed; inline;
  private
    procedure SetItem(const Index: Integer; const Value: TInstructionFilter); inline;
  private
    procedure IncInheritedConflictCount; inline;
    procedure DecInheritedConflictCount; inline;
  private
    procedure CreateFilterAtIndex(Index: Integer; FilterClass: TInstructionFilterClass;
      IsRootTable, IsStaticFilter: Boolean);
    procedure InsertDefinition(Definition: TInstructionDefinition);
    procedure RemoveDefinition(Definition: TInstructionDefinition);
  protected
    constructor Create(Editor: TInstructionEditor; Parent: TInstructionFilter;
      IsRootTable, IsStaticFilter: Boolean); virtual;
  protected
    property Definitions[const Index: Integer]: TInstructionDefinition read GetDefinition;
    property DefinitionCount: Integer read GetDefinitionCount;
  public
    class function IsDefinitionContainer: Boolean; virtual;
    class function GetNeutralElementType: TNeutralElementType; virtual;
    class function GetCapacity: Cardinal; virtual;
    class function GetInsertPosition(const Definition: TInstructionDefinition): Integer; virtual;
    class function GetDescription: String; virtual;
    class function GetItemDescription(Index: Integer): String; virtual;
  public
    function IndexOf(const Filter: TInstructionFilter): Integer;
  public
    destructor Destroy; override;
  public
    property Editor: TInstructionEditor read FEditor;
    property Parent: TInstructionFilter read FParent;
    property Items[const Index: Integer]: TInstructionFilter read GetItem;
    property HasConflicts: Boolean read GetConflictState;
    property Data: Pointer read FData write FData;
  published
    property FilterFlags: TInstructionFilterFlags read FFilterFlags;
    property NeutralElementType: TNeutralElementType read GetNeutralElementType;
    property Capacity: Cardinal read GetCapacity;
    property Conflicts: TInstructionFilterConflicts read FConflicts;
    property ItemCount: Integer read FItemCount;
  end;

  TDefinitionContainer = class(TInstructionFilter)
  public
    class function IsDefinitionContainer: Boolean; override;
  public
    property Definitions;
  published
    property DefinitionCount;
  end;

  TEditorWorkStartEvent =
    procedure(Sender: TObject; MinWorkCount, MaxWorkCount: Integer) of Object;
  TEditorWorkEvent =
    procedure(Sender: TObject; WorkCount: Integer) of Object;
  TEditorFilterEvent =
    procedure(Sender: TObject; Filter: TInstructionFilter) of Object;
  TEditorDefinitionEvent =
  procedure(Sender: TObject; Definition: TInstructionDefinition) of Object;

  TInstructionEditor = class(TObject)
  strict private
    class var FilterOrderDef: TInstructionFilterList;
    class var FilterOrderXOP: TInstructionFilterList;
    class var FilterOrderVEX: TInstructionFilterList;
    class var FilterOrderEVEX: TInstructionFilterList;
  strict private
    class function GetFilterList(Encoding: TInstructionEncoding): PInstructionFilterList; inline;
  strict private
    FDefinitions: TList<TInstructionDefinition>;
    FRootTable: TInstructionFilter;
    FFilterCount: Integer;
    FUpdateCount: Integer;
    FPreventDefinitionRemoval: Boolean;
  strict private
    FOnWorkStart: TEditorWorkStartEvent;
    FOnWork: TEditorWorkEvent;
    FOnWorkEnd: TNotifyEvent;
    FOnBeginUpdate: TNotifyEvent;
    FOnEndUpdate: TNotifyEvent;
    FOnFilterCreated: TEditorFilterEvent;
    FOnFilterInserted: TEditorFilterEvent;
    FOnFilterChanged: TEditorFilterEvent;
    FOnFilterRemoved: TEditorFilterEvent;
    FOnFilterDestroyed: TEditorFilterEvent;
    FOnDefinitionCreated: TEditorDefinitionEvent;
    FOnDefinitionInserted: TEditorDefinitionEvent;
    FOnDefinitionChanged: TEditorDefinitionEvent;
    FOnDefinitionRemoved: TEditorDefinitionEvent;
    FOnDefinitionDestroyed: TEditorDefinitionEvent;
  strict private
    function GetDefinition(const Index: Integer): TInstructionDefinition; inline;
    function GetDefinitionCount: Integer; inline;
  strict private
    function GetDefinitionTopLevelFilter(Definition: TInstructionDefinition): TInstructionFilter;
  private
    procedure RegisterDefinition(Definition: TInstructionDefinition); inline;
    procedure InsertDefinition(Definition: TInstructionDefinition);
    procedure RemoveDefinition(Definition: TInstructionDefinition); inline;
    procedure UnregisterDefinition(Definition: TInstructionDefinition); inline;
  private
    procedure FilterCreated(Filter: TInstructionFilter); inline;
    procedure FilterInserted(Filter: TInstructionFilter); inline;
    procedure FilterChanged(Filter: TInstructionFilter); inline;
    procedure FilterRemoved(Filter: TInstructionFilter); inline;
    procedure FilterDestroyed(Filter: TInstructionFilter); inline;
    procedure DefinitionInserted(Definition: TInstructionDefinition); inline;
    procedure DefinitionChanged(Definition: TInstructionDefinition); inline;
    procedure DefinitionRemoved(Definition: TInstructionDefinition); inline;
  public
    class constructor Create;
  public
    procedure BeginUpdate; inline;
    procedure EndUpdate; inline;
  public
    procedure LoadFromJSON(JSON: PJSONVariantData);
    procedure SaveToJSON(JSON: PJSONVariantData);
    procedure LoadFromFile(const Filename: String);
    procedure SaveToFile(const Filename: String);
    procedure Reset;
  public
    function CreateDefinition(const Mnemonic: String): TInstructionDefinition; inline;
  public
    constructor Create;
    destructor Destroy; override;
  public
    property RootTable: TInstructionFilter read FRootTable;
    property FilterCount: Integer read FFilterCount;
    property Definitions[const Index: Integer]: TInstructionDefinition read GetDefinition;
    property DefinitionCount: Integer read GetDefinitionCount;
  public
    property OnWorkStart: TEditorWorkStartEvent read FOnWorkStart write FOnWorkStart;
    property OnWork: TEditorWorkEvent read FOnWork write FOnWork;
    property OnWorkEnd: TNotifyEvent read FOnWorkEnd write FOnWorkEnd;
    property OnBeginUpdate: TNotifyEvent read FOnBeginUpdate write FOnBeginUpdate;
    property OnEndUpdate: TNotifyEvent read FOnEndUpdate write FOnEndUpdate;
    property OnFilterCreated: TEditorFilterEvent read FOnFilterCreated write FOnFilterCreated;
    property OnFilterInserted: TEditorFilterEvent read FOnFilterInserted write FOnFilterInserted;
    property OnFilterChanged: TEditorFilterEvent read FOnFilterChanged write FOnFilterChanged;
    property OnFilterRemoved: TEditorFilterEvent read FOnFilterRemoved write FOnFilterRemoved;
    property OnFilterDestroyed: TEditorFilterEvent read FOnFilterDestroyed write FOnFilterDestroyed;
    property OnDefinitionCreated: TEditorDefinitionEvent read FOnDefinitionCreated write
      FOnDefinitionCreated;
    property OnDefinitionInserted: TEditorDefinitionEvent read FOnDefinitionInserted write
      FOnDefinitionInserted;
    property OnDefinitionChanged: TEditorDefinitionEvent read FOnDefinitionChanged write
      FOnDefinitionChanged;
    property OnDefinitionRemoved: TEditorDefinitionEvent read FOnDefinitionRemoved write
      FOnDefinitionRemoved;
    property OnDefinitionDestroyed: TEditorDefinitionEvent read FOnDefinitionDestroyed write
      FOnDefinitionDestroyed;
  end;

  TTableGeneratorStatistics = record
  public
    FilterCount: Integer;
    FilterSize: Cardinal;
    DefinitionCount: Integer;
    DefinitionSize: Cardinal;
    MnemonicCount: Integer;
    MnemonicSize: Cardinal;
  end;

  TGeneratorWorkOperation = (
    woIndexingDefinitions,
    woIndexingFilters,
    woGeneratingFilterFiles,
    woGeneratingDefinitionFiles,
    woGeneratingMnemonicFiles
  );

  TGeneratorWorkStartEvent =
    procedure(Sender: TObject; Operation: TGeneratorWorkOperation; MinWorkCount,
      MaxWorkCount: Integer) of Object;
  TGeneratorWorkEvent =
    procedure(Sender: TObject; WorkCount: Integer) of Object;

  TTableGenerator = class(TObject)
  strict private type
    TIndexedFilterItem = record
    public
      Id: Integer;
      Filter: TInstructionFilter;
      Items: array of TIndexedFilterItem;
      IsRedirect: Boolean;
    end;
    TIndexedDefinitionItem = record
    public
      Id: Integer;
      Definition: TInstructionDefinition;
    end;
  strict private type
    PIndexedFilterList     = ^TIndexedFilterList;
    TIndexedFilterList     = TArray<TPair<TInstructionFilterClass, TArray<TIndexedFilterItem>>>;
    PIndexedDefinitionList = ^TIndexedDefinitionList;
    TIndexedDefinitionList = TArray<TIndexedDefinitionItem>;
    PMnemonicList          = ^TMnemonicList;
    TMnemonicList          = TArray<String>;
  strict private
    FStatistics: TTableGeneratorStatistics;
  strict private
    FOnWorkStart: TGeneratorWorkStartEvent;
    FOnWork: TGeneratorWorkEvent;
    FOnWorkEnd: TNotifyEvent;
  strict private
    procedure WorkStart(Operation: TGeneratorWorkOperation; MinWorkCount: Integer;
      MaxWorkCount: Integer); inline;
    procedure Work(WorkCount: Integer); inline;
    procedure WorkEnd; inline;
  strict private
    procedure CreateEntityLists(Editor: TInstructionEditor;
      var FilterList: TIndexedFilterList;
      var DefinitionList: TIndexedDefinitionList;
      var MnemonicList: TMnemonicList);
  strict private
    procedure GenerateInstructionTable(const OutputDirectory: String;
      const FilterList: PIndexedFilterList; FilterCount: Integer);
    procedure GenerateDefinitionList(const OutputDirectory: String;
      const DefinitionList: PIndexedDefinitionList);
    procedure GenerateMnemonicLists(const OutputDirectory: String;
      const MnemonicList: PMnemonicList);
  public
    procedure GenerateFiles(Editor: TInstructionEditor; const OutputDirectory: String);
  public
    constructor Create;
    destructor Destroy; override;
  public
    property Statistics: TTableGeneratorStatistics read FStatistics;
  public
    property OnWorkStart: TGeneratorWorkStartEvent read FOnWorkStart write FOnWorkStart;
    property OnWork: TGeneratorWorkEvent read FOnWork write FOnWork;
    property OnWorkEnd: TNotifyEvent read FOnWorkEnd write FOnWorkEnd;
  end;

implementation

uses
  System.SysUtils, System.Variants, System.TypInfo, System.Generics.Defaults, untHelperClasses,
  untInstructionFilters;

{$REGION 'Const: JSON strings for TOpcodeExtensions'}
const
  SExtInstructionMode: array[TExtInstructionMode] of String = (
    'neutral',
    'require64',
    'exclude64'
  );

  SExtMandatoryPrefix: array[TExtMandatoryPrefix] of String = (
    'none',
    '66',
    'f3',
    'f2'
  );

  SExtModrmMod: array[TExtModrmMod] of String = (
    'neutral',
    'memory',
    'register'
  );

  SExtModrmReg: array[TExtModrmReg] of String = (
    'neutral',
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7'
  );

  SExtModrmRm: array[TExtModrmRm] of String = (
    'neutral',
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7'
  );

  SExtOperandSize: array[TExtOperandSize] of String = (
    'default',
    '16',
    '32'
  );

  SExtAddressSize: array[TExtAddressSize] of String = (
    'default',
    '16',
    '32',
    '64'
  );

  SExtBitFilter: array[TExtBitFilter] of String = (
    'rex_w',
    'vex_l',
    'evex_l2',
    'evex_b'
  );
{$ENDREGION}

{$REGION 'Const: JSON strings for TCPUIDFeatureFlags'}
const
  SCPUIDFeatureFlag: array[TCPUIDFeatureFlag] of String = (
    '3dnow',
    'adx',
    'aesni',
    'avx',
    'avx2',
    'avx512bw',
    'avx512cd',
    'avx512dq',
    'avx512er',
    'avx512f',
    'avx512pf',
    'avx512vl',
    'bmi1',
    'bmi2',
    'cmov',
    'cmpxchg16b',
    'f16c',
    'fma',
    'fma4',
    'fsgsbase',
    'hle',
    'lzcnt',
    'mmx',
    'movbe',
    'mpx',
    'pclmul',
    'popcnt',
    'prefetchw',
    'rdrand',
    'rdseed',
    'rtm',
    'sha',
    'sse1',
    'sse2',
    'sse3',
    'sse41',
    'sse42',
    'sse4a',
    'ssse3',
    'tbm',
    'tsx',
    'xop',
    'fxsr',
    'lahfsahf',
    'xsave',
    'xsaves',
    'xsavec',
    'xsaveopt',
    'mfence',
    'vbmi',
    'ifma'
  );
{$ENDREGION}

{$REGION 'Const: JSON strings for TX86Registers'}
const
  SX86Register: array[TX86Register] of String = (
    'none',
    // General purpose registers 64-bit
    'rax',    'rcx',    'rdx',   'rbx',    'rsp',   'rbp',   'rsi',   'rdi',
    'r8',     'r9',     'r10',   'r11',    'r12',   'r13',   'r14',   'r15',
    // General purpose registers 32-bit
    'eax',    'ecx',    'edx',   'ebx',    'esp',   'ebp',   'esi',   'edi',
    'r8d',    'r9d',    'r10d',  'r11d',   'r12d',  'r13d',  'r14d',  'r15d',
    // General purpose registers 16-bit
    'ax',     'cx',     'dx',    'bx',     'sp',    'bp',    'si',    'di',
    'r8w',    'r9w',    'r10w',  'r11w',   'r12w',  'r13w',  'r14w',  'r15w',
    // General purpose registers  8-bit
    'al',     'cl',     'dl',    'bl',     'ah',    'ch',    'dh',    'bh',
    'spl',    'bpl',    'sil',   'dil',
    'r8b',    'r9b',    'r10b',  'r11b',   'r12b',  'r13b',  'r14b',  'r15b',
    // Floating point legacy registers
    'st0',    'st1',    'st2',   'st3',    'st4',   'st5',   'st6',   'st7',
    // Floating point multimedia registers
    'mm0',    'mm1',    'mm2',   'mm3',    'mm4',   'mm5',   'mm6',   'mm7',
    // Floating point vector registers 512-bit
    'zmm0',   'zmm1',   'zmm2',  'zmm3',   'zmm4',  'zmm5',  'zmm6',  'zmm7',
    'zmm8',   'zmm9',   'zmm10', 'zmm11',  'zmm12', 'zmm13', 'zmm14', 'zmm15',
    'zmm16',  'zmm17',  'zmm18', 'zmm19',  'zmm20', 'zmm21', 'zmm22', 'zmm23',
    'zmm24',  'zmm25',  'zmm26', 'zmm27',  'zmm28', 'zmm29', 'zmm30', 'zmm31',
    // Floating point vector registers 256-bit
    'ymm0',   'ymm1',   'ymm2',  'ymm3',   'ymm4',  'ymm5',  'ymm6',  'ymm7',
    'ymm8',   'ymm9',   'ymm10', 'ymm11',  'ymm12', 'ymm13', 'ymm14', 'ymm15',
    'ymm16',  'ymm17',  'ymm18', 'ymm19',  'ymm20', 'ymm21', 'ymm22', 'ymm23',
    'ymm24',  'ymm25',  'ymm26', 'ymm27',  'ymm28', 'ymm29', 'ymm30', 'ymm31',
    // Floating point vector registers 128-bit
    'xmm0',   'xmm1',   'xmm2',  'xmm3',   'xmm4',  'xmm5',  'xmm6',  'xmm7',
    'xmm8',   'xmm9',   'xmm10', 'xmm11',  'xmm12', 'xmm13', 'xmm14', 'xmm15',
    'xmm16',  'xmm17',  'xmm18', 'xmm19',  'xmm20', 'xmm21', 'xmm22', 'xmm23',
    'xmm24',  'xmm25',  'xmm26', 'xmm27',  'xmm28', 'xmm29', 'xmm30', 'xmm31',
    // Special registers
    'rflags', 'eflags', 'flags', 'rip',    'eip',   'ip',
    // Segment registers
    'es',     'cs',     'ss',    'ds',     'gs',    'fs',
    // Control registers
    'cr0',    'cr1',    'cr2',   'cr3',    'cr4',   'cr5',   'cr6',   'cr7',
    'cr8',    'cr9',    'cr10',  'cr11',   'cr12',  'cr13',  'cr14',  'cr15',
    // Debug registers
    'dr0',    'dr1',    'dr2',   'dr3',    'dr4',   'dr5',   'dr6',   'dr7',
    'dr8',    'dr9',    'dr10',  'dr11',   'dr12',  'dr13',  'dr14',  'dr15',
    // Mask registers
    'k0',     'k1',     'k2',    'k3',     'k4',    'k5',     'k6',   'k7',
    // Bounds registers
    'bnd0',   'bnd1',   'bnd2',  'bnd3'
  );
{$ENDREGION}

{$REGION 'Const: JSON strings for TX86Flags'}
const
  SX86FlagValue: array[TX86FlagValue] of String = (
    'unused',
    'tested',
    'modified',
    'reset',
    'set',
    'undefined',
    'prior'
  );
{$ENDREGION}

{$REGION 'Const: JSON strings for TInstructionOperand'}
const
  SOperandType: array[TOperandType] of String = (
    'unused',
    'gpr8',
    'gpr16',
    'gpr32',
    'gpr64',
    'fpr',
    'vr64',
    'vr128',
    'vr256',
    'vr512',
    'cr',
    'dr',
    'sreg',
    'mskr',
    'bndr',
    'mem',
    'mem8',
    'mem16',
    'mem32',
    'mem64',
    'mem80',
    'mem128',
    'mem256',
    'mem512',
    'mem32bcst2',
    'mem32bcst4',
    'mem32bcst8',
    'mem32bcst16',
    'mem64bcst2',
    'mem64bcst4',
    'mem64bcst8',
    'mem64bcst16',
    'mem32vsibx',
    'mem32vsiby',
    'mem32vsibz',
    'mem64vsibx',
    'mem64vsiby',
    'mem64vsibz',
    'mem1616',
    'mem1632',
    'mem1664',
    'mem112',
    'mem224',
    'imm8',
    'imm8u',
    'imm16',
    'imm32',
    'imm64',
    'rel8',
    'rel16',
    'rel32',
    'rel64',
    'ptr1616',
    'ptr1632',
    'ptr1664',
    'moffs16',
    'moffs32',
    'moffs64',
    'srcidx8',
    'srcidx16',
    'srcidx32',
    'srcidx64',
    'dstidx8',
    'dstidx16',
    'dstidx32',
    'dstidx64',
    '1',
    'al',
    'cl',
    'ax',
    'dx',
    'eax',
    'rax',
    'st0',
    'es',
    'ss',
    'cs',
    'ds',
    'fs',
    'gs'
  );

  SOperandEncoding: array[TOperandEncoding] of String = (
    'none',
    'modrm_reg',
    'modrm_rm',
    'modrm_rm_cd1',
    'modrm_rm_cd2',
    'modrm_rm_cd4',
    'modrm_rm_cd8',
    'modrm_rm_cd16',
    'modrm_rm_cd32',
    'modrm_rm_cd64',
    'opcode',
    'vex_vvvv',
    'evex_aaa',
    'imm8',
    'imm16',
    'imm32',
    'imm64'
  );

  SOperandAccessMode: array[TOperandAccessMode] of String = (
    'read',
    'write',
    'readwrite'
  );
{$ENDREGION}

{$REGION 'Const: JSON strings for TInstructionDefinition'}
const
  SInstructionEncoding: array[TInstructionEncoding] of String = (
    'default',
    '3dnow',
    'xop',
    'vex',
    'evex'
  );

  SOpcodeMap: array[TOpcodeMap] of String = (
    'default',
    '0f',
    '0f38',
    '0f3a',
    'xop8',
    'xop9',
    'xopa'
  );

  SInstructionDefinitionFlag: array[TInstructionDefinitionFlag] of String = (
    'conflict',
    'accepts_lock',
    'accepts_rep',
    'accepts_xacquire',
    'accepts_xrelease',
    'accepts_evex_aaa',
    'accepts_evex_z',
    'has_evex_bc',
    'has_evex_rc',
    'has_evex_sae'
  );
{$ENDREGION}

{$REGION 'Class: TJSONEnumHelper'}
type
  TJSONEnumHelper = record
  private
    class function ReadString(JSON: PJSONVariantData; const Name, Default: String;
      const LowerCase: Boolean = true): String; static; inline;
  public
    class function ReadEnumValueFromString(JSON: PJSONVariantData; const Name: String;
      const Values: array of String): Integer; static;
  end;

class function TJSONEnumHelper.ReadEnumValueFromString(JSON: PJSONVariantData; const Name: String;
  const Values: array of String): Integer;
begin
  Result := TStringHelper.IndexStr(ReadString(JSON, Name, Values[0]), Values);
  if (Result < 0) then
  begin
    raise Exception.CreateFmt('The "%s" field contains an invalid enum value.', [Name]);
  end;
end;

class function TJSONEnumHelper.ReadString(JSON: PJSONVariantData; const Name, Default: String;
  const LowerCase: Boolean): String;
var
  V: Variant;
begin
  V := JSON^.Value[Name];
  if (VarIsEmpty(V)) then
  begin
    Exit(Default);
  end;
  Result := V;
  if (LowerCase) then
  begin
    TStringHelper.AnsiLowerCase(Result);
  end;
end;
{$ENDREGION}

{$REGION 'Class: TOpcodeExtensions'}
procedure TOpcodeExtensions.AssignTo(Dest: TPersistent);
var
  D: TOpcodeExtensions;
begin
  if (Dest is TOpcodeExtensions) then
  begin
    D := Dest as TOpcodeExtensions;
    D.FMode := FMode;
    D.FMandatoryPrefix := FMandatoryPrefix;
    D.FModrmMod := FModrmMod;
    D.FModrmReg := FModrmReg;
    D.FModrmRm := FModrmRm;
    D.FOperandSize := FOperandSize;
    D.FAddressSize := FAddressSize;
    D.FBitFilters := FBitFilters;
    D.Changed;
  end else inherited;
end;

procedure TOpcodeExtensions.Changed;
begin
  FDefinition.UpdatePosition;
end;

constructor TOpcodeExtensions.Create(Definition: TInstructionDefinition);
begin
  inherited Create;
  FDefinition := Definition;
end;

function TOpcodeExtensions.Equals(const Value: TOpcodeExtensions): Boolean;
begin
  Result :=
    (Value.FMode = FMode) and (Value.FMandatoryPrefix = FMandatoryPrefix) and
    (Value.FModrmMod = FModrmMod) and (Value.FModrmReg = FModrmReg) and
    (Value.FModrmRm = FModrmRm) and (Value.FOperandSize = FOperandSize) and
    (Value.FAddressSize = FAddressSize) and (Value.FBitFilters = FBitFilters);
end;

procedure TOpcodeExtensions.LoadFromJSON(JSON: PJSONVariantData; const FieldName: String);
var
  V, A: PJSONVariantData;
  I: Integer;
  F: TExtBitFilter;
  BitFilters: TExtBitFilters;
begin
  V := JSON.Data(FieldName);
  if (Assigned(V)) then
  begin
    if (V^.Kind <> jvObject) then
    begin
      raise Exception.CreateFmt('The "%s" field is not a valid JSON object.', [FieldName]);
    end;
    I := TJSONEnumHelper.ReadEnumValueFromString(V, 'mode',      SExtInstructionMode);
    SetMode(TExtInstructionMode(I));
    I := TJSONEnumHelper.ReadEnumValueFromString(V, 'prefix',    SExtMandatoryPrefix);
    SetPrefix(TExtMandatoryPrefix(I));
    I := TJSONEnumHelper.ReadEnumValueFromString(V, 'modrm_mod', SExtModrmMod);
    SetModrmMod(TExtModrmMod(I));
    I := TJSONEnumHelper.ReadEnumValueFromString(V, 'modrm_reg', SExtModrmReg);
    SetModrmReg(TExtModrmReg(I));
    I := TJSONEnumHelper.ReadEnumValueFromString(V, 'modrm_rm',  SExtModrmRm);
    SetModrmRm(TExtModrmRm(I));
    I := TJSONEnumHelper.ReadEnumValueFromString(V, 'opsize',    SExtOperandSize);
    SetOperandSize(TExtOperandSize(I));
    I := TJSONEnumHelper.ReadEnumValueFromString(V, 'adsize',    SExtAddressSize);
    SetAddressSize(TExtAddressSize(I));
    A := V^.Data('bitfilters');
    if (Assigned(A)) then
    begin
      if (A^.Kind <> jvArray) then
      begin
        raise Exception.Create('The "prefix_flags" field is not a valid JSON array.');
      end;
      BitFilters := [];
      for I := 0 to A^.Count - 1 do
      begin
        for F := Low(SExtBitFilter) to High(SExtBitFilter) do
        begin
          if (LowerCase(A^.Item[I]) = SExtBitFilter[F]) then
          begin
            BitFilters := BitFilters + [F];
            Break;
          end;
        end;
      end;
      SetBitFilters(BitFilters);
    end;
  end;
end;

procedure TOpcodeExtensions.SaveToJSON(JSON: PJSONVariantData; const FieldName: String);
var
  V, A: TJSONVariantData;
  F: TExtBitFilter;
begin
  V.Init;
  if (FMode <> imNeutral) then
    V.AddNameValue('mode', SExtInstructionMode[FMode]);
  if (FMandatoryPrefix <> mpNone) then
    V.AddNameValue('prefix', SExtMandatoryPrefix[FMandatoryPrefix]);
  if (FModrmMod <> mdNeutral) then
    V.AddNameValue('modrm_mod', SExtModrmMod[FModrmMod]);
  if (FModrmRm <> rmNeutral) then
    V.AddNameValue('modrm_rm', SExtModrmRm[FModrmRm]);
  if (FModrmReg <> rgNeutral) then
    V.AddNameValue('modrm_reg', SExtModrmReg[FModrmReg]);
  if (FOperandSize <> osNeutral) then
    V.AddNameValue('opsize', SExtOperandSize[FOperandSize]);
  if (FAddressSize <> asNeutral) then
    V.AddNameValue('adsize', SExtAddressSize[FAddressSize]);
  A.Init;
  for F in FBitFilters do
  begin
    A.AddValue(SExtBitFilter[F]);
  end;
  if (A.Count > 0) then
  begin
    V.AddNameValue('bitfilters', Variant(A));
  end;
  if (V.Count > 0) then
  begin
    JSON^.AddNameValue(FieldName, Variant(V));
  end;
end;

procedure TOpcodeExtensions.SetAddressSize(const Value: TExtAddressSize);
begin
  if (FAddressSize <> Value) then
  begin
    FAddressSize := Value;
    Changed;
  end;
end;

procedure TOpcodeExtensions.SetBitFilters(const Value: TExtBitFilters);
begin
  if (FBitFilters <> Value) then
  begin
    FBitFilters := Value;
    Changed;
  end;
end;

procedure TOpcodeExtensions.SetMandatoryPrefix(const Value: TExtMandatoryPrefix);
begin
  if (FMandatoryPrefix <> Value) then
  begin
    FMandatoryPrefix := Value;
    Changed;
  end;
end;

procedure TOpcodeExtensions.SetMode(const Value: TExtInstructionMode);
begin
  if (FMode <> Value) then
  begin
    FMode := Value;
    Changed;
  end;
end;

procedure TOpcodeExtensions.SetModrmMod(const Value: TExtModrmMod);
begin
  if (FModrmMod <> Value) then
  begin
    FModrmMod := Value;
    Changed;
  end;
end;

procedure TOpcodeExtensions.SetModrmReg(const Value: TExtModrmReg);
begin
  if (FModrmReg <> Value) then
  begin
    FModrmReg := Value;
    Changed;
  end;
end;

procedure TOpcodeExtensions.SetModrmRm(const Value: TExtModrmRm);
begin
  if (FModrmRm <> Value) then
  begin
    FModrmRm := Value;
    Changed;
  end;
end;

procedure TOpcodeExtensions.SetOperandSize(const Value: TExtOperandSize);
begin
  if (FOperandSize <> Value) then
  begin
    FOperandSize := Value;
    Changed;
  end;
end;

procedure TOpcodeExtensions.SetPrefix(const Value: TExtMandatoryPrefix);
begin
  FMandatoryPrefix := Value;
end;
{$ENDREGION}

{$REGION 'Class: TCPUIDFeatureFlags'}
procedure TCPUIDFeatureFlags.AssignTo(Dest: TPersistent);
var
  D: TCPUIDFeatureFlags;
begin
  if (Dest is TCPUIDFeatureFlags) then
  begin
    D := Dest as TCPUIDFeatureFlags;
    D.SetFeatureFlags(FFeatureFlags);
  end else inherited;
end;

procedure TCPUIDFeatureFlags.Changed;
begin
  FDefinition.UpdateValues;
end;

constructor TCPUIDFeatureFlags.Create(Definition: TInstructionDefinition);
begin
  inherited Create;
  FDefinition := Definition;
end;

function TCPUIDFeatureFlags.Equals(const Value: TCPUIDFeatureFlags): Boolean;
begin
  Result := (Value.FFeatureFlags = FFeatureFlags);
end;

procedure TCPUIDFeatureFlags.LoadFromJSON(JSON: PJSONVariantData; const FieldName: String);
var
  A: PJSONVariantData;
  I: Integer;
  C: TCPUIDFeatureFlag;
  Value: TCPUIDFeatureFlagSet;
begin
  A := JSON.Data(FieldName);
  if (Assigned(A)) then
  begin
    if (A^.Kind <> jvArray) then
    begin
      raise Exception.CreateFmt('The "%s" field is not a valid JSON array.', [FieldName]);
    end;
    Value := [];
    for I := 0 to A^.Count - 1 do
    begin
      for C := Low(SCPUIDFeatureFlag) to High(SCPUIDFeatureFlag) do
      begin
        if (LowerCase(A^.Item[I]) = SCPUIDFeatureFlag[C]) then
        begin
          Value := Value + [C];
          Break;
        end;
      end;
    end;
    SetFeatureFlags(Value);
  end;
end;

procedure TCPUIDFeatureFlags.SaveToJSON(JSON: PJSONVariantData; const FieldName: String);
var
  A: TJSONVariantData;
  C: TCPUIDFeatureFlag;
begin
  A.Init;
  for C in FFeatureFlags do
  begin
    A.AddValue(SCPUIDFeatureFlag[C]);
  end;
  if (A.Count > 0) then
  begin
    JSON.AddNameValue(FieldName, Variant(A));
  end;
end;

procedure TCPUIDFeatureFlags.SetFeatureFlags(const Value: TCPUIDFeatureFlagSet);
begin
  if (FFeatureFlags <> Value) then
  begin
    FFeatureFlags := Value;
    Changed;
  end;
end;
{$ENDREGION}

{$REGION 'Class: TX86Registers'}
procedure TX86Registers.AssignTo(Dest: TPersistent);
var
  D: TX86Registers;
begin
  if (Dest is TX86Registers) then
  begin
    D := Dest as TX86Registers;
    D.SetRegisters(FRegisters);
  end else inherited;
end;

procedure TX86Registers.Changed;
begin
  FDefinition.UpdateValues;
end;

constructor TX86Registers.Create(Definition: TInstructionDefinition);
begin
  inherited Create;
  FDefinition := Definition;
end;

function TX86Registers.Equals(const Value: TX86Registers): Boolean;
begin
  Result := (Value.FRegisters = FRegisters);
end;

procedure TX86Registers.LoadFromJSON(JSON: PJSONVariantData; const FieldName: String);
var
  A: PJSONVariantData;
  I: Integer;
  R: TX86Register;
  Value: TX86RegisterSet;
begin
  A := JSON^.Data(FieldName);
  if (Assigned(A)) then
  begin
    if (A^.Kind <> jvArray) then
    begin
      raise Exception.CreateFmt('The "%s" field is not a valid JSON array.', [FieldName]);
    end;
    Value := [];
    for I := 0 to A^.Count - 1 do
    begin
      for R := Low(SX86Register) to High(SX86Register) do
      begin
        if (LowerCase(A^.Item[I]) = SX86Register[R]) then
        begin
          Value := Value + [R];
          Break;
        end;
      end;
    end;
    SetRegisters(Value);
  end;
end;

procedure TX86Registers.SaveToJSON(JSON: PJSONVariantData; const FieldName: String);
var
  A: TJSONVariantData;
  R: TX86Register;
begin
  A.Init;
  for R in FRegisters do
  begin
    A.AddValue(SX86Register[R]);
  end;
  if (A.Count > 0) then
  begin
    JSON.AddNameValue(FieldName, Variant(A));
  end;
end;

procedure TX86Registers.SetRegisters(const Value: TX86RegisterSet);
begin
  if (FRegisters <> Value) then
  begin
    FRegisters := Value;
    Changed;
  end;
end;
{$ENDREGION}

{$REGION 'Class: TX86Flags'}
procedure TX86Flags.AssignTo(Dest: TPersistent);
var
  D: TX86Flags;
begin
  if (Dest is TX86Flags) then
  begin
    D := Dest as TX86Flags;
    D.FCF := FCF;
    D.FPF := FPF;
    D.FAF := FAF;
    D.FZF := FZF;
    D.FSF := FSF;
    D.FTF := FTF;
    D.FIF := FIF;
    D.FDF := FDF;
    D.FOF := FOF;
    D.FRF := FRF;
    D.FVM := FVM;
    D.FAC := FAC;
    D.FVIF := FVIF;
    D.FVIP := FVIP;
    D.FID := FID;
    D.Changed;
  end else inherited;
end;

procedure TX86Flags.Changed;
begin
  FDefinition.UpdateValues;
end;

constructor TX86Flags.Create(Definition: TInstructionDefinition);
begin
  inherited Create;
  FDefinition := Definition;
end;

function TX86Flags.Equals(const Value: TX86Flags): Boolean;
begin
  Result := (Value.FCF = FCF) and (Value.FPF = FPF) and (Value.FAF = FAF) and
    (Value.FZF = FZF) and (Value.FSF = FSF) and (Value.FTF = FTF) and (Value.FIF = FIF) and
    (Value.FDF = FDF) and (Value.FOF = FOF) and (Value.FRF = FRF) and (Value.FVM = FVM) and
    (Value.FAC = FAC) and (Value.FVIF = FVIF) and (Value.FVIP = FVIP) and (Value.FID = FID);
end;

procedure TX86Flags.LoadFromJSON(JSON: PJSONVariantData; const FieldName: String);
var
  C: PJSONVariantData;
  F: array[0..14] of ^TX86FlagValue;
  N: array[0..14] of String;
  I, J: Integer;
begin
  C := JSON.Data(FieldName);
  if (Assigned(C)) then
  begin
    if (C^.Kind <> jvObject) then
    begin
      raise Exception.CreateFmt('The "%s" field is not a valid JSON object.', [FieldName]);
    end;
    F[ 0] := @FCF;  F[ 1] := @FPF;  F[ 2] := @FAF;  F[ 3] := @FZF;  F[ 4] := @FSF;
    F[ 5] := @FTF;  F[ 6] := @FIF;  F[ 7] := @FDF;  F[ 8] := @FOF;  F[ 9] := @FRF;
    F[10] := @FVM;  F[11] := @FAC;  F[12] := @FVIF; F[13] := @FVIP; F[14] := @FID;
    N[ 0] := 'cf';  N[ 1] := 'pf';  N[ 2] := 'af';  N[ 3] := 'zf';  N[ 4] := 'sf';
    N[ 5] := 'tf';  N[ 6] := 'if';  N[ 7] := 'df';  N[ 8] := 'of';  N[ 9] := 'rf';
    N[10] := 'vm';  N[11] := 'ac';  N[12] := 'vif'; N[13] := 'vip'; N[14] := 'id';
    for I := Low(N) to High(N) do
    begin
      J := TJSONEnumHelper.ReadEnumValueFromString(C, N[I], SX86FlagValue);
      F[I]^ := TX86FlagValue(J);
    end;
    Changed;
  end;
end;

procedure TX86Flags.SaveToJSON(JSON: PJSONVariantData; const FieldName: String);
var
  F: array[0..14] of ^TX86FlagValue;
  N: array[0..14] of String;
  J: TJSONVariantData;
  I: Integer;
begin
  F[ 0] := @FCF;  F[ 1] := @FPF;  F[ 2] := @FAF;  F[ 3] := @FZF;  F[ 4] := @FSF;
  F[ 5] := @FTF;  F[ 6] := @FIF;  F[ 7] := @FDF;  F[ 8] := @FOF;  F[ 9] := @FRF;
  F[10] := @FVM;  F[11] := @FAC;  F[12] := @FVIF; F[13] := @FVIP; F[14] := @FID;
  N[ 0] := 'cf';  N[ 1] := 'pf';  N[ 2] := 'af';  N[ 3] := 'zf';  N[ 4] := 'sf';
  N[ 5] := 'tf';  N[ 6] := 'if';  N[ 7] := 'df';  N[ 8] := 'of';  N[ 9] := 'rf';
  N[10] := 'vm';  N[11] := 'ac';  N[12] := 'vif'; N[13] := 'vip'; N[14] := 'id';
  J.Init;
  for I := Low(N) to High(N) do
  begin
    if (F[I]^ <> fvUnused) then
    begin
      J.AddNameValue(N[I], SX86FlagValue[F[I]^]);
    end;
  end;
  if (J.Count > 0) then
  begin
    JSON.AddNameValue(FieldName, Variant(J));
  end;
end;

procedure TX86Flags.SetAC(const Value: TX86FlagValue);
begin
  if (FAC <> Value) then
  begin
    FAC := Value;
    Changed;
  end;
end;

procedure TX86Flags.SetAF(const Value: TX86FlagValue);
begin
  if (FAF <> Value) then
  begin
    FAF := Value;
    Changed;
  end;
end;

procedure TX86Flags.SetCF(const Value: TX86FlagValue);
begin
  if (FCF <> Value) then
  begin
    FCF := Value;
    Changed;
  end;
end;

procedure TX86Flags.SetDF(const Value: TX86FlagValue);
begin
  if (FDF <> Value) then
  begin
    FDF := Value;
    Changed;
  end;
end;

procedure TX86Flags.SetID(const Value: TX86FlagValue);
begin
  if (FID <> Value) then
  begin
    FID := Value;
    Changed;
  end;
end;

procedure TX86Flags.SetIF(const Value: TX86FlagValue);
begin
  if (FIF <> Value) then
  begin
    FIF := Value;
    Changed;
  end;
end;

procedure TX86Flags.SetOF(const Value: TX86FlagValue);
begin
  if (FOF <> Value) then
  begin
    FOF := Value;
    Changed;
  end;
end;

procedure TX86Flags.SetPF(const Value: TX86FlagValue);
begin
  if (FPF <> Value) then
  begin
    FPF := Value;
    Changed;
  end;
end;

procedure TX86Flags.SetRF(const Value: TX86FlagValue);
begin
  if (FRF <> Value) then
  begin
    FRF := Value;
    Changed;
  end;
end;

procedure TX86Flags.SetSF(const Value: TX86FlagValue);
begin
  if (FSF <> Value) then
  begin
    FSF := Value;
    Changed;
  end;
end;

procedure TX86Flags.SetTF(const Value: TX86FlagValue);
begin
  if (FTF <> Value) then
  begin
    FTF := Value;
    Changed;
  end;
end;

procedure TX86Flags.SetVIF(const Value: TX86FlagValue);
begin
  if (FVIF <> Value) then
  begin
    FVIF := Value;
    Changed;
  end;
end;

procedure TX86Flags.SetVIP(const Value: TX86FlagValue);
begin
  if (FVIP <> Value) then
  begin
    FVIP := Value;
    Changed;
  end;
end;

procedure TX86Flags.SetVM(const Value: TX86FlagValue);
begin
  if (FVM <> Value) then
  begin
    FVM := Value;
    Changed;
  end;
end;

procedure TX86Flags.SetZF(const Value: TX86FlagValue);
begin
  if (FZF <> Value) then
  begin
    FZF := Value;
    Changed;
  end;
end;
{$ENDREGION}

{$REGION 'Class: TInstructionOperand'}
procedure TInstructionOperand.AssignTo(Dest: TPersistent);
var
  D: TInstructionOperand;
begin
  if (Dest is TInstructionOperand) then
  begin
    D := Dest as TInstructionOperand;
    D.FType := FType;
    D.FEncoding := FEncoding;
    D.FAccessMode := FAccessMode;
    D.Changed;
  end else inherited;
end;

procedure TInstructionOperand.Changed;
begin
  FOperands.Changed;
end;

constructor TInstructionOperand.Create(Operands: TInstructionOperands);
begin
  inherited Create;
  FOperands := Operands;
end;

function TInstructionOperand.Equals(const Value: TInstructionOperand): Boolean;
begin
  Result :=
    (Value.FType = FType) and (Value.FEncoding = FEncoding) and (Value.FAccessMode = FAccessMode);
end;

function TInstructionOperand.GetConflictState: Boolean;
begin
  Result := false;
  case FType of
    optGPR8,
    optGPR16:
      Result := not (FEncoding in [opeModrmReg, opeModrmRm, opeOpcodeBits]);
    optGPR32,
    optGPR64:
      Result := not (FEncoding in [opeModrmReg, opeModrmRm, opeOpcodeBits, opeVexVVVV]);
    optFPR:
      Result := not (FEncoding in [opeModrmRm]);
    optVR64:
      Result := not (FEncoding in [opeModrmReg, opeModrmRm]);
    optVR128,
    optVR256,
    optVR512:
      Result := not (FEncoding in [opeModrmReg, opeModrmRm, opeVexVVVV, opeImm8, opeModrmRmCD1,
        opeModrmRmCD2, opeModrmRmCD4, opeModrmRmCD8, opeModrmRmCD16, opeModrmRmCD32,
        opeModrmRmCD64]);
    optCR,
    optDR,
    optSREG:
      Result := not (FEncoding in [opeModrmReg]);
    optMSKR:
      Result := not (FEncoding in [opeModrmReg, opeModrmRm, opeVexVVVV]);
    optBNDR:
      Result := not (FEncoding in [opeModrmReg, opeModrmRm]);
    optMem:
      Result := not (FEncoding in [opeModrmRm]);
    optMem8,
    optMem16,
    optMem32,
    optMem64:
      Result := not (FEncoding in [opeModrmRm, opeModrmRmCD1, opeModrmRmCD2, opeModrmRmCD4,
        opeModrmRmCD8, opeModrmRmCD16, opeModrmRmCD32, opeModrmRmCD64]);
    optMem80:
      Result := not (FEncoding in [opeModrmRm]);
    optMem128,
    optMem256,
    optMem512:
      Result := not (FEncoding in [opeModrmRm, opeModrmRmCD1, opeModrmRmCD2, opeModrmRmCD4,
        opeModrmRmCD8, opeModrmRmCD16, opeModrmRmCD32, opeModrmRmCD64]);
    optMem32Bcst2,
    optMem32Bcst4,
    optMem32Bcst8,
    optMem32Bcst16,
    optMem64Bcst2,
    optMem64Bcst4,
    optMem64Bcst8,
    optMem64Bcst16:
      Result := not (FEncoding in [opeModrmRmCD1, opeModrmRmCD2, opeModrmRmCD4, opeModrmRmCD8,
        opeModrmRmCD16, opeModrmRmCD32, opeModrmRmCD64]);
    optMem32VSIBX,
    optMem32VSIBY,
    optMem32VSIBZ,
    optMem64VSIBX,
    optMem64VSIBY,
    optMem64VSIBZ:
      Result := not (FEncoding in [opeModrmRm, opeModrmRmCD1, opeModrmRmCD2, opeModrmRmCD4,
        opeModrmRmCD8, opeModrmRmCD16, opeModrmRmCD32, opeModrmRmCD64]);
    optMem1616,
    optMem1632,
    optMem1664,
    optMem112,
    optMem224:
      Result := not (FEncoding in [opeModrmRm]);
    optImm8,
    optImm8U:
      Result := not (FEncoding in [opeImm8]);
    optImm16:
      Result := not (FEncoding in [opeImm8, opeImm16]);
    optImm32:
      Result := not (FEncoding in [opeImm8, opeImm32]);
    optImm64:
      Result := not (FEncoding in [opeImm8, opeImm32, opeImm64]);
    optRel8:
      Result := not (FEncoding in [opeImm8]);
    optRel16:
      Result := not (FEncoding in [opeImm16]);
    optRel32:
      Result := not (FEncoding in [opeImm32]);
    optRel64:
      Result := not (FEncoding in [opeImm64]);
    optPtr1616,
    optPtr1632,
    optPtr1664,
    optMoffs16,
    optMoffs32,
    optMoffs64,
    optSrcIndex8,
    optSrcIndex16,
    optSrcIndex32,
    optSrcIndex64,
    optDstIndex8,
    optDstIndex16,
    optDstIndex32,
    optDstIndex64,
    optFixed1,
    optFixedAL,
    optFixedCL,
    optFixedAX,
    optFixedDX,
    optFixedEAX,
    optFixedRAX,
    optFixedST0,
    optFixedES,
    optFixedSS,
    optFixedCS,
    optFixedDS,
    optFixedFS,
    optFixedGS:
      Result := not (FEncoding in [opeNone]);
  end;
end;

function TInstructionOperand.GetDescription(IncludeAccessMode: Boolean): String;
begin
  if (GetConflictState) then
  begin
    Result := 'invalid';
    Exit;
  end;
  Result := '';
  if (FType <> optUnused) then
  begin
    case FType of
      optGPR8      : Result := 'GPR8';
      optGPR16     : Result := 'GPR16';
      optGPR32     : Result := 'GPR32';
      optGPR64     : Result := 'GPR64';
      optFPR       : Result := 'ST(i)';
      optVR64      : Result := 'MM64';
      optVR128     : Result := 'XMM128';
      optVR256     : Result := 'YMM256';
      optVR512     : Result := 'ZMM512';
      optMSKR      : Result := 'MASK';
      optBNDR      : Result := 'BND';
      optCR        : Result := 'CR';
      optDR        : Result := 'DR';
      optMem       : Result := 'mem';
      optMem8      : Result := 'mem8';
      optMem16     : Result := 'mem16';
      optMem32     : Result := 'mem32';
      optMem64     : Result := 'mem64';
      optMem80     : Result := 'mem80';
      optMem128    : Result := 'mem128';
      optMem256    : Result := 'mem256';
      optMem512    : Result := 'mem512';
      optMem32Bcst2: Result := 'mem32bcst2';
      optMem32Bcst4: Result := 'mem32bcst4';
      optMem32Bcst8: Result := 'mem32bcst8';
      optMem32Bcst16: Result := 'mem32bcst16';
      optMem64Bcst2: Result := 'mem64bcst2';
      optMem64Bcst4: Result := 'mem64bcst4';
      optMem64Bcst8: Result := 'mem64bcst8';
      optMem64Bcst16: Result := 'mem64bcst16';
      optMem112    : Result := 'mem112';
      optMem224    : Result := 'mem224';
      optImm8      : Result := 'imm8';
      optImm16     : Result := 'imm16';
      optImm32     : Result := 'imm32';
      optImm64     : Result := 'imm64';
      optImm8U     : Result := 'imm8u';
      optRel8      : Result := 'rel8';
      optRel16     : Result := 'rel16';
      optRel32     : Result := 'rel32';
      optRel64     : Result := 'rel64';
      optPtr1616   : Result := 'ptr16:16';
      optPtr1632   : Result := 'ptr16:32';
      optPtr1664   : Result := 'ptr16:64';
      optMoffs16   : Result := 'moffs16';
      optMoffs32   : Result := 'moffs32';
      optMoffs64   : Result := 'moffs64';
      optSrcIndex8 : Result := 'srcidx8';
      optSrcIndex16: Result := 'srcidx16';
      optSrcIndex32: Result := 'srcidx32';
      optSrcIndex64: Result := 'srcidx64';
      optDstIndex8 : Result := 'dstidx8';
      optDstIndex16: Result := 'dstidx16';
      optDstIndex32: Result := 'dstidx32';
      optDstIndex64: Result := 'dstidx64';
      optSREG      : Result := 'SEG';
      optMem1616   : Result := 'mem16:16';
      optMem1632   : Result := 'mem16:32';
      optMem1664   : Result := 'mem16:64';
      optMem32VSIBX : Result := 'mem32vsibx';
      optMem32VSIBY : Result := 'mem32vsiby';
      optMem32VSIBZ : Result := 'mem32vsibz';
      optMem64VSIBX : Result := 'mem64vsibx';
      optMem64VSIBY : Result := 'mem64vsiby';
      optMem64VSIBZ : Result := 'mem64vsibz';
      optFixed1    : Result := '1';
      optFixedAL   : Result := 'AL';
      optFixedCL   : Result := 'CL';
      optFixedAX   : Result := 'AX';
      optFixedDX   : Result := 'DX';
      optFixedEAX  : Result := 'EAX';
      optFixedRAX  : Result := 'RAX';
      optFixedES   : Result := 'ES';
      optFixedCS   : Result := 'CS';
      optFixedSS   : Result := 'SS';
      optFixedDS   : Result := 'DS';
      optFixedGS   : Result := 'GS';
      optFixedFS   : Result := 'FS';
      optFixedST0  : Result := 'ST0';
    end;
    if (IncludeAccessMode) then
    begin
      case FAccessMode of
        opaRead     : Result := Result + ' (r)';
        opaWrite    : Result := Result + ' (w)';
        opaReadWrite: Result := Result + ' (r, w)';
      end;
    end;
  end;
end;

procedure TInstructionOperand.LoadFromJSON(JSON: PJSONVariantData; const FieldName: String);
var
  V: PJSONVariantData;
  I: Integer;
begin
  V := JSON^.Data(FieldName);
  if Assigned(V) then
  begin
    if (V^.Kind <> jvObject) then
    begin
      raise Exception.CreateFmt('The "%s" field is not a valid JSON object.', [FieldName]);
    end;
    I := TJSONEnumHelper.ReadEnumValueFromString(V, 'type',       SOperandType);
    SetType(TOperandType(I));
    I := TJSONEnumHelper.ReadEnumValueFromString(V, 'encoding',   SOperandEncoding);
    SetEncoding(TOperandEncoding(I));
    I := TJSONEnumHelper.ReadEnumValueFromString(V, 'accessmode', SOperandAccessMode);
    SetAccessMode(TOperandAccessMode(I));
  end;
end;

procedure TInstructionOperand.SaveToJSON(JSON: PJSONVariantData; const FieldName: String);
var
  V: TJSONVariantData;
begin
  if (FType <> optUnused) then
  begin
    V.Init;
    V.AddNameValue('type', SOperandType[FType]);
    if (FEncoding   <> opeNone) then V.AddNameValue('encoding',   SOperandEncoding[FEncoding]);
    if (FAccessMode <> opaRead) then V.AddNameValue('accessmode', SOperandAccessMode[FAccessMode]);
    JSON^.AddNameValue(FieldName, Variant(V));
  end;
end;

procedure TInstructionOperand.SetAccessMode(const Value: TOperandAccessMode);
begin
  if (FAccessMode <> Value) then
  begin
    FAccessMode := Value;
    Changed;
  end;
end;

procedure TInstructionOperand.SetEncoding(const Value: TOperandEncoding);
begin
  if (FEncoding <> Value) then
  begin
    FEncoding := Value;
    Changed;
  end;
end;

procedure TInstructionOperand.SetType(const Value: TOperandType);
begin
  if (FType <> Value) then
  begin
    case Value of
      optGPR8: ;
      optGPR16: ;
      optGPR32: ;
      optGPR64: ;
      optVR64: ;
      optVR128: ;
      optVR256: ;
      optVR512: ;
      optFPR:
        FEncoding := opeModrmRm;
      optCR: ;
      optDR: ;
      optSREG: ;
      optMSKR: ;
      optBNDR: ;
      optMem: ;
      optMem8: ;
      optMem16: ;
      optMem32: ;
      optMem64: ;
      optMem80: ;
      optMem128: ;
      optMem256: ;
      optMem512: ;
      optMem32Bcst2: ;
      optMem32Bcst4: ;
      optMem32Bcst8: ;
      optMem32Bcst16: ;
      optMem64Bcst2: ;
      optMem64Bcst4: ;
      optMem64Bcst8: ;
      optMem64Bcst16: ;
      optMem32VSIBX: ;
      optMem32VSIBY: ;
      optMem32VSIBZ: ;
      optMem64VSIBX: ;
      optMem64VSIBY: ;
      optMem64VSIBZ: ;
      optMem1616: ;
      optMem1632: ;
      optMem1664: ;
      optMem112: ;
      optMem224: ;
      optImm8: ;
      optImm8U: ;
      optImm16: ;
      optImm32: ;
      optImm64: ;
      optRel8: ;
      optRel16: ;
      optRel32: ;
      optRel64: ;
      optPtr1616: ;
      optPtr1632: ;
      optPtr1664: ;
      optMoffs16: ;
      optMoffs32: ;
      optMoffs64: ;
      optSrcIndex8: ;
      optSrcIndex16: ;
      optSrcIndex32: ;
      optSrcIndex64: ;
      optDstIndex8: ;
      optDstIndex16: ;
      optDstIndex32: ;
      optDstIndex64: ;
      optFixed1: ;
      optFixedAL: ;
      optFixedCL: ;
      optFixedAX: ;
      optFixedDX: ;
      optFixedEAX: ;
      optFixedRAX: ;
      optFixedST0: ;
      optFixedES: ;
      optFixedSS: ;
      optFixedCS: ;
      optFixedDS: ;
      optFixedFS: ;
      optFixedGS: ;
    end;
    {case Value of
      optUnused:
        FEncoding := opeNone;
      optGPR8,
      optGPR16,
      optGPR32,
      optGPR64,
      optVR64,
      optVR128,
      optVR256,
      optVR512,
      optBNDR,
      optCR,
      optDR:
        if (FEncoding <> opeModrmRm) then
        begin
          FEncoding := opeModrmReg;
        end;
      optMSKR:
        if (FEncoding <> opeModrmRm) and (FEncoding <> opeVexVVVV) then
        begin
          FEncoding := opeModrmReg;
        end;
      optFPR:
        FEncoding := opeModrmRm;
      optMem,
      optMem8,
      optMem16,
      optMem32,
      optMem64,
      optMem80,
      optMem128,
      optMem256,
      optMem512,
      optMem1616,
      optMem1632,
      optMem1664,
      optMem32VSIBX,
      optMem32VSIBY,
      optMem32VSIBZ,
      optMem64VSIBX,
      optMem64VSIBY,
      optMem64VSIBZ,
      optMem32Bcst2,
      optMem32Bcst4,
      optMem32Bcst8,
      optMem32Bcst16,
      optMem64Bcst2,
      optMem64Bcst4,
      optMem64Bcst8,
      optMem64Bcst16,
      optMem112,
      optMem224:
        if not (FEncoding in [opeModrmRm, opeModrmRmCD1, opeModrmRmCD2, opeModrmRmCD4,
          opeModrmRmCD8, opeModrmRmCD16, opeModrmRmCD32, opeModrmRmCD64]) then
        begin
          FEncoding := opeModrmRm;
        end;
      optImm8:
        FEncoding := opeImm8;
      optImm16:
        FEncoding := opeImm16;
      optImm32:
        FEncoding := opeImm32;
      optImm64:
        if (FEncoding <> opeImm32) then
        begin
          FEncoding := opeImm64;
        end;
      optImm8U:
        FEncoding := opeImm8;
      optRel8:
        FEncoding := opeImm8;
      optRel16:
        FEncoding := opeImm16;
      optRel32:
        FEncoding := opeImm32;
      optRel64:
        if (FEncoding <> opeImm32) then // TODO: ?
        begin
          FEncoding := opeImm64;
        end;
      optPtr1616,
      optPtr1632,
      optPtr1664:
        FEncoding := opeNone;
      optMoffs16,
      optMoffs32,
      optMoffs64:
        FEncoding := opeNone;
      optSREG:
        FEncoding := opeModrmReg;
      optSrcIndex8,
      optSrcIndex16,
      optSrcIndex32,
      optSrcIndex64,
      optDstIndex8,
      optDstIndex16,
      optDstIndex32,
      optDstIndex64,
      optFixed1,
      optFixedAL,
      optFixedCL,
      optFixedAX,
      optFixedDX,
      optFixedEAX,
      optFixedRAX,
      optFixedCS,
      optFixedSS,
      optFixedDS,
      optFixedES,
      optFixedFS,
      optFixedGS,
      optFixedST0:
        FEncoding := opeNone;
    end;}
    FType := Value;
    Changed;
  end;
end;
{$ENDREGION}

{$REGION 'Class: TInstructionOperands'}
procedure TInstructionOperands.AssignTo(Dest: TPersistent);
var
  D: TInstructionOperands;
begin
  if (Dest is TInstructionOperands) then
  begin
    D := Dest as TInstructionOperands;
    D.FOperandA.Assign(FOperandA);
    D.FOperandB.Assign(FOperandB);
    D.FOperandC.Assign(FOperandC);
    D.FOperandD.Assign(FOperandD);
    D.Changed;
  end else inherited;
end;

procedure TInstructionOperands.Changed;
{var
  A: array[0..3] of TInstructionOperand;
  I, J: Integer;
begin
  FHasConflicts := false;

  // Check for invalid operand order
  A[0] := FOperandA; A[1] := FOperandB; A[2] := FOperandC; A[3] := FOperandD;
  for I := High(A) downto Low(A) do
  begin
    if (A[I].OperandType <> otUnused) then
    begin
      for J := I downto Low(A) do
      begin
        if (A[J].OperandType = otUnused) then
        begin
          FHasConflicts := true;
          Break;
        end;
      end;
    end;
    if (FHasConflicts) then
    begin
      Break;
    end;
  end; }
begin

  // TODO: Determine Encoding

  FDefinition.UpdateValues;
end;

constructor TInstructionOperands.Create(Definition: TInstructionDefinition);
begin
  inherited Create;
  FDefinition := Definition;
  FOperandA := TInstructionOperand.Create(Self);
  FOperandB := TInstructionOperand.Create(Self);
  FOperandC := TInstructionOperand.Create(Self);
  FOperandD := TInstructionOperand.Create(Self);
end;

destructor TInstructionOperands.Destroy;
begin
  if (Assigned(FOperandA)) then FOperandA.Free;
  if (Assigned(FOperandB)) then FOperandB.Free;
  if (Assigned(FOperandC)) then FOperandC.Free;
  if (Assigned(FOperandD)) then FOperandD.Free;
  inherited;
end;

function TInstructionOperands.Equals(const Value: TInstructionOperands): Boolean;
begin
  Result :=
    (Value.FOperandA.Equals(FOperandA)) and (Value.FOperandB.Equals(FOperandB)) and
    (Value.FOperandC.Equals(FOperandC)) and (Value.FOperandD.Equals(FOperandD));
end;

function TInstructionOperands.GetConflictState: Boolean;
var
  I: Integer;
  EncReg, EncRm, EncVVVV, EncAAA: Integer;
begin
  Result :=
    (FOperandA.HasConflicts) or (FOperandB.HasConflicts) or (FOperandC.HasConflicts) or
    (OperandD.HasConflicts);
  if (not Result) then
  begin
    EncReg := 0; EncRm := 0; EncVVVV := 0; EncAAA := 0;
    for I := 0 to 3 do
    begin
      case GetOperandById(I).Encoding of
        opeModrmReg   : Inc(EncReg);
        opeModrmRm,
        opeModrmRmCD1,
        opeModrmRmCD2,
        opeModrmRmCD4,
        opeModrmRmCD8,
        opeModrmRmCD16,
        opeModrmRmCD32,
        opeModrmRmCD64: Inc(EncRm);
        opeVexVVVV    : Inc(EncVVVV);
        opeEvexAAA    : Inc(EncAAA);
      end;
      if (EncReg > 1) or (EncRm > 1) or (EncVVVV > 1) or (EncAAA > 1) then
      begin
        Result := true;
        Break;
      end;
    end;
    if (FDefinition.OpcodeExtensions.ModrmMod <> mdNeutral) and (EncReg > 0) and (EncRm = 0) then
    begin
      Exit(true)
    end
    // TODO: Check operand order, ...
  end;
end;

function TInstructionOperands.GetOperandById(Id: Integer): TInstructionOperand;
begin
  Result := nil;
  case Id of
    0: Result := FOperandA;
    1: Result := FOperandB;
    2: Result := FOperandC;
    3: Result := FOperandD;
  end;
end;

procedure TInstructionOperands.LoadFromJSON(JSON: PJSONVariantData; const FieldName: String);
var
  V: PJSONVariantData;
begin
  V := JSON^.Data(FieldName);
  if Assigned(V) then
  begin
    if (V^.Kind <> jvObject) then
    begin
      raise Exception.CreateFmt('The "%s" field is not a valid JSON object.', [FieldName]);
    end;
    FOperandA.LoadFromJSON(V, 'operand1');
    FOperandB.LoadFromJSON(V, 'operand2');
    FOperandC.LoadFromJSON(V, 'operand3');
    FOperandD.LoadFromJSON(V, 'operand4');
  end;
end;

procedure TInstructionOperands.SaveToJSON(JSON: PJSONVariantData; const FieldName: String);
var
  V: TJSONVariantData;
begin
  V.Init;
  FOperandA.SaveToJSON(@V, 'operand1');
  FOperandB.SaveToJSON(@V, 'operand2');
  FOperandC.SaveToJSON(@V, 'operand3');
  FOperandD.SaveToJSON(@V, 'operand4');
  if (V.Count > 0) then
  begin
    JSON^.AddNameValue('operands', Variant(V));
  end;
end;
{$ENDREGION}

{$REGION 'Class: TInstructionDefinition'}
procedure TInstructionDefinition.AssignTo(Dest: TPersistent);
var
  D: TInstructionDefinition;
begin
  if (Dest is TInstructionDefinition) then
  begin
    D := Dest as TInstructionDefinition;
    D.BeginUpdate;
    try
      D.FMnemonic := FMnemonic;
      D.FEncoding := FEncoding;
      D.FOpcodeMap := FOpcodeMap;
      D.FOpcode := FOpcode;
      D.FExtensions.Assign(FExtensions);
      D.FCPUID.Assign(FCPUID);
      D.FOperands.Assign(FOperands);
      D.FFlags := FFlags;
      D.FImplicitRead.Assign(FImplicitRead);
      D.FImplicitWrite.Assign(FImplicitWrite);
      D.FX86Flags.Assign(FX86Flags);
      D.FComment := FComment;
      D.Update;
    finally
      D.EndUpdate;
    end;
  end else inherited;
end;

procedure TInstructionDefinition.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

constructor TInstructionDefinition.Create(Editor: TInstructionEditor; const Mnemonic: String);
begin
  inherited Create;
  FEditor := Editor;
  if (Mnemonic = '') then
  begin
    raise Exception.Create('Mnemonic can not be empty.');
  end;
  FMnemonic := Mnemonic;
  FExtensions := TOpcodeExtensions.Create(Self);
  FCPUID := TCPUIDFeatureFlags.Create(Self);
  FOperands := TInstructionOperands.Create(Self);
  FImplicitRead := TX86Registers.Create(Self);
  FImplicitWrite := TX86Registers.Create(Self);
  FX86Flags := TX86Flags.Create(Self);
  // Insert definition into the definition list. This method does NOT insert the definition into
  // the table structure
  FEditor.RegisterDefinition(Self);
end;

destructor TInstructionDefinition.Destroy;
begin
  // Remove definition from the filter structure
  if (Assigned(FParent)) then
  begin
    FEditor.RemoveDefinition(Self);
  end;
  // Remove definition from the definition list
  FEditor.UnregisterDefinition(Self);
  if (Assigned(FExtensions))    then FExtensions.Free;
  if (Assigned(FCPUID))         then FCPUID.Free;
  if (Assigned(FOperands))      then FOperands.Free;
  if (Assigned(FImplicitRead))  then FImplicitRead.Free;
  if (Assigned(FImplicitWrite)) then FImplicitWrite.Free;
  if (Assigned(FX86Flags))      then FX86Flags.Free;
  inherited;
end;

procedure TInstructionDefinition.EndUpdate;
begin
  if (FUpdateCount > 0) then
  begin
    Dec(FUpdateCount);
  end;
  if (FUpdateCount = 0) then
  begin
    if (FDoUpdatePosition) then
    begin
      UpdatePosition;
      FDoUpdatePosition := false;
    end;
    if (FDoUpdateValues) then
    begin
      UpdateValues;
      FDoUpdateValues := false;
    end;
  end;
end;

function TInstructionDefinition.Equals(const Value: TInstructionDefinition): Boolean;
begin
  // Comment is excluded from the equality check
  Result :=
    (Value.FMnemonic = FMnemonic) and (Value.FEncoding = FEncoding) and
    (Value.FOpcodeMap = FOpcodeMap) and (Value.FOpcode = FOpcode) and
    (Value.FExtensions.Equals(FExtensions)) and (Value.FCPUID.Equals(FCPUID)) and
    (Value.FOperands.Equals(FOperands)) and (Value.FFlags = FFlags) and
    (Value.FImplicitRead.Equals(FImplicitRead)) and
    (Value.FImplicitWrite.Equals(FImplicitWrite)) and (Value.FX86Flags.Equals(FX86Flags));
end;

function TInstructionDefinition.GetConflictState: Boolean;
begin
  Result := (FConflicts <> []);
end;

procedure TInstructionDefinition.LoadFromJSON(JSON: PJSONVariantData);
var
  I: Integer;
  A: PJSONVariantData;
  F: TInstructionDefinitionFlag;
  Flags: TInstructionDefinitionFlags;
begin
  BeginUpdate;
  try
    if (VarIsClear(JSON^.Value['mnemonic']) or (JSON^.Value['mnemonic'] = '')) then
    begin
      raise Exception.Create('The "mnemonic" field can not be empty.');
    end;
    SetMnemonic(JSON^.Value['mnemonic']);
    I := TJSONEnumHelper.ReadEnumValueFromString(JSON, 'encoding', SInstructionEncoding);
    SetEncoding(TInstructionEncoding(I));
    I := TJSONEnumHelper.ReadEnumValueFromString(JSON, 'map',      SOpcodeMap);
    SetOpcodeMap(TOpcodeMap(I));
    if (VarIsClear(JSON^.Value['opcode']) or
      (not TryStrToInt('$' + JSON^.Value['opcode'], I))) or (I < 0) or (I >= 256) then
    begin
      raise Exception.Create('The "opcode" field does not contain a valid hexadecimal byte value.');
    end;
    SetOpcode(I);

    FEVEXCD8Scale := JSON^.Value['cd8scale'];

    FExtensions.LoadFromJSON(JSON, 'extensions');
    FCPUID.LoadFromJSON(JSON, 'cpuid');
    FOperands.LoadFromJSON(JSON, 'operands');
    FImplicitRead.LoadFromJSON(JSON, 'implicit_read');
    FImplicitWrite.LoadFromJSON(JSON, 'implicit_write');
    A := JSON.Data('flags');
    if (Assigned(A)) then
    begin
      if (A^.Kind <> jvArray) then
      begin
        raise Exception.Create('The "flags" field is not a valid JSON array.');
      end;
      Flags := [];
      for I := 0 to A^.Count - 1 do
      begin
        for F := Low(SInstructionDefinitionFlag) to High(SInstructionDefinitionFlag) do
        begin
          if (LowerCase(A^.Item[I]) = SInstructionDefinitionFlag[F]) then
          begin
            Flags := Flags + [F];
            Break;
          end;
        end;
      end;
      SetFlags(Flags);
    end;
    FX86Flags.LoadFromJSON(JSON, 'x86flags');
    FComment := JSON^.Value['comment'];
  finally
    EndUpdate;
  end;
end;

procedure TInstructionDefinition.SaveToJSON(JSON: PJSONVariantData);
var
  A: TJSONVariantData;
  F: TInstructionDefinitionFlag;
begin
  JSON^.AddNameValue('mnemonic', FMnemonic);
  JSON^.AddNameValue('opcode', LowerCase(IntToHex(FOpcode, 2)));
  if (FEncoding  <> ieDefault) then JSON^.AddNameValue('encoding', SInstructionEncoding[FEncoding]);
  if (FOpcodeMap <> omDefault) then JSON^.AddNameValue('map',      SOpcodeMap[FOpcodeMap]);
  FExtensions.SaveToJSON(JSON, 'extensions');
  FCPUID.SaveToJSON(JSON, 'cpuid');
  FOperands.SaveToJSON(JSON, 'operands');
  FImplicitRead.SaveToJSON(JSON, 'implicit_read');
  FImplicitWrite.SaveToJSON(JSON, 'implicit_write');
  A.Init;
  for F in FFlags do
  begin
    A.AddValue(SInstructionDefinitionFlag[F]);
  end;
  if (A.Count > 0) then
  begin
    JSON^.AddNameValue('flags', Variant(A));
  end;
  FX86Flags.SaveToJSON(JSON, 'x86flags');
  if (FComment <> '') then
  begin
    JSON^.AddNameValue('comment', FComment);
  end;
  JSON^.AddNameValue('cd8scale', FEVEXCD8Scale);
end;

procedure TInstructionDefinition.SetComment(const Value: String);
begin
  if (FComment <> Value) then
  begin
    FComment := Value;
    UpdateValues;
  end;
end;

procedure TInstructionDefinition.SetEncoding(const Value: TInstructionEncoding);
begin
  if (FEncoding <> Value) then
  begin
    // TODO: Check exception cases
    case Value of
      ieDefault,
      ieVEX,
      ieEVEX:
        begin
          if (not (FOpcodeMap in [omDefault, om0F, om0F38, om0F3A])) then FOpcodeMap := omDefault;
        end;
      ie3DNow:
        begin
          if (FOpcodeMap <> om0F) then FOpcodeMap := om0F;
        end;
      ieXOP:
        begin
          if (not (FOpcodeMap in [omXOP8, omXOP9, omXOPA])) then FOpcodeMap := omXOP8;
        end;
    end;
    FEncoding := Value;
    UpdatePosition;
  end;
end;

procedure TInstructionDefinition.SetFlags(const Value: TInstructionDefinitionFlags);
begin
  if (FFlags <> Value) then
  begin
    FFlags := Value;
    UpdateValues;
  end;
end;

procedure TInstructionDefinition.SetMnemonic(const Value: String);
begin
  if (Value = '') then
  begin
    raise Exception.Create('Mnemonic can not be empty.');
  end;
  if (FMnemonic <> Value) then
  begin
    FMnemonic := LowerCase(Value);
    UpdateValues;
  end;
end;

procedure TInstructionDefinition.SetOpcode(const Value: TOpcodeByte);
begin
  if (FOpcode <> Value) then
  begin
    FOpcode := Value;
    UpdatePosition;
  end;
end;

procedure TInstructionDefinition.SetOpcodeMap(const Value: TOpcodeMap);
var
  E: Boolean;
begin
  if (FOpcodeMap <> Value) then
  begin
    E := false;
    case FEncoding of
      ieDefault,
      ieVEX,
      ieEVEX  : E := (Value in [omXOP8, omXOP9, omXOPA]);
      ie3DNow : E := (Value <> om0F);
      ieXOP   : E := (Value in [omDefault, om0F, om0F38, om0F3A]);
    end;
    if (E) then
    begin
      raise Exception.Create('The current instruction encoding does not support this opcode map.');
    end;
    FOpcodeMap := Value;
    UpdatePosition;
  end;
end;

procedure TInstructionDefinition.SetParent(Parent: TDefinitionContainer);
begin
  // This method should ONLY be called by TInstructionDefinition.Create,
  // TInstructionFilter.InsertDefinition and TInstructionFilter.RemoveDefinition
  if (Assigned(FParent)) then
  begin
    if (HasConflicts) then
    begin
      FParent.DecInheritedConflictCount;
    end;
    FEditor.DefinitionRemoved(Self);
  end;
  FParent := Parent;
  if (Assigned(Parent)) then
  begin
    if (HasConflicts) then
    begin
      FParent.IncInheritedConflictCount;
    end;
    FEditor.DefinitionInserted(Self);
  end;
end;

procedure TInstructionDefinition.Update;
begin
  UpdatePosition;
  UpdateValues;
end;

procedure TInstructionDefinition.UpdateConflictFlags;
var
  Conflicts: TInstructionDefinitionConflicts;
begin
  Conflicts := [];
  if (ifForceConflict in FFlags) then
  begin
    Include(Conflicts, idcForcedConflict);
  end;
  if (FOperands.HasConflicts) then
  begin
    Include(Conflicts, idcOperands);
  end;
  // TODO: Check for X86Flag conflicts
  //       [ ] EFLAGS in ImplicitRead / ImplicitWrite required or forbidden
  // TODO: Check for more conflicts
  if (FConflicts <> Conflicts) then
  begin
    if (Assigned(FParent)) then
    begin
      if (FConflicts = []) and (Conflicts <> []) then
      begin
        FParent.IncInheritedConflictCount;
      end else if (FConflicts <> []) and (Conflicts = []) then
      begin
        FParent.DecInheritedConflictCount;
      end;
    end;
    FConflicts := Conflicts;
  end;
end;

procedure TInstructionDefinition.UpdatePosition;
begin
  UpdateValues;
  if (FUpdateCount > 0) then
  begin
    FDoUpdatePosition := true;
  end else
  begin
    FEditor.InsertDefinition(Self);
  end;
end;

procedure TInstructionDefinition.UpdateValues;
begin
  if (FUpdateCount > 0) then
  begin
    FDoUpdateValues := true;
  end else
  begin
    UpdateConflictFlags;
    FEditor.DefinitionChanged(Self);
  end;
end;
{$ENDREGION}

{$REGION 'Class: TInstructionFilter'}
procedure TInstructionFilter.Changed;
begin
  // TODO: Implement BeginUpdate, EndUpdate to reduce Changed calls
  FEditor.FilterChanged(Self);
end;

constructor TInstructionFilter.Create(Editor: TInstructionEditor; Parent: TInstructionFilter;
  IsRootTable, IsStaticFilter: Boolean);
begin
  inherited Create;

  Assert(Assigned(Editor));
  Assert((not Assigned(Parent)) or
    (Assigned(Parent) and IsStaticFilter and (iffIsStaticFilter in Parent.FilterFlags)) or
    (Assigned(Parent) and (not IsStaticFilter)));

  FEditor := Editor;
  if (IsRootTable) then
  begin
    FFilterFlags := FFilterFlags + [iffIsRootTable];
  end;
  if (IsStaticFilter) then
  begin
    FFilterFlags := FFilterFlags + [iffIsStaticFilter];
  end;
  if (IsDefinitionContainer) then
  begin
    FFilterFlags := FFilterFlags + [iffIsDefinitionContainer];
    FDefinitions := TList<TInstructionDefinition>.Create;
  end else
  begin
    SetLength(FItems, GetCapacity);
  end;
  FEditor.FilterCreated(Self);
  SetParent(Parent);
end;

procedure TInstructionFilter.CreateFilterAtIndex(Index: Integer;
  FilterClass: TInstructionFilterClass; IsRootTable, IsStaticFilter: Boolean);
begin
  SetItem(Index, FilterClass.Create(FEditor, Self, IsRootTable, IsStaticFilter));
end;

procedure TInstructionFilter.DecInheritedConflictCount;
begin
  Dec(FInheritedConflicts);
  if (FInheritedConflicts = 0) then
  begin
    SetConflicts(FConflicts - [ifcInheritedConflict]);
    if (Assigned(FParent)) then
    begin
      FParent.DecInheritedConflictCount;
    end;
  end;
end;

destructor TInstructionFilter.Destroy;
begin
  Assert((FItemCount = 0) and (FParent = nil));
  if Assigned(FDefinitions) then
  begin
    Assert(FDefinitions.Count = 0);
    FDefinitions.Free;
  end;
  FEditor.FilterDestroyed(Self);
  inherited;
end;

class function TInstructionFilter.GetCapacity: Cardinal;
begin
  Result := 0;
end;

function TInstructionFilter.GetConflictState: Boolean;
begin
  Result := (FConflicts <> []);
end;

function TInstructionFilter.GetDefinition(const Index: Integer): TInstructionDefinition;
begin
  Assert((Index >= 0) and (Index < FDefinitions.Count));
  Result := FDefinitions[Index];
end;

function TInstructionFilter.GetDefinitionCount: Integer;
begin
  Result := 0;
  if Assigned(FDefinitions) then
  begin
    Result := FDefinitions.Count;
  end;
end;

class function TInstructionFilter.GetDescription: String;
begin
  Result := Self.ClassName;
end;

class function TInstructionFilter.GetInsertPosition(
  const Definition: TInstructionDefinition): Integer;
begin
  Result := -1;
end;

function TInstructionFilter.GetItem(const Index: Integer): TInstructionFilter;
begin
  Assert((Index >= 0) and (Index < Integer(GetCapacity)));
  Result := FItems[Index];
end;

class function TInstructionFilter.GetItemDescription(Index: Integer): String;
begin
  Result := '';
end;

class function TInstructionFilter.GetNeutralElementType: TNeutralElementType;
begin
  Result := netNotAvailable;
end;

procedure TInstructionFilter.IncInheritedConflictCount;
begin
  Inc(FInheritedConflicts);
  if (FInheritedConflicts = 1) then
  begin
    SetConflicts(FConflicts + [ifcInheritedConflict]);
    if (Assigned(FParent)) then
    begin
      FParent.IncInheritedConflictCount;
    end;
  end;
end;

function TInstructionFilter.IndexOf(const Filter: TInstructionFilter): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := Low(FItems) to High(FItems) do
  begin
    if (FItems[I] = Filter) then
    begin
      Result := I;
      Break;
    end;
  end;
end;

procedure TInstructionFilter.InsertDefinition(Definition: TInstructionDefinition);
begin
  Assert(IsDefinitionContainer);
  FDefinitions.Add(Definition);
  Definition.SetParent(Self as TDefinitionContainer);
  if (FDefinitions.Count = 2) then
  begin
    SetConflicts(FConflicts + [ifcDefinitionCount]);
    if (Assigned(FParent)) then
    begin
      FParent.IncInheritedConflictCount;
    end;
  end;
  Changed;
end;

class function TInstructionFilter.IsDefinitionContainer: Boolean;
begin
  Result := false;
end;

procedure TInstructionFilter.RemoveDefinition(Definition: TInstructionDefinition);
begin
  Assert(IsDefinitionContainer);
  Assert(FDefinitions.IndexOf(Definition) >= 0);
  if (FDefinitions.Count = 2) then
  begin
    SetConflicts(FConflicts - [ifcDefinitionCount]);
    if (Assigned(FParent)) then
    begin
      FParent.DecInheritedConflictCount;
    end;
  end;
  Definition.SetParent(nil);
  FDefinitions.Remove(Definition);
  Changed;
end;

procedure TInstructionFilter.SetConflicts(const Value: TInstructionFilterConflicts);
begin
  if (FConflicts <> Value) then
  begin
    FConflicts := Value;
    Changed;
  end;
end;

procedure TInstructionFilter.SetItem(const Index: Integer; const Value: TInstructionFilter);
begin
  Assert((Index >= 0) and (Index < Length(FItems)));
  if (FItems[Index] <> Value) then
  begin
    if (Assigned(Value) and (not Assigned(FItems[Index]))) then
    begin
      Inc(FItemCount);
    end else if (not Assigned(Value) and (Assigned(FItems[Index]))) then
    begin
      Dec(FItemCount);
    end;
    if (Assigned(FItems[Index])) then
    begin
      FItems[Index].SetParent(nil);
    end;
    FItems[Index] := Value;
    if (Assigned(Value)) then
    begin
      FItems[Index].SetParent(Self);
    end;
    // Update neutral element conflict
    if (GetNeutralElementType in [netPlaceholder]) then
    begin
      if (Assigned(FItems[0])) and (FItemCount > 1) then
      begin
        if (not (ifcNeutralElement in FConflicts)) then
        begin
          SetConflicts(FConflicts + [ifcNeutralElement]);
          if (Assigned(FParent)) then
          begin
            FParent.IncInheritedConflictCount;
          end;
        end;
      end else
      begin
        if (ifcNeutralElement in FConflicts) then
        begin
          SetConflicts(FConflicts - [ifcNeutralElement]);
          if (Assigned(FParent)) then
          begin
            FParent.DecInheritedConflictCount;
          end;
        end;
      end;
    end;
    Changed;
  end;
end;

procedure TInstructionFilter.SetParent(Parent: TInstructionFilter);
begin
  Assert((not Assigned(Parent)) or
    (Assigned(Parent) and (iffIsStaticFilter in FFilterFlags) and
    (iffIsStaticFilter in Parent.FilterFlags)) or (Assigned(Parent) and
    (not (iffIsStaticFilter in FFilterFlags))));
  if (FParent <> Parent) then
  begin
    if (Assigned(FParent)) then
    begin
      FEditor.FilterRemoved(Self);
      if (HasConflicts) then
      begin
        FParent.DecInheritedConflictCount;
      end;
    end;
    FParent := Parent;
    if (Assigned(Parent)) then
    begin
      FEditor.FilterInserted(Self);
      if (HasConflicts) then
      begin
        Parent.IncInheritedConflictCount;
      end;
    end;
    Changed;
  end;
end;
{$ENDREGION}

{$REGION 'Class: TDefinitionContainer'}
class function TDefinitionContainer.IsDefinitionContainer: Boolean;
begin
  Result := true;
end;
{$ENDREGION}

{$REGION 'Class: TInstructionEditor'}
procedure TInstructionEditor.BeginUpdate;
begin
  Inc(FUpdateCount);
  if (FUpdateCount = 1) and Assigned(FOnBeginUpdate) then
  begin
    FOnBeginUpdate(Self);
  end;
end;

constructor TInstructionEditor.Create;
begin
  inherited Create;
  FDefinitions := TList<TInstructionDefinition>.Create;
end;

class constructor TInstructionEditor.Create;
begin
  // Default filter order
  SetLength(FilterOrderDef, 8);
  FilterOrderDef[ 0]  := TModrmModFilter;
  FilterOrderDef[ 1]  := TModrmRegFilter;
  FilterOrderDef[ 2]  := TModrmRmFilter;
  FilterOrderDef[ 3]  := TRexWFilter;
  FilterOrderDef[ 4]  := TOperandSizeFilter;
  FilterOrderDef[ 5]  := TAddressSizeFilter;
  FilterOrderDef[ 6]  := TMandatoryPrefixFilter;
  FilterOrderDef[ 7]  := TModeFilter;
  // Specialized filter order for XOP instruction encoding
  SetLength(FilterOrderXOP, 8);
  FilterOrderXOP[ 0]  := TModrmModFilter;
  FilterOrderXOP[ 1]  := TModrmRegFilter;
  FilterOrderXOP[ 2]  := TModrmRmFilter;
  FilterOrderXOP[ 3]  := TRexWFilter;
  FilterOrderXOP[ 4]  := TOperandSizeFilter;
  FilterOrderXOP[ 5]  := TAddressSizeFilter;
  FilterOrderXOP[ 6]  := TModeFilter;
  FilterOrderXOP[ 7]  := TVexLFilter;
  // Specialized filter order for VEX instruction encoding
  SetLength(FilterOrderVEX, 9);
  FilterOrderVEX[ 0]  := TOpcodeFilter;
  FilterOrderVEX[ 1]  := TModrmModFilter;
  FilterOrderVEX[ 2]  := TModrmRegFilter;
  FilterOrderVEX[ 3]  := TModrmRmFilter;
  FilterOrderVEX[ 4]  := TRexWFilter;
  FilterOrderVEX[ 5]  := TOperandSizeFilter;
  FilterOrderVEX[ 6]  := TAddressSizeFilter;
  FilterOrderVEX[ 7]  := TModeFilter;
  FilterOrderVEX[ 8]  := TVexLFilter;
  // Specialized filter order for EVEX instruction encoding
  SetLength(FilterOrderEVEX, 11);
  FilterOrderEVEX[ 0] := TOpcodeFilter;
  FilterOrderEVEX[ 1] := TModrmModFilter;
  FilterOrderEVEX[ 2] := TModrmRegFilter;
  FilterOrderEVEX[ 3] := TModrmRmFilter;
  FilterOrderEVEX[ 4] := TRexWFilter;
  FilterOrderEVEX[ 5] := TOperandSizeFilter;
  FilterOrderEVEX[ 6] := TAddressSizeFilter;
  FilterOrderEVEX[ 7] := TModeFilter;
  FilterOrderEVEX[ 8] := TEvexBFilter;
  FilterOrderEVEX[ 9] := TVexLFilter;
  FilterOrderEVEX[10] := TEvexL2Filter;
end;

function TInstructionEditor.CreateDefinition(const Mnemonic: String): TInstructionDefinition;
begin
  Result := TInstructionDefinition.Create(Self, Mnemonic);
end;

procedure TInstructionEditor.DefinitionChanged(Definition: TInstructionDefinition);
begin
  if Assigned(FOnDefinitionChanged) then
  begin
    FOnDefinitionChanged(Self, Definition);
  end;
end;

procedure TInstructionEditor.DefinitionInserted(Definition: TInstructionDefinition);
begin
  if Assigned(FOnDefinitionInserted) then
  begin
    FOnDefinitionInserted(Self, Definition);
  end;
end;

procedure TInstructionEditor.DefinitionRemoved(Definition: TInstructionDefinition);
begin
  if Assigned(FOnDefinitionRemoved) then
  begin
    FOnDefinitionRemoved(Self, Definition);
  end;
end;

destructor TInstructionEditor.Destroy;

procedure DestroyChildFilters(Filter: TInstructionFilter);
var
  I: Integer;
  F: TInstructionFilter;
begin
  Assert(iffIsStaticFilter in Filter.FilterFlags);
  if (Filter.ItemCount > 0) then
  begin
    for I := 0 to Filter.Capacity - 1 do
    begin
      if (Assigned(Filter.Items[I])) then
      begin
        DestroyChildFilters(Filter.Items[I]);
        F := Filter.Items[I];
        Filter.SetItem(I, nil);
        F.Free;
      end;
    end;
  end;
end;

var
  I: Integer;
begin
  BeginUpdate;
  try
    if (Assigned(FDefinitions)) then
    begin
      FPreventDefinitionRemoval := true;
      for I := FDefinitions.Count - 1 downto 0 do
      begin
        FDefinitions[I].Free;
      end;
      FDefinitions.Free;
    end;
    if Assigned(FRootTable) then
    begin
      DestroyChildFilters(FRootTable);
      FRootTable.Free;
    end;
  finally
    EndUpdate;
  end;
  inherited;
end;

procedure TInstructionEditor.EndUpdate;
begin
  if (FUpdateCount > 0) then
  begin
    Dec(FUpdateCount);
  end;
  if (FUpdateCount = 0) then
  begin
    if Assigned(FOnEndUpdate) then
    begin
      FOnEndUpdate(Self);
    end;
  end;
end;

procedure TInstructionEditor.FilterChanged(Filter: TInstructionFilter);
begin
  if Assigned(FOnFilterChanged) then
  begin
    FOnFilterChanged(Self, Filter);
  end;
end;

procedure TInstructionEditor.FilterCreated(Filter: TInstructionFilter);
begin
  if Assigned(FOnFilterCreated) then
  begin
    FOnFilterCreated(Self, Filter);
  end;
end;

procedure TInstructionEditor.FilterDestroyed(Filter: TInstructionFilter);
begin
  if Assigned(FOnFilterDestroyed) then
  begin
    FOnFilterDestroyed(Self, Filter);
  end;
end;

procedure TInstructionEditor.FilterInserted(Filter: TInstructionFilter);
begin
  if (not Filter.IsDefinitionContainer) then Inc(FFilterCount);
  if Assigned(FOnFilterInserted) then
  begin
    FOnFilterInserted(Self, Filter);
  end;
end;

procedure TInstructionEditor.FilterRemoved(Filter: TInstructionFilter);
begin
  if (not Filter.IsDefinitionContainer) then Dec(FFilterCount);
  if Assigned(FOnFilterRemoved) then
  begin
    FOnFilterRemoved(Self, Filter);
  end;
end;

function TInstructionEditor.GetDefinition(const Index: Integer): TInstructionDefinition;
begin
  Assert((Index >= 0) and (Index < FDefinitions.Count));
  Result := FDefinitions[Index];
end;

function TInstructionEditor.GetDefinitionCount: Integer;
begin
  Result := FDefinitions.Count;
end;

function TInstructionEditor.GetDefinitionTopLevelFilter(
  Definition: TInstructionDefinition): TInstructionFilter;
begin
  Result := nil;
  case Definition.Encoding of
    ieDefault:
      begin
        case Definition.OpcodeMap of
          omDefault:
            Result := FRootTable;
          om0F:
            Result := FRootTable.Items[$0F];
          om0F38:
            Result := FRootTable.Items[$0F].Items[$38];
          om0F3A:
            Result := FRootTable.Items[$0F].Items[$3A];
          omXOP8,
          omXOP9,
          omXOPA:
            Assert(false);
        end;
      end;
    ie3DNow:
      Result := FRootTable.Items[$0F].Items[$0F].Items[$01];
    ieXOP:
      begin
        case Definition.OpcodeMap of
          omDefault,
          om0F,
          om0F38,
          om0F3A: Assert(false);
          omXOP8:
            Result := FRootTable.Items[$8F].Items[$02].Items[$01];
          omXOP9:
            Result := FRootTable.Items[$8F].Items[$02].Items[$02];
          omXOPA:
            Result := FRootTable.Items[$8F].Items[$02].Items[$03];
        end;
      end;
    ieVEX:
      Result := FRootTable.Items[$C4].Items[$03];
    ieEVEX:
      Result := FRootTable.Items[$62].Items[$04];
  end;
  Assert(Assigned(Result));
end;

class function TInstructionEditor.GetFilterList(
  Encoding: TInstructionEncoding): PInstructionFilterList;
begin
  Result := @FilterOrderDef;
  case Encoding of
    ieXOP:
      Result := @FilterOrderXOP;
    ieVEX:
      Result := @FilterOrderVEX;
    ieEVEX:
      Result := @FilterOrderEVEX;
  end;
end;

procedure TInstructionEditor.InsertDefinition(Definition: TInstructionDefinition);
var
  F, T: TInstructionFilter;
  I, Index: Integer;
  FilterList: PInstructionFilterList;
  IsRequiredFilter: Boolean;
begin
  BeginUpdate;
  try
    // Remove the definition from its old position
    RemoveDefinition(Definition);

    // Skip all static tables. This code assumes that the parent of a static-table is always
    // another static table.
    // There is no need to create a static table as child of a non-static one at the moment.
    F := GetDefinitionToplevelFilter(Definition);
    Index := F.GetInsertPosition(Definition);
    while (Assigned(F.Items[Index])) and (iffIsStaticFilter in F.Items[Index].FilterFlags) do
    begin
      F := F.Items[Index];
      Index := F.GetInsertPosition(Definition);
    end;

    // Create required filters
    FilterList := GetFilterList(Definition.Encoding);
    for I := Low(FilterList^) to High(FilterList^) do
    begin
      // Check if the current definition requires this filter
      IsRequiredFilter := false;
      case FilterList^[I].GetNeutralElementType of
        netNotAvailable:
          IsRequiredFilter := (FilterList^[I].GetInsertPosition(Definition) >= 0);
        netPlaceholder,
        netValue:
          IsRequiredFilter := (FilterList^[I].GetInsertPosition(Definition) >  0);
      end;

      Index := F.GetInsertPosition(Definition);

      // We have to enforce this filter, if a definition in the target-slot already requires the
      // same filter type
      if (not IsRequiredFilter) and (FilterList^[I].GetNeutralElementType <> netNotAvailable) and
        (F.Items[Index] is FilterList^[I]) then
      begin
        IsRequiredFilter := true;
      end;

      if (IsRequiredFilter) then
      begin
        // If the target slot is not occupied, just go ahead and create the new filter
        if (not Assigned(F.Items[Index])) then
        begin
          F.CreateFilterAtIndex(Index, FilterList^[I], false, false);
        end;
        // If the target slot is occupied by a different filter type, we need to save the old
        // filter and insert it into our new one
        if (F.Items[Index] is FilterList^[I]) then
        begin
          F := F.Items[Index];
        end else
        begin
          T := F.Items[Index];
          F.CreateFilterAtIndex(Index, FilterList^[I], false, false);
          F := F.Items[Index];
          F.SetItem(0, T);
        end;
      end;
    end;

    // Create a definition-container and actually insert the definition
    Index := F.GetInsertPosition(Definition);
    if (not Assigned(F.Items[Index])) then
    begin
      F.CreateFilterAtIndex(Index, TDefinitionContainer, false, false);
    end;
    F.Items[Index].InsertDefinition(Definition);
  finally
    EndUpdate;
  end;
end;

procedure TInstructionEditor.LoadFromFile(const Filename: String);
var
  List: TStringList;
  JSON: TJSONVariantData;
begin
  List := TStringList.Create;
  try
    List.LoadFromFile(Filename);
    JSON.Init;
    if (not JSON.FromJSON(List.Text)) or (JSON.Kind <> jvObject) then
    begin
      raise Exception.Create('Could not parse JSON file.');
    end;
    LoadFromJSON(@JSON);
  finally
    List.Free;
  end;
end;

procedure TInstructionEditor.LoadFromJSON(JSON: PJSONVariantData);
var
  JSONDefinitions,
  JSONDefinition: PJSONVariantData;
  I: Integer;
  Definition: TInstructionDefinition;
begin
  BeginUpdate;
  try
    Reset;
    try
      if (JSON^.Kind <> jvObject) then
      begin
        raise Exception.Create('Invalid JSON object.');
      end;
      JSONDefinitions := JSON^.Data('definitions');
      if ((not Assigned(JSONDefinitions)) or (JSONDefinitions^.Kind <> jvArray)) then
      begin
        raise Exception.Create(
          'The JSON object does not contain the required "definitions" array.');
      end;
      if (Assigned(FOnWorkStart)) then
      begin
        FOnWorkStart(Self, 0, JSONDefinitions^.Count);
      end;
      for I := 0 to JSONDefinitions^.Count - 1 do
      begin
        JSONDefinition := JSONVariantDataSafe(JSONDefinitions^.Item[I], jvObject);
        if (not Assigned(JSONDefinition)) then
        begin
          raise Exception.CreateFmt(
            'The definition item #%d is not a valid JSON object.', [I + 1]);
        end;
        // RegisterDefinition and InsertDefinition are indirectly called
        Definition := CreateDefinition('unnamed');
        Definition.BeginUpdate;
        try
          try
            Definition.UpdatePosition;
            Definition.LoadFromJSON(JSONDefinition);
          except
            on E: Exception do
            begin
              raise Exception.CreateFmt(
                'Error while parsing definition #%d: "%s"', [I + 1, E.Message]);
            end;
          end;
        finally
          Definition.EndUpdate;
        end;
        if (Assigned(FOnWork)) then
        begin
          FOnWork(Self, I + 1);
        end;
      end;
      if (Assigned(FOnWorkEnd)) then
      begin
        FOnWorkEnd(Self);
      end;
    except
      Reset;
      raise;
    end;
  finally
    EndUpdate;
  end;
end;

procedure TInstructionEditor.RegisterDefinition(Definition: TInstructionDefinition);
begin
  // This method is automatically called by TInstructionDefinition.Create
  Assert(not FDefinitions.Contains(Definition));
  FDefinitions.Add(Definition);
  if Assigned(FOnDefinitionCreated) then
  begin
    FOnDefinitionCreated(Self, Definition);
  end;
end;

procedure TInstructionEditor.RemoveDefinition(Definition: TInstructionDefinition);
var
  F, P, T: TInstructionFilter;
  I: Integer;
  DoRemove: Boolean;
begin
  if (not Assigned(Definition.Parent)) then
  begin
    Exit;
  end;
  BeginUpdate;
  try
    F := Definition.Parent;
    F.RemoveDefinition(Definition);
    if (F.DefinitionCount > 0) then
    begin
      Exit;
    end;
    // Remove empty filter tables
    DoRemove := true;
    while (DoRemove and Assigned(F) and (not (iffIsRootTable in F.FilterFlags))) do
    begin
      if (F.IsDefinitionContainer) then
      begin
        DoRemove := (F.DefinitionCount = 0);
      end else
      begin
        DoRemove := (not (iffIsStaticFilter in F.FilterFlags)) and
          ((F.ItemCount = 0) or ((F.NeutralElementType <> netNotAvailable) and
          (F.ItemCount = 1) and (Assigned(F.Items[0]))));
      end;
      if (DoRemove) then
      begin
        Assert(Assigned(F.Parent));
        P := F.Parent;
        I := P.IndexOf(F);
        if (not (F.IsDefinitionContainer)) and (Assigned(F.Items[0])) then
        begin
          T := F.Items[0];
          F.SetItem(0, nil);
          P.SetItem(I, T);
        end else
        begin
          P.SetItem(I, nil);
        end;
        F.Free;
        F := P;
      end;
    end;
  finally
    EndUpdate;
  end;
end;

procedure TInstructionEditor.Reset;
var
  I: Integer;
begin
  BeginUpdate;
  try
    FPreventDefinitionRemoval := true;
    for I := FDefinitions.Count - 1 downto 0 do
    begin
      FDefinitions[I].Free;
    end;
    FPreventDefinitionRemoval := false;
    FDefinitions.Clear;
    if (not Assigned(FRootTable)) then
    begin
      FFilterCount := 1;
      // 1, 2 and 3 Byte Opcode Tables
      FRootTable := TOpcodeFilter.Create(Self, nil, true, true);
      FRootTable.CreateFilterAtIndex($0F, TOpcodeFilter, false, true);
      FRootTable.Items[$0F].CreateFilterAtIndex($38, TOpcodeFilter, false, true);
      FRootTable.Items[$0F].CreateFilterAtIndex($3A, TOpcodeFilter, false, true);
      // 3DNow Table
      FRootTable.Items[$0F].CreateFilterAtIndex($0F, TEncodingFilter, false, true);
      FRootTable.Items[$0F].Items[$0F].CreateFilterAtIndex($01, TOpcodeFilter, false, true);
      // 3 Byte VEX Table
      FRootTable.CreateFilterAtIndex($C4, TEncodingFilter, false, true);
      FRootTable.Items[$C4].CreateFilterAtIndex($03, TVEXMapFilter, false, true);
      // 2 Byte VEX Table (we copy the 3 byte VEX table later)
      FRootTable.CreateFilterAtIndex($C5, TEncodingFilter, false, true);
      FRootTable.Items[$C5].CreateFilterAtIndex($03, TVEXMapFilter, false, true);
      // XOP Table
      FRootTable.CreateFilterAtIndex($8F, TEncodingFilter, false, true);
      FRootTable.Items[$8F].CreateFilterAtIndex($02, TXOPMapFilter, false, true);
      for I := 1 to FRootTable.Items[$8F].Items[$02].Capacity - 1 do
      begin
        FRootTable.Items[$8F].Items[$02].CreateFilterAtIndex(I, TOpcodeFilter, false, true);
      end;
      // EVEX Table
      FRootTable.CreateFilterAtIndex($62, TEncodingFilter, false, true);
      FRootTable.Items[$62].CreateFilterAtIndex($04, TVEXMapFilter, false, true);
    end;
  finally
    EndUpdate;
  end;
end;

procedure TInstructionEditor.SaveToFile(const Filename: String);
var
  JSON: TJSONVariantData;
  List: TStringList;
begin
  JSON.Init;
  SaveToJSON(@JSON);
  List := TStringList.Create;
  try
    List.Text := TJSONHelper.JSONToString(@JSON);
    List.SaveToFile(FileName);
  finally
    List.Free;
  end;
end;

procedure TInstructionEditor.SaveToJSON(JSON: PJSONVariantData);
var
  Comparison: TComparison<TInstructionDefinition>;
  I: Integer;
  JSONDefinitionList, JSONDefinition: TJSONVariantData;
begin
  // Sort definitions by mnemonic
  Comparison :=
    function(const Left, Right: TInstructionDefinition): Integer
    begin
      Result := CompareStr(Left.Mnemonic, Right.Mnemonic);
    end;
  FDefinitions.Sort(TComparer<TInstructionDefinition>.Construct(Comparison));
  // Save to JSON
  if (Assigned(FOnWorkStart)) then
  begin
    FOnWorkStart(Self, 0, FDefinitions.Count);
  end;
  JSONDefinitionList.Init;
  for I := 0 to FDefinitions.Count - 1 do
  begin
    JSONDefinition.Init;
    FDefinitions[I].SaveToJSON(@JSONDefinition);
    JSONDefinitionList.AddValue(Variant(JSONDefinition));
    if (Assigned(FOnWork)) then
    begin
      FOnWork(Self, I + 1);
    end;
  end;
  JSON^.AddNameValue('definitions', Variant(JSONDefinitionList));
  if (Assigned(FOnWorkEnd)) then
  begin
    FOnWorkEnd(Self);
  end;
end;

procedure TInstructionEditor.UnregisterDefinition(Definition: TInstructionDefinition);
begin
  // This method is automatically called by TInstructionDefinition.Destroy
  Assert(FDefinitions.Contains(Definition));
  if Assigned(FOnDefinitionDestroyed) then
  begin
    FOnDefinitionDestroyed(Self, Definition);
  end;
  if (not FPreventDefinitionRemoval) then
  begin
    FDefinitions.Remove(Definition);
  end;
end;
{$ENDREGION}

{$REGION 'Const: Constants used by TTableGenerator'}
const
  MNEMONIC_ALIASES: array[0..0] of String = (
    'nop'
  );
  FILENAME_INSTRUCTIONTABLE        = 'InstructionTable.inc';
  FILENAME_MNEMONICENUM            = 'Mnemonics.inc';
  FILENAME_MNEMONICSTRINGS         = 'MnemonicStrings.inc';
  FILENAME_INSTRUCTIONDEFINITIONS  = 'InstructionDefinitions.inc';
  SIZEOF_INSTRUCTIONTABLENODE      = 3;
  SIZEOF_INSTRUCTIONDEFINITION     = 10;
  TYPEOF_INSTRUCTIONTABLENODE      = 'ZydisInstructionTableNode';
  TYPEOF_INSTRUCTIONOPERANDS       = 'ZydisInstructionOperands';
  TYPEOF_INSTRUCTIONDEFINITION     = 'ZydisInstructionDefinition';
  INSTRUCTIONTABLENODE_INVALID     = 'ZYDIS_INVALID';
  INSTRUCTIONTABLENODE_FILTER      = 'ZYDIS_FILTER';
  INSTRUCTIONTABLENODE_DEFINITION  = 'ZYDIS_DEFINITION';
  PREFIX_FILTERARRAY               = 'filter';
  PREFIX_FILTERTYPE                = 'ZYDIS_NODETYPE_FILTER_';
  PREFIX_MNEMONIC                  = 'ZYDIS_MNEMONIC_';
  INSTRUCTIONDEFINITION_DEFINITION = 'ZYDIS_MAKE_DEFINITION';
  INSTRUCTIONDEFINITION_OPERAND    = 'ZYDIS_MAKE_OPERAND';
  PREFIX_OPERAND_TYPE              = 'ZYDIS_SEM_OPERAND_TYPE_';
  PREFIX_OPERAND_ENCODING          = 'ZYDIS_OPERAND_ENCODING_';
  PREFIX_OPERAND_ACCESSMODE        = 'ZYDIS_OPERAND_ACCESS_';
  ARRAYNAME_INSTRUCTIONOPERANDS    = 'instructionOperands';
  ARRAYNAME_INSTRUCTIONDEFINITIONS = 'instructionDefinitions';
{$ENDREGION}

{$REGION 'Class: TTableGenerator'}
constructor TTableGenerator.Create;
begin
  inherited Create;

end;

procedure TTableGenerator.CreateEntityLists(Editor: TInstructionEditor;
  var FilterList: TIndexedFilterList; var DefinitionList: TIndexedDefinitionList;
  var MnemonicList: TMnemonicList);

var
  IndexDict: TDictionary<TInstructionFilterClass, Integer>;

procedure CreateChildIndizes(var Root: TIndexedFilterItem);
var
  I, J: Integer;
begin
  SetLength(Root.Items, Root.Filter.Capacity);
  FillChar(Root.Items[0], Length(Root.Items) * SizeOf(Root.Items[0]), #0);
  for I := 0 to Root.Filter.Capacity - 1 do
  begin
    Root.Items[I].Id := -1;
    Root.Items[I].Filter := Root.Filter.Items[I];
    if (Assigned(Root.Items[I].Filter)) then
    begin
      if (not IndexDict.ContainsKey(TInstructionFilterClass(Root.Filter.Items[I].ClassType))) then
      begin
        Root.Items[I].Id := 0;
        IndexDict.Add(TInstructionFilterClass(Root.Filter.Items[I].ClassType), 1);
      end else
      begin
        Root.Items[I].Id := IndexDict[TInstructionFilterClass(Root.Filter.Items[I].ClassType)];
        IndexDict[TInstructionFilterClass(Root.Filter.Items[I].ClassType)] := Root.Items[I].Id + 1;
      end;

      if (Root.Items[I].Filter.IsDefinitionContainer) then
      begin
        // Fix mnemonic index
        for J := Low(DefinitionList) to High(DefinitionList) do
        begin
          if (DefinitionList[J].Definition.Parent = Root.Items[I].Filter) then
          begin
            Root.Items[I].Id := DefinitionList[J].Id;
            Break;
          end;
        end;
      end else
      begin
        Inc(FStatistics.FilterCount);
        Inc(FStatistics.FilterSize, Root.Items[I].Filter.GetCapacity * SIZEOF_INSTRUCTIONTABLENODE);
        if (Root.Items[I].Filter.NeutralElementType = netPlaceholder) then
        begin
          Dec(FStatistics.FilterSize, SIZEOF_INSTRUCTIONTABLENODE);
        end;
        Work(FStatistics.FilterCount);
      end;

      CreateChildIndizes(Root.Items[I]);
    end;
  end;
end;

var
  ListDict: TDictionary<TInstructionFilterClass, TList<TIndexedFilterItem>>;

procedure AddFiltersToListDict(const Root: TIndexedFilterItem);
var
  FilterList: TList<TIndexedFilterItem>;
  I: Integer;
begin
  if (Root.IsRedirect) then Exit;
  if (not ListDict.ContainsKey(TInstructionFilterClass(Root.Filter.ClassType))) then
  begin
    FilterList := TList<TIndexedFilterItem>.Create;
    ListDict.Add(TInstructionFilterClass(Root.Filter.ClassType), FilterList);
  end else
  begin
    FilterList := ListDict[TInstructionFilterClass(Root.Filter.ClassType)];
  end;
  FilterList.Add(Root);
  for I := Low(Root.Items) to High(Root.Items) do
  begin
    if (Root.Items[I].Id < 0) or (Root.Items[I].Filter is TEncodingFilter) then Continue;
    AddFiltersToListDict(Root.Items[I]);
  end;
end;

var
  DList: TList<TInstructionDefinition>;
  DComparison: TComparison<TInstructionDefinition>;
  MList: TList<String>;
  MComparison: TComparison<String>;
  I, J, K: Integer;
  Root, Temp: TIndexedFilterItem;
  A: TArray<TPair<TInstructionFilterClass, TList<TIndexedFilterItem>>>;
begin
  // Create definition indizes and a sorted definition-list
  DList := TList<TInstructionDefinition>.Create;
  try
    WorkStart(woIndexingDefinitions, 0, Editor.DefinitionCount * 2);
    for I := 0 to Editor.DefinitionCount - 1 do
    begin
      DList.Add(Editor.Definitions[I]);
      Work(I + 1);
    end;
    DComparison :=
      function(const Left, Right: TInstructionDefinition): Integer
      begin
        Result := CompareStr(Left.Mnemonic, Right.Mnemonic);
      end;
    DList.Sort(TComparer<TInstructionDefinition>.Construct(DComparison));
    SetLength(DefinitionList, DList.Count);
    for I := 0 to DList.Count - 1 do
    begin
      DefinitionList[I].Id := I;
      DefinitionList[I].Definition := DList[I];
      Work(Editor.DefinitionCount + I + 1);
    end;
    WorkEnd;
  finally
    DList.Free;
  end;
  FStatistics.DefinitionCount := Length(DefinitionList);
  FStatistics.DefinitionSize := Length(DefinitionList) * SIZEOF_INSTRUCTIONDEFINITION;

  // Create sorted mnemonic list with all aliases
  FStatistics.MnemonicSize := 0;
  MList := TList<String>.Create;
  try
    for I := 0 to Editor.DefinitionCount - 1 do
    begin
      MList.Add(Editor.Definitions[I].Mnemonic);
    end;
    for I := Low(MNEMONIC_ALIASES) to High(MNEMONIC_ALIASES) do
    begin
      MList.Add(MNEMONIC_ALIASES[I]);
    end;
    MComparison :=
      function(const Left, Right: String): Integer
      begin
        Result := CompareStr(Left, Right);
      end;
    MList.Sort(TComparer<String>.Construct(MComparison));
    for I := MList.Count - 1 downto 1 do
    begin
      if (MList[I] = MList[I - 1]) then
      begin
        MList.Delete(I);
      end;
    end;
    MList.Insert(0, 'invalid');
    SetLength(MnemonicList, MList.Count);
    for I := 0 to MList.Count - 1 do
    begin
      MnemonicList[I] := MList[I];
      Inc(FStatistics.MnemonicSize, Length(MnemonicList[I]));
    end;
  finally
    MList.Free;
  end;
  FStatistics.MnemonicCount := Length(MnemonicList);

  IndexDict := TDictionary<TInstructionFilterClass, Integer>.Create;
  try
    // Generate internal tree structure
    Root.Id := 0;
    Root.Filter := Editor.RootTable;
    Root.IsRedirect := false;
    IndexDict.Add(TOpcodeFilter, 1);
    FStatistics.FilterCount := 1;
    FStatistics.FilterSize := 256 * SIZEOF_INSTRUCTIONTABLENODE;
    WorkStart(woIndexingFilters, 0, Editor.FilterCount - 1);
    CreateChildIndizes(Root);
    WorkEnd;

    // Unlink encoding filters
    Root.Items[$0F].Items[$0F] := Root.Items[$0F].Items[$0F].Items[$01];
    Temp := Root.Items[$C4].Items[$03];
    Temp.Items[$00] := Root.Items[$C4].Items[$00];
    Root.Items[$C4] := Temp;
    Temp := Root.Items[$C5].Items[$03];
    Temp.Items[$00] := Root.Items[$C5].Items[$00];
    Root.Items[$C5] := Temp;
    Temp := Root.Items[$62].Items[$04];
    Temp.Items[$00] := Root.Items[$62].Items[$00];
    Root.Items[$62] := Temp;
    Temp := Root.Items[$8F].Items[$02];
    Temp.Items[$00] := Root.Items[$8F].Items[$00];
    Root.Items[$8F] := Temp;

    // Initialize 2-byte VEX filter
    Root.Items[$C5].Items[$01] := Root.Items[$C4].Items[$01]; // 0x0F
    Root.Items[$C5].Items[$01].IsRedirect := true;
    Root.Items[$C5].Items[$05] := Root.Items[$C4].Items[$05]; // 0x66 0x0F
    Root.Items[$C5].Items[$05].IsRedirect := true;
    Root.Items[$C5].Items[$09] := Root.Items[$C4].Items[$09]; // 0xF3 0x0F
    Root.Items[$C5].Items[$09].IsRedirect := true;
    Root.Items[$C5].Items[$0D] := Root.Items[$C4].Items[$0D]; // 0xF2 0x0F
    Root.Items[$C5].Items[$0D].IsRedirect := true;

    Dec(FStatistics.FilterCount, 5);
    Dec(FStatistics.FilterSize, 5 * 5 * SIZEOF_INSTRUCTIONTABLENODE);

    // Generate filter list
    ListDict :=
      TObjectDictionary<TInstructionFilterClass, TList<TIndexedFilterItem>>.Create([doOwnsValues]);
    try
      AddFiltersToListDict(Root);
      A := ListDict.ToArray;
      SetLength(FilterList, Length(A));
      for I := Low(A) to High(A) do
      begin
        FilterList[I].Key := A[I].Key;
        FilterList[I].Value := A[I].Value.ToArray;
        // Clear recursive child-item arrays
        for J := Low(FilterList[I].Value) to HigH(FilterList[I].Value) do
        begin
          for K := Low(FilterList[I].Value[J].Items) to High(FilterList[I].Value[J].Items) do
          begin
            SetLength(FilterList[I].Value[J].Items[K].Items, 0);
          end;
        end;
      end;
    finally
      ListDict.Free;
    end;
  finally
    IndexDict.Free;
  end;
end;

destructor TTableGenerator.Destroy;
begin

  inherited;
end;

procedure TTableGenerator.GenerateDefinitionList(const OutputDirectory: String;
  const DefinitionList: PIndexedDefinitionList);

procedure AppendOperand(Buffer: TStringBuffer; Operand: TInstructionOperand);
var
  OperandType,
  OperandEncoding,
  OperandAccessMode: String;
begin
  OperandType := 'UNUSED';
  case Operand.OperandType of
    optGPR8       : OperandType := 'GPR8';
    optGPR16      : OperandType := 'GPR16';
    optGPR32      : OperandType := 'GPR32';
    optGPR64      : OperandType := 'GPR64';
    optFPR        : OperandType := 'FPR';
    optVR64       : OperandType := 'VR64';
    optVR128      : OperandType := 'VR128';
    optVR256      : OperandType := 'VR256';
    optVR512      : OperandType := 'VR512';
    optCR         : OperandType := 'CR';
    optDR         : OperandType := 'DR';
    optMSKR       : OperandType := 'MSKR';
    optBNDR       : OperandType := 'BNDR';
    optMem        : OperandType := 'MEM';
    optMem8       : OperandType := 'MEM8';
    optMem16      : OperandType := 'MEM16';
    optMem32      : OperandType := 'MEM32';
    optMem64      : OperandType := 'MEM64';
    optMem80      : OperandType := 'MEM80';
    optMem128     : OperandType := 'MEM128';
    optMem256     : OperandType := 'MEM256';
    optMem512     : OperandType := 'MEM512';
    optMem32Bcst2 : OperandType := 'MEM32_BCST2';
    optMem32Bcst4 : OperandType := 'MEM32_BCST4';
    optMem32Bcst8 : OperandType := 'MEM32_BCST8';
    optMem32Bcst16: OperandType := 'MEM32_BCST16';
    optMem64Bcst2 : OperandType := 'MEM64_BCST2';
    optMem64Bcst4 : OperandType := 'MEM64_BCST4';
    optMem64Bcst8 : OperandType := 'MEM64_BCST8';
    optMem64Bcst16: OperandType := 'MEM64_BCST16';
    optMem112     : OperandType := 'MEM112';
    optMem224     : OperandType := 'MEM224';
    optImm8       : OperandType := 'IMM8';
    optImm16      : OperandType := 'IMM16';
    optImm32      : OperandType := 'IMM32';
    optImm64      : OperandType := 'IMM64';
    optImm8U      : OperandType := 'IMM8U';
    optRel8       : OperandType := 'REL8';
    optRel16      : OperandType := 'REL16';
    optRel32      : OperandType := 'REL32';
    optRel64      : OperandType := 'REL64';
    optPtr1616    : OperandType := 'PTR1616';
    optPtr1632    : OperandType := 'PTR1632';
    optPtr1664    : OperandType := 'PTR1664';
    optMoffs16    : OperandType := 'MOFFS16';
    optMoffs32    : OperandType := 'MOFFS32';
    optMoffs64    : OperandType := 'MOFFS64';
    optSrcIndex8  : OperandType := 'SRCIDX8';
    optSrcIndex16 : OperandType := 'SRCIDX16';
    optSrcIndex32 : OperandType := 'SRCIDX32';
    optSrcIndex64 : OperandType := 'SRCIDX64';
    optDstIndex8  : OperandType := 'DSTIDX8';
    optDstIndex16 : OperandType := 'DSTIDX16';
    optDstIndex32 : OperandType := 'DSTIDX32';
    optDstIndex64 : OperandType := 'DSTIDX64';
    optSREG       : OperandType := 'SREG';
    optMem1616    : OperandType := 'M1616';
    optMem1632    : OperandType := 'M1632';
    optMem1664    : OperandType := 'M1664';
    optMem32VSIBX : OperandType := 'MEM32_VSIBX';
    optMem32VSIBY : OperandType := 'MEM32_VSIBY';
    optMem32VSIBZ : OperandType := 'MEM32_VSIBZ';
    optMem64VSIBX : OperandType := 'MEM64_VSIBX';
    optMem64VSIBY : OperandType := 'MEM64_VSIBY';
    optMem64VSIBZ : OperandType := 'MEM64_VSIBZ';
    optFixed1     : OperandType := 'FIXED1';
    optFixedAL    : OperandType := 'AL';
    optFixedCL    : OperandType := 'CL';
    optFixedAX    : OperandType := 'AX';
    optFixedDX    : OperandType := 'DX';
    optFixedEAX   : OperandType := 'EAX';
    optFixedRAX   : OperandType := 'RAX';
    optFixedES    : OperandType := 'ES';
    optFixedCS    : OperandType := 'CS';
    optFixedSS    : OperandType := 'SS';
    optFixedDS    : OperandType := 'DS';
    optFixedGS    : OperandType := 'GS';
    optFixedFS    : OperandType := 'FS';
    optFixedST0   : OperandType := 'ST0';
  end;
  OperandEncoding := 'NONE';
  case Operand.Encoding of
    opeModrmReg   : OperandEncoding := 'REG';
    opeModrmRm    : OperandEncoding := 'RM';
    opeModrmRmCD1 : OperandEncoding := 'RM';
    opeModrmRmCD2 : OperandEncoding := 'RM_CD2';
    opeModrmRmCD4 : OperandEncoding := 'RM_CD4';
    opeModrmRmCD8 : OperandEncoding := 'RM_CD8';
    opeModrmRmCD16: OperandEncoding := 'RM_CD16';
    opeModrmRmCD32: OperandEncoding := 'RM_CD32';
    opeModrmRmCD64: OperandEncoding := 'RM_CD64';
    opeOpcodeBits : OperandEncoding := 'OPCODE';
    opeVexVVVV    : OperandEncoding := 'VVVV';
    opeEvexAAA    : OperandEncoding := 'AAA';
    opeImm8       : OperandEncoding := 'IMM8';
    opeImm16      : OperandEncoding := 'IMM16';
    opeImm32      : OperandEncoding := 'IMM32';
    opeImm64      : OperandEncoding := 'IMM64';
  end;
  OperandAccessMode := 'READ';
  case Operand.AccessMode of
    opaWrite      : OperandAccessMode := 'WRITE';
    opaReadWrite  : OperandAccessMode := 'READWRITE';
  end;
  Buffer.Append(Format('%s(%s%s, %s%s, %s%s)', [INSTRUCTIONDEFINITION_OPERAND,
    PREFIX_OPERAND_TYPE, OperandType, PREFIX_OPERAND_ENCODING, OperandEncoding,
    PREFIX_OPERAND_ACCESSMODE, OperandAccessMode]));
end;

var
  Buffer: TStringBuffer;
  StringList: TStringList;
  I, J: Integer;

  S, T, U: String;

  Operands: TList<TInstructionOperands>;
  B: Boolean;
begin
  Operands := TList<TInstructionOperands>.Create;
  try
    for I := Low(DefinitionList^) to High(DefinitionList^) do
    begin
      B := false;
      for J := 0 to Operands.Count - 1 do
      begin
        if (Operands[J].Equals(DefinitionList^[I].Definition.Operands)) then
        begin
          B := true;
          Break;
        end;
      end;
      if (not B) then
      begin
        Operands.Add(DefinitionList^[I].Definition.Operands);
      end;
    end;

    Buffer := TStringBuffer.Create;
    try
      Buffer.AppendLn(Format('const %s %s[] =', [
        TYPEOF_INSTRUCTIONOPERANDS, ARRAYNAME_INSTRUCTIONOPERANDS]));
      Buffer.AppendLn('{');
      for I := 0 to Operands.Count - 1 do
      begin
        Buffer.Append(Format('    /*%.4x*/ { ', [I]));
        for J := 0 to 3 do
        begin
          AppendOperand(Buffer, Operands[I].GetOperandById(J));
          if (J <> 3) then
          begin
            Buffer.Append(', ');
          end;
        end;
        if (I <> (Operands.Count - 1)) then
        begin
          Buffer.AppendLn(' },');
        end else
        begin
          Buffer.AppendLn(' }');
        end;
      end;
      Buffer.AppendLn('};');
      Buffer.AppendLn('');

      Buffer.AppendLn(Format('const %s %s[] =', [
        TYPEOF_INSTRUCTIONDEFINITION, ARRAYNAME_INSTRUCTIONDEFINITIONS]));
      Buffer.AppendLn('{');
      WorkStart(woGeneratingDefinitionFiles, 0, Length(DefinitionList^));
      for I := Low(DefinitionList^) to High(DefinitionList^) do
      begin
        Buffer.Append(Format('    /*%.4x*/ ', [I]));
        //Buffer.Append(Format('{ %s%s, { ', [
        Buffer.Append(Format('ZYDIS_MAKE_DEFINITION(%s%s, ', [
          PREFIX_MNEMONIC, AnsiUpperCase(DefinitionList^[I].Definition.Mnemonic)]));
        {for J := 0 to 3 do
        begin
          AppendOperand(Buffer, DefinitionList^[I].Definition.Operands.GetOperandById(J));
          if (J <> 3) then
          begin
            Buffer.Append(', ');
          end;
        end;}

        for J := 0 to Operands.Count - 1 do
        begin
          if (Operands[J].Equals(DefinitionList^[I].Definition.Operands)) then
          begin
            Buffer.Append(Format('0x%.4x', [J]));
            Break;
          end;
        end;

        //Buffer.Append(' }');

        S := '0'; T := '0'; U := '0';
        if (ifAcceptsEvexAAA in DefinitionList^[I].Definition.Flags) then S := '1';
        if (ifAcceptsEvexZ   in DefinitionList^[I].Definition.Flags) then T := '1';
        if (ifHasEvexBC      in DefinitionList^[I].Definition.Flags) then U := '1'
        else
        if (ifHasEvexRC      in DefinitionList^[I].Definition.Flags) then U := '2'
        else
        if (ifHasEvexSAE     in DefinitionList^[I].Definition.Flags) then U := '3';

        Buffer.Append(Format(', ZYDIS_MAKE_AVX512INFO(%s, %s, %s)', [U, S, T]));

        if (I <> High(DefinitionList^)) then
        begin
          //Buffer.AppendLn(' },');
          Buffer.AppendLn(' ),');
        end else
        begin
          //Buffer.AppendLn(' }');
          Buffer.AppendLn(' )');
        end;
        Work(I + 1);
      end;
      WorkEnd;
      if (Length(DefinitionList^) = 0) then
      begin
        Buffer.AppendLn(Format('    /*0000*/ { %sINVALID }', [PREFIX_MNEMONIC]));
      end;
      Buffer.AppendLn('};');
      StringList := TStringList.Create;
      try
        StringList.Text := Buffer.Value;
        StringList.SaveToFile(OutputDirectory + FILENAME_INSTRUCTIONDEFINITIONS);
      finally
        StringList.Free;
      end;
    finally
      Buffer.Free;
    end;

  finally
    Operands.Free;
  end;
end;

procedure TTableGenerator.GenerateFiles(Editor: TInstructionEditor; const OutputDirectory: String);
var
  FilterList: TIndexedFilterList;
  DefinitionList: TIndexedDefinitionList;
  MnemonicList: TMnemonicList;
begin
  // Check error cases
  if (not Assigned(Editor.RootTable)) then
  begin
    raise Exception.Create('The instruction editor does not contain tables.');
  end;
  if (Editor.RootTable.HasConflicts) then
  begin
    raise Exception.Create('The instruction editor has unresolved conflicts.');
  end;

  CreateEntityLists(Editor, FilterList, DefinitionList, MnemonicList);
  GenerateInstructionTable(OutputDirectory, @FilterList, FStatistics.FilterCount);
  GenerateDefinitionList(OutputDirectory, @DefinitionList);
  GenerateMnemonicLists(OutputDirectory, @MnemonicList);
end;

procedure TTableGenerator.GenerateInstructionTable(const OutputDirectory: String;
  const FilterList: PIndexedFilterList; FilterCount: Integer);
var
  Buffer: TStringBuffer;
  StringList: TStringList;
  A: ^TArray<TIndexedFilterItem>;
  WorkCount,
  IndexShift: Integer;
  I, J, K: Integer;
begin
  Buffer := TStringBuffer.Create;
  try
    WorkCount := 0;
    WorkStart(woGeneratingFilterFiles, 0, FilterCount);
    for I := Low(InstructionFilterClasses) to High(InstructionFilterClasses) do
    begin
      if (InstructionFilterClasses[I] = TEncodingFilter) then Continue;
      IndexShift := 0;
      if (InstructionFilterClasses[I].GetNeutralElementType = netPlaceholder) then
      begin
        IndexShift := 1;
      end;

      // Open the filter-array
      Buffer.AppendLn(Format('const %s %s%s[][%d] = ', [
        TYPEOF_INSTRUCTIONTABLENODE, PREFIX_FILTERARRAY,
        InstructionFilterClasses[I].GetDescription,
        Integer(InstructionFilterClasses[I].GetCapacity) - IndexShift]));
      Buffer.AppendLn('{');

      A := nil;
      for J := Low(FilterList^) to High(FilterList^) do
      begin
        if (FilterList^[J].Key = InstructionFilterClasses[I]) then
        begin
          A := @FilterList^[J].Value;
          Break;
        end;
      end;

      if (Assigned(A)) then
      begin
        // Add all filters of the current type
        for J := Low(A^) to High(A^) do
        begin

          // Open the local filter array
          Buffer.AppendLn('    {');

          // Add all filter values of the current filter
          for K := IndexShift to High(A^[J].Items) do
          begin
            Buffer.Append(Format('        /*%.4x*/ ', [K]));
            if (A^[J].Items[K].Id < 0) then
            begin
              Buffer.Append(INSTRUCTIONTABLENODE_INVALID);
            end else if (A^[J].Items[K].Filter is TDefinitionContainer) then
            begin
              Assert((A^[J].Items[K].Filter as TDefinitionContainer).DefinitionCount = 1);
              Buffer.Append(Format('%s(0x%.4x)', [
                INSTRUCTIONTABLENODE_DEFINITION, A^[J].Items[K].Id]));
            end else
            begin
              Buffer.Append(Format('%s(%s%s, 0x%.4x)', [
                INSTRUCTIONTABLENODE_FILTER, PREFIX_FILTERTYPE, AnsiUpperCase(
                TInstructionFilterClass(A^[J].Items[K].Filter.ClassType).GetDescription),
                A^[J].Items[K].Id]));
            end;
            if (K < High(A^[J].Items)) then
            begin
              Buffer.AppendLn(',');
            end else
            begin
              Buffer.AppendLn('');
            end;
          end;

          // Close the local filter array
          Buffer.Append('    }');
          if (J < High(A^)) then
          begin
            Buffer.AppendLn(',');
          end else
          begin
            Buffer.AppendLn('');
          end;

          Inc(WorkCount);
          Work(WorkCount);
        end;
      end else
      begin
        Buffer.AppendLn('    {');
        for J := IndexShift to InstructionFilterClasses[I].GetCapacity - 1 do
        begin
          Buffer.Append(Format('        /*%.4x*/ %s', [J, INSTRUCTIONTABLENODE_INVALID]));
          if (J < Integer(InstructionFilterClasses[I].GetCapacity - 1)) then
          begin
            Buffer.AppendLn(',');
          end else
          begin
            Buffer.AppendLn('');
          end;
        end;
        Buffer.AppendLn('    }');
      end;

      // Close the filter array
      Buffer.AppendLn('};');
      if (I < High(InstructionFilterClasses)) then
      begin
        Buffer.AppendLn('');
      end;

    end;
    WorkEnd;

    StringList := TStringList.Create;
    try
      StringList.Text := Buffer.Value;
      StringList.SaveToFile(OutputDirectory + FILENAME_INSTRUCTIONTABLE);
    finally
      StringList.Free;
    end;
  finally
    Buffer.Free;
  end;
end;

procedure TTableGenerator.GenerateMnemonicLists(const OutputDirectory: String;
  const MnemonicList: PMnemonicList);
var
  I: Integer;
  MnemonicEnum,
  MnemonicStrings: TStringBuffer;
  StringList: TStringList;
begin
  MnemonicEnum := TStringBuffer.Create;
  try
    MnemonicStrings := TStringBuffer.Create;
    try
      WorkStart(woGeneratingMnemonicFiles, 0, Length(MnemonicList^));
      for I := Low(MnemonicList^) to High(MnemonicList^) do
      begin
        MnemonicEnum.Append(Format('    /*%.4x*/ %s%s', [
          I, PREFIX_MNEMONIC, AnsiUpperCase(MnemonicList^[I])]));
        MnemonicStrings.Append(Format('    /*%.4x*/ "%s"', [I, MnemonicList^[I]]));
        if (I <> High(MnemonicList^)) then
        begin
          MnemonicEnum.AppendLn(',');
          MnemonicStrings.AppendLn(',');
        end else
        begin
          MnemonicEnum.AppendLn('');
          MnemonicStrings.AppendLn('');
        end;
        Work(I + 1);
      end;
      WorkEnd;
      StringList := TStringList.Create;
      try
        StringList.Text := MnemonicEnum.Value;
        StringList.SaveToFile(OutputDirectory + FILENAME_MNEMONICENUM);
        StringList.Text := MnemonicStrings.Value;
        StringList.SaveToFile(OutputDirectory + FILENAME_MNEMONICSTRINGS);
      finally
        StringList.Free;
      end;
    finally
      MnemonicStrings.Free;
    end;
  finally
    MnemonicEnum.Free;
  end;
end;

procedure TTableGenerator.Work(WorkCount: Integer);
begin
  if (Assigned(FOnWork)) then
  begin
    FOnWork(Self, WorkCount);
  end;
end;

procedure TTableGenerator.WorkEnd;
begin
  if (Assigned(FOnWorkEnd)) then
  begin
    FOnWorkEnd(Self);
  end;
end;

procedure TTableGenerator.WorkStart(Operation: TGeneratorWorkOperation; MinWorkCount,
  MaxWorkCount: Integer);
begin
  if (Assigned(FOnWorkStart)) then
  begin
    FOnWorkStart(Self, Operation, MinWorkCount, MaxWorkCount);
  end;
end;
{$ENDREGION}

end.

