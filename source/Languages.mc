(:glance)
function loadLanguages() as Void {
    languages = {
        "en" => {
            "name" => Rez.Strings.enName,
            "flags" => [
                Rez.Drawables.enFlag,
                Rez.Drawables.enFlagS
            ],
            "chartColor" => 0x00FF00,
            "reveal" => "R E V E A L"       
        },
        "de" => {
            "name" => Rez.Strings.deName,
            "flags" => [
                Rez.Drawables.deFlag,
                Rez.Drawables.deFlagS
            ],
            "chartColor" => 0xAA5555,
            "reveal" => "V E R R A T E N"
        },
        "fr" => {
            "name" => Rez.Strings.frName,
            "flags" => [
                Rez.Drawables.frFlag,
                Rez.Drawables.frFlagS
            ],
            "chartColor" => 0xFF55FF,
            "reveal" => "R É V É L E R"
        },
        "es" => {
            "name" => Rez.Strings.esName,
            "flags" => [
                Rez.Drawables.esFlag,
                Rez.Drawables.esFlagS
            ],
            "chartColor" => 0x0055FF,
            "reveal" => "R E V E L A R"
        },
        "ru" => {
            "name" => Rez.Strings.ruName,
            "flags" => [
                Rez.Drawables.ruFlag,
                Rez.Drawables.ruFlagS
            ],
            "chartColor" => 0xAAAA00,
            "reveal" => "РАСКРЫВАТЬ"
        },
        "pt" => {
            "name" => Rez.Strings.ptName,
            "flags" => [
                Rez.Drawables.ptFlag,
                Rez.Drawables.ptFlagS
            ],
            "chartColor" => 0x5500FF,
            "reveal" => "R E V E L A R"
        },
        "hu" => {
            "name" => Rez.Strings.huName,
            "flags" => [
                Rez.Drawables.huFlag,
                Rez.Drawables.huFlagS
            ],
            "chartColor" => 0xFFAA00,
            "reveal" => "F E L F E D",
        },
        "nb" => {
            "name" => Rez.Strings.nbName,
            "flags" => [
                Rez.Drawables.nbFlag,
                Rez.Drawables.nbFlagS
            ],
            "chartColor" => 0x55FF55,
            "reveal" => "A V S L Ø R E"
        }
    };
}