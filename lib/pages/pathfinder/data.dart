// ignore_for_file: require_trailing_commas

import 'package:latlong2/latlong.dart';

Map<String, LatLng> predefinedLocations = {
  'UFO': const LatLng(51.448051, 7.259111),
  'U35-Haltestelle': const LatLng(51.447198, 7.259043),
  'UNICENTER': const LatLng(51.447985, 7.258623),
  'MZ': const LatLng(51.446053, 7.259574),
  'SH': const LatLng(51.445724, 7.259661),
  'SSC': const LatLng(51.446138, 7.260922),
  'UV': const LatLng(51.445772, 7.260552),
  'UB': const LatLng(51.445127, 7.260327),
  'GamingHub': const LatLng(51.445211, 7.259726),
  'Repair Café': const LatLng(51.445029, 7.259882),
  'AUDIMAX': const LatLng(51.444118, 7.261505),
  'Mensa': const LatLng(51.443282, 7.262258),
  'VZ': const LatLng(51.442925, 7.262552),
  'CASPO': const LatLng(51.442723, 7.262436),
  'MA': const LatLng(51.444993, 7.258908),
  'MB/TZR': const LatLng(51.444652, 7.2577),
  'MC/VC': const LatLng(51.444214, 7.256587),
  'MAFO': const LatLng(51.444733, 7.259557),
  'MABF': const LatLng(51.445159, 7.258016),
  'HMA': const LatLng(51.444392, 7.258677),
  'KulturCafé': const LatLng(51.445886, 7.259654),
  'FNO': const LatLng(51.445254, 7.261878),
  'HZO': const LatLng(51.44478, 7.262698),
  'IA': const LatLng(51.445949, 7.262607),
  'IB': const LatLng(51.446348, 7.263733),
  'IC': const LatLng(51.446741, 7.264835),
  'ID': const LatLng(51.447127, 7.266222),
  //'ZGH': const LatLng(),
  'HIA': const LatLng(51.445592, 7.263637),
  'ICFW': const LatLng(51.446185, 7.264557),
  'HIB': const LatLng(51.446009, 7.26471),
  'ICFO': const LatLng(51.446595, 7.265687),
  'HIC': const LatLng(51.446461, 7.26581),
  'HID': const LatLng(51.446809, 7.266467),
  'CC': const LatLng(51.443973, 7.259845),
  'Q-West': const LatLng(51.44403, 7.258903),
  'GA': const LatLng(51.443491, 7.25955),
  'GB': const LatLng(51.443106, 7.25845),
  'GC': const LatLng(51.442715, 7.257316),
  'GD': const LatLng(51.44226, 7.256181),
  'HGA': const LatLng(51.443737, 7.259958),
  'HGB': const LatLng(51.443342, 7.258866),
  'HGC': const LatLng(51.442974, 7.257662),
  'GCFW': const LatLng(51.442346, 7.256945),
  'GAFO': const LatLng(51.442847, 7.260564),
  'GABF': const LatLng(51.442539, 7.259553),
  'GBCF': const LatLng(51.442138, 7.258386),
  'UniKids': const LatLng(51.441977, 7.261644),
  'NB': const LatLng(51.444603, 7.264508),
  'NC': const LatLng(51.445032, 7.26556),
  'ND': const LatLng(51.445321, 7.266759),
  'HNA': const LatLng(51.444544, 7.263566),
  'HNB': const LatLng(51.445048, 7.265095),
  'HNC': const LatLng(51.445389, 7.266204),
  'NBCF': const LatLng(51.444019, 7.265737),
  'NCDF': const LatLng(51.444437, 7.266948),
  'NDEF': const LatLng(51.444832, 7.26814),
  'ZN': const LatLng(51.44509, 7.268653),
  'NT': const LatLng(51.443536, 7.265527),
  'RUBION': const LatLng(51.443657, 7.266155),
  'Isotopenlabor': const LatLng(51.444018, 7.267117),
  'ZEMOS': const LatLng(51.445633, 7.268131),
  'BMZ': const LatLng(51.444561, 7.255235),
  'ZKF': const LatLng(51.445523, 7.258071),
  'IAN': const LatLng(51.446647, 7.261938),
  'IBN': const LatLng(51.447, 7.262752),
  'ICN': const LatLng(51.447448, 7.263219),
  'IDN': const LatLng(51.447889, 7.263472),
};

final Map<dynamic, Map<String, dynamic>> graph = {
  ('SH', '0', 'Haupteingang(West)'): {
    'Coordinates': [1782, 1353],
    'Connections': [
      (('SH', '0', 'EN_10'), 117),
    ]
  },
  ('SH', '0', '004'): {
    'Coordinates': [1491, 1353],
    'Connections': [
      (('SH', '0', 'EN_20'), 100),
    ]
  },
  ('SH', '0', '006'): {
    'Coordinates': [1307, 1242],
    'Connections': [
      (('SH', '0', 'EN_20'), 116),
    ]
  },
  ('SH', '0', '007'): {
    'Coordinates': [1385, 1450],
    'Connections': [
      (('SH', '0', 'EN_21'), 84),
    ]
  },
  ('SH', '0', '008'): {
    'Coordinates': [1327, 1517],
    'Connections': [
      (('SH', '0', 'EN_22'), 91),
    ]
  },
  ('SH', '0', '009'): {
    'Coordinates': [1277, 1563],
    'Connections': [
      (('SH', '0', 'EN_23'), 99),
    ]
  },
  ('SH', '0', '010'): {
    'Coordinates': [1232, 1615],
    'Connections': [
      (('SH', '0', 'EN_24'), 104),
    ]
  },
  ('SH', '0', '011'): {
    'Coordinates': [1162, 1686],
    'Connections': [
      (('SH', '0', 'EN_25'), 99),
    ]
  },
  ('SH', '0', '012'): {
    'Coordinates': [1108, 1732],
    'Connections': [
      (('SH', '0', 'EN_26'), 89),
    ]
  },
  ('SH', '0', '013'): {
    'Coordinates': [1039, 1801],
    'Connections': [
      (('SH', '0', 'EN_27'), 97),
    ]
  },
  ('SH', '0', '014'): {
    'Coordinates': [948, 1621],
    'Connections': [
      (('SH', '0', 'EN_28'), 96),
    ]
  },
  ('SH', '0', '015'): {
    'Coordinates': [898, 1563],
    'Connections': [
      (('SH', '0', 'EN_29'), 105),
    ]
  },
  ('SH', '0', '016'): {
    'Coordinates': [855, 1520],
    'Connections': [
      (('SH', '0', 'EN_30'), 103),
    ]
  },
  ('SH', '0', '017'): {
    'Coordinates': [803, 1465],
    'Connections': [
      (('SH', '0', 'EN_31'), 101),
    ]
  },
  ('SH', '0', '018'): {
    'Coordinates': [731, 1409],
    'Connections': [
      (('SH', '0', 'EN_32'), 88),
    ]
  },
  ('SH', '0', '066'): {
    'Coordinates': [558, 1359],
    'Connections': [
      (('SH', '0', 'EN_35'), 85),
    ]
  },
  ('SH', '0', '068'): {
    'Coordinates': [651, 1271],
    'Connections': [
      (('SH', '0', 'EN_40'), 82),
    ]
  },
  ('SH', '0', '069'): {
    'Coordinates': [714, 1193],
    'Connections': [
      (('SH', '0', 'EN_37'), 107),
    ]
  },
  ('SH', '0', '070'): {
    'Coordinates': [775, 1132],
    'Connections': [
      (('SH', '0', 'EN_38'), 115),
    ]
  },
  ('SH', '0', '071'): {
    'Coordinates': [870, 1041],
    'Connections': [
      (('SH', '0', 'EN_39'), 103),
    ]
  },
  ('SH', '0', '072'): {
    'Coordinates': [972, 1082],
    'Connections': [
      (('SH', '0', 'EN_39'), 59),
    ]
  },
  ('SH', '0', '062'): {
    'Coordinates': [428, 1617],
    'Connections': [
      (('SH', '0', 'EN_35'), 268),
      (('SH', '0', '065'), 150),
    ]
  },
  ('SH', '0', '065'): {
    'Coordinates': [485, 1478],
    'Connections': [
      (('SH', '0', '062'), 150),
    ]
  },
  ('SH', '0', '036'): {
    'Coordinates': [1234, 1045],
    'Connections': [
      (('SH', '0', '031'), 112),
    ]
  },
  ('SH', '0', '037'): {
    'Coordinates': [1162, 974],
    'Connections': [
      (('SH', '0', '031'), 86),
    ]
  },
  ('SH', '0', '039'): {
    'Coordinates': [1091, 911],
    'Connections': [
      (('SH', '0', '040'), 77),
    ]
  },
  ('SH', '0', '040'): {
    'Coordinates': [1134, 846],
    'Connections': [
      (('SH', '0', '031'), 135),
      (('SH', '0', '039'), 77),
      (('SH', '0', '038'), 112),
    ]
  },
  ('SH', '0', '038'): {
    'Coordinates': [1221, 775],
    'Connections': [
      (('SH', '0', '040'), 112),
    ]
  },
  ('SH', '0', '035'): {
    'Coordinates': [1277, 820],
    'Connections': [
      (('SH', '0', '031'), 119),
    ]
  },
  ('SH', '0', '031'): {
    'Coordinates': [1238, 933],
    'Connections': [
      (('SH', '0', '030'), 226),
      (('SH', '0', '037'), 86),
      (('SH', '0', '035'), 119),
      (('SH', '0', '040'), 135),
      (('SH', '0', '036'), 112),
    ]
  },
  ('SH', '0', '030'): {
    'Coordinates': [1407, 1084],
    'Connections': [
      (('SH', '0', 'EN_15'), 156),
      (('SH', '0', 'WC'), 91),
      (('SH', '0', '031'), 226),
    ]
  },
  ('SH', '0', '081'): {
    'Coordinates': [1377, 660],
    'Connections': [
      (('SH', '0', 'EN_13'), 120),
    ]
  },
  ('SH', '0', '083'): {
    'Coordinates': [1418, 539],
    'Connections': [
      (('SH', '0', 'EN_13'), 77),
    ]
  },
  ('SH', '0', '085'): {
    'Coordinates': [1524, 532],
    'Connections': [
      (('SH', '0', 'EN_13'), 76),
    ]
  },
  ('SH', '0', 'CulturCafe'): {
    'Coordinates': [1968, 1013],
    'Connections': [
      (('SH', '0', 'EN_12'), 94),
      (('SH', '0', 'EN_10'), 362),
    ]
  },
  ('SH', '0', 'WC'): {
    'Coordinates': [1472, 1019],
    'Connections': [
      (('SH', '0', '030'), 91),
    ]
  },
  ('SH', '0', 'EN_10'): {
    'Coordinates': [1706, 1264],
    'Connections': [
      (('SH', '0', 'CulturCafe'), 362),
      (('SH', '0', 'EN_11'), 75),
      (('SH', '0', 'Haupteingang(West)'), 117),
    ]
  },
  ('SH', '0', 'EN_11'): {
    'Coordinates': [1656, 1208],
    'Connections': [
      (('SH', '0', 'EN_10'), 75),
      (('SH', '0', 'EN_15'), 139),
      (('SH', '0', 'EN_16'), 132),
    ]
  },
  ('SH', '0', 'EN_12'): {
    'Coordinates': [1875, 998],
    'Connections': [
      (('SH', '0', 'EN_13'), 569),
      (('SH', '0', 'CulturCafe'), 94),
    ]
  },
  ('SH', '0', 'EN_13'): {
    'Coordinates': [1476, 591],
    'Connections': [
      (('SH', '0', '083'), 77),
      (('SH', '0', '085'), 76),
      (('SH', '0', '081'), 120),
      (('SH', '0', 'EN_12'), 569),
    ]
  },
  ('SH', '0', 'EN_15'): {
    'Coordinates': [1517, 1195],
    'Connections': [
      (('SH', '0', 'EN_11'), 139),
      (('SH', '0', 'EN_16'), 162),
      (('SH', '0', '030'), 156),
      (('SH', '0', 'EN_19'), 125),
    ]
  },
  ('SH', '0', 'EN_16'): {
    'Coordinates': [1630, 1078],
    'Connections': [
      (('SH', '0', 'EN_15'), 162),
      (('SH', '0', 'EN_11'), 132),
      (('SH', '0', 'EN_17'), 206),
    ]
  },
  ('SH', '0', 'EN_17'): {
    'Coordinates': [1500, 918],
    'Connections': [
      (('SH', '0', 'EN_16'), 206),
      (('SH', '0', 'EN_18'), 78),
    ]
  },
  ('SH', '0', 'EN_18'): {
    'Coordinates': [1552, 859],
    'Connections': [
      (('SH', '0', 'EN_17'), 78),
      (('SH', '0', 'TreppenhausNord'), 155),
    ]
  },
  ('SH', '0', 'EN_19'): {
    'Coordinates': [1435, 1290],
    'Connections': [
      (('SH', '0', 'EN_20'), 44),
      (('SH', '0', 'EN_15'), 125),
    ]
  },
  ('SH', '0', 'EN_20'): {
    'Coordinates': [1398, 1314],
    'Connections': [
      (('SH', '0', '006'), 116),
      (('SH', '0', 'EN_19'), 44),
      (('SH', '0', '004'), 100),
      (('SH', '0', 'EN_21'), 105),
    ]
  },
  ('SH', '0', 'EN_21'): {
    'Coordinates': [1325, 1390],
    'Connections': [
      (('SH', '0', 'EN_20'), 105),
      (('SH', '0', '007'), 84),
      (('SH', '0', 'EN_22'), 94),
    ]
  },
  ('SH', '0', 'EN_22'): {
    'Coordinates': [1258, 1457],
    'Connections': [
      (('SH', '0', 'EN_21'), 94),
      (('SH', '0', '008'), 91),
      (('SH', '0', 'EN_23'), 67),
    ]
  },
  ('SH', '0', 'EN_23'): {
    'Coordinates': [1203, 1496],
    'Connections': [
      (('SH', '0', 'EN_22'), 67),
      (('SH', '0', 'EN_24'), 66),
      (('SH', '0', '009'), 99),
    ]
  },
  ('SH', '0', 'EN_24'): {
    'Coordinates': [1156, 1543],
    'Connections': [
      (('SH', '0', 'EN_23'), 66),
      (('SH', '0', '010'), 104),
      (('SH', '0', 'EN_25'), 95),
    ]
  },
  ('SH', '0', 'EN_25'): {
    'Coordinates': [1093, 1615],
    'Connections': [
      (('SH', '0', 'EN_24'), 95),
      (('SH', '0', '011'), 99),
      (('SH', '0', 'EN_26'), 75),
    ]
  },
  ('SH', '0', 'EN_26'): {
    'Coordinates': [1043, 1671],
    'Connections': [
      (('SH', '0', 'EN_25'), 75),
      (('SH', '0', 'EN_27'), 124),
      (('SH', '0', '012'), 89),
    ]
  },
  ('SH', '0', 'EN_27'): {
    'Coordinates': [952, 1756],
    'Connections': [
      (('SH', '0', 'EN_26'), 124),
      (('SH', '0', '013'), 97),
      (('SH', '0', 'EN_28'), 96),
    ]
  },
  ('SH', '0', 'EN_28'): {
    'Coordinates': [881, 1691],
    'Connections': [
      (('SH', '0', 'EN_27'), 96),
      (('SH', '0', 'EN_29'), 63),
      (('SH', '0', '014'), 96),
    ]
  },
  ('SH', '0', 'EN_29'): {
    'Coordinates': [835, 1647],
    'Connections': [
      (('SH', '0', 'EN_28'), 63),
      (('SH', '0', 'EN_30'), 73),
      (('SH', '0', '015'), 105),
    ]
  },
  ('SH', '0', 'EN_30'): {
    'Coordinates': [783, 1595],
    'Connections': [
      (('SH', '0', 'EN_29'), 73),
      (('SH', '0', 'EN_31'), 71),
      (('SH', '0', '016'), 103),
      (('SH', '0', 'EingangSüd'), 137),
    ]
  },
  ('SH', '0', 'EN_31'): {
    'Coordinates': [736, 1541],
    'Connections': [
      (('SH', '0', 'EN_30'), 71),
      (('SH', '0', 'EN_32'), 106),
      (('SH', '0', '017'), 101),
      (('SH', '0', 'EN_33'), 92),
    ]
  },
  ('SH', '0', 'EN_32'): {
    'Coordinates': [662, 1465],
    'Connections': [
      (('SH', '0', 'EN_31'), 106),
      (('SH', '0', '018'), 88),
    ]
  },
  ('SH', '0', 'EN_33'): {
    'Coordinates': [662, 1597],
    'Connections': [
      (('SH', '0', 'TreppenhausSüd'), 90),
      (('SH', '0', 'EN_31'), 92),
    ]
  },
  ('SH', '0', 'TreppenhausNord'): {
    'Coordinates': [1435, 757],
    'Connections': [
      (('SH', '0', 'EN_18'), 155),
    ]
  },
  ('SH', '0', 'TreppenhausSüd'): {
    'Coordinates': [595, 1658],
    'Connections': [
      (('SH', '0', 'EN_33'), 90),
      (('SH', '1', 'TreppenhausSüd2.Etage'), 1),
    ]
  },
  ('SH', '0', 'EN_35'): {
    'Coordinates': [614, 1424],
    'Connections': [
      (('SH', '0', '062'), 268),
      (('SH', '0', '066'), 85),
      (('SH', '0', 'EN_40'), 140),
    ]
  },
  ('SH', '0', 'EN_37'): {
    'Coordinates': [779, 1279],
    'Connections': [
      (('SH', '0', '069'), 107),
      (('SH', '0', 'EN_40'), 79),
      (('SH', '0', 'EN_38'), 80),
    ]
  },
  ('SH', '0', 'EN_38'): {
    'Coordinates': [840, 1227],
    'Connections': [
      (('SH', '0', '070'), 115),
      (('SH', '0', 'EN_37'), 80),
      (('SH', '0', 'EN_39'), 136),
    ]
  },
  ('SH', '0', 'EN_39'): {
    'Coordinates': [931, 1125],
    'Connections': [
      (('SH', '0', '071'), 103),
      (('SH', '0', 'EN_38'), 136),
      (('SH', '0', '072'), 59),
    ]
  },
  ('SH', '0', 'EN_40'): {
    'Coordinates': [714, 1325],
    'Connections': [
      (('SH', '0', '068'), 82),
      (('SH', '0', 'EN_35'), 140),
      (('SH', '0', 'EN_37'), 79),
    ]
  },
  ('SH', '0', 'EingangSüd'): {
    'Coordinates': [727, 1721],
    'Connections': [
      (('SH', '0', 'EN_30'), 137),
    ]
  },
  ('SH', '1', '112'): {
    'Coordinates': [700, 1694],
    'Connections': []
  },
  ('SH', '1', '113'): {
    'Coordinates': [606, 1619],
    'Connections': [
      (('SH', '1', 'EN_32'), 124),
      (('SH', '1', '114'), 108),
    ]
  },
  ('SH', '1', '114'): {
    'Coordinates': [528, 1544],
    'Connections': [
      (('SH', '1', '113'), 108),
    ]
  },
  ('SH', '1', '111'): {
    'Coordinates': [675, 1935],
    'Connections': [
      (('SH', '1', 'EN_31'), 93),
    ]
  },
  ('SH', '1', '110'): {
    'Coordinates': [740, 1850],
    'Connections': [
      (('SH', '1', 'EN_33'), 166),
    ]
  },
  ('SH', '1', '109'): {
    'Coordinates': [800, 1797],
    'Connections': [
      (('SH', '1', 'EN_58'), 77),
    ]
  },
  ('SH', '1', '108'): {
    'Coordinates': [862, 1735],
    'Connections': [
      (('SH', '1', 'EN_57'), 80),
    ]
  },
  ('SH', '1', '107'): {
    'Coordinates': [916, 1675],
    'Connections': [
      (('SH', '1', 'EN_56'), 77),
    ]
  },
  ('SH', '1', '106'): {
    'Coordinates': [953, 1638],
    'Connections': [
      (('SH', '1', 'EN_55'), 72),
    ]
  },
  ('SH', '1', '105'): {
    'Coordinates': [1000, 1578],
    'Connections': [
      (('SH', '1', 'EN_54'), 59),
    ]
  },
  ('SH', '1', '104'): {
    'Coordinates': [1053, 1532],
    'Connections': [
      (('SH', '1', 'EN_53'), 62),
    ]
  },
  ('SH', '1', '103'): {
    'Coordinates': [1116, 1472],
    'Connections': [
      (('SH', '1', 'EN_52'), 66),
    ]
  },
  ('SH', '1', '102'): {
    'Coordinates': [1191, 1410],
    'Connections': [
      (('SH', '1', 'EN_51'), 71),
    ]
  },
  ('SH', '1', '101'): {
    'Coordinates': [1272, 1328],
    'Connections': [
      (('SH', '1', 'EN_50'), 78),
    ]
  },
  ('SH', '1', 'AnschlussMusischesZentrum'): {
    'Coordinates': [1422, 1063],
    'Connections': [
      (('SH', '1', 'EN_50'), 264),
    ]
  },
  ('SH', '1', '122'): {
    'Coordinates': [715, 2047],
    'Connections': [
      (('SH', '1', 'EN_35'), 92),
    ]
  },
  ('SH', '1', '124'): {
    'Coordinates': [806, 2119],
    'Connections': [
      (('SH', '1', 'EN_37'), 108),
    ]
  },
  ('SH', '1', '126'): {
    'Coordinates': [884, 2204],
    'Connections': [
      (('SH', '1', 'EN_39'), 110),
    ]
  },
  ('SH', '1', '128'): {
    'Coordinates': [959, 2269],
    'Connections': [
      (('SH', '1', 'EN_40'), 111),
    ]
  },
  ('SH', '1', '130'): {
    'Coordinates': [1019, 2326],
    'Connections': [
      (('SH', '1', 'EN_41'), 108),
    ]
  },
  ('SH', '1', '132'): {
    'Coordinates': [1078, 2388],
    'Connections': [
      (('SH', '1', 'EN_42'), 110),
    ]
  },
  ('SH', '1', '136'): {
    'Coordinates': [1197, 2513],
    'Connections': [
      (('SH', '1', 'EN_45'), 104),
    ]
  },
  ('SH', '1', '138'): {
    'Coordinates': [1278, 2582],
    'Connections': [
      (('SH', '1', 'EN_46'), 95),
    ]
  },
  ('SH', '1', '143'): {
    'Coordinates': [1206, 2763],
    'Connections': [
      (('SH', '1', 'EN_46'), 106),
    ]
  },
  ('SH', '1', '141'): {
    'Coordinates': [1134, 2685],
    'Connections': [
      (('SH', '1', 'EN_46'), 89),
    ]
  },
  ('SH', '1', '139'): {
    'Coordinates': [1081, 2632],
    'Connections': [
      (('SH', '1', 'EN_45'), 87),
    ]
  },
  ('SH', '1', '137'): {
    'Coordinates': [1016, 2576],
    'Connections': [
      (('SH', '1', 'EN_43'), 75),
    ]
  },
  ('SH', '1', '135'): {
    'Coordinates': [953, 2523],
    'Connections': [
      (('SH', '1', 'EN_42'), 79),
    ]
  },
  ('SH', '1', '133'): {
    'Coordinates': [897, 2448],
    'Connections': [
      (('SH', '1', 'EN_41'), 65),
    ]
  },
  ('SH', '1', '131'): {
    'Coordinates': [853, 2398],
    'Connections': [
      (('SH', '1', 'EN_40'), 55),
    ]
  },
  ('SH', '1', '129'): {
    'Coordinates': [797, 2348],
    'Connections': [
      (('SH', '1', 'EN_39'), 58),
    ]
  },
  ('SH', '1', '127'): {
    'Coordinates': [744, 2307],
    'Connections': [
      (('SH', '1', 'EN_38'), 70),
    ]
  },
  ('SH', '1', '125'): {
    'Coordinates': [694, 2247],
    'Connections': [
      (('SH', '1', 'EN_37'), 62),
    ]
  },
  ('SH', '1', '123'): {
    'Coordinates': [640, 2201],
    'Connections': [
      (('SH', '1', 'EN_36'), 66),
    ]
  },
  ('SH', '1', '121'): {
    'Coordinates': [590, 2144],
    'Connections': [
      (('SH', '1', 'EN_35'), 66),
    ]
  },
  ('SH', '1', '150'): {
    'Coordinates': [544, 2101],
    'Connections': [
      (('SH', '1', 'EN_34'), 67),
    ]
  },
  ('SH', '1', '151'): {
    'Coordinates': [493, 2044],
    'Connections': [
      (('SH', '1', 'EN_30'), 62),
    ]
  },
  ('SH', '1', '152'): {
    'Coordinates': [443, 2000],
    'Connections': [
      (('SH', '1', 'EN_29'), 65),
    ]
  },
  ('SH', '1', '155'): {
    'Coordinates': [390, 1950],
    'Connections': [
      (('SH', '1', 'EN_28'), 72),
    ]
  },
  ('SH', '1', '157'): {
    'Coordinates': [337, 1897],
    'Connections': [
      (('SH', '1', 'EN_27'), 68),
    ]
  },
  ('SH', '1', '158'): {
    'Coordinates': [234, 1782],
    'Connections': [
      (('SH', '1', 'EN_25'), 53),
    ]
  },
  ('SH', '1', '160'): {
    'Coordinates': [196, 1678],
    'Connections': [
      (('SH', '1', 'EN_24'), 38),
    ]
  },
  ('SH', '1', '161'): {
    'Coordinates': [253, 1610],
    'Connections': [
      (('SH', '1', 'EN_23'), 44),
    ]
  },
  ('SH', '1', '162'): {
    'Coordinates': [334, 1532],
    'Connections': [
      (('SH', '1', 'EN_22'), 48),
    ]
  },
  ('SH', '1', '164'): {
    'Coordinates': [425, 1447],
    'Connections': [
      (('SH', '1', 'EN_21'), 35),
    ]
  },
  ('SH', '1', '165'): {
    'Coordinates': [506, 1369],
    'Connections': [
      (('SH', '1', 'EN_20'), 38),
    ]
  },
  ('SH', '1', '167'): {
    'Coordinates': [562, 1294],
    'Connections': [
      (('SH', '1', 'EN_19'), 48),
    ]
  },
  ('SH', '1', '168'): {
    'Coordinates': [615, 1238],
    'Connections': [
      (('SH', '1', 'EN_18'), 49),
    ]
  },
  ('SH', '1', '169'): {
    'Coordinates': [678, 1172],
    'Connections': [
      (('SH', '1', 'EN_17'), 59),
    ]
  },
  ('SH', '1', '170'): {
    'Coordinates': [731, 1131],
    'Connections': [
      (('SH', '1', 'EN_16'), 58),
    ]
  },
  ('SH', '1', '171'): {
    'Coordinates': [800, 1069],
    'Connections': [
      (('SH', '1', 'EN_13'), 50),
    ]
  },
  ('SH', '1', '174'): {
    'Coordinates': [847, 1012],
    'Connections': [
      (('SH', '1', 'EN_12'), 46),
    ]
  },
  ('SH', '1', '175'): {
    'Coordinates': [919, 953],
    'Connections': [
      (('SH', '1', 'EN_11'), 53),
    ]
  },
  ('SH', '1', '176'): {
    'Coordinates': [975, 887],
    'Connections': [
      (('SH', '1', 'EN_10'), 49),
    ]
  },
  ('SH', '1', '177'): {
    'Coordinates': [1034, 828],
    'Connections': [
      (('SH', '1', 'EN_9'), 62),
    ]
  },
  ('SH', '1', '181'): {
    'Coordinates': [1100, 775],
    'Connections': [
      (('SH', '1', 'EN_8'), 60),
    ]
  },
  ('SH', '1', '184'): {
    'Coordinates': [1159, 712],
    'Connections': [
      (('SH', '1', 'EN_7'), 73),
    ]
  },
  ('SH', '1', '185'): {
    'Coordinates': [1216, 650],
    'Connections': [
      (('SH', '1', 'EN_6'), 70),
    ]
  },
  ('SH', '1', '186'): {
    'Coordinates': [1272, 600],
    'Connections': [
      (('SH', '1', 'EN_5'), 72),
    ]
  },
  ('SH', '1', '182'): {
    'Coordinates': [1256, 897],
    'Connections': [
      (('SH', '1', 'EN_8'), 138),
    ]
  },
  ('SH', '1', '183'): {
    'Coordinates': [1306, 841],
    'Connections': [
      (('SH', '1', 'EN_7'), 122),
    ]
  },
  ('SH', '1', '188'): {
    'Coordinates': [1450, 697],
    'Connections': [
      (('SH', '1', 'EN_5'), 135),
    ]
  },
  ('SH', '1', '189'): {
    'Coordinates': [1528, 434],
    'Connections': [
      (('SH', '1', 'EN_3'), 77),
    ]
  },
  ('SH', '1', '191'): {
    'Coordinates': [1453, 347],
    'Connections': [
      (('SH', '1', 'EN_2'), 77),
    ]
  },
  ('SH', '1', '193'): {
    'Coordinates': [1388, 281],
    'Connections': [
      (('SH', '1', 'EN_1'), 80),
    ]
  },
  ('SH', '1', '199'): {
    'Coordinates': [1338, 225],
    'Connections': [
      (('SH', '1', 'EN_0'), 91),
    ]
  },
  ('SH', '1', '198'): {
    'Coordinates': [1222, 206],
    'Connections': [
      (('SH', '1', 'EN_0'), 75),
    ]
  },
  ('SH', '1', '197'): {
    'Coordinates': [1175, 234],
    'Connections': [
      (('SH', '1', 'EN_0'), 92),
    ]
  },
  ('SH', '1', '196'): {
    'Coordinates': [1219, 325],
    'Connections': [
      (('SH', '1', 'EN_0'), 66),
    ]
  },
  ('SH', '1', '187'): {
    'Coordinates': [1378, 497],
    'Connections': [
      (('SH', '1', 'EN_4'), 59),
    ]
  },
  ('SH', '1', '172'): {
    'Coordinates': [906, 1188],
    'Connections': [
      (('SH', '1', 'EN_13'), 110),
    ]
  },
  ('SH', '1', '101d'): {
    'Coordinates': [1006, 1103],
    'Connections': [
      (('SH', '1', 'EN_12'), 139),
    ]
  },
  ('SH', '1', '101a'): {
    'Coordinates': [1081, 1241],
    'Connections': [
      (('SH', '1', 'EN_50'), 160),
      (('SH', '1', 'EN_51'), 131),
    ]
  },
  ('SH', '1', 'TreppehnausNord2.Etage'): {
    'Coordinates': [1150, 1031],
    'Connections': [
      (('SH', '1', 'EN_49'), 96),
      (('SH', '1', 'EN_48'), 79),
    ]
  },
  ('SH', '1', 'TreppenhausSüd2.Etage'): {
    'Coordinates': [431, 1757],
    'Connections': [
      (('SH', '1', 'EN_26'), 95),
      (('SH', '1', 'EN_32'), 99),
      (('SH', '0', 'TreppenhausSüd'), 1),
    ]
  },
  ('SH', '1', 'EN_0'): {
    'Coordinates': [1259, 272],
    'Connections': [
      (('SH', '1', '197'), 92),
      (('SH', '1', '198'), 75),
      (('SH', '1', '196'), 66),
      (('SH', '1', '199'), 91),
      (('SH', '1', 'EN_1'), 88),
    ]
  },
  ('SH', '1', 'EN_1'): {
    'Coordinates': [1325, 331],
    'Connections': [
      (('SH', '1', 'EN_0'), 88),
      (('SH', '1', '193'), 80),
      (('SH', '1', 'EN_2'), 95),
    ]
  },
  ('SH', '1', 'EN_2'): {
    'Coordinates': [1394, 397],
    'Connections': [
      (('SH', '1', 'EN_1'), 95),
      (('SH', '1', '191'), 77),
      (('SH', '1', 'EN_3'), 123),
    ]
  },
  ('SH', '1', 'EN_3'): {
    'Coordinates': [1475, 490],
    'Connections': [
      (('SH', '1', 'EN_4'), 70),
      (('SH', '1', 'EN_2'), 123),
      (('SH', '1', '189'), 77),
    ]
  },
  ('SH', '1', 'EN_4'): {
    'Coordinates': [1422, 537],
    'Connections': [
      (('SH', '1', 'EN_5'), 153),
      (('SH', '1', 'EN_3'), 70),
      (('SH', '1', '187'), 59),
    ]
  },
  ('SH', '1', 'EN_5'): {
    'Coordinates': [1322, 653],
    'Connections': [
      (('SH', '1', 'EN_6'), 77),
      (('SH', '1', '186'), 72),
      (('SH', '1', '188'), 135),
      (('SH', '1', 'EN_4'), 153),
    ]
  },
  ('SH', '1', 'EN_6'): {
    'Coordinates': [1263, 703],
    'Connections': [
      (('SH', '1', 'EN_7'), 77),
      (('SH', '1', '185'), 70),
      (('SH', '1', 'EN_5'), 77),
      (('SH', '1', 'EN_6'), 0),
      (('SH', '1', 'EN_6'), 0),
    ]
  },
  ('SH', '1', 'EN_7'): {
    'Coordinates': [1213, 762],
    'Connections': [
      (('SH', '1', 'EN_8'), 91),
      (('SH', '1', '184'), 73),
      (('SH', '1', 'EN_6'), 77),
      (('SH', '1', '183'), 122),
    ]
  },
  ('SH', '1', 'EN_8'): {
    'Coordinates': [1141, 819],
    'Connections': [
      (('SH', '1', 'EN_9'), 86),
      (('SH', '1', '181'), 60),
      (('SH', '1', 'EN_7'), 91),
      (('SH', '1', '182'), 138),
    ]
  },
  ('SH', '1', 'EN_9'): {
    'Coordinates': [1075, 875],
    'Connections': [
      (('SH', '1', 'EN_10'), 85),
      (('SH', '1', '177'), 62),
      (('SH', '1', 'EN_8'), 86),
    ]
  },
  ('SH', '1', 'EN_10'): {
    'Coordinates': [1006, 925],
    'Connections': [
      (('SH', '1', 'EN_11'), 91),
      (('SH', '1', '176'), 49),
      (('SH', '1', 'EN_9'), 85),
    ]
  },
  ('SH', '1', 'EN_11'): {
    'Coordinates': [950, 997],
    'Connections': [
      (('SH', '1', 'EN_12'), 87),
      (('SH', '1', '175'), 53),
      (('SH', '1', 'EN_11'), 0),
      (('SH', '1', 'EN_11'), 0),
      (('SH', '1', 'EN_49'), 156),
      (('SH', '1', 'EN_10'), 91),
    ]
  },
  ('SH', '1', 'EN_12'): {
    'Coordinates': [878, 1047],
    'Connections': [
      (('SH', '1', 'EN_13'), 84),
      (('SH', '1', '174'), 46),
      (('SH', '1', 'EN_11'), 87),
      (('SH', '1', '101d'), 139),
    ]
  },
  ('SH', '1', 'EN_13'): {
    'Coordinates': [825, 1113],
    'Connections': [
      (('SH', '1', 'EN_16'), 92),
      (('SH', '1', '172'), 110),
      (('SH', '1', '171'), 50),
      (('SH', '1', 'EN_12'), 84),
    ]
  },
  ('SH', '1', 'EN_16'): {
    'Coordinates': [762, 1181],
    'Connections': [
      (('SH', '1', 'EN_17'), 71),
      (('SH', '1', '170'), 58),
      (('SH', '1', 'EN_13'), 92),
    ]
  },
  ('SH', '1', 'EN_17'): {
    'Coordinates': [706, 1225],
    'Connections': [
      (('SH', '1', 'EN_18'), 81),
      (('SH', '1', '169'), 59),
      (('SH', '1', 'EN_16'), 71),
    ]
  },
  ('SH', '1', 'EN_18'): {
    'Coordinates': [644, 1278],
    'Connections': [
      (('SH', '1', 'EN_19'), 80),
      (('SH', '1', '168'), 49),
      (('SH', '1', 'EN_17'), 81),
    ]
  },
  ('SH', '1', 'EN_19'): {
    'Coordinates': [587, 1335],
    'Connections': [
      (('SH', '1', 'EN_20'), 92),
      (('SH', '1', '167'), 48),
      (('SH', '1', 'EN_18'), 80),
    ]
  },
  ('SH', '1', 'EN_20'): {
    'Coordinates': [525, 1403],
    'Connections': [
      (('SH', '1', 'EN_21'), 111),
      (('SH', '1', '165'), 38),
      (('SH', '1', 'EN_19'), 92),
    ]
  },
  ('SH', '1', 'EN_21'): {
    'Coordinates': [443, 1478],
    'Connections': [
      (('SH', '1', 'EN_22'), 119),
      (('SH', '1', '164'), 35),
      (('SH', '1', 'EN_20'), 111),
    ]
  },
  ('SH', '1', 'EN_22'): {
    'Coordinates': [365, 1569],
    'Connections': [
      (('SH', '1', 'EN_32'), 196),
      (('SH', '1', 'EN_23'), 116),
      (('SH', '1', '162'), 48),
      (('SH', '1', 'EN_21'), 119),
    ]
  },
  ('SH', '1', 'EN_23'): {
    'Coordinates': [278, 1647],
    'Connections': [
      (('SH', '1', 'EN_24'), 72),
      (('SH', '1', '161'), 44),
      (('SH', '1', 'EN_22'), 116),
    ]
  },
  ('SH', '1', 'EN_24'): {
    'Coordinates': [228, 1700],
    'Connections': [
      (('SH', '1', 'EN_25'), 57),
      (('SH', '1', '160'), 38),
      (('SH', '1', 'EN_23'), 72),
    ]
  },
  ('SH', '1', 'EN_25'): {
    'Coordinates': [268, 1741],
    'Connections': [
      (('SH', '1', 'EN_26'), 115),
      (('SH', '1', 'EN_24'), 57),
      (('SH', '1', '158'), 53),
    ]
  },
  ('SH', '1', 'EN_26'): {
    'Coordinates': [356, 1816],
    'Connections': [
      (('SH', '1', 'EN_27'), 62),
      (('SH', '1', 'EN_25'), 115),
      (('SH', '1', 'TreppenhausSüd2.Etage'), 95),
    ]
  },
  ('SH', '1', 'EN_27'): {
    'Coordinates': [397, 1863],
    'Connections': [
      (('SH', '1', 'EN_28'), 59),
      (('SH', '1', 'EN_26'), 62),
      (('SH', '1', '157'), 68),
    ]
  },
  ('SH', '1', 'EN_28'): {
    'Coordinates': [443, 1900],
    'Connections': [
      (('SH', '1', 'EN_29'), 75),
      (('SH', '1', 'EN_27'), 59),
      (('SH', '1', '155'), 72),
    ]
  },
  ('SH', '1', 'EN_29'): {
    'Coordinates': [493, 1957],
    'Connections': [
      (('SH', '1', 'EN_30'), 61),
      (('SH', '1', 'EN_28'), 75),
      (('SH', '1', '152'), 65),
      (('SH', '1', 'EN_31'), 169),
    ]
  },
  ('SH', '1', 'EN_30'): {
    'Coordinates': [537, 2000],
    'Connections': [
      (('SH', '1', 'EN_34'), 84),
      (('SH', '1', 'EN_29'), 61),
      (('SH', '1', '151'), 62),
    ]
  },
  ('SH', '1', 'EN_31'): {
    'Coordinates': [628, 1854],
    'Connections': [
      (('SH', '1', 'EN_29'), 169),
      (('SH', '1', '111'), 93),
      (('SH', '1', 'EN_58'), 172),
      (('SH', '1', 'EN_33'), 84),
    ]
  },
  ('SH', '1', 'EN_32'): {
    'Coordinates': [512, 1700],
    'Connections': [
      (('SH', '1', 'TreppenhausSüd2.Etage'), 99),
      (('SH', '1', 'EN_33'), 110),
      (('SH', '1', 'EN_22'), 196),
      (('SH', '1', '113'), 124),
    ]
  },
  ('SH', '1', 'EN_33'): {
    'Coordinates': [590, 1778],
    'Connections': [
      (('SH', '1', 'EN_31'), 84),
      (('SH', '1', 'EN_32'), 110),
      (('SH', '1', '110'), 166),
    ]
  },
  ('SH', '1', 'EN_34'): {
    'Coordinates': [597, 2060],
    'Connections': [
      (('SH', '1', 'EN_35'), 70),
      (('SH', '1', 'EN_30'), 84),
      (('SH', '1', '150'), 67),
    ]
  },
  ('SH', '1', 'EN_35'): {
    'Coordinates': [647, 2110],
    'Connections': [
      (('SH', '1', 'EN_36'), 63),
      (('SH', '1', 'EN_34'), 70),
      (('SH', '1', '121'), 66),
      (('SH', '1', '122'), 92),
    ]
  },
  ('SH', '1', 'EN_36'): {
    'Coordinates': [690, 2157],
    'Connections': [
      (('SH', '1', 'EN_37'), 57),
      (('SH', '1', 'EN_35'), 63),
      (('SH', '1', '123'), 66),
    ]
  },
  ('SH', '1', 'EN_37'): {
    'Coordinates': [731, 2197],
    'Connections': [
      (('SH', '1', 'EN_38'), 77),
      (('SH', '1', 'EN_36'), 57),
      (('SH', '1', '125'), 62),
      (('SH', '1', '124'), 108),
    ]
  },
  ('SH', '1', 'EN_38'): {
    'Coordinates': [787, 2251],
    'Connections': [
      (('SH', '1', 'EN_39'), 66),
      (('SH', '1', 'EN_37'), 77),
      (('SH', '1', '127'), 70),
    ]
  },
  ('SH', '1', 'EN_39'): {
    'Coordinates': [831, 2301],
    'Connections': [
      (('SH', '1', 'EN_40'), 77),
      (('SH', '1', 'EN_38'), 66),
      (('SH', '1', '129'), 58),
      (('SH', '1', '126'), 110),
    ]
  },
  ('SH', '1', 'EN_40'): {
    'Coordinates': [887, 2354],
    'Connections': [
      (('SH', '1', 'EN_41'), 61),
      (('SH', '1', 'EN_39'), 77),
      (('SH', '1', '131'), 55),
      (('SH', '1', '128'), 111),
    ]
  },
  ('SH', '1', 'EN_41'): {
    'Coordinates': [934, 2394],
    'Connections': [
      (('SH', '1', 'EN_42'), 77),
      (('SH', '1', 'EN_40'), 61),
      (('SH', '1', '133'), 65),
      (('SH', '1', '130'), 108),
    ]
  },
  ('SH', '1', 'EN_42'): {
    'Coordinates': [987, 2451],
    'Connections': [
      (('SH', '1', 'EN_43'), 73),
      (('SH', '1', 'EN_41'), 77),
      (('SH', '1', '135'), 79),
      (('SH', '1', '132'), 110),
    ]
  },
  ('SH', '1', 'EN_43'): {
    'Coordinates': [1038, 2504],
    'Connections': [
      (('SH', '1', 'EN_44'), 79),
      (('SH', '1', 'EN_42'), 73),
      (('SH', '1', '137'), 75),
    ]
  },
  ('SH', '1', 'EN_44'): {
    'Coordinates': [1100, 2554],
    'Connections': [
      (('SH', '1', 'EN_45'), 88),
      (('SH', '1', 'EN_59'), 110),
      (('SH', '1', 'EN_43'), 79),
    ]
  },
  ('SH', '1', 'EN_45'): {
    'Coordinates': [1166, 2613],
    'Connections': [
      (('SH', '1', 'EN_46'), 68),
      (('SH', '1', '139'), 87),
      (('SH', '1', '136'), 104),
      (('SH', '1', 'EN_44'), 88),
    ]
  },
  ('SH', '1', 'EN_46'): {
    'Coordinates': [1219, 2657],
    'Connections': [
      (('SH', '1', 'AnschlussVerwaltung'), 227),
      (('SH', '1', '138'), 95),
      (('SH', '1', '143'), 106),
      (('SH', '1', '141'), 89),
      (('SH', '1', 'EN_45'), 68),
    ]
  },
  ('SH', '1', 'AnschlussVerwaltung'): {
    'Coordinates': [1385, 2813],
    'Connections': [
      (('SH', '1', 'EN_46'), 227),
    ]
  },
  ('SH', '1', 'EN_47'): {
    'Coordinates': [1166, 937],
    'Connections': [
      (('SH', '1', 'EN_48'), 55),
    ]
  },
  ('SH', '1', 'EN_48'): {
    'Coordinates': [1206, 975],
    'Connections': [
      (('SH', '1', 'TreppehnausNord2.Etage'), 79),
      (('SH', '1', 'EN_47'), 55),
    ]
  },
  ('SH', '1', 'EN_49'): {
    'Coordinates': [1075, 1091],
    'Connections': [
      (('SH', '1', 'EN_11'), 156),
      (('SH', '1', 'TreppehnausNord2.Etage'), 96),
      (('SH', '1', 'EN_50'), 234),
    ]
  },
  ('SH', '1', 'EN_50'): {
    'Coordinates': [1241, 1256],
    'Connections': [
      (('SH', '1', 'EN_51'), 139),
      (('SH', '1', '101'), 78),
      (('SH', '1', 'AnschlussMusischesZentrum'), 264),
      (('SH', '1', 'EN_49'), 234),
      (('SH', '1', '101a'), 160),
    ]
  },
  ('SH', '1', 'EN_51'): {
    'Coordinates': [1144, 1356],
    'Connections': [
      (('SH', '1', 'EN_52'), 87),
      (('SH', '1', '102'), 71),
      (('SH', '1', 'EN_50'), 139),
      (('SH', '1', '101a'), 131),
    ]
  },
  ('SH', '1', 'EN_52'): {
    'Coordinates': [1081, 1416],
    'Connections': [
      (('SH', '1', 'EN_53'), 101),
      (('SH', '1', '103'), 66),
      (('SH', '1', 'EN_51'), 87),
    ]
  },
  ('SH', '1', 'EN_53'): {
    'Coordinates': [1009, 1488],
    'Connections': [
      (('SH', '1', 'EN_54'), 64),
      (('SH', '1', '104'), 62),
      (('SH', '1', 'EN_52'), 101),
    ]
  },
  ('SH', '1', 'EN_54'): {
    'Coordinates': [962, 1532],
    'Connections': [
      (('SH', '1', 'EN_55'), 67),
      (('SH', '1', '105'), 59),
      (('SH', '1', 'EN_53'), 64),
    ]
  },
  ('SH', '1', 'EN_55'): {
    'Coordinates': [912, 1578],
    'Connections': [
      (('SH', '1', 'EN_56'), 59),
      (('SH', '1', '106'), 72),
      (('SH', '1', 'EN_54'), 67),
    ]
  },
  ('SH', '1', 'EN_56'): {
    'Coordinates': [866, 1616],
    'Connections': [
      (('SH', '1', 'EN_57'), 82),
      (('SH', '1', '107'), 77),
      (('SH', '1', 'EN_55'), 59),
    ]
  },
  ('SH', '1', 'EN_57'): {
    'Coordinates': [809, 1675],
    'Connections': [
      (('SH', '1', 'EN_58'), 82),
      (('SH', '1', '108'), 80),
      (('SH', '1', 'EN_56'), 82),
    ]
  },
  ('SH', '1', 'EN_58'): {
    'Coordinates': [753, 1735],
    'Connections': [
      (('SH', '1', 'EN_31'), 172),
      (('SH', '1', '109'), 77),
      (('SH', '1', 'EN_57'), 82),
    ]
  },
  ('SH', '1', 'EN_59'): {
    'Coordinates': [1141, 2451],
    'Connections': [
      (('SH', '1', 'EN_44'), 110),
    ]
  },
};
