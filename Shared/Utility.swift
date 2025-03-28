//
//  Utility.swift
//  BuiltDiff
//
//  Created by Timmy Nguyen on 3/19/25.
//

import Foundation

extension String {
    // note: using .localized will not automically update Localizable.xcstrings. Using String(localized:) does.
    var localized: String {
        String(localized: String.LocalizationValue(self))
    }
    
    func localized(_ args: CVarArg...) -> String {
        let format = String(localized: String.LocalizationValue(self))
        return String(format: format, arguments: args)
    }
}

// Note: iPhone + watchOS simulator doesn't sync? Have to manually add workouts separately to watch. Changing weight/color syncs though, cloudkit doesn't seme to sync. works on physical

//let translation: [String: String] = [
//    "Pull Day": "Pull Day",
//    "Push Day": "Push Day",
//    "Leg Day": "Leg Day",
//    "Bench Press": "Bench Press",
//    "Squat": "Squat",
//    "Deadlift": "Deadlift",
//    "Dumbbell Curl": "Dumbbell Curl",
//    "Bent Over Row": "Bent Over Row",
//    "Dumbbell Shoulder Press": "Dumbbell Shoulder Press",
//    "Incline Bench Press": "Incline Bench Press",
//    "Lat Pulldown": "Lat Pulldown",
//    "Dumbbell Lateral Raise": "Dumbbell Lateral Raise",
//    "Romanian Deadlift": "Romanian Deadlift",
//    "Tricep Pushdown": "Tricep Pushdown",
//    "Hammer Curl": "Hammer Curl",
//    "Seated Cable Row": "Seated Cable Row",
//    "Machine Calf Raise": "Machine Calf Raise",
//    "Dumbbell Lunge": "Dumbbell Lunge",
//    "Tricep Extension": "Tricep Extension"
//]

// Japanese
//let translation: [String: String] = [
//    "Pull Day": "プルデイ",
//    "Push Day": "プッシュデイ",
//    "Leg Day": "レッグデイ",
//    "Bench Press": "ベンチプレス",
//    "Squat": "スクワット",
//    "Deadlift": "デッドリフト",
//    "Dumbbell Curl": "ダンベルカール",
//    "Bent Over Row": "ベントオーバーロウ",
//    "Dumbbell Shoulder Press": "ダンベルショルダープレス",
//    "Incline Bench Press": "インクラインベンチプレス",
//    "Lat Pulldown": "ラットプルダウ",
//    "Dumbbell Lateral Raise": "ダンベルレータルレイズ",
//    "Romanian Deadlift": "ルーマニアンデッドリフト",
//    "Tricep Pushdown": "トライセプスプッシュダウン",
//    "Hammer Curl": "ハンマーカール",
//    "Seated Cable Row": "シーテッドケーブルロウ",
//    "Machine Calf Raise": "マシンカーフレイズ",
//    "Dumbbell Lunge": "ダンベルランジ",
//    "Tricep Extension": "トライセプスエクステンション"
//]

//// Spanish (US)
//let translation: [String: String] = [
//    "Pull Day": "Día de Tirón",
//    "Push Day": "Día de Empuje",
//    "Leg Day": "Día de Piernas",
//    "Bench Press": "Press de Banca",
//    "Squat": "Sentadilla",
//    "Deadlift": "Peso Muerto",
//    "Dumbbell Curl": "Curl de Mancuerna",
//    "Bent Over Row": "Remo Inclinado",
//    "Dumbbell Shoulder Press": "Press de Hombro con Mancuernas",
//    "Incline Bench Press": "Press de Banca Inclinado",
//    "Lat Pulldown": "Jalón al Pecho",
//    "Dumbbell Lateral Raise": "Elevación Lateral con Mancuernas",
//    "Romanian Deadlift": "Peso Muerto Rumano",
//    "Tricep Pushdown": "Pushdown de Tríceps",
//    "Hammer Curl": "Curl Martillo",
//    "Seated Cable Row": "Remo Sentado en Polea",
//    "Machine Calf Raise": "Elevación de Talones en Máquina",
//    "Dumbbell Lunge": "Zancada con Mancuernas",
//    "Tricep Extension": "Extensión de Tríceps"
//]

//// Chinese
//let translation: [String: String] = [
//    "Pull Day": "拉日",
//    "Push Day": "推日",
//    "Leg Day": "腿日",
//    "Bench Press": "卧推",
//    "Squat": "深蹲",
//    "Deadlift": "硬拉",
//    "Dumbbell Curl": "哑铃弯举",
//    "Bent Over Row": "俯身划船",
//    "Dumbbell Shoulder Press": "哑铃推肩",
//    "Incline Bench Press": "上斜卧推",
//    "Lat Pulldown": "高位下拉",
//    "Dumbbell Lateral Raise": "哑铃侧平举",
//    "Romanian Deadlift": "罗马尼亚硬拉",
//    "Tricep Pushdown": "下压三头肌",
//    "Hammer Curl": "锤式弯举",
//    "Seated Cable Row": "坐姿划船",
//    "Machine Calf Raise": "器械提踵",
//    "Dumbbell Lunge": "哑铃箭步蹲",
//    "Tricep Extension": "三头肌伸展"
//]

//// French
//let translation: [String: String] = [
//    "Pull Day": "Jour de tirage",
//    "Push Day": "Jour de poussée",
//    "Leg Day": "Jour des jambes",
//    "Bench Press": "Développé couché",
//    "Squat": "Squat",
//    "Deadlift": "Soulevé de terre",
//    "Dumbbell Curl": "Curl avec haltères",
//    "Bent Over Row": "Rowing penché",
//    "Dumbbell Shoulder Press": "Développé épaules avec haltères",
//    "Incline Bench Press": "Développé incliné",
//    "Lat Pulldown": "Tirage à la poulie haute",
//    "Dumbbell Lateral Raise": "Élévations latérales",
//    "Romanian Deadlift": "Soulevé de terre roumain",
//    "Tricep Pushdown": "Extension triceps à la poulie",
//    "Hammer Curl": "Curl marteau",
//    "Seated Cable Row": "Tirage assis à la poulie",
//    "Machine Calf Raise": "Élévations de mollets à la machine",
//    "Dumbbell Lunge": "Fente avec haltères",
//    "Tricep Extension": "Extension triceps"
//]

//// German
//let translation: [String: String] = [
//    "Pull Day": "Zugtag",
//    "Push Day": "Drücktag",
//    "Leg Day": "Beintag",
//    "Bench Press": "Bankdrücken",
//    "Squat": "Kniebeuge",
//    "Deadlift": "Kreuzheben",
//    "Dumbbell Curl": "Kurzhantelcurl",
//    "Bent Over Row": "Vorgebeugtes Rudern",
//    "Dumbbell Shoulder Press": "Schulterdrücken mit Kurzhanteln",
//    "Incline Bench Press": "Schrägbankdrücken",
//    "Lat Pulldown": "Latzug",
//    "Dumbbell Lateral Raise": "Seitheben",
//    "Romanian Deadlift": "Rumänisches Kreuzheben",
//    "Tricep Pushdown": "Trizepsdrücken am Kabelzug",
//    "Hammer Curl": "Hammercurl",
//    "Seated Cable Row": "Sitzendes Kabelrudern",
//    "Machine Calf Raise": "Wadenheben an der Maschine",
//    "Dumbbell Lunge": "Ausfallschritt mit Kurzhanteln",
//    "Tricep Extension": "Trizeps Extension"
//]

// Hindi
//let translation: [String: String] = [
//    "Pull Day": "खींचने का दिन",
//    "Push Day": "धक्का दिन",
//    "Leg Day": "पैरों का दिन",
//    "Bench Press": "बेंच प्रेस",
//    "Squat": "स्क्वाट",
//    "Deadlift": "डेडलिफ्ट",
//    "Dumbbell Curl": "डम्बल कर्ल",
//    "Bent Over Row": "बेंट ओवर रो",
//    "Dumbbell Shoulder Press": "डम्बल शोल्डर प्रेस",
//    "Incline Bench Press": "इंक्लाइन बेंच प्रेस",
//    "Lat Pulldown": "लैट पुलडाउन",
//    "Dumbbell Lateral Raise": "डम्बल लेटरल रेज",
//    "Romanian Deadlift": "रोमेनियाई डेडलिफ्ट",
//    "Tricep Pushdown": "ट्राइसेप पुशडाउन",
//    "Hammer Curl": "हैमर कर्ल",
//    "Seated Cable Row": "सीटेड केबल रो",
//    "Machine Calf Raise": "मशीन कैफ रेज",
//    "Dumbbell Lunge": "डम्बल लंज",
//    "Tricep Extension": "ट्राइसेप एक्सटेंशन"
//]

//// Indonesian
//let translation: [String: String] = [
//    "Pull Day": "Hari Tarik",
//    "Push Day": "Hari Dorong",
//    "Leg Day": "Hari Kaki",
//    "Bench Press": "Tekan Bangku",
//    "Squat": "Squat",
//    "Deadlift": "Angkat Mati",
//    "Dumbbell Curl": "Dumbbell Curl",
//    "Bent Over Row": "Row Membungkuk",
//    "Dumbbell Shoulder Press": "Tekan Bahu dengan Dumbbell",
//    "Incline Bench Press": "Tekan Bangku Miring",
//    "Lat Pulldown": "Tarik Lat",
//    "Dumbbell Lateral Raise": "Angkat Samping Dumbbell",
//    "Romanian Deadlift": "Angkat Mati Rumania",
//    "Tricep Pushdown": "Tekan Tricep ke Bawah",
//    "Hammer Curl": "Hammer Curl",
//    "Seated Cable Row": "Row Kabel Duduk",
//    "Machine Calf Raise": "Angkat Betis Mesin",
//    "Dumbbell Lunge": "Lunge dengan Dumbbell",
//    "Tricep Extension": "Ekstensi Tricep"
//]

// Italian
//let translation: [String: String] = [
//    "Pull Day": "Giorno di trazione",
//    "Push Day": "Giorno di spinta",
//    "Leg Day": "Giorno delle gambe",
//    "Bench Press": "Panca piana",
//    "Squat": "Squat",
//    "Deadlift": "Stacco da terra",
//    "Dumbbell Curl": "Curl con manubri",
//    "Bent Over Row": "Rematore",
//    "Dumbbell Shoulder Press": "Spinta per le spalle con manubri",
//    "Incline Bench Press": "Panca inclinata",
//    "Lat Pulldown": "Trazione alla lat machine",
//    "Dumbbell Lateral Raise": "Alzate laterali con manubri",
//    "Romanian Deadlift": "Stacco rumeno",
//    "Tricep Pushdown": "Pushdown per tricipiti",
//    "Hammer Curl": "Curl a martello",
//    "Seated Cable Row": "Rematore al cavo seduto",
//    "Machine Calf Raise": "Calf raise alla macchina",
//    "Dumbbell Lunge": "Affondi con manubri",
//    "Tricep Extension": "Estensioni per tricipiti"
//]

// Korean
//let translation: [String: String] = [
//    "Pull Day": "풀데이",
//    "Push Day": "푸쉬데이",
//    "Leg Day": "레그데이",
//    "Bench Press": "벤치 프레스",
//    "Squat": "스쿼트",
//    "Deadlift": "데드리프트",
//    "Dumbbell Curl": "덤벨 컬",
//    "Bent Over Row": "벤트 오버 로우",
//    "Dumbbell Shoulder Press": "덤벨 숄더 프레스",
//    "Incline Bench Press": "인클라인 벤치 프레스",
//    "Lat Pulldown": "랫 풀다운",
//    "Dumbbell Lateral Raise": "덤벨 레터럴 레이즈",
//    "Romanian Deadlift": "루마니안 데드리프트",
//    "Tricep Pushdown": "트라이셉스 푸시다운",
//    "Hammer Curl": "해머 컬",
//    "Seated Cable Row": "시티드 케이블 로우",
//    "Machine Calf Raise": "머신 카프 레이즈",
//    "Dumbbell Lunge": "덤벨 런지",
//    "Tricep Extension": "트라이셉스 익스텐션"
//]

//// Portuguese
//let translation: [String: String] = [
//    "Pull Day": "Dia de puxada",
//    "Push Day": "Dia de empurrar",
//    "Leg Day": "Dia de pernas",
//    "Bench Press": "Supino",
//    "Squat": "Agachamento",
//    "Deadlift": "Levantamento terra",
//    "Dumbbell Curl": "Rosca com halteres",
//    "Bent Over Row": "Remada curvada",
//    "Dumbbell Shoulder Press": "Desenvolvimento de ombros com halteres",
//    "Incline Bench Press": "Supino inclinado",
//    "Lat Pulldown": "Puxada na polia",
//    "Dumbbell Lateral Raise": "Elevação lateral com halteres",
//    "Romanian Deadlift": "Levantamento terra romeno",
//    "Tricep Pushdown": "Pushdown de tríceps",
//    "Hammer Curl": "Rosca martelo",
//    "Seated Cable Row": "Remada sentada na polia",
//    "Machine Calf Raise": "Elevação de panturrilha na máquina",
//    "Dumbbell Lunge": "Afundo com halteres",
//    "Tricep Extension": "Extensão de tríceps"
//]
//
//// Russian
//let translation: [String: String] = [
//    "Pull Day": "День тяги",
//    "Push Day": "День жима",
//    "Leg Day": "День ног",
//    "Bench Press": "Жим лёжа",
//    "Squat": "Приседания",
//    "Deadlift": "Становая тяга",
//    "Dumbbell Curl": "Подъем гантелей на бицепс",
//    "Bent Over Row": "Тяга в наклоне",
//    "Dumbbell Shoulder Press": "Жим гантелей над головой",
//    "Incline Bench Press": "Наклонный жим",
//    "Lat Pulldown": "Тяга верхнего блока",
//    "Dumbbell Lateral Raise": "Разведение гантелей в стороны",
//    "Romanian Deadlift": "Румынская тяга",
//    "Tricep Pushdown": "Пушдаун на трицепс",
//    "Hammer Curl": "Молотковый подъем",
//    "Seated Cable Row": "Сидячая тяга на кабеле",
//    "Machine Calf Raise": "Подъем на носки в тренажере",
//    "Dumbbell Lunge": "Выпады с гантелями",
//    "Tricep Extension": "Разгибание трицепса"
//]
