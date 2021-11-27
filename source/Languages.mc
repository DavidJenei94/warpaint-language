
function loadLanguages() as Void {
    languagesDict = {
        "en" => {
            "name" => Rez.Strings.enName,
            "flags" => [
                Rez.Drawables.enFlag,
                Rez.Drawables.enFlagS
            ],
            "chartColor" => 0xFF0000,
            "reveal" => "R E V E A L",
            "totalLearnedWords" => 0,
            "learnedWords" => 0           
        },
        "de" => {
            "name" => Rez.Strings.deName,
            "flags" => [
                Rez.Drawables.deFlag,
                Rez.Drawables.deFlagS
            ],
            "chartColor" => 0xFF5500,
            "reveal" => "V E R R A T E N",
            "totalLearnedWords" => 0,
            "learnedWords" => 0
        },
        "fr" => {
            "name" => Rez.Strings.frName,
            "flags" => [
                Rez.Drawables.frFlag,
                Rez.Drawables.frFlagS
            ],
            "chartColor" => 0xFF0055,
            "reveal" => "R É V É L E R",
            "totalLearnedWords" => 0,
            "learnedWords" => 0
        },
        "es" => {
            "name" => Rez.Strings.esName,
            "flags" => [
                Rez.Drawables.esFlag,
                Rez.Drawables.esFlagS
            ],
            "chartColor" => 0x550000,
            "reveal" => "R E V E L A R",
            "totalLearnedWords" => 0,
            "learnedWords" => 0
        },
        "ru" => {
            "name" => Rez.Strings.ruName,
            "flags" => [
                Rez.Drawables.ruFlag,
                Rez.Drawables.ruFlagS
            ],
            "chartColor" => 0x555500,
            "reveal" => "РАСКРЫВАТЬ",
            "totalLearnedWords" => 0,
            "learnedWords" => 0
        },
        "pt" => {
            "name" => Rez.Strings.ptName,
            "flags" => [
                Rez.Drawables.ptFlag,
                Rez.Drawables.ptFlagS
            ],
            "chartColor" => 0x0055AA,
            "reveal" => "R E V E L A R",
            "totalLearnedWords" => 0,
            "learnedWords" => 0
        },
        "hu" => {
            "name" => Rez.Strings.huName,
            "flags" => [
                Rez.Drawables.huFlag,
                Rez.Drawables.huFlagS
            ],
            "chartColor" => 0xFF00FF,
            "reveal" => "F E L F E D",
            "totalLearnedWords" => 0,
            "learnedWords" => 0
        },
        "nb" => {
            "name" => Rez.Strings.nbName,
            "flags" => [
                Rez.Drawables.nbFlag,
                Rez.Drawables.nbFlagS
            ],
            "chartColor" => 0xFF55AA,
            "reveal" => "A V S L Ø R E",
            "totalLearnedWords" => 0,
            "learnedWords" => 0
        }
    };

    //  var testlanguagesDictBest = {
    //     "languages" => [
    //         {
    //             "isoCode" => "en",
    //             "name" => Rez.Strings.enName,
    //             "flags" => [
    //                 Rez.Drawables.enFlag,
    //                 Rez.Drawables.enFlagS
    //             ],
    //             "chartColor" => 0xFF0000,
    //             "reveal" => "R E V E A L",
    //             "totalLearnedWords" => 0,
    //             "learnedWords" => 0
    //         },
    //         {
    //             "isoCode" => "de",
    //             "name" => Rez.Strings.deName,
    //             "flags" => [
    //                 Rez.Drawables.deFlag,
    //                 Rez.Drawables.deFlagS
    //             ],
    //             "chartColor" => 0xFF0000,
    //             "reveal" => "V E R R A T E N",
    //             "totalLearnedWords" => 0,
    //             "learnedWords" => 0
    //         },
    //         {
    //             "isoCode" => "fr",
    //             "name" => Rez.Strings.frName,
    //             "flags" => [
    //                 Rez.Drawables.frFlag,
    //                 Rez.Drawables.frFlagS
    //             ],
    //             "chartColor" => 0xFF0000,
    //             "reveal" => "R É V É L E R",
    //             "totalLearnedWords" => 0,
    //             "learnedWords" => 0
    //         },
    //         {
    //             "isoCode" => "es",
    //             "name" => Rez.Strings.esName,
    //             "flags" => [
    //                 Rez.Drawables.esFlag,
    //                 Rez.Drawables.esFlagS
    //             ],
    //             "chartColor" => 0xFF0000,
    //             "reveal" => "R E V E L A R",
    //             "totalLearnedWords" => 0,
    //             "learnedWords" => 0
    //         },
    //         {
    //             "isoCode" => "ru",
    //             "name" => Rez.Strings.ruName,
    //             "flags" => [
    //                 Rez.Drawables.ruFlag,
    //                 Rez.Drawables.ruFlagS
    //             ],
    //             "chartColor" => 0xFF0000,
    //             "reveal" => "РАСКРЫВАТЬ",
    //             "totalLearnedWords" => 0,
    //             "learnedWords" => 0
    //         },
    //         {
    //             "isoCode" => "pt",
    //             "name" => Rez.Strings.ptName,
    //             "flags" => [
    //                 Rez.Drawables.ptFlag,
    //                 Rez.Drawables.ptFlagS
    //             ],
    //             "chartColor" => 0xFF0000,
    //             "reveal" => "R E V E L A R",
    //             "totalLearnedWords" => 0,
    //             "learnedWords" => 0
    //         },
    //         {
    //             "isoCode" => "hu",
    //             "name" => Rez.Strings.huName,
    //             "flags" => [
    //                 Rez.Drawables.huFlag,
    //                 Rez.Drawables.huFlagS
    //             ],
    //             "chartColor" => 0xFF0000,
    //             "reveal" => "F E L F E D",
    //             "totalLearnedWords" => 0,
    //             "learnedWords" => 0
    //         },
    //         {
    //             "isoCode" => "nb",
    //             "name" => Rez.Strings.nbName,
    //             "flags" => [
    //                 Rez.Drawables.nbFlag,
    //                 Rez.Drawables.nbFlagS
    //             ],
    //             "chartColor" => 0xFF0000,
    //             "reveal" => "A V S L Ø R E",
    //             "totalLearnedWords" => 0,
    //             "learnedWords" => 0
    //         }
    //     ]
    // };
}