:set -XOverloadedStrings
:set prompt ""

import Sound.Tidal.Context

import System.IO (hSetEncoding, stdout, utf8)

hSetEncoding stdout utf8

-- total latency = oLatency + cFrameTimespan
tidal <- startTidal (superdirtTarget {oLatency = 0.2, oAddress = "127.0.0.1", oPort = 57120}) (defaultConfig {cFrameTimespan = 1/20})

:{
let p = streamReplace tidal
    -- hush = streamHush tidal
    hush = mapM_ ($ silence) [d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,d15,d16]
    list = streamList tidal
    mute = streamMute tidal
    unmute = streamUnmute tidal
    solo = streamSolo tidal
    unsolo = streamUnsolo tidal
    once = streamOnce tidal
    first = streamFirst tidal
    asap = once
    nudgeAll = streamNudgeAll tidal
    all = streamAll tidal
    resetCycles = streamResetCycles tidal
    setcps = asap . cps
    xfade i = transition tidal True (Sound.Tidal.Transition.xfadeIn 4) i
    xfadeIn i t = transition tidal True (Sound.Tidal.Transition.xfadeIn t) i
    histpan i t = transition tidal True (Sound.Tidal.Transition.histpan t) i
    wait i t = transition tidal True (Sound.Tidal.Transition.wait t) i
    waitT i f t = transition tidal True (Sound.Tidal.Transition.waitT f t) i
    jump i = transition tidal True (Sound.Tidal.Transition.jump) i
    jumpIn i t = transition tidal True (Sound.Tidal.Transition.jumpIn t) i
    jumpIn' i t = transition tidal True (Sound.Tidal.Transition.jumpIn' t) i
    jumpMod i t = transition tidal True (Sound.Tidal.Transition.jumpMod t) i
    mortal i lifespan release = transition tidal True (Sound.Tidal.Transition.mortal lifespan release) i
    interpolate i = transition tidal True (Sound.Tidal.Transition.interpolate) i
    interpolateIn i t = transition tidal True (Sound.Tidal.Transition.interpolateIn t) i
    clutch i = transition tidal True (Sound.Tidal.Transition.clutch) i
    clutchIn i t = transition tidal True (Sound.Tidal.Transition.clutchIn t) i
    anticipate i = transition tidal True (Sound.Tidal.Transition.anticipate) i
    anticipateIn i t = transition tidal True (Sound.Tidal.Transition.anticipateIn t) i
    forId i t = transition tidal False (Sound.Tidal.Transition.mortalOverlay t) i
    d1 = p 1 . (|< orbit 0)
    d2 = p 2 . (|< orbit 1)
    d3 = p 3 . (|< orbit 2)
    d4 = p 4 . (|< orbit 3)
    d5 = p 5 . (|< orbit 4)
    d6 = p 6 . (|< orbit 5)
    d7 = p 7 . (|< orbit 6)
    d8 = p 8 . (|< orbit 7)
    d9 = p 9 . (|< orbit 8)
    d10 = p 10 . (|< orbit 9)
    d11 = p 11 . (|< orbit 10)
    d12 = p 12 . (|< orbit 11)
    d13 = p 13
    d14 = p 14
    d15 = p 15
    d16 = p 16
-- custom function
    -- use it with overlay combination
    snowball' :: Int -> (Pattern a -> Pattern a -> Pattern a) -> (Pattern a -> Pattern a) -> Pattern a -> Pattern a
    snowball' depth combinationFunction f pattern = cat $ take depth $
      scanl combinationFunction pattern $ drop 1 $ iterate f pattern
    -- use it in stack
    listen n p = selectF n [(const $ s "~"), id] $ p
    -- use it with multiple instances of degradeBy, offset the randomness
    degOffsetBy :: Pattern Time -> Pattern Double -> Pattern a -> Pattern a
    degOffsetBy n = tParam (_degradeByUsing ((n ~>) rand))
-- custom control for external SynthDef
    amp = pF "amp"
    dec = pF "dec"
    atkT = pF "atkT"
    relT = pF "relT"
    curve = pF "curve"
    beatFreq = pF "beatFreq"
    tu = pF "tu"
    myst = pF "myst"
    dur = pF "dur"
    exciterRel = pF "exciterRel"
    envL1 = pF "envL1"
    envL2 = pF "envL2"
    envL3 = pF "envL3"
    envT1 = pF "envT1"
    envT2 = pF "envT2"
    enfL1 = pF "enfL1"
    enfL2 = pF "enfL2"
    enfL3 = pF "enfL3"
    enfT1 = pF "enfT1"
    enfT2 = pF "enfT2"
    enfT3 = pF "enfT3"
    attLowf = pF "attLowf"
    relLowf = pF "relLowf"
    lowNoiseLev = pF "lowNoiseLev"
    attHif = pF "attHif"
    relHif = pF "relHif"
    hiNoiseLev = pF "hiNoiseLev"
    attHi = pF "attHi"
    relHi = pF "relHi"
    hiLev = pF "hiLev"
    attTh = pF "attTh"
    relTh = pF "relTh"
    freq1 = pF "freq1"
    freq2 = pF "freq2"
    freq3 = pF "freq3"
    freq4 = pF "freq4"
    ringAmp = pF "ringAmp"
    ringRel = pF "ringRel"
    wobbleDepth = pF "wobbleDepth"
    wobbleMin = pF "wobbleMin"
    wobbleMax = pF "wobbleMax"
    strikeAmp = pF "strikeAmp"
    strikeDec = pF "strikeDec"
    strikeRel = pF "strikeRel"
    strikeDepth = pF "strikeDepth"
    strikeHarmonic = pF "strikeHarmonic"
    humAmp = pF "humAmp"
    humAtt = pF "humAtt"
    humDec = pF "humDec"
    humRel = pF "humRel"
    blpFreq1 = pF "blpFreq1"
    blpFreq2 = pF "blpFreq2"
    seqRate = pF "seqRate"
    seqVal1 = pF "seqVal1"
    seqVal2 = pF "seqVal2"
    seqVal3 = pF "seqVal3"
    envL4 = pF "envL4"
    envL5 = pF "envL5"
    randFreq = pF "randFreq"
    randAmt = pF "randAmt"
    envT3 = pF "envT3"
    envT4 = pF "envT4"
    envT5 = pF "envT5"
    mixNoise = pF "mixNoise"
    sinFreq = pF "sinFreq"
    sinAmp = pF "sinAmp"
    fsinFreq = pF "fsinFreq"
    fsinAmp = pF "fsinAmp"
    mixSaw = pF "mixSaw"
    sawFreq = pF "sawFreq"
    hpfreq = pF "hpfreq"
    hprq = pF "hprq"
    feedBack = pF "feedBack"
    fbPost = pF "fbPost"
    dustfreq = pF "dustfreq"
    dustdecay = pF "dustdecay"
    fmfreq = pF "fmfreq"
    folAtt = pF "folAtt"
    folDec = pF "folDec"
    sinMix = pF "sinMix"
    a = pF "a"
    b = pF "b"
    c = pF "c"
    d = pF "d"
    xi = pF "xi"
    yi = pF "yi"
    depth = pF "depth"
    regen = pF "regen"
    sweep = pF "sweep"
    rq = pF "rq"
    x = pF "x"
    drumRel = pF "drumRel"
    stickRel = pF "stickRel"
    drumModeAmp = pF "drumModeAmp"
    timbreIndex = pF "timbreIndex"
    feedback = pF "feedback"
    delaytime = pF "delaytime"
    decaytime = pF "decaytime"
    level = pF "level"
    note1 = pF "note1"
    note2 = pF "note2"
    amp1 = pF "amp1"
    amp2 = pF "amp2"
    lpfFreq = pF "lpfFreq"
    hpfFreq = pF "hpfFreq"
    basefreq = pF "basefreq"
    ratio = pF "ratio"
    sweeptime = pF "sweeptime"
    singSwitch = pF "singSwitch"
    decayScale = pF "decayScale"
    lag = pF "lag"
    baseFreq = pF "baseFreq"
    penvL1 = pF "penvL1"
    penvL2 = pF "penvL2"
    ptime = pF "ptime"
    pcurve = pF "pcurve"
    pulsew = pF "pulsew"
    rlpfFrq = pF "rlpfFrq"
    rlpfRq = pF "rlpfRq"
    rhpfFrq = pF "rhpfFrq"
    rhpfRq = pF "rhpfRq"
    envC1 = pF "envC1"
    envC2 = pF "envC2"
    envC3 = pF "envC3"
    envC4 = pF "envC4"
    tridDur = pF "tridDur"
    roomSize = pF "roomSize"
    levScale = pF "levScale"
    seqv1 = pF "seqv1"
    seqv2 = pF "seqv2"
    seqv3 = pF "seqv3"
    seqv4 = pF "seqv4"
    seqv5 = pF "seqv5"
    seqFreq = pF "seqFreq"
    freqMin = pF "freqMin"
    freqMax = pF "freqMax"
    bwrMod = pF "bwrMod"
    wamp = pF "wamp"
    envNatt = pF "envNatt"
    envNrel = pF "envNrel"
    wbpfFreq = pF "wbpfFreq"
    wbpfRq = pF "wbpfRq"
    sinFrq1 = pF "sinFrq1"
    sinFrq2 = pF "sinFrq2"
    sinPh1 = pF "sinPh1"
    sinPh2 = pF "sinPh2"
    sinLev1 = pF "sinLev1"
    sinLev2 = pF "sinLev2"
    envSatt = pF "envSatt"
    envSrel = pF "envSrel"
    mix = pF "mix"
    ffreq = pF "ffreq"
    noise = pF "noise"
    dc = pF "dc"
    env0L1 = pF "env0L1"
    env0L2 = pF "env0L2"
    env0L3 = pF "env0L3"
    env0L4 = pF "env0L4"
    atkEnv0 = pF "atkEnv0"
    decEnv0 = pF "decEnv0"
    relEnv0 = pF "relEnv0"
    fratio = pF "fratio"
    env1L1 = pF "env1L1"
    env1L2 = pF "env1L2"
    env1L3 = pF "env1L3"
    env1T1 = pF "env1T1"
    env1T2 = pF "env1T2"
    curve1 = pF "curve1"
    curve2 = pF "curve2"
    curve3 = pF "curve3"
    phase = pF "phase"
    oamp = pF "oamp"
    owhich2 = pF "owhich2"
    ochoose = pF "ochoose"
    rootIndex = pF "rootIndex"
    initAtt = pF "initAtt"
    initRel = pF "initRel"
    initAmp = pF "initAmp"
    initStart = pF "initStart"
    initEnd = pF "initEnd"
    bodyAtt = pF "bodyAtt"
    bodyRel = pF "bodyRel"
    bodyAmp = pF "bodyAmp"
    bodyStart = pF "bodyStart"
    bodyEnd = pF "bodyEnd"
    envAtt = pF "envAtt"
    envRel = pF "envRel"
    envCurve = pF "envCurve"
    sinfreq = pF "sinfreq"
    tuf = pF "tuf"
    centerFreq = pF "centerFreq"
    modamp = pF "modamp"
    coef = pF "coef"
    t1freq = pF "t1freq"
    t1harmonic = pF "t1harmonic"
    t1glide = pF "t1glide"
    t1att = pF "t1att"
    t1rel = pF "t1rel"
    t1curve = pF "t1curve"
    t1del = pF "t1del"
    t1amp = pF "t1amp"
    t2freq = pF "t2freq"
    t2harmonic = pF "t2harmonic"
    t2glide = pF "t2glide"
    t2att = pF "t2att"
    t2rel = pF "t2rel"
    t2curve = pF "t2curve"
    t2del = pF "t2del"
    t2amp = pF "t2amp"
    h1freq = pF "h1freq"
    h1harmonic = pF "h1harmonic"
    h1glide = pF "h1glide"
    h1rq = pF "h1rq"
    h1att = pF "h1att"
    h1rel = pF "h1rel"
    h1curve = pF "h1curve"
    h1del = pF "h1del"
    h1amp = pF "h1amp"
    h2freq = pF "h2freq"
    h2harmonic = pF "h2harmonic"
    h2glide = pF "h2glide"
    h2att = pF "h2att"
    h2rel = pF "h2rel"
    h2curve = pF "h2curve"
    h2del = pF "h2del"
    h2amp = pF "h2amp"
    cfreq = pF "cfreq"
    crq = pF "crq"
    camp = pF "camp"
    impfreq = pF "impfreq"
    phRate = pF "phRate"
    lagFreq = pF "lagFreq"
    inAmt = pF "inAmt"
    coef1 = pF "coef1"
    coef2 = pF "coef2"
    ringTime = pF "ringTime"
    dist = pF "dist"
    vcaLev1 = pF "vcaLev1"
    vcaLev2 = pF "vcaLev2"
    vcaLev3 = pF "vcaLev3"
    vcaLev4 = pF "vcaLev4"
    vcaLev5 = pF "vcaLev5"
    vcaTime1 = pF "vcaTime1"
    vcaTime2 = pF "vcaTime2"
    vcaTime3 = pF "vcaTime3"
    vcaTime4 = pF "vcaTime4"
    vcaCurve1 = pF "vcaCurve1"
    vcaCurve2 = pF "vcaCurve2"
    vcaCurve3 = pF "vcaCurve3"
    vcfLev1 = pF "vcfLev1"
    vcfLev2 = pF "vcfLev2"
    vcfLev3 = pF "vcfLev3"
    vcfLev4 = pF "vcfLev4"
    vcfTime1 = pF "vcfTime1"
    vcfTime2 = pF "vcfTime2"
    vcfTime3 = pF "vcfTime3"
    vcfCurve1 = pF "vcfCurve1"
    vcfCurve2 = pF "vcfCurve2"
    impFreq = pF "impFreq"
    delTimeMod = pF "delTimeMod"
    env0T1 = pF "env0T1"
    env0T2 = pF "env0T2"
    env0T3 = pF "env0T3"
    curve0_1 = pF "curve0_1"
    curve0_2 = pF "curve0_2"
    curve0_3 = pF "curve0_3"
    curve1_1 = pF "curve1_1"
    curve1_2 = pF "curve1_2"
    decDens = pF "decDens"
    decTimeFreq = pF "decTimeFreq"
    decamp = pF "decamp"
    envpL1 = pF "envpL1"
    envpL2 = pF "envpL2"
    envpL3 = pF "envpL3"
    envpT1 = pF "envpT1"
    envpT2 = pF "envpT2"
    filterHarmonic = pF "filterHarmonic"
    preamp = pF "preamp"
    pulseAmp = pF "pulseAmp"
    noiseAmp = pF "noiseAmp"
    sineAmp = pF "sineAmp"
    tone = pF "tone"
    echohz1 = pF "echohz1"
    echohz2 = pF "echohz2"
    shelfFreq = pF "shelfFreq"
    rs = pF "rs"
    db = pF "db"
    damp = pF "damp"
    freqSin = pF "freqSin"
    ampSin = pF "ampSin"
    freqSaw = pF "freqSaw"
    ampSaw = pF "ampSaw"
    oscMix = pF "oscMix"
    freqClc = pF "freqClc"
    harmClc = pF "harmClc"
    ampClc = pF "ampClc"
    maxL = pF "maxL"
    t1Clc = pF "t1Clc"
    t2Clc = pF "t2Clc"
    t3Clc = pF "t3Clc"
    gFreq = pF "gFreq"
    fric = pF "fric"
    toneRel = pF "toneRel"
    toneAmp = pF "toneAmp"
    noiseRel = pF "noiseRel"
    nyquist = pF "nyquist"
    lpFreq = pF "lpFreq"
    hpFreq = pF "hpFreq"
    lev = pF "lev"
    formantA = pF "formantA"
    formantB = pF "formantB"
    overlapA = pF "overlapA"
    overlapB = pF "overlapB"
    fadeTime = pF "fadeTime"
    scaler = pF "scaler"
    rungler1 = pF "rungler1"
    rungler2 = pF "rungler2"
    runglerFilt = pF "runglerFilt"
    filtFreq = pF "filtFreq"
    filterType = pF "filterType"
    outSignal = pF "outSignal"
    freqSrt = pF "freqSrt"
    freqEnd = pF "freqEnd"
    freqTime = pF "freqTime"
    envpT3 = pF "envpT3"
    envpT4 = pF "envpT4"
    envpL4 = pF "envpL4"
    envpCurve = pF "envpCurve"
    tott = pF "tott"
    durr = pF "durr"
    env0Crv1 = pF "env0Crv1"
    env0Crv2 = pF "env0Crv2"
    env0Crv3 = pF "env0Crv3"
    env1Crv1 = pF "env1Crv1"
    env1Crv2 = pF "env1Crv2"
    coeff = pF "coeff"
    avar = pF "avar"
    bvar = pF "bvar"
    cvar = pF "cvar"
    dvar = pF "dvar"
    maxFreq = pF "maxFreq"
    decaylevel = pF "decaylevel"
    sweepCurve = pF "sweepCurve"
    scl = pF "scl"
    ipress = pF "ipress"
    ibreath = pF "ibreath"
    ifeedbk1 = pF "ifeedbk1"
    ifeedbk2 = pF "ifeedbk2"
    hpf1 = pF "hpf1"
    hpf2 = pF "hpf2"
    bpf1 = pF "bpf1"
    bpf2 = pF "bpf2"
    sawFreq1 = pF "sawFreq1"
    sawFreq2 = pF "sawFreq2"
    sawAmp = pF "sawAmp"
    bpff = pF "bpff"
    bpffModSpeed = pF "bpffModSpeed"
    bpffModAmt = pF "bpffModAmt"
    delayTime = pF "delayTime"
    decayTime = pF "decayTime"
    lforate = pF "lforate"
    lfowidth = pF "lfowidth"
    modHarmonic = pF "modHarmonic"
    snareAmp = pF "snareAmp"
    snareRez = pF "snareRez"
    bwr = pF "bwr"
    env0T4 = pF "env0T4"
    timeScale = pF "timeScale"
    wnoiseAmp = pF "wnoiseAmp"
    sel = pF "sel"
    envLevel1 = pF "envLevel1"
    envLevel2 = pF "envLevel2"
    envLevel3 = pF "envLevel3"
    levelScale = pF "levelScale"
    levelBias = pF "levelBias"
    revtime = pF "revtime"
    revMix = pF "revMix"
    glissf = pF "glissf"
    switch = pF "switch"
    fm1 = pF "fm1"
    pm1 = pF "pm1"
    ring1 = pF "ring1"
    offset1 = pF "offset1"
    fm2 = pF "fm2"
    pm2 = pF "pm2"
    ring2 = pF "ring2"
    offset2 = pF "offset2"
    fold = pF "fold"
    wrap = pF "wrap"
    envfL1 = pF "envfL1"
    envfL2 = pF "envfL2"
    envfL3 = pF "envfL3"
    envfL4 = pF "envfL4"
    envfT1 = pF "envfT1"
    envfT2 = pF "envfT2"
    envfT3 = pF "envfT3"
    envfCurve = pF "envfCurve"
    envnAtt = pF "envnAtt"
    envnRel = pF "envnRel"
    envnCurve = pF "envnCurve"
    kracter = pF "kracter"
    hpfRq = pF "hpfRq"
    lpfRq = pF "lpfRq"
    trigDur = pF "trigDur"
    lfCubTu = pF "lfCubTu"
    freqenvL1 = pF "freqenvL1"
    freqenvL2 = pF "freqenvL2"
    freqenvL3 = pF "freqenvL3"
    freqenvL4 = pF "freqenvL4"
    freqenvT1 = pF "freqenvT1"
    freqenvT2 = pF "freqenvT2"
    freqenvT3 = pF "freqenvT3"
    ampenvL1 = pF "ampenvL1"
    ampenvL2 = pF "ampenvL2"
    ampenvL3 = pF "ampenvL3"
    ampenvL4 = pF "ampenvL4"
    ampenvT1 = pF "ampenvT1"
    ampenvT2 = pF "ampenvT2"
    ampenvT3 = pF "ampenvT3"
    tonerel = pF "tonerel"
    noiserel = pF "noiserel"
    noisetop = pF "noisetop"
    noisebottom = pF "noisebottom"
    noiseamp = pF "noiseamp"
    tonelo = pF "tonelo"
    tonehi = pF "tonehi"
    toneamp = pF "toneamp"
    blend = pF "blend"
    enfCurve = pF "enfCurve"
    sin2Frq = pF "sin2Frq"
    sin2Amp = pF "sin2Amp"
    curvep = pF "curvep"
    filterFreq = pF "filterFreq"
    rTrgRate = pF "rTrgRate"
    rFreq1 = pF "rFreq1"
    rFreq2 = pF "rFreq2"
    rFreq3 = pF "rFreq3"
    rFreq4 = pF "rFreq4"
    rFreq5 = pF "rFreq5"
    rFreq6 = pF "rFreq6"
    rDec = pF "rDec"
    revSize = pF "revSize"
    revTime = pF "revTime"
    revDamp = pF "revDamp"
    nFrqR = pF "nFrqR"
    lfnFrqR1 = pF "lfnFrqR1"
    lfnFrqR2 = pF "lfnFrqR2"
    lpfR = pF "lpfR"
    hpfR = pF "hpfR"
    revSizeR = pF "revSizeR"
    revTimeR = pF "revTimeR"
    revDampR = pF "revDampR"
    dryLevR = pF "dryLevR"
    modDurR = pF "modDurR"
    lfnFrqT1 = pF "lfnFrqT1"
    lfnFrqT2 = pF "lfnFrqT2"
    hpfT = pF "hpfT"
    revSizeT = pF "revSizeT"
    revTimeT = pF "revTimeT"
    revDampT = pF "revDampT"
    dryLevT = pF "dryLevT"
    modDurT = pF "modDurT"
    sawFrq = pF "sawFrq"
    plcTrigRate = pF "plcTrigRate"
    plcDelay = pF "plcDelay"
    plcDecay = pF "plcDecay"
    pCntTrigRate = pF "pCntTrigRate"
    pCntResetRate = pF "pCntResetRate"
    krpsLpfFrq = pF "krpsLpfFrq"
    krpsHpfFrq = pF "krpsHpfFrq"
    kickLpfFrq = pF "kickLpfFrq"
    kickHpfFrq = pF "kickHpfFrq"
    ringFrq = pF "ringFrq"
    ringDec = pF "ringDec"
    envAmpAtt = pF "envAmpAtt"
    envAmpRel = pF "envAmpRel"
    envFrqAtt = pF "envFrqAtt"
    envFrqRel = pF "envFrqRel"
    kharm1 = pF "kharm1"
    kharm2 = pF "kharm2"
    kharm3 = pF "kharm3"
    kharm4 = pF "kharm4"
    kamp1 = pF "kamp1"
    kamp2 = pF "kamp2"
    kamp3 = pF "kamp3"
    kamp4 = pF "kamp4"
    kring1 = pF "kring1"
    kring2 = pF "kring2"
    kring3 = pF "kring3"
    kring4 = pF "kring4"
    frqScale = pF "frqScale"
    decScale = pF "decScale"
    resoMix = pF "resoMix"
    phmodFrq = pF "phmodFrq"
    envfCure = pF "envfCure"
    numharm = pF "numharm"
    sigatt = pF "sigatt"
    sigdec = pF "sigdec"
    thresh = pF "thresh"
    revRoom = pF "revRoom"
    attTim = pF "attTim"
    relTim = pF "relTim"
    timescale = pF "timescale"
    widthmod = pF "widthmod"
    width = pF "width"
    abc = pF "abc"
    randLo = pF "randLo"
    randHi = pF "randHi"
    bprq = pF "bprq"
    beats = pF "beats"
    envOffset = pF "envOffset"
    endReflection = pF "endReflection"
    jetReflection = pF "jetReflection"
    jetRatio = pF "jetRatio"
    noiseGain = pF "noiseGain"
    vibFreq = pF "vibFreq"
    vibGain = pF "vibGain"
    iphase = pF "iphase"
    impRate = pF "impRate"
    kfreq = pF "kfreq"
    kdec = pF "kdec"
    delTime = pF "delTime"
    decTime = pF "decTime"
    envaT1 = pF "envaT1"
    envaL1 = pF "envaL1"
    envaT2 = pF "envaT2"
    envaL2 = pF "envaL2"
    envaT3 = pF "envaT3"
    envaL3 = pF "envaL3"
    envaT4 = pF "envaT4"
    envaL4 = pF "envaL4"
    envaCurve = pF "envaCurve"
    envfT4 = pF "envfT4"
    pitch = pF "pitch"
    verbMix = pF "verbMix"
    verbRoom = pF "verbRoom"
    verbTime = pF "verbTime"
    verbDamp = pF "verbDamp"
    atk = pF "atk"
    midiPitch = pF "midiPitch"
    art = pF "art"
    noiseFreq = pF "noiseFreq"
    noiseLev = pF "noiseLev"
    noiseOffset = pF "noiseOffset"
    dis = pF "dis"
    atf = pF "atf"
    notes = pF "notes"
    at = pF "at"
    snd = pF "snd"
    fund = pF "fund"
    filter = pF "filter"
    bend = pF "bend"
    filterfreq = pF "filterfreq"
    attackTime = pF "attackTime"
    releaseTime = pF "releaseTime"
    mRatio = pF "mRatio"
    cRatio = pF "cRatio"
    index = pF "index"
    iScale = pF "iScale"
    cAtk = pF "cAtk"
    cRel = pF "cRel"
    dcy = pF "dcy"
    envfL5 = pF "envfL5"
    envfAmt = pF "envfAmt"
    lfnFrq = pF "lfnFrq"
    lfnAmt = pF "lfnAmt"
    sawPh = pF "sawPh"
    sawDecDiv = pF "sawDecDiv"
    sinFb = pF "sinFb"
    sinDecDiv = pF "sinDecDiv"
    freqenv = pF "freqenv"
    q = pF "q"
    fq = pF "fq"
    rnd1 = pF "rnd1"
    rnd2 = pF "rnd2"
    rnd3 = pF "rnd3"
    env1 = pF "env1"
    env2 = pF "env2"
    seq1 = pF "seq1"
    seq2 = pF "seq2"
    seq3 = pF "seq3"
    seq4 = pF "seq4"
    seq5 = pF "seq5"
    seqDiv = pF "seqDiv"
    bwrLo = pF "bwrLo"
    bwrHi = pF "bwrHi"
    mFrq = pF "mFrq"
    mFB = pF "mFB"
    frq = pF "frq"
    fB = pF "fB"
    mul = pF "mul"
    theta = pF "theta"
    rho = pF "rho"
    lfnFreq = pF "lfnFreq"
    lfnAmp = pF "lfnAmp"
    lfnOffset = pF "lfnOffset"
    ampDst1 = pF "ampDst1"
    ampDst2 = pF "ampDst2"
    durDst1 = pF "durDst1"
    durDst2 = pF "durDst2"
    adPar1 = pF "adPar1"
    adPar2 = pF "adPar2"
    ddPar1 = pF "ddPar1"
    ddPar2 = pF "ddPar2"
    delTime1 = pF "delTime1"
    delTime2 = pF "delTime2"
    pNoiseFreq = pF "pNoiseFreq"
    modDur = pF "modDur"
    ringFreq = pF "ringFreq"
    rqhpf = pF "rqhpf"
    freq1bpf = pF "freq1bpf"
    freq2bpf = pF "freq2bpf"
    rq1bpf = pF "rq1bpf"
    rq2bpf = pF "rq2bpf"
    rqlpf = pF "rqlpf"
    mixBpf = pF "mixBpf"
    bpeqf1 = pF "bpeqf1"
    bpeqrq1 = pF "bpeqrq1"
    bpeqamp1 = pF "bpeqamp1"
    bpeqf2 = pF "bpeqf2"
    bpeqrq2 = pF "bpeqrq2"
    bpeqamp2 = pF "bpeqamp2"
    hpff = pF "hpff"
    modLo = pF "modLo"
    modHi = pF "modHi"
    loopNode = pF "loopNode"
    envLevel4 = pF "envLevel4"
    envLevel5 = pF "envLevel5"
    envLevel6 = pF "envLevel6"
    envTime1 = pF "envTime1"
    envTime2 = pF "envTime2"
    envTime3 = pF "envTime3"
    envTime4 = pF "envTime4"
    envTime5 = pF "envTime5"
    del1 = pF "del1"
    del2 = pF "del2"
    trgChance1 = pF "trgChance1"
    trgChance2 = pF "trgChance2"
    trgChance3 = pF "trgChance3"
    trgRate1 = pF "trgRate1"
    trgRate2 = pF "trgRate2"
    trgRate3 = pF "trgRate3"
    rDec1 = pF "rDec1"
    rDec2 = pF "rDec2"
    rDec3 = pF "rDec3"
    rDec4 = pF "rDec4"
    rAmp1 = pF "rAmp1"
    rAmp2 = pF "rAmp2"
    rAmp3 = pF "rAmp3"
    rAmp4 = pF "rAmp4"
    punch = pF "punch"
    envfLev1 = pF "envfLev1"
    envfLev2 = pF "envfLev2"
    envfTime = pF "envfTime"
    freqTime1 = pF "freqTime1"
    freqTime2 = pF "freqTime2"
    impSigRate = pF "impSigRate"
    impRevRate = pF "impRevRate"
    impRevPh = pF "impRevPh"
    blipFreq = pF "blipFreq"
    blipHarm = pF "blipHarm"
    blipAmp = pF "blipAmp"
    env1T3 = pF "env1T3"
    env1T4 = pF "env1T4"
    i_doneAction = pF "i_doneAction"
    sing_switch = pF "sing_switch"
    decayscale = pF "decayscale"
    pulseFreq = pF "pulseFreq"
    fenvamount = pF "fenvamount"
    startFreq = pF "startFreq"
    endFreq = pF "endFreq"
    linedur = pF "linedur"
    lowpass = pF "lowpass"
    smoothLo = pF "smoothLo"
    smoothHi = pF "smoothHi"
    foldRange = pF "foldRange"
    smoothAmount = pF "smoothAmount"
    lpfmin = pF "lpfmin"
    lpfmax = pF "lpfmax"
    hpfmin = pF "hpfmin"
    hpfmax = pF "hpfmax"
    frq1 = pF "frq1"
    frq2 = pF "frq2"
    frq3 = pF "frq3"
    frq4 = pF "frq4"
    click = pF "click"
    compTresh = pF "compTresh"
    lagamount = pF "lagamount"
    chorus = pF "chorus"
    minRel = pF "minRel"
    maxRel = pF "maxRel"
    clickRel = pF "clickRel"
    rls = pF "rls"
    stn = pF "stn"
    envLev1 = pF "envLev1"
    envLev2 = pF "envLev2"
    envLev3 = pF "envLev3"
    envLev4 = pF "envLev4"
    clipLevel = pF "clipLevel"
    impPhase = pF "impPhase"
    impLevel = pF "impLevel"
    noiseLevel = pF "noiseLevel"
    eqfreq = pF "eqfreq"
    eqrq = pF "eqrq"
    eqdb = pF "eqdb"
    length = pF "length"
    envbfL1 = pF "envbfL1"
    envbfL2 = pF "envbfL2"
    envbfL3 = pF "envbfL3"
    envbfRel = pF "envbfRel"
    envbfC = pF "envbfC"
    envbaL1 = pF "envbaL1"
    envbaL2 = pF "envbaL2"
    envbaL3 = pF "envbaL3"
    envbaL4 = pF "envbaL4"
    envbaL5 = pF "envbaL5"
    envbaT1 = pF "envbaT1"
    envbaT2 = pF "envbaT2"
    envbaT3 = pF "envbaT3"
    envbaT4 = pF "envbaT4"
    envbaC1 = pF "envbaC1"
    envbaC2 = pF "envbaC2"
    envbaC3 = pF "envbaC3"
    envbAmp = pF "envbAmp"
    pfSt = pF "pfSt"
    pfEnd = pF "pfEnd"
    pfDur = pF "pfDur"
    envpaL1 = pF "envpaL1"
    envpaL2 = pF "envpaL2"
    envpaL3 = pF "envpaL3"
    envpaL4 = pF "envpaL4"
    envpaL5 = pF "envpaL5"
    envpaT1 = pF "envpaT1"
    envpaT2 = pF "envpaT2"
    envpaT3 = pF "envpaT3"
    envpaT4 = pF "envpaT4"
    envpaC1 = pF "envpaC1"
    envpaC2 = pF "envpaC2"
    envpaC3 = pF "envpaC3"
    envpAmp = pF "envpAmp"
    envcaAtt = pF "envcaAtt"
    envcaRel = pF "envcaRel"
    envcAmp = pF "envcAmp"
    cFundFreq = pF "cFundFreq"
    cFormFreq = pF "cFormFreq"
    cBwFreq = pF "cBwFreq"
    eSawDec = pF "eSawDec"
    eSinL1 = pF "eSinL1"
    eSinL2 = pF "eSinL2"
    eSinL3 = pF "eSinL3"
    eSinL4 = pF "eSinL4"
    eSinT1 = pF "eSinT1"
    eSinT2 = pF "eSinT2"
    eSinT3 = pF "eSinT3"
    eSinC1 = pF "eSinC1"
    eSinC2 = pF "eSinC2"
    eSinC3 = pF "eSinC3"
    sawMix = pF "sawMix"
    bpfFreq = pF "bpfFreq"
    bpfRq = pF "bpfRq"
    bpfMix = pF "bpfMix"
    brfFreq1 = pF "brfFreq1"
    brfFreq2 = pF "brfFreq2"
    brfRq = pF "brfRq"
    bandwidth = pF "bandwidth"
    bdFrqL1 = pF "bdFrqL1"
    bdFrqL2 = pF "bdFrqL2"
    bdFrqL3 = pF "bdFrqL3"
    bdFrqT1 = pF "bdFrqT1"
    bdFrqT2 = pF "bdFrqT2"
    bdFrqC = pF "bdFrqC"
    bdAmpAtt = pF "bdAmpAtt"
    bdAmpSus = pF "bdAmpSus"
    bdAmpRel = pF "bdAmpRel"
    bdAmpLev = pF "bdAmpLev"
    bdAmpCurve = pF "bdAmpCurve"
    popFrqSt = pF "popFrqSt"
    popFrqEnd = pF "popFrqEnd"
    popFrqDur = pF "popFrqDur"
    popAmpAtt = pF "popAmpAtt"
    popAmpSus = pF "popAmpSus"
    popAmpRel = pF "popAmpRel"
    popAmpLev = pF "popAmpLev"
    clkAmpAtt = pF "clkAmpAtt"
    clkAmpRel = pF "clkAmpRel"
    clkAmpLev = pF "clkAmpLev"
    clkAmpCurve = pF "clkAmpCurve"
    clkfFundFreq = pF "clkfFundFreq"
    clkfFormFreq = pF "clkfFormFreq"
    clkfBwFreq = pF "clkfBwFreq"
    clkLpfFreq = pF "clkLpfFreq"
    clickatt = pF "clickatt"
    clicksus = pF "clicksus"
    clickrel = pF "clickrel"
    clickamp = pF "clickamp"
    hipass = pF "hipass"
    lopass = pF "lopass"
    bodyatt = pF "bodyatt"
    bodyrel = pF "bodyrel"
    bodyamp = pF "bodyamp"
    rattlehold = pF "rattlehold"
    rattleatt = pF "rattleatt"
    rattlerel = pF "rattlerel"
    rattleamp = pF "rattleamp"
    rattlefreq = pF "rattlefreq"
    rattlepeak = pF "rattlepeak"
    sweepatt = pF "sweepatt"
    sweeprel = pF "sweeprel"
    sweepamp = pF "sweepamp"
    sweepstart = pF "sweepstart"
    sweepend = pF "sweepend"
    attSinFreq = pF "attSinFreq"
    relSinFreq = pF "relSinFreq"
    curveSinFreq = pF "curveSinFreq"
    levSin = pF "levSin"
    attBpfFreq = pF "attBpfFreq"
    relBpfFreq = pF "relBpfFreq"
    timeScaleBpf = pF "timeScaleBpf"
    curveBpf = pF "curveBpf"
    levBpf = pF "levBpf"
    levScaleBpf = pF "levScaleBpf"
    levBiasBpf = pF "levBiasBpf"
    lineStartBpf = pF "lineStartBpf"
    lineEndBpf = pF "lineEndBpf"
    lineDurBpf = pF "lineDurBpf"
    lineLevBpf = pF "lineLevBpf"
    subamp = pF "subamp"
    drumAmp = pF "drumAmp"
    beaterAmp = pF "beaterAmp"
    clickAmp = pF "clickAmp"
    startsubfreq = pF "startsubfreq"
    endsubfreq = pF "endsubfreq"
    linesubdur = pF "linesubdur"
    subdecay = pF "subdecay"
    sublowpass = pF "sublowpass"
    drumFreq = pF "drumFreq"
    drumHarmonic = pF "drumHarmonic"
    drumSweep = pF "drumSweep"
    drumAtt = pF "drumAtt"
    drumFilter = pF "drumFilter"
    modIndex = pF "modIndex"
    modFreq = pF "modFreq"
    beaterFreq = pF "beaterFreq"
    beaterHarmonic = pF "beaterHarmonic"
    beaterSweep = pF "beaterSweep"
    noiseMod = pF "noiseMod"
    beaterL1 = pF "beaterL1"
    beaterL2 = pF "beaterL2"
    beaterL3 = pF "beaterL3"
    beaterL4 = pF "beaterL4"
    beaterT1 = pF "beaterT1"
    beaterT2 = pF "beaterT2"
    beaterT3 = pF "beaterT3"
    clkffreq = pF "clkffreq"
    clkres = pF "clkres"
    popfreq = pF "popfreq"
    noisefreq = pF "noisefreq"
    x0 = pF "x0"
    x1 = pF "x1"
    ts = pF "ts"
    aamp1 = pF "aamp1"
    aamp2 = pF "aamp2"
    aamp3 = pF "aamp3"
    aamp4 = pF "aamp4"
    famp1 = pF "famp1"
    famp2 = pF "famp2"
    famp3 = pF "famp3"
    famp4 = pF "famp4"
    p1 = pF "p1"
    envSL1 = pF "envSL1"
    envSL2 = pF "envSL2"
    envSL3 = pF "envSL3"
    envSL4 = pF "envSL4"
    envST1 = pF "envST1"
    envST2 = pF "envST2"
    envST3 = pF "envST3"
    envSCurve = pF "envSCurve"
    delDecay = pF "delDecay"
    impMin = pF "impMin"
    impMax = pF "impMax"
    curve4 = pF "curve4"
    counterFreq = pF "counterFreq"
    counterMul = pF "counterMul"
    counterAdd = pF "counterAdd"
    srDiv = pF "srDiv"
    spec1 = pF "spec1"
    spec2 = pF "spec2"
    sigFreq = pF "sigFreq"
    spring = pF "spring"
    beltmass = pF "beltmass"
    source = pF "source"
    envaL5 = pF "envaL5"
    envaCrv = pF "envaCrv"
    envpCrv = pF "envpCrv"
    modAmt = pF "modAmt"
    sinfAdd = pF "sinfAdd"
    sinPhase = pF "sinPhase"
    sinpAdd = pF "sinpAdd"
    rf1Freq = pF "rf1Freq"
    rf1Rq = pF "rf1Rq"
    rf2Freq = pF "rf2Freq"
    rf2Rq = pF "rf2Rq"
    freqMultiplier = pF "freqMultiplier"
    decLevel = pF "decLevel"
    reverb = pF "reverb"
    spreadRate = pF "spreadRate"
    minDelay = pF "minDelay"
    maxDelay = pF "maxDelay"
    fxb = pF "fxb"
    fxv = pF "fxv"
    bbcb = pF "bbcb"
    bbcv = pF "bbcv"
    sinAmpStart = pF "sinAmpStart"
    sinAmpEnd = pF "sinAmpEnd"
    sinAmpDur = pF "sinAmpDur"
    delMix = pF "delMix"
    delTimeL = pF "delTimeL"
    delDecL = pF "delDecL"
    delTimeR = pF "delTimeR"
    delDecR = pF "delDecR"
    blipFreqMod = pF "blipFreqMod"
    blipHarmo = pF "blipHarmo"
    brfFreq = pF "brfFreq"
    sweep1 = pF "sweep1"
    sweep2 = pF "sweep2"
    vol1 = pF "vol1"
    vol2 = pF "vol2"
    syncEgTop = pF "syncEgTop"
    syncRatio = pF "syncRatio"
    syncDcy = pF "syncDcy"
    mod1 = pF "mod1"
    mod2 = pF "mod2"
    envCrv = pF "envCrv"
    lvlScale = pF "lvlScale"
    envInv = pF "envInv"
    envPow = pF "envPow"
    attFreq = pF "attFreq"
    softclip = pF "softclip"
    headAmp = pF "headAmp"
    decCoef = pF "decCoef"
    ampSlope = pF "ampSlope"
    snaresAmp = pF "snaresAmp"
    followAtt = pF "followAtt"
    followRel = pF "followRel"
    snareGate = pF "snareGate"
    envNoiseFrq1 = pF "envNoiseFrq1"
    envNoiseFrq2 = pF "envNoiseFrq2"
    envNoiseVol = pF "envNoiseVol"
    rhpfFreq = pF "rhpfFreq"
    rhpf1Freq = pF "rhpf1Freq"
    rhpf1Rq = pF "rhpf1Rq"
    clickAtk = pF "clickAtk"
    clickRls = pF "clickRls"
    clickSus = pF "clickSus"
    clickLevScale = pF "clickLevScale"
    clickEnvPow = pF "clickEnvPow"
    clickEnvNoiseAmp = pF "clickEnvNoiseAmp"
    clickEnvInv = pF "clickEnvInv"
    clickFreq = pF "clickFreq"
    globalEnvPow = pF "globalEnvPow"
    globalEnvNoise = pF "globalEnvNoise"
    globalEnvInv = pF "globalEnvInv"
    frqStart = pF "frqStart"
    frqEnd = pF "frqEnd"
    frqTime = pF "frqTime"
    sawPow = pF "sawPow"
    crv = pF "crv"
    envNoiseAmp = pF "envNoiseAmp"
    envTonePow = pF "envTonePow"
    envNoisePow = pF "envNoisePow"
    --
    sinFrq = pF "sinFrq"
    sinPh = pF "sinPh"
    sawLev = pF "sawLev"
    sinLev = pF "sinLev"
    clickHpf = pF "clickHpf"
    clickInScale = pF "clickInScale"
    clickRq = pF "clickRq"
    clickPow = pF "clickPow"
    envNpow = pF "envNpow"
    envSpow = pF "envSpow"
    envScurve = pF "envScurve"
    envNcurve = pF "envNcurve"
    --
    envDivDur = pF "envDivDur"
    --
    modAmount = pF "modAmount"
    rlpfFreq = pF "rlpfFreq"
    --
    sin1Freq = pF "sin1Freq"
    sin2Freq = pF "sin2Freq"
    hpffreq = pF "hpffreq"
    clickHpRq = pF "clickHpRq"
    clickLpf = pF "clickLpf"
    clickLpRq = pF "clickLpRq"
    clickCurve = pF "clickCurve"
    distAmt = pF "distAmt"
    distMix = pF "distMix"
    --
    r = pF "r"
    --
    envf2L1 = pF "envf2L1"
    envf2L2 = pF "envf2L2"
    envf2L3 = pF "envf2L3"
    envf2L4 = pF "envf2L4"
    envf2T1 = pF "envf2T1"
    envf2T2 = pF "envf2T2"
    envf2T3 = pF "envf2T3"
    bpfFreq1 = pF "bpfFreq1"
    bpfFreq2 = pF "bpfFreq2"
    bpfRq1 = pF "bpfRq1"
    bpfRq2 = pF "bpfRq2"
    --
    sinStart = pF "sinStart"
    sinEnd = pF "sinEnd"
    sinDur = pF "sinDur"
    noise1Amp = pF "noise1Amp"
    noise2Amp = pF "noise2Amp"
    --
    rhpf = pF "rhpf"
    envModCrv = pF "envModCrv"
    envModPow = pF "envModPow"
    envModNoise = pF "envModNoise"
    envModAmt = pF "envModAmt"
    --
    sinAddAmp = pF "sinAddAmp"
    --
    lfn1Freq = pF "lfn1Freq"
    lfn1Scale = pF "lfn1Scale"
    lfn2Freq = pF "lfn2Freq"
    lfn2Scale = pF "lfn2Scale"
    --
    rMajor = pF "rMajor"
    rMinor = pF "rMinor"
    tMajor = pF "tMajor"
    sMinor = pF "sMinor"
    freq_u = pF "freq_u"
    freq_v = pF "freq_v"
    scaleX = pF "scaleX"
    scaleY = pF "scaleY"
    scaleZ = pF "scaleZ"
    --
    cdur = pF "cdur"
    --
    krpsAtt = pF "krpsAtt"
    krpsRel = pF "krpsRel"
    krpsSus = pF "krpsSus"
    krpsEnvPow = pF "krpsEnvPow"
    krpsLev = pF "krpsLev"
    --
    addFreq = pF "addFreq"
    sousFreq = pF "sousFreq"
    frqCurve1 = pF "frqCurve1"
    frqCurve2 = pF "frqCurve2"
    --
    envLev = pF "envLev"
    a0 = pF "a0"
    a1 = pF "a1"
    a2 = pF "a2"
    selectMod = pF "selectMod"
    --
    atk1 = pF "atk1"
    rls1 = pF "rls1"
    crv1 = pF "crv1"
    --
    frq1_1 = pF "frq1_1"
    frq1_2 = pF "frq1_2"
    frq1_3 = pF "frq1_3"
    frq1_4 = pF "frq1_4"
    frq1_5 = pF "frq1_5"
    frq1_6 = pF "frq1_6"
    frq1_7 = pF "frq1_7"
    frq1_8 = pF "frq1_8"
    frq1_9 = pF "frq1_9"
    frq1_10 = pF "frq1_10"
    frq1_11 = pF "frq1_11"
    frq1_12 = pF "frq1_12"
    frq1_13 = pF "frq1_13"
    frq1_14 = pF "frq1_14"
    frq1_15 = pF "frq1_15"
    frq2_1 = pF "frq2_1"
    frq2_2 = pF "frq2_2"
    frq2_3 = pF "frq2_3"
    frq2_4 = pF "frq2_4"
    frq2_5 = pF "frq2_5"
    frq2_6 = pF "frq2_6"
    frq2_7 = pF "frq2_7"
    frq2_8 = pF "frq2_8"
    frq2_9 = pF "frq2_9"
    frq2_10 = pF "frq2_10"
    frq2_11 = pF "frq2_11"
    frq2_12 = pF "frq2_12"
    frq2_13 = pF "frq2_13"
    frq2_14 = pF "frq2_14"
    frq2_15 = pF "frq2_15"
    add1 = pF "add1"
    add2 = pF "add2"
    div1 = pF "div1"
    div2 = pF "div2"
    rng1Lo = pF "rng1Lo"
    rng1Hi = pF "rng1Hi"
    rng2Lo = pF "rng2Lo"
    rng2Hi = pF "rng2Hi"
    thr = pF "thr"
    --
    levScaleSin = pF "levScaleSin"
    levBiasSin = pF "levBiasSin"
    --
    sat = pF "sat"
    startFreqMod = pF "startFreqMod"
    endFreqMod = pF "endFreqMod"
    --
    crv2 = pF "crv2"
    --
    freqStart = pF "freqStart"
    freqGrow = pF "freqGrow"
    --
    ser1_1 = pF "ser1_1"
    ser1_2 = pF "ser1_2"
    ser1_3 = pF "ser1_3"
    ser1_4 = pF "ser1_4"
    ser1Size = pF "ser1Size"
    ser2_1 = pF "ser2_1"
    ser2_2 = pF "ser2_2"
    ser2_3 = pF "ser2_3"
    ser2_4 = pF "ser2_4"
    ser2_5 = pF "ser2_5"
    ser2Size = pF "ser2Size"
    sinFmin = pF "sinFmin"
    sigSel = pF "sigSel"
    fbSel = pF "fbSel"
    divisor = pF "divisor"
    modul = pF "modul"
    --
    mul1 = pF "mul1"
    mul2 = pF "mul2"
    mulTanh = pF "mulTanh"
    modu1 = pF "modu1"
    modu2 = pF "modu2"
    rate1 = pF "rate1"
    rate2 = pF "rate2"
    smooth1 = pF "smooth1"
    smooth2 = pF "smooth2"
    randMax = pF "randMax"
    randMin = pF "randMin"
    --
    seqOffSet = pF "seqOffSet"
    seqMul = pF "seqMul"
    mod3 = pF "mod3"
    dev1 = pF "dev1"
    dev2 = pF "dev2"
    add = pF "add"
    --
    seq1OffSet = pF "seq1OffSet"
    seq1Mul = pF "seq1Mul"
    seq2OffSet = pF "seq2OffSet"
    seq2Mul = pF "seq2Mul"
    --
    tRand1Min = pF "tRand1Min"
    tRand1Max = pF "tRand1Max"
    tRand2Min = pF "tRand2Min"
    tRand2Max = pF "tRand2Max"
    sig1RangeMin = pF "sig1RangeMin"
    sig1RangeMax = pF "sig1RangeMax"
    sig2RangeMin = pF "sig2RangeMin"
    sig2RangeMax = pF "sig2RangeMax"
    --
    noiseAmp1 = pF "noiseAmp1"
    noiseAmp2 = pF "noiseAmp2"
    noiseAtk = pF "noiseAtk"
    noiseDcy = pF "noiseDcy"
    --
    atkf = pF "atkf"
    rlsf = pF "rlsf"
    crvf = pF "crvf"
    trigSpeedMin = pF "trigSpeedMin"
    trigSpeedMax = pF "trigSpeedMax"
    tuDiv = pF "tuDiv"
    freqEnvMin = pF "freqEnvMin"
    freqEnvMax = pF "freqEnvMax"
    mratio = pF "mratio"
    boost = pF "boost"
    --
    ringzDec = pF "ringzDec"
    --
    waveSel = pF "waveSel"
    freqLow = pF "freqLow"
    phaseLow = pF "phaseLow"
    ampLow = pF "ampLow"
    --
    sampleRate = pF "sampleRate"
    factor = pF "factor"
    --
    time = pF "time"
    iAtk = pF "iAtk"
    iRel = pF "iRel"
    phaseModFreq = pF "phaseModFreq"
    --
    envL6 = pF "envL6"
    envL7 = pF "envL7"
    envT6 = pF "envT6"
    hpfFrq = pF "hpfFrq"
    --
    triEnvCrv = pF "triEnvCrv"
    lev1Mul = pF "lev1Mul"
    lev2Mul = pF "lev2Mul"
    dcyf = pF "dcyf"
    atkpf = pF "atkpf"
    dcypf = pF "dcypf"
    crvpf = pF "crvpf"
    --
    rotateFreq = pF "rotateFreq"
    rotateAmount = pF "rotateAmount"
    sizeEnvAmount = pF "sizeEnvAmount"
    durFreq = pF "durFreq"
    --
    oscfreq = pF "oscfreq"
    lfofreq = pF "lfofreq"
    lfoamount = pF "lfoamount"
    penvamount = pF "penvamount"
    decaycurve = pF "decaycurve"
    patt = pF "patt"
    pdec = pF "pdec"
    shamount = pF "shamount"
    shrate = pF "shrate"
    ampatt = pF "ampatt"
    ampdec = pF "ampdec"
    ampdecaycurve = pF "ampdecaycurve"
    oscwaveform = pF "oscwaveform"
    noiseatt = pF "noiseatt"
    noisedec = pF "noisedec"
    nfiltfreq = pF "nfiltfreq"
    noisereso = pF "noisereso"
    noisefiltselect = pF "noisefiltselect"
    mixfade = pF "mixfade"
    drive = pF "drive"
    --
    op1att = pF "op1att"
    op2att = pF "op2att"
    op3att = pF "op3att"
    op4att = pF "op4att"
    op1dec = pF "op1dec"
    op2dec = pF "op2dec"
    op3dec = pF "op3dec"
    op4dec = pF "op4dec"
    op1sus = pF "op1sus"
    op2sus = pF "op2sus"
    op3sus = pF "op3sus"
    op4sus = pF "op4sus"
    op1rel = pF "op1rel"
    op2rel = pF "op2rel"
    op3rel = pF "op3rel"
    op4rel = pF "op4rel"
    op1amt = pF "op1amt"
    op2amt = pF "op2amt"
    op3amt = pF "op3amt"
    op4amt = pF "op4amt"
    op1tune = pF "op1tune"
    op2tune = pF "op2tune"
    op3tune = pF "op3tune"
    op4tune = pF "op4tune"
    --
    segments = pF "segments"
    xMajor = pF "xMajor"
    yMajor = pF "yMajor"
    circlefreq = pF "circlefreq"
    --
    amount = pF "amount"
    --
    lfSrc1Sel = pF "lfSrc1Sel"
    lfSrc1Rate = pF "lfSrc1Rate"
    lfSrc2Sel = pF "lfSrc2Sel"
    lfSrc2Rate = pF "lfSrc2Rate"
    switchSrcRate = pF "switchSrcRate"
    --
    lfRate = pF "lfRate"
    lfPhase = pF "lfPhase"
    selFilt = pF "selFilt"
    --
    selSnd = pF "selSnd"
    stnf = pF "stnf"
    --
    fltAtk = pF "fltAtk"
    fltRls = pF "fltRls"
    fltAtkCurve = pF "fltAtkCurve"
    fltRlsCurve = pF "fltRlsCurve"
    atkCurve = pF "atkCurve"
    rlsCurve = pF "rlsCurve"
    inharmonic = pF "inharmonic"
    tilt = pF "tilt"
    lpfCutoff = pF "lpfCutoff"
    lpfEnvAmount = pF "lpfEnvAmount"
    lpfSlope = pF "lpfSlope"
    peakSlope = pF "peakSlope"
    peakRes = pF "peakRes"
    --
    soundmod = pF "soundmod"
:}

:{
let setI = streamSetI tidal
    setF = streamSetF tidal
    setS = streamSetS tidal
    setR = streamSetR tidal
    setB = streamSetB tidal
:}

:set prompt "tidal> "
:set prompt-cont ""
