const String mensaSampleServerData = '''
{
    "data": {
        "Mo, 10.10.": {
            "Aktion": [
                {
                    "title": "Curry-Hähnchen mit Blumenkohl, Ebly, Spinat & Curry-Joghurt",
                    "price": "5,20 €  / 6,20 €",
                    "allergies": "(G,a,a1,g,l,1,3,5)"
                }
            ],
            "Komponentenessen": [
                {
                    "title": "Kohlroulade mit Kümmelsauce",
                    "price": "2,30 €  / 3,30 €",
                    "allergies": "(S,a,a1,a3,f,i)"
                }
            ],
            "Vegetarische Menükomponente": [
                {
                    "title": "Polenta Knusperschniite mit heller Sauce",
                    "price": "1,90 €  / 2,90 €",
                    "allergies": "(V,a,a1,a5,c,f,g,i)"
                }
            ],
            "Beilage": [
                {
                    "title": "Paprika-Bohnengemüse",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(VG)"
                },
                {
                    "title": "Ratatouille",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(VG)"
                },
                {
                    "title": "Kartoffel Drillinge",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(V,g)"
                },
                {
                    "title": "Couscous",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(VG,a,a1,i)"
                }
            ],
            "Salatbeilage": [
                {
                    "title": "Gurkensalat",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(VG,j)"
                },
                {
                    "title": "Rohkost Italiasalat mit Italia Dressing",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(VG)"
                },
                {
                    "title": "Rahm-Gurkensalat",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(V,c,f,g,j,2)"
                },
                {
                    "title": "Eisberg mit Paprikastreifen und French-Dressing",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(V,a,a3,c,g,i,j,2)"
                }
            ],
            "Dessert": [
                {
                    "title": "Quark mit Früchten",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(V,g)"
                },
                {
                    "title": "Schokopudding mit Vanillesauce",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(V,a,a1,g,1)"
                },
                {
                    "title": "Tiramisu Creme mit Löffelbiskuit",
                    "price": "1,40 €  / 1,80 €",
                    "allergies": "(a,a1,c,f,g)"
                },
                {
                    "title": "Vanillepudding mit Erdbeersauce",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(V,a,a1,g,1,2)"
                }
            ],
            "Döner": [
                {
                    "title": "Halal Hähnchendöner mit Pommes oder Reis und Salat",
                    "price": "3,90 €  / 5,20 €",
                    "allergies": "(G,H,a,a1,g,j,l,1,2,5)"
                }
            ],
            "Falafel Teller": [
                {
                    "title": "Falafel Teller mit Pommes oder Reis und Salat",
                    "price": "3,40 €  / 4,50 €",
                    "allergies": "(VG,a,a1,f,i,j,l,1,2,5)"
                }
            ],
            "Nudeltheke": [
                {
                    "title": "Rinderbolognese, Sojabolognese, Champignonrahmsauce, Käse Sahnesauce",
                    "price": "2,60 €  / 3,90 €",
                    "allergies": "(R,a,a1,a3,f,g,i,1)"
                }
            ],
            "Sprinter": [
                {
                    "title": "Paella",
                    "price": "2,50 €  / 3,50 €",
                    "allergies": "(F,G,b,n,k)"
                }
            ]
        },
        "Di, 11.10.": {
            "Aktion": [
                {
                    "title": "Thunfischwrap mit Weißkäse, Salat und Guacamoledip dazu Wedges",
                    "price": "6,90 €  / 7,90 €",
                    "allergies": "(F,a,a1,c,d,f,g,j,2,3)"
                }
            ],
            "Komponentenessen": [
                {
                    "title": "Rinderhacksteak mit Salsa Sauce",
                    "price": "2,90 €  / 3,90 €",
                    "allergies": "(R,a,a1,c,j,f,i,2,9)"
                }
            ],
            "Vegetarische Menükomponente": [
                {
                    "title": "Valess Schnitzel mit Kräutersauce",
                    "price": "1,80 €  / 2,80 €",
                    "allergies": "(V,a,a1,a4,c,f,i,g)"
                }
            ],
            "Beilage": [
                {
                    "title": "Brokkoli mit Kichererbsen",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(VG,a,a1,f)"
                },
                {
                    "title": "Balkangemüse",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(VG)"
                },
                {
                    "title": "Kartoffelpüree",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(V,g)"
                },
                {
                    "title": "Couscous",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(VG,a,a1,i)"
                }
            ],
            "Salatbeilage": [
                {
                    "title": "Bohnensalat",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(VG)"
                },
                {
                    "title": "Kappessalat mit Cocktailtomaten",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(V,c,f,g,i,j,m)"
                },
                {
                    "title": "Blattsalat 'Barcelona' mit French-Dressing",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(V,a,a3,c,g,i,j,2,3)"
                },
                {
                    "title": "Salat 'Helgoländer Mix' mit Italia-Dressing",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(VG)"
                }
            ],
            "Dessert": [
                {
                    "title": "Nutellamousse",
                    "price": "1,40 €  / 1,80 €",
                    "allergies": "(V,f,g,h,h2)"
                },
                {
                    "title": "Quark mit Früchten",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(V,g)"
                },
                {
                    "title": "Grießpudding mit Erdbeerpüree",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(V,a,a1,g,1,2)"
                },
                {
                    "title": "Karamellpudding mit Vanillesauce",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(V,f,g,1)"
                }
            ],
            "Döner": [
                {
                    "title": "Halal Hähnchendöner mit Pommes oder Reis und Salat",
                    "price": "3,90 €  / 5,20 €",
                    "allergies": "(G,H,a,a1,g,j,1,2)"
                }
            ],
            "Falafel Teller": [
                {
                    "title": "Falafel Teller mit Pommes oder Reis und Salat",
                    "price": "3,40 €  / 4,50 €",
                    "allergies": "(VG,a,a1,f,i,j,1,2)"
                }
            ],
            "Nudeltheke": [
                {
                    "title": "Rinderbolognese, Sojabolognese, Champignonrahmsauce, Käse Sahnesauce",
                    "price": "2,60 €  / 3,90 €",
                    "allergies": "(R,a,a1,a3,f,g,i,1)"
                }
            ],
            "Sprinter": [
                {
                    "title": "Spätzle-Spitzkohl Auflauf",
                    "price": "2,50 €  / 3,70 €",
                    "allergies": "(V,a,a1,c,g)"
                }
            ]
        },
        "Mi, 12.10.": {
            "Aktion": [
                {
                    "title": "Krustenbraten mit Mandel-Brokkoli und Kräuterkartoffeln",
                    "price": "4,20 €  / 5,20 €",
                    "allergies": "(S,a,a1,c,g,h,h1,i)"
                }
            ],
            "Study&Fit": [
                {
                    "title": "Steckrüben-Bohnen-Paprika-Curry mit Chilikartoffeln Mousse Kokos",
                    "price": "3,90 €  / 5,50 €",
                    "allergies": "(V,f,g,i,k)"
                }
            ],
            "Komponentenessen": [
                {
                    "title": "Putenschnitzel mit Estragon-Waldpilzsauce",
                    "price": "2,90 €  / 3,90 €",
                    "allergies": "(G,a,a1,a3,f,g,i)"
                }
            ],
            "Vegetarische Menükomponente": [
                {
                    "title": "Karotten-Röstling mit Schnittlauchsauce",
                    "price": "1,80 €  / 2,80 €",
                    "allergies": "(V,a,a1,a4,c,f)"
                }
            ],
            "Beilage": [
                {
                    "title": "Kaisergemüse",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(VG)"
                },
                {
                    "title": "Wirsing in Rahm",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(VG,f)"
                },
                {
                    "title": "Pommes frites",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(VG)"
                },
                {
                    "title": "Zartweizen",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(VG,a,a1)"
                }
            ],
            "Dessert": [
                {
                    "title": "Karamellpudding mit Vanillesauce",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(V,f,g,1)"
                },
                {
                    "title": "Grießpudding mit Erdbeerpüree",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(V,a,a1,g,1,2)"
                },
                {
                    "title": "Quark mit Früchten",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(V,g)"
                },
                {
                    "title": "Nutellamousse",
                    "price": "1,40 €  / 1,80 €",
                    "allergies": "(V,f,g,h,h2)"
                }
            ],
            "Döner": [
                {
                    "title": "Halal Hähnchendöner mit Pommes oder Reis und Salat",
                    "price": "3,90 €  / 5,20 €",
                    "allergies": "(G,H,a,a1,g,j,1,2)"
                }
            ],
            "Falafel Teller": [
                {
                    "title": "Falafel Teller mit Pommes oder Reis und Salat",
                    "price": "3,40 €  / 4,50 €",
                    "allergies": "(VG,a,a1,f,i,j,1,2)"
                }
            ],
            "Nudeltheke": [
                {
                    "title": "Tortellini mit Spinat und Käse gefüllt Rinderbolognese, Sojabolognese, Champignonrahmsauce, Käse Sahnesauce",
                    "price": "2,60 €  / 3,90 €",
                    "allergies": "(R,a,a1,a3,f,g,i,1)"
                }
            ],
            "Sprinter": [
                {
                    "title": "Steckrüben-Bohnen-Paprika-Curry mit Chilikartoffeln",
                    "price": "2,50 €  / 3,70 €",
                    "allergies": "(VG,f,i,k)"
                }
            ]
        },
        "Do, 13.10.": {
            "Aktion": [
                {
                    "title": "Rindergeschnetzeltes mit Kartoffel-Kerbelpüree Möhrenrohkost",
                    "price": "4,50 €  / 5,50 €",
                    "allergies": "(R,a,a1,a3,f,g,i,j,3)"
                }
            ],
            "Study&Fit": [
                {
                    "title": "Hähnchenspieß mit Honig-Senf-Rahmsauce Linsen-Vollkornreis Kidneybohnen-Maissalat Banane",
                    "price": "4,50 €  / 5,70 €",
                    "allergies": "(G,a,a1,a3,f,g,i,j,3)"
                }
            ],
            "Komponentenessen": [
                {
                    "title": "Hähnchenspieß mit Honig-Senf-Rahmsauce",
                    "price": "2,90 €  / 3,90 €",
                    "allergies": "(G,a,a1,a3,f,g,i,j)"
                }
            ],
            "Vegetarische Menükomponente": [
                {
                    "title": "Linsen-Karotte-Maultaschen mit Ziegenkäsesauce",
                    "price": "2,50 €  / 3,50 €",
                    "allergies": "(V,a,a1,c,f,g)"
                }
            ],
            "Beilage": [
                {
                    "title": "Karottenmix 'Rustica'",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(VG)"
                },
                {
                    "title": "Zucchinigemüse",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(VG)"
                },
                {
                    "title": "Linsen-Vollkornreis",
                    "price": "€",
                    "allergies": "(VG)"
                },
                {
                    "title": "Spätzle",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(V,a,a1,c,g,1)"
                }
            ],
            "Salatbeilage": [
                {
                    "title": "Kidneybohnen-Maissalat",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(VG,3)"
                }
            ],
            "Dessert": [
                {
                    "title": "Nutellamousse",
                    "price": "1,40 €  / 1,80 €",
                    "allergies": "(V,f,g,h,h2)"
                },
                {
                    "title": "Quark mit Früchten",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(V,g)"
                },
                {
                    "title": "Schokopudding mit Vanillesauce",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(V,a,a1,g,1)"
                },
                {
                    "title": "Karamellpudding mit Vanillesauce",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(V,f,g,1)"
                }
            ],
            "Döner": [
                {
                    "title": "Halal Hähnchendöner mit Pommes oder Reis und Salat",
                    "price": "3,90 €  / 5,20 €",
                    "allergies": "(G,H,a,a1,g,j,1,2)"
                }
            ],
            "Falafel Teller": [
                {
                    "title": "Falafel Teller mit Pommes oder Reis und Salat",
                    "price": "3,40 €  / 4,50 €",
                    "allergies": "(VG,a,a1,f,i,j,1,2)"
                }
            ],
            "Nudeltheke": [
                {
                    "title": "Tortellini mit Spinat und Käse gefüllt Rinderbolognese, Sojabolognese, Champignonrahmsauce, Käse Sahnesauce",
                    "price": "2,60 €  / 3,90 €",
                    "allergies": "(R,a,a1,a3,f,g,i,1)"
                }
            ],
            "Sprinter": [
                {
                    "title": "Brötchen Chili sin Carne",
                    "price": "2,50 €  / 3,70 €",
                    "allergies": "(VG,a,a1,a3,f,2,3)"
                }
            ]
        },
        "Fr, 14.10.": {
            "Aktion": [
                {
                    "title": "Burrito mit Salsa Dip",
                    "price": "4,20 €  / 5,20 €",
                    "allergies": "(R,a,a1,g,1,3)"
                }
            ],
            "Study&Fit": [
                {
                    "title": "Pflaumen Lassi Paniertes Seelachsfilet mit Paprikasauce Pilz-Kürbisgemüse Petersilienkartoffeln",
                    "price": "4,60 €  / 6,00 €",
                    "allergies": "(F,a,a1,d,g,2,9)"
                }
            ],
            "Komponentenessen": [
                {
                    "title": "Paniertes Seelachsfilet mit Paprikasauce",
                    "price": "2,60 €  / 3,60 €",
                    "allergies": "(F,a,a1,d,2,9)"
                }
            ],
            "Vegetarische Menükomponente": [
                {
                    "title": "Vegane Currywurst",
                    "price": "2,50 €  / 3,50 €",
                    "allergies": "(VG,f,i,2,9)"
                }
            ],
            "Beilage": [
                {
                    "title": "Pilz-Kürbisgemüse",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(VG)"
                },
                {
                    "title": "Spinat mit Hirtenkäse und Sonnenblumenkernen",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(V,g)"
                },
                {
                    "title": "Petersilienkartoffeln",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(VG)"
                },
                {
                    "title": "Kartoffeltwister",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(VG,a,a1)"
                }
            ],
            "Dessert": [
                {
                    "title": "Nutellamousse",
                    "price": "1,40 €  / 1,80 €",
                    "allergies": "(V,f,g,h,h2)"
                },
                {
                    "title": "Quark mit Früchten",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(V,g)"
                },
                {
                    "title": "Schokopudding mit Vanillesauce",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(V,a,a1,g,1)"
                },
                {
                    "title": "Karamellpudding mit Vanillesauce",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(V,f,g,1)"
                }
            ],
            "Döner": [
                {
                    "title": "Halal Hähnchendöner mit Pommes oder Reis und Salat",
                    "price": "3,90 €  / 5,20 €",
                    "allergies": "(G,H,a,a1,g,j,1,2)"
                }
            ],
            "Falafel Teller": [
                {
                    "title": "Falafel Teller mit Pommes oder Reis und Salat",
                    "price": "3,40 €  / 4,50 €",
                    "allergies": "(VG,a,a1,f,i,j,1,2)"
                }
            ],
            "Nudeltheke": [
                {
                    "title": "Tortellini mit Spinat und Käse gefüllt Rinderbolognese, Sojabolognese, Champignonrahmsauce, Käse Sahnesauce",
                    "price": "2,60 €  / 3,90 €",
                    "allergies": "(R,a,a1,a3,f,g,i,1)"
                }
            ],
            "Sprinter": [
                {
                    "title": "Kaiserschmarren mit Zimt & Zucker und Apfelkompott",
                    "price": "2,20 €  / 3,30 €",
                    "allergies": "(V,a,a1,c,g)"
                }
            ]
        },
        "Mo, 17.10.": {
            "Aktion": [
                {
                    "title": "Gedöppte Dicke Bohnen mit Speck, Mettwurst und Kartöffelkes",
                    "price": "4,60 €  / 5,60 €",
                    "allergies": "(S,g,i,j,2,3,4)"
                }
            ],
            "Study&Fit": [
                {
                    "title": "Putensteak mit Kürbissauce Karottengemüse mit Petersilienpest Vollkornreis",
                    "price": "4,90 €  / 6,30 €",
                    "allergies": "(G,c,f,g,h,h3)"
                }
            ],
            "Komponentenessen": [
                {
                    "title": "Putensteak mit Kürbissauce",
                    "price": "2,90 €  / 3,90 €",
                    "allergies": "(G,f)"
                }
            ],
            "Vegetarische Menükomponente": [
                {
                    "title": "Semmelknödel mit Waldpilzragout",
                    "price": "2,20 €  / 3,20 €",
                    "allergies": "(V,a,a1,c,f)"
                }
            ],
            "Beilage": [
                {
                    "title": "Spitzkohl",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(VG)"
                },
                {
                    "title": "Karottengemüse mit Petersilienpest",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(V,c,g,h,h3)"
                },
                {
                    "title": "Vollkornreis",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(VG)"
                },
                {
                    "title": "Kartoffelgratin",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(V,g,2)"
                }
            ],
            "Dessert": [
                {
                    "title": "Nutellamousse",
                    "price": "1,40 €  / 1,80 €",
                    "allergies": "(V,f,g,h,h2)"
                },
                {
                    "title": "Grießpudding mit Erdbeerpüree",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(V,a,a1,g,1,2)"
                },
                {
                    "title": "Schokopudding mit Vanillesauce",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(V,a,a1,g,1)"
                },
                {
                    "title": "Karamellpudding mit Vanillesauce",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(V,f,g,1)"
                }
            ],
            "Döner": [
                {
                    "title": "Halal Hähnchendöner mit Pommes oder Reis und Salat",
                    "price": "3,90 €  / 5,20 €",
                    "allergies": "(G,H,a,a1,g,j,1,2)"
                }
            ],
            "Falafel Teller": [
                {
                    "title": "Falafel Teller mit Pommes oder Reis und Salat",
                    "price": "3,40 €  / 4,50 €",
                    "allergies": "(VG,a,a1,f,i,j,1,2)"
                }
            ],
            "Nudeltheke": [
                {
                    "title": "Rinderbolognese Käse Sahnesauce, Champignonrahmsauce, Sojabolognese, Tortellini gelb gefüllt mit Käse/Spinat",
                    "price": "2,60 €  / 3,90 €",
                    "allergies": "(R,a,a1,a3,f,g,i,1)"
                }
            ],
            "Sprinter": [
                {
                    "title": "Piroggen mit Schmorzwiebeln",
                    "price": "2,20 €  / 3,30 €",
                    "allergies": "(V,a,a1,c,g,1)"
                }
            ]
        },
        "Di, 18.10.": {
            "Aktion": [
                {
                    "title": "Couscous mit Lammhaxe, Zucchini und Paprika",
                    "price": "3,50 €  / 4,50 €",
                    "allergies": "(L,a,a1,g)"
                }
            ],
            "Study&Fit": [
                {
                    "title": "Backofengemüse [Paprika, Zucchini] mit Kräuter-Tomatensauce und Rosmarin-Kartoffelecken Quark mit Beeren",
                    "price": "2,50 €  / 3,70 €",
                    "allergies": "(V,a,a1,c,g,i,1)"
                }
            ],
            "Komponentenessen": [
                {
                    "title": "Cevapcici vom Rind mit Tzatziki",
                    "price": "3,00 €  / 4,00 €",
                    "allergies": "(R,a,a1,c,g,j)"
                }
            ],
            "Vegetarische Menükomponente": [
                {
                    "title": "Kürbis Chiasamenbratling mit Basilikumsauce",
                    "price": "2,00 €  / 3,00 €",
                    "allergies": "(VG,f)"
                }
            ],
            "Beilage": [
                {
                    "title": "Balkan-Gemüse",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(VG,i)"
                },
                {
                    "title": "Gerösteter Brokkoli mit Bröseln",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(VG,a,a1,a3,f,1)"
                },
                {
                    "title": "Kartoffelwedges",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(VG,a,a1)"
                },
                {
                    "title": "Reisnudeln",
                    "price": "0,80 €  / 0,90 €",
                    "allergies": "(VG,a,a1)"
                }
            ],
            "Dessert": [
                {
                    "title": "Nutellamousse",
                    "price": "1,40 €  / 1,80 €",
                    "allergies": "(V,f,g,h,h2)"
                },
                {
                    "title": "Grießpudding mit Erdbeerpüree",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(V,a,a1,g,1,2)"
                },
                {
                    "title": "Schokopudding mit Vanillesauce",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(V,a,a1,g,1)"
                },
                {
                    "title": "Karamellpudding mit Vanillesauce",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(V,f,g,1)"
                }
            ],
            "Döner": [
                {
                    "title": "Halal Hähnchendöner mit Pommes oder Reis und Salat",
                    "price": "3,90 €  / 5,20 €",
                    "allergies": "(G,H,a,a1,g,j,1,2)"
                }
            ],
            "Falafel Teller": [
                {
                    "title": "Falafel Teller mit Pommes oder Reis und Salat",
                    "price": "3,40 €  / 4,50 €",
                    "allergies": "(VG,a,a1,f,i,j,1,2)"
                }
            ],
            "Nudeltheke": [
                {
                    "title": "Rinderbolognese Käse Sahnesauce, Champignonrahmsauce, Sojabolognese, Tortellini gelb gefüllt mit Käse/Spinat",
                    "price": "2,60 €  / 3,90 €",
                    "allergies": "(R,a,a1,a3,f,g,i,1)"
                }
            ],
            "Sprinter": [
                {
                    "title": "Backofengemüse [Paprika, Zucchini] mit Kräuter-Tomatensauce und Rosmarin-Kartoffelecken",
                    "price": "2,50 €  / 3,70 €",
                    "allergies": "(V,a,a1,c,g,i,1)"
                }
            ]
        },
        "Mi, 19.10.": {
            "Study&Fit": [
                {
                    "title": "Teriyaki Hähnchenbrust mit Kokossauce Wokgemüse Kichererbsenreis Apfel",
                    "price": "5,44 €  / 6,90 €",
                    "allergies": "(A,G,a,a1,f,i,k,l,5)"
                }
            ],
            "Komponentenessen": [
                {
                    "title": "Teriyaki Hähnchenbrust mit Kokossauce",
                    "price": "2,90 €  / 3,90 €",
                    "allergies": "(A,G,a,a1,f,i,k,l,5)"
                }
            ],
            "Vegetarische Menükomponente": [
                {
                    "title": "Pocket Ziegenkäse-Mango mit Currysauce",
                    "price": "2,60 €  / 3,60 €",
                    "allergies": "(V,a,a1,a5,c,f,g,2)"
                }
            ],
            "Beilage": [
                {
                    "title": "Blumenkohl, Romanesco und Brokkoli",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(VG)"
                },
                {
                    "title": "Wokgemüse",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(VG,a,a1,f,k)"
                },
                {
                    "title": "Risolée-Kartoffeln",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(VG)"
                },
                {
                    "title": "Kichererbsenreis",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(VG)"
                }
            ],
            "Dessert": [
                {
                    "title": "Nutellamousse",
                    "price": "1,40 €  / 1,80 €",
                    "allergies": "(V,f,g,h,h2)"
                },
                {
                    "title": "Grießpudding mit Erdbeerpüree",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(V,a,a1,g,1,2)"
                },
                {
                    "title": "Schokopudding mit Vanillesauce",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(V,a,a1,g,1)"
                },
                {
                    "title": "Karamellpudding mit Vanillesauce",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(V,f,g,1)"
                }
            ],
            "Döner": [
                {
                    "title": "Halal Hähnchendöner mit Pommes oder Reis und Salat",
                    "price": "3,90 €  / 5,20 €",
                    "allergies": "(G,H,a,a1,g,j,1,2)"
                }
            ],
            "Falafel Teller": [
                {
                    "title": "Falafel Teller mit Pommes oder Reis und Salat",
                    "price": "3,40 €  / 4,50 €",
                    "allergies": "(VG,a,a1,f,i,j,1,2)"
                }
            ],
            "Nudeltheke": [
                {
                    "title": "Rinderbolognese Käse Sahnesauce, Champignonrahmsauce, Sojabolognese, Tortellini gelb gefüllt mit Käse/Spinat",
                    "price": "2,60 €  / 3,90 €",
                    "allergies": "(R,a,a1,a3,f,g,i,1)"
                }
            ],
            "Sprinter": [
                {
                    "title": "Steckrübeneintopf mit veganen Hackbällchen",
                    "price": "2,50 €  / 3,70 €",
                    "allergies": "(VG,a,a1,a3,f)"
                }
            ]
        },
        "Do, 20.10.": {
            "Aktion": [
                {
                    "title": "Hähnchengyros mit Tsatziki, Reis und Krautsalat",
                    "price": "4,20 €  / 5,20 €",
                    "allergies": "(G,g,j)"
                }
            ],
            "Study&Fit": [
                {
                    "title": "Smoothie Apfel-Karotte-Orange Schweinerückensteak mit Tomaten-Basilikumsauce  Vollkornnudeln Kopfsalat mit Italia Dressing",
                    "price": "5,00 €  / 6,30 €",
                    "allergies": "(S,a,a1,i,3)"
                }
            ],
            "Komponentenessen": [
                {
                    "title": "Schweinerückensteak mit Tomaten-Basilikumsauce",
                    "price": "2,10 €  / 3,10 €",
                    "allergies": "(S,i)"
                }
            ],
            "Vegetarische Menükomponente": [
                {
                    "title": "Vegetarische Königsberger Klopse",
                    "price": "2,00 €  / 3,00 €",
                    "allergies": "(V,a,a1,c,f,g,i)"
                }
            ],
            "Beilage": [
                {
                    "title": "Zucchinigemüse",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(VG)"
                },
                {
                    "title": "Blumenkohl in Rahm",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(VG,a,a1,a3,f,i)"
                },
                {
                    "title": "Vollkornnudeln",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(VG,a,a1)"
                },
                {
                    "title": "Zartweizen mit Paprik",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(VG,a,a1,2)"
                }
            ],
            "Salatbeilage": [
                {
                    "title": "Kopfsalat mit Italia Dressing",
                    "price": "0,80 €  / 0,90 €",
                    "allergies": "(VG)"
                }
            ],
            "Dessert": [
                {
                    "title": "Nutellamousse",
                    "price": "1,40 €  / 1,80 €",
                    "allergies": "(V,f,g,h,h2)"
                },
                {
                    "title": "Grießpudding mit Erdbeerpüree",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(V,a,a1,g,1,2)"
                },
                {
                    "title": "Schokopudding mit Vanillesauce",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(V,a,a1,g,1)"
                },
                {
                    "title": "Karamellpudding mit Vanillesauce",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(V,f,g,1)"
                }
            ],
            "Döner": [
                {
                    "title": "Halal Hähnchendöner mit Pommes oder Reis und Salat",
                    "price": "3,90 €  / 5,20 €",
                    "allergies": "(G,H,a,a1,g,j,1,2)"
                }
            ],
            "Falafel Teller": [
                {
                    "title": "Falafel Teller mit Pommes oder Reis und Salat",
                    "price": "3,40 €  / 4,50 €",
                    "allergies": "(VG,a,a1,f,i,j,1,2)"
                }
            ],
            "Nudeltheke": [
                {
                    "title": "Rinderbolognese Käse Sahnesauce, Champignonrahmsauce, Sojabolognese, Tortellini gelb gefüllt mit Käse/Spinat",
                    "price": "2,60 €  / 3,90 €",
                    "allergies": "(R,a,a1,a3,f,g,i,1)"
                }
            ],
            "Sprinter": [
                {
                    "title": "Bulgur Kürbispfanne mit Minz Dip",
                    "price": "2,50 €  / 3,70 €",
                    "allergies": "(VG,a,a1,f,2,3)"
                }
            ]
        },
        "Fr, 21.10.": {
            "Aktion": [
                {
                    "title": "Lahmacun mit knackigem Salat und Tzatziki",
                    "price": "4,20 €  / 5,20 €",
                    "allergies": "(VG,a,a1,f,3)"
                }
            ],
            "Study&Fit": [
                {
                    "title": "Regenbogenforelle mit Dillrahmsauce  Salzkartoffeln Gurkensalat mit Cocktailtomaten",
                    "price": "5,20 €  / 6,60 €",
                    "allergies": "(F,VG,f,j)"
                }
            ],
            "Komponentenessen": [
                {
                    "title": "Regenbogenforelle mit Dillrahmsauce",
                    "price": "3,20 €  / 4,20 €",
                    "allergies": "(F,VG,f)"
                }
            ],
            "Vegetarische Menükomponente": [
                {
                    "title": "Ofenkürbis mit Kartoffeln dazu Harissa Dip",
                    "price": "2,00 €  / 3,00 €",
                    "allergies": "(VG,f,2,3)"
                }
            ],
            "Beilage": [
                {
                    "title": "Gurkengemüse",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(VG)"
                },
                {
                    "title": "Buntes Gemüse",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(VG)"
                },
                {
                    "title": "Salzkartoffeln",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(VG)"
                },
                {
                    "title": "Kräuterreis",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(VG)"
                }
            ],
            "Salatbeilage": [
                {
                    "title": "Gurkensalat mit Cocktailtomaten",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(VG,j)"
                }
            ],
            "Dessert": [
                {
                    "title": "Nutellamousse",
                    "price": "1,40 €  / 1,80 €",
                    "allergies": "(V,f,g,h,h2)"
                },
                {
                    "title": "Grießpudding mit Erdbeerpüree",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(V,a,a1,g,1,2)"
                },
                {
                    "title": "Schokopudding mit Vanillesauce",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(V,a,a1,g,1)"
                },
                {
                    "title": "Karamellpudding mit Vanillesauce",
                    "price": "1,00 €  / 1,20 €",
                    "allergies": "(V,f,g,1)"
                }
            ],
            "Döner": [
                {
                    "title": "Halal Hähnchendöner mit Pommes oder Reis und Salat",
                    "price": "3,90 €  / 5,20 €",
                    "allergies": "(G,H,a,a1,g,j,1,2)"
                }
            ],
            "Falafel Teller": [
                {
                    "title": "Falafel Teller mit Pommes oder Reis und Salat",
                    "price": "3,40 €  / 4,50 €",
                    "allergies": "(VG,a,a1,f,i,j,1,2)"
                }
            ],
            "Nudeltheke": [
                {
                    "title": "Rinderbolognese Käse Sahnesauce, Champignonrahmsauce, Sojabolognese, Tortellini gelb gefüllt mit Käse/Spinat",
                    "price": "2,60 €  / 3,90 €",
                    "allergies": "(R,a,a1,a3,f,g,i,1)"
                }
            ],
            "Sprinter": [
                {
                    "title": "Grüne Bandnudeln  mit heller Knoblauch- und Austernpilzsauce",
                    "price": "2,20 €  / 3,30 €",
                    "allergies": "(VG,a,a1,f)"
                }
            ]
        },
        "id": "6345d7685610506b083b6572"
    }
}
''';
