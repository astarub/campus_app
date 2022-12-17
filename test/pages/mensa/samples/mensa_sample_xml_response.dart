import 'package:xml/xml.dart';

final XmlDocument mensaSampleTestDataXML = XmlDocument.parse('''
<?xml version="1.0" encoding="utf-8"?>
<NewDataSet>
  <Header>
    <Client Version="16.10" />
    <Date From="2022-12-16" To="2023-01-01" CalendarWeek="52" />
    <ServiceUnit Name="Mensa/RUB Küche (ab 1.4.18 Mensa Verkauf)" CostCenterNr="16" />
    <Print Date="2022-12-16" Time="11:34" />
    <RDE Name="Speiseplan (XML)" FormNumber="1" />
    <BillOfFareName>Menüplan</BillOfFareName>
    <Kitchen ExternalName="" PersonInCharge="" Phone="" EMail="">
      <Address><![CDATA[Mensa RUB
        Küche
        Universitätsstraße 150
        44801 Bochum]]>
      </Address>
    </Kitchen>
    <SCF_TIMESTAMP><![CDATA[12/16/2022 11:34:05]]></SCF_TIMESTAMP>
    <Variable1>
    </Variable1>
    <Variable2>
    </Variable2>
    <Variable3>
    </Variable3>
    <Variable4>
    </Variable4>
    <Variable5>
    </Variable5>
  </Header>
  <WeekDays>
    <WeekDay Day="Montag" Date="2022-12-19" Mealtime="Mittagsverpflegung">
      <MenuLine Name="Beilagen RUB" ShortName="B3">
        <InfoText>
        </InfoText>
        <SetMenu IdentNr="12022121900192" ItemID="21332" Name="Beilagen RUB" DisplayName="" IndividualName="" SalesPrice="0.00" SalesPrice1="0.00" SalesPrice2="0.00" TrafficLight="0" SalesUnit="Stück" IsComponentOriented="true">
          <SetMenuDetails>
            <GastDesc value="Paprikagemüse&#xA;Leipziger Allerlei&#xA;Couscous&#xA;Bandnudeln">
              <GastDescTranslation lang="en-gb" value="Paprikagemüse (VG) (RUB)&#xA;Leipziger Allerlei (VG) (RUB)&#xA;Couscous 200 g (VG) (RUB)&#xA;Bandnudeln 180 g (VG) (RUB)" />
            </GastDesc>
            <ProductInfo>
              <Product name="" PLU="" ProductPrice="0.00" ProductPrice2="0.00" ProductPrice3="0.00" ProductPrice4="0.00" ProductPrice5="0.00" ProductPrice6="0.00" ProductPrice7="0.00" ProductPrice8="0.00" ProductPrice9="0.00" ProductPrice10="0.00" />
            </ProductInfo>
            <AdditiveInfo>
              <AdditiveGroup name="Allergene" code="Al">
                <Additive name="Gluten" shortName="GLU" digitalSignageCode="GLU" />
                <Additive name="Sellerie" shortName="i" digitalSignageCode="i" />
                <Additive name="Weizen" shortName="a1" digitalSignageCode="a1" />
              </AdditiveGroup>
              <AdditiveGroup name="Information" code="Info">
                <Additive name="ohne Kennzeichnung" shortName="(-)" digitalSignageCode="(-)" />
              </AdditiveGroup>
            </AdditiveInfo>
            <FoodLabelInfo>
              <FoodLabelGroup name="Allergene" code="Al">
                <Allergens>
                  <FoodLabel name="Gluten" code="GLU" digitalSignageCode="GLU" />
                  <FoodLabel name="Sellerie" code="i" digitalSignageCode="i" />
                  <FoodLabel name="Weizen" code="a1" digitalSignageCode="a1" />
                </Allergens>
              </FoodLabelGroup>
              <FoodLabelGroup name="Information" code="Info">
                <Information>
                  <FoodLabel name="ohne Kennzeichnung" code="(-)" digitalSignageCode="(-)" />
                </Information>
              </FoodLabelGroup>
            </FoodLabelInfo>
          </SetMenuDetails>
          <Component IdentNr="32022121900192" RecipeID="2296" Name="Paprikagemüse" SalesPrice="0.00" SalesPrice1="0.00" SalesPrice2="0.00" TrafficLight="0" SalesUnit="Portion" CompGroup="Gemüsebeilagen" CompType="2" CompID="2296" Weight="0.150" NutriScore="" ServingTool="" Seasonality="0">
            <ComponentDetails>
              <GastDesc value="Paprikagemüse" />
              <ProductInfo>
                <Product name="Paprikagemüse (VG)" PLU="40257" ProductPrice="1.00" ProductPrice2="1.00" ProductPrice3="1.20" ProductPrice4="1.20" ProductPrice5="1.20" ProductPrice6="1.20" ProductPrice7="0.00" ProductPrice8="0.00" ProductPrice9="0.00" ProductPrice10="0.00" />
              </ProductInfo>
              <NutritionInfo>
                <Nutrient name="Kilokalorien" shortName="kcal" unit="kcal" digitalSignageCode="kcal" value="40.68" value100="27.12" />
                <Nutrient name="Kilojoule" shortName="kJ" unit="kJ" digitalSignageCode="kJ" value="168.65" value100="112.43" />
                <Nutrient name="Fett" shortName="F" unit="g" digitalSignageCode="F" value="1.32" value100="0.88" />
                <Nutrient name="gesättigte Fettsäuren" shortName="ges FS " unit="g" digitalSignageCode="ges FS " value="0.16" value100="0.11" />
                <Nutrient name="Kohlenhydrate" shortName="KH" unit="g" digitalSignageCode="KH" value="5.06" value100="3.37" />
                <Nutrient name="Zucker" shortName="Zucker" unit="g" digitalSignageCode="Zucker" value="4.11" value100="2.74" />
                <Nutrient name="Eiweiss" shortName="EW" unit="g" digitalSignageCode="EW" value="1.78" value100="1.18" />
                <Nutrient name="Salz" shortName="Salz" unit="g" digitalSignageCode="Salz" value="0.22" value100="0.15" />
                <Nutrient name="Ballaststoffe" shortName="BST" unit="g" digitalSignageCode="BST" value="2.80" value100="1.87" />
              </NutritionInfo>
              <DietaryValues Exchanges="0.3" Fuids="" />
              <AdditiveInfo>
                <AdditiveGroup name="Information" code="Info">
                  <Additive name="ohne Kennzeichnung" shortName="(-)" digitalSignageCode="(-)" />
                </AdditiveGroup>
              </AdditiveInfo>
              <FoodLabelInfo>
                <FoodLabelGroup name="Information" code="Info">
                  <Information>
                    <FoodLabel name="ohne Kennzeichnung" code="(-)" digitalSignageCode="(-)" />
                  </Information>
                </FoodLabelGroup>
              </FoodLabelInfo>
              <ListOfIngredients value="" />
              <CategoryInfo />
            </ComponentDetails>
          </Component>
          <Component IdentNr="32022121900192" RecipeID="2291" Name="Leipziger Allerlei" SalesPrice="0.00" SalesPrice1="0.00" SalesPrice2="0.00" TrafficLight="0" SalesUnit="Portion" CompGroup="Gemüsebeilagen" CompType="2" CompID="2291" Weight="0.150" NutriScore="" ServingTool="" Seasonality="0">
            <ComponentDetails>
              <GastDesc value="Leipziger Allerlei" />
              <ProductInfo>
                <Product name="Leipziger Allerlei (VG) (RUB)" PLU="180044" ProductPrice="1.00" ProductPrice2="1.00" ProductPrice3="1.20" ProductPrice4="1.20" ProductPrice5="1.20" ProductPrice6="0.30" ProductPrice7="0.00" ProductPrice8="0.00" ProductPrice9="0.00" ProductPrice10="0.00" />
              </ProductInfo>
              <NutritionInfo>
                <Nutrient name="Kilokalorien" shortName="kcal" unit="kcal" digitalSignageCode="kcal" value="69.43" value100="46.29" />
                <Nutrient name="Kilojoule" shortName="kJ" unit="kJ" digitalSignageCode="kJ" value="291.31" value100="194.21" />
                <Nutrient name="Fett" shortName="F" unit="g" digitalSignageCode="F" value="0.62" value100="0.41" />
                <Nutrient name="gesättigte Fettsäuren" shortName="ges FS " unit="g" digitalSignageCode="ges FS " value="0.16" value100="0.11" />
                <Nutrient name="Kohlenhydrate" shortName="KH" unit="g" digitalSignageCode="KH" value="9.20" value100="6.14" />
                <Nutrient name="Zucker" shortName="Zucker" unit="g" digitalSignageCode="Zucker" value="5.44" value100="3.63" />
                <Nutrient name="Eiweiss" shortName="EW" unit="g" digitalSignageCode="EW" value="4.06" value100="2.71" />
                <Nutrient name="Salz" shortName="Salz" unit="g" digitalSignageCode="Salz" value="0.42" value100="0.28" />
                <Nutrient name="Ballaststoffe" shortName="BST" unit="g" digitalSignageCode="BST" value="0.00" value100="0.00" />
              </NutritionInfo>
              <DietaryValues Exchanges="0.6" Fuids="" />
              <AdditiveInfo>
                <AdditiveGroup name="Information" code="Info">
                  <Additive name="ohne Kennzeichnung" shortName="(-)" digitalSignageCode="(-)" />
                </AdditiveGroup>
              </AdditiveInfo>
              <FoodLabelInfo>
                <FoodLabelGroup name="Information" code="Info">
                  <Information>
                    <FoodLabel name="ohne Kennzeichnung" code="(-)" digitalSignageCode="(-)" />
                  </Information>
                </FoodLabelGroup>
              </FoodLabelInfo>
              <ListOfIngredients value="" />
              <CategoryInfo />
            </ComponentDetails>
          </Component>
          <Component IdentNr="32022121900192" RecipeID="5202" Name="Couscous" SalesPrice="0.00" SalesPrice1="0.00" SalesPrice2="0.00" TrafficLight="0" SalesUnit="Portion" CompGroup="Stärkebeilagen" CompType="2" CompID="5202" Weight="0.200" NutriScore="" ServingTool="" Seasonality="0">
            <ComponentDetails>
              <GastDesc value="Couscous" />
              <ProductInfo>
                <Product name="Couscous" PLU="40290" ProductPrice="1.00" ProductPrice2="1.00" ProductPrice3="1.20" ProductPrice4="1.20" ProductPrice5="1.20" ProductPrice6="0.30" ProductPrice7="1.13" ProductPrice8="0.00" ProductPrice9="0.00" ProductPrice10="0.00" />
              </ProductInfo>
              <NutritionInfo>
                <Nutrient name="Kilokalorien" shortName="kcal" unit="kcal" digitalSignageCode="kcal" value="293.09" value100="146.54" />
                <Nutrient name="Kilojoule" shortName="kJ" unit="kJ" digitalSignageCode="kJ" value="1236.50" value100="618.25" />
                <Nutrient name="Fett" shortName="F" unit="g" digitalSignageCode="F" value="4.16" value100="2.08" />
                <Nutrient name="gesättigte Fettsäuren" shortName="ges FS " unit="g" digitalSignageCode="ges FS " value="0.53" value100="0.27" />
                <Nutrient name="Kohlenhydrate" shortName="KH" unit="g" digitalSignageCode="KH" value="51.47" value100="25.74" />
                <Nutrient name="Zucker" shortName="Zucker" unit="g" digitalSignageCode="Zucker" value="4.47" value100="2.23" />
                <Nutrient name="Eiweiss" shortName="EW" unit="g" digitalSignageCode="EW" value="8.19" value100="4.10" />
                <Nutrient name="Salz" shortName="Salz" unit="g" digitalSignageCode="Salz" value="1.35" value100="0.67" />
                <Nutrient name="Ballaststoffe" shortName="BST" unit="g" digitalSignageCode="BST" value="0.02" value100="0.01" />
              </NutritionInfo>
              <DietaryValues Exchanges="3.4" Fuids="" />
              <AdditiveInfo>
                <AdditiveGroup name="Allergene" code="Al">
                  <Additive name="Gluten" shortName="GLU" digitalSignageCode="GLU" />
                  <Additive name="Sellerie" shortName="i" digitalSignageCode="i" />
                  <Additive name="Weizen" shortName="a1" digitalSignageCode="a1" />
                </AdditiveGroup>
                <AdditiveGroup name="Information" code="Info">
                  <Additive name="ohne Kennzeichnung" shortName="(-)" digitalSignageCode="(-)" />
                </AdditiveGroup>
              </AdditiveInfo>
              <FoodLabelInfo>
                <FoodLabelGroup name="Allergene" code="Al">
                  <Allergens>
                    <FoodLabel name="Gluten" code="GLU" digitalSignageCode="GLU" />
                    <FoodLabel name="Sellerie" code="i" digitalSignageCode="i" />
                    <FoodLabel name="Weizen" code="a1" digitalSignageCode="a1" />
                  </Allergens>
                </FoodLabelGroup>
                <FoodLabelGroup name="Information" code="Info">
                  <Information>
                    <FoodLabel name="ohne Kennzeichnung" code="(-)" digitalSignageCode="(-)" />
                  </Information>
                </FoodLabelGroup>
              </FoodLabelInfo>
              <ListOfIngredients value="" />
              <CategoryInfo>
                <CategoryGroup name="" categoryNo="2">
                  <Category name="WHS" />
                </CategoryGroup>
              </CategoryInfo>
            </ComponentDetails>
          </Component>
          <Component IdentNr="32022121900192" RecipeID="7696" Name="Bandnudeln" SalesPrice="0.00" SalesPrice1="0.00" SalesPrice2="0.00" TrafficLight="0" SalesUnit="Portion" CompGroup="Stärkebeilagen" CompType="2" CompID="7696" Weight="0.180" NutriScore="" ServingTool="" Seasonality="0">
            <ComponentDetails>
              <GastDesc value="Bandnudeln" />
              <ProductInfo>
                <Product name="Bandnudeln 180 g (VG) (RUB)" PLU="40555" ProductPrice="1.00" ProductPrice2="1.00" ProductPrice3="1.20" ProductPrice4="1.20" ProductPrice5="1.20" ProductPrice6="0.30" ProductPrice7="0.00" ProductPrice8="0.00" ProductPrice9="0.00" ProductPrice10="0.00" />
              </ProductInfo>
              <NutritionInfo>
                <Nutrient name="Kilokalorien" shortName="kcal" unit="kcal" digitalSignageCode="kcal" value="318.51" value100="176.95" />
                <Nutrient name="Kilojoule" shortName="kJ" unit="kJ" digitalSignageCode="kJ" value="1350.87" value100="750.49" />
                <Nutrient name="Fett" shortName="F" unit="g" digitalSignageCode="F" value="1.15" value100="0.64" />
                <Nutrient name="gesättigte Fettsäuren" shortName="ges FS " unit="g" digitalSignageCode="ges FS " value="0.39" value100="0.22" />
                <Nutrient name="Kohlenhydrate" shortName="KH" unit="g" digitalSignageCode="KH" value="69.37" value100="38.54" />
                <Nutrient name="Zucker" shortName="Zucker" unit="g" digitalSignageCode="Zucker" value="3.20" value100="1.78" />
                <Nutrient name="Eiweiss" shortName="EW" unit="g" digitalSignageCode="EW" value="10.81" value100="6.01" />
                <Nutrient name="Salz" shortName="Salz" unit="g" digitalSignageCode="Salz" value="0.11" value100="0.06" />
                <Nutrient name="Ballaststoffe" shortName="BST" unit="g" digitalSignageCode="BST" value="0.00" value100="0.00" />
              </NutritionInfo>
              <DietaryValues Exchanges="4.6" Fuids="" />
              <AdditiveInfo>
                <AdditiveGroup name="Allergene" code="Al">
                  <Additive name="Gluten" shortName="GLU" digitalSignageCode="GLU" />
                  <Additive name="Weizen" shortName="a1" digitalSignageCode="a1" />
                </AdditiveGroup>
                <AdditiveGroup name="Information" code="Info">
                  <Additive name="ohne Kennzeichnung" shortName="(-)" digitalSignageCode="(-)" />
                </AdditiveGroup>
              </AdditiveInfo>
              <FoodLabelInfo>
                <FoodLabelGroup name="Allergene" code="Al">
                  <Allergens>
                    <FoodLabel name="Gluten" code="GLU" digitalSignageCode="GLU" />
                    <FoodLabel name="Weizen" code="a1" digitalSignageCode="a1" />
                  </Allergens>
                </FoodLabelGroup>
                <FoodLabelGroup name="Information" code="Info">
                  <Information>
                    <FoodLabel name="ohne Kennzeichnung" code="(-)" digitalSignageCode="(-)" />
                  </Information>
                </FoodLabelGroup>
              </FoodLabelInfo>
              <ListOfIngredients value="" />
              <CategoryInfo />
            </ComponentDetails>
          </Component>
        </SetMenu>
      </MenuLine>
      <MenuLine Name="Aktionsgericht RUB" ShortName="Action">
        <InfoText>
        </InfoText>
        <SetMenu IdentNr="12022121900286" ItemID="21335" Name="Aktionsgericht RUB" DisplayName="" IndividualName="" SalesPrice="0.00" SalesPrice1="0.00" SalesPrice2="0.00" TrafficLight="0" SalesUnit="Stück" IsComponentOriented="true">
          <SetMenuDetails>
            <GastDesc value="Schweinehaxe 180 g (S) (RUB)&#xA;&quot;Bayrisch&quot; Kraut&#xA;Kartoffelklößchen">
              <GastDescTranslation lang="en-gb" value="Schweinehaxe 180 g (S) (RUB)&#xA;&quot;Bayrisch&quot; Kraut&#xA;Kartoffelklößchen 6 x 25 g (V) (RUB)" />
            </GastDesc>
            <ProductInfo>
              <Product name="" PLU="" ProductPrice="0.00" ProductPrice2="0.00" ProductPrice3="0.00" ProductPrice4="0.00" ProductPrice5="0.00" ProductPrice6="0.00" ProductPrice7="0.00" ProductPrice8="0.00" ProductPrice9="0.00" ProductPrice10="0.00" />
            </ProductInfo>
            <AdditiveInfo>
              <AdditiveGroup name="Zusatzstoff" code="Zs">
                <Additive name="mit Konservierungsstoff" shortName="2" digitalSignageCode="2" />
                <Additive name="mit Antioxidationsmittel" shortName="3" digitalSignageCode="3" />
              </AdditiveGroup>
              <AdditiveGroup name="Allergene" code="Al">
                <Additive name="Sojabohnen" shortName="SJB" digitalSignageCode="SJB" />
                <Additive name="Weizen" shortName="a1" digitalSignageCode="a1" />
              </AdditiveGroup>
              <AdditiveGroup name="Information" code="Info">
                <Additive name="mit Schwein" shortName="SCHW" digitalSignageCode="SCHW" />
                <Additive name="ohne Kennzeichnung" shortName="(-)" digitalSignageCode="(-)" />
              </AdditiveGroup>
            </AdditiveInfo>
            <FoodLabelInfo>
              <FoodLabelGroup name="Allergene" code="Al">
                <Allergens>
                  <FoodLabel name="Sojabohnen" code="SJB" digitalSignageCode="SJB" />
                  <FoodLabel name="Weizen" code="a1" digitalSignageCode="a1" />
                </Allergens>
              </FoodLabelGroup>
              <FoodLabelGroup name="Information" code="Info">
                <Information>
                  <FoodLabel name="mit Schwein" code="SCHW" digitalSignageCode="SCHW" />
                  <FoodLabel name="ohne Kennzeichnung" code="(-)" digitalSignageCode="(-)" />
                </Information>
              </FoodLabelGroup>
              <FoodLabelGroup name="Zusatzstoff" code="Zs">
                <Additives>
                  <FoodLabel name="mit Konservierungsstoff" code="2" digitalSignageCode="2" />
                  <FoodLabel name="mit Antioxidationsmittel" code="3" digitalSignageCode="3" />
                </Additives>
              </FoodLabelGroup>
            </FoodLabelInfo>
          </SetMenuDetails>
          <Component IdentNr="32022121900286" RecipeID="8749" Name="Schweinehaxe 180 g (S) (RUB)" SalesPrice="0.00" SalesPrice1="0.00" SalesPrice2="0.00" TrafficLight="0" SalesUnit="Portion" CompGroup="Hauptgerichte Schwein" CompType="2" CompID="8749" Weight="0.180" NutriScore="" ServingTool="" Seasonality="0">
            <ComponentDetails>
              <GastDesc value="Schweinehaxe 180 g (S) (RUB)" />
              <ProductInfo>
                <Product name="" PLU="" ProductPrice="0.00" ProductPrice2="0.00" ProductPrice3="0.00" ProductPrice4="0.00" ProductPrice5="0.00" ProductPrice6="0.00" ProductPrice7="0.00" ProductPrice8="0.00" ProductPrice9="0.00" ProductPrice10="0.00" />
              </ProductInfo>
              <NutritionInfo>
                <Nutrient name="Kilokalorien" shortName="kcal" unit="kcal" digitalSignageCode="kcal" value="259.20" value100="144.00" />
                <Nutrient name="Kilojoule" shortName="kJ" unit="kJ" digitalSignageCode="kJ" value="1085.40" value100="603.00" />
                <Nutrient name="Fett" shortName="F" unit="g" digitalSignageCode="F" value="11.70" value100="6.50" />
                <Nutrient name="gesättigte Fettsäuren" shortName="ges FS " unit="g" digitalSignageCode="ges FS " value="2.70" value100="1.50" />
                <Nutrient name="Kohlenhydrate" shortName="KH" unit="g" digitalSignageCode="KH" value="1.08" value100="0.60" />
                <Nutrient name="Zucker" shortName="Zucker" unit="g" digitalSignageCode="Zucker" value="0.90" value100="0.50" />
                <Nutrient name="Eiweiss" shortName="EW" unit="g" digitalSignageCode="EW" value="37.80" value100="21.00" />
                <Nutrient name="Salz" shortName="Salz" unit="g" digitalSignageCode="Salz" value="3.78" value100="2.10" />
                <Nutrient name="Ballaststoffe" shortName="BST" unit="g" digitalSignageCode="BST" value="0.00" value100="0.00" />
              </NutritionInfo>
              <DietaryValues Exchanges="0" Fuids="" />
              <AdditiveInfo>
                <AdditiveGroup name="Zusatzstoff" code="Zs">
                  <Additive name="mit Antioxidationsmittel" shortName="3" digitalSignageCode="3" />
                </AdditiveGroup>
                <AdditiveGroup name="Allergene" code="Al">
                  <Additive name="Sojabohnen" shortName="SJB" digitalSignageCode="SJB" />
                  <Additive name="Weizen" shortName="a1" digitalSignageCode="a1" />
                </AdditiveGroup>
                <AdditiveGroup name="Information" code="Info">
                  <Additive name="mit Schwein" shortName="SCHW" digitalSignageCode="SCHW" />
                </AdditiveGroup>
              </AdditiveInfo>
              <FoodLabelInfo>
                <FoodLabelGroup name="Allergene" code="Al">
                  <Allergens>
                    <FoodLabel name="Sojabohnen" code="SJB" digitalSignageCode="SJB" />
                    <FoodLabel name="Weizen" code="a1" digitalSignageCode="a1" />
                  </Allergens>
                </FoodLabelGroup>
                <FoodLabelGroup name="Information" code="Info">
                  <Information>
                    <FoodLabel name="mit Schwein" code="SCHW" digitalSignageCode="SCHW" />
                  </Information>
                </FoodLabelGroup>
                <FoodLabelGroup name="Zusatzstoff" code="Zs">
                  <Additives>
                    <FoodLabel name="mit Antioxidationsmittel" code="3" digitalSignageCode="3" />
                  </Additives>
                </FoodLabelGroup>
              </FoodLabelInfo>
              <ListOfIngredients value="" />
              <CategoryInfo />
            </ComponentDetails>
          </Component>
          <Component IdentNr="32022121900286" RecipeID="2262" Name="&quot;Bayrisch&quot; Kraut" SalesPrice="0.00" SalesPrice1="0.00" SalesPrice2="0.00" TrafficLight="0" SalesUnit="Portion" CompGroup="Gemüsebeilagen" CompType="2" CompID="2262" Weight="0.150" NutriScore="" ServingTool="" Seasonality="0">
            <ComponentDetails>
              <GastDesc value="&quot;Bayrisch&quot; Kraut" />
              <ProductInfo>
                <Product name="" PLU="" ProductPrice="0.00" ProductPrice2="0.00" ProductPrice3="0.00" ProductPrice4="0.00" ProductPrice5="0.00" ProductPrice6="0.00" ProductPrice7="0.00" ProductPrice8="0.00" ProductPrice9="0.00" ProductPrice10="0.00" />
              </ProductInfo>
              <NutritionInfo>
                <Nutrient name="Kilokalorien" shortName="kcal" unit="kcal" digitalSignageCode="kcal" value="134.14" value100="89.43" />
                <Nutrient name="Kilojoule" shortName="kJ" unit="kJ" digitalSignageCode="kJ" value="555.46" value100="370.31" />
                <Nutrient name="Fett" shortName="F" unit="g" digitalSignageCode="F" value="9.13" value100="6.08" />
                <Nutrient name="gesättigte Fettsäuren" shortName="ges FS " unit="g" digitalSignageCode="ges FS " value="1.18" value100="0.79" />
                <Nutrient name="Kohlenhydrate" shortName="KH" unit="g" digitalSignageCode="KH" value="8.96" value100="5.97" />
                <Nutrient name="Zucker" shortName="Zucker" unit="g" digitalSignageCode="Zucker" value="8.08" value100="5.39" />
                <Nutrient name="Eiweiss" shortName="EW" unit="g" digitalSignageCode="EW" value="3.74" value100="2.49" />
                <Nutrient name="Salz" shortName="Salz" unit="g" digitalSignageCode="Salz" value="1.19" value100="0.79" />
                <Nutrient name="Ballaststoffe" shortName="BST" unit="g" digitalSignageCode="BST" value="3.00" value100="2.00" />
              </NutritionInfo>
              <DietaryValues Exchanges="0.5" Fuids="" />
              <AdditiveInfo>
                <AdditiveGroup name="Zusatzstoff" code="Zs">
                  <Additive name="mit Konservierungsstoff" shortName="2" digitalSignageCode="2" />
                </AdditiveGroup>
                <AdditiveGroup name="Information" code="Info">
                  <Additive name="mit Schwein" shortName="SCHW" digitalSignageCode="SCHW" />
                  <Additive name="ohne Kennzeichnung" shortName="(-)" digitalSignageCode="(-)" />
                </AdditiveGroup>
              </AdditiveInfo>
              <FoodLabelInfo>
                <FoodLabelGroup name="Information" code="Info">
                  <Information>
                    <FoodLabel name="mit Schwein" code="SCHW" digitalSignageCode="SCHW" />
                    <FoodLabel name="ohne Kennzeichnung" code="(-)" digitalSignageCode="(-)" />
                  </Information>
                </FoodLabelGroup>
                <FoodLabelGroup name="Zusatzstoff" code="Zs">
                  <Additives>
                    <FoodLabel name="mit Konservierungsstoff" code="2" digitalSignageCode="2" />
                  </Additives>
                </FoodLabelGroup>
              </FoodLabelInfo>
              <ListOfIngredients value="" />
              <CategoryInfo />
            </ComponentDetails>
          </Component>
          <Component IdentNr="32022121900286" RecipeID="14275" Name="Kartoffelklößchen" SalesPrice="0.00" SalesPrice1="0.00" SalesPrice2="0.00" TrafficLight="0" SalesUnit="Stück" CompGroup="Stärkebeilagen" CompType="2" CompID="14275" Weight="0.150" NutriScore="" ServingTool="" Seasonality="0">
            <ComponentDetails>
              <GastDesc value="Kartoffelklößchen" />
              <ProductInfo>
                <Product name="Kartoffelklößchen 6 x 25 g (V) (RUB)" PLU="46713" ProductPrice="1.00" ProductPrice2="1.00" ProductPrice3="1.20" ProductPrice4="1.20" ProductPrice5="1.20" ProductPrice6="0.00" ProductPrice7="0.00" ProductPrice8="0.00" ProductPrice9="0.00" ProductPrice10="0.00" />
                <Product name="Kartoffelklößchen" PLU="40227" ProductPrice="1.00" ProductPrice2="1.00" ProductPrice3="1.20" ProductPrice4="1.20" ProductPrice5="1.20" ProductPrice6="0.00" ProductPrice7="0.00" ProductPrice8="0.00" ProductPrice9="0.00" ProductPrice10="0.00" />
              </ProductInfo>
              <NutritionInfo>
                <Nutrient name="Kilokalorien" shortName="kcal" unit="kcal" digitalSignageCode="kcal" value="162.00" value100="108.00" />
                <Nutrient name="Kilojoule" shortName="kJ" unit="kJ" digitalSignageCode="kJ" value="687.00" value100="458.00" />
                <Nutrient name="Fett" shortName="F" unit="g" digitalSignageCode="F" value="0.15" value100="0.10" />
                <Nutrient name="gesättigte Fettsäuren" shortName="ges FS " unit="g" digitalSignageCode="ges FS " value="0.08" value100="0.05" />
                <Nutrient name="Kohlenhydrate" shortName="KH" unit="g" digitalSignageCode="KH" value="36.00" value100="24.00" />
                <Nutrient name="Zucker" shortName="Zucker" unit="g" digitalSignageCode="Zucker" value="0.38" value100="0.25" />
                <Nutrient name="Eiweiss" shortName="EW" unit="g" digitalSignageCode="EW" value="2.25" value100="1.50" />
                <Nutrient name="Salz" shortName="Salz" unit="g" digitalSignageCode="Salz" value="2.25" value100="1.50" />
                <Nutrient name="Ballaststoffe" shortName="BST" unit="g" digitalSignageCode="BST" value="0.00" value100="0.00" />
              </NutritionInfo>
              <DietaryValues Exchanges="2.4" Fuids="" />
              <AdditiveInfo>
                <AdditiveGroup name="Information" code="Info">
                  <Additive name="ohne Kennzeichnung" shortName="(-)" digitalSignageCode="(-)" />
                </AdditiveGroup>
              </AdditiveInfo>
              <FoodLabelInfo>
                <FoodLabelGroup name="Information" code="Info">
                  <Information>
                    <FoodLabel name="ohne Kennzeichnung" code="(-)" digitalSignageCode="(-)" />
                  </Information>
                </FoodLabelGroup>
              </FoodLabelInfo>
              <ListOfIngredients value="" />
              <CategoryInfo />
            </ComponentDetails>
          </Component>
        </SetMenu>
      </MenuLine>
      <MenuLine Name="Study and Fit" ShortName="S&amp;F">
        <InfoText>
        </InfoText>
        <SetMenu IdentNr="12022121900310" ItemID="16058" Name="STUDY&amp;FIT" DisplayName="" IndividualName="" SalesPrice="0.00" SalesPrice1="0.00" SalesPrice2="0.00" TrafficLight="0" SalesUnit="Stück" Weight="0.600" IsComponentOriented="false" NutriScore="">
          <SetMenuDetails>
            <GastDesc value="Rinderragout [Paprika, Zucchini]&#xA;Paprikagemüse&#xA;Couscous">
              <GastDescTranslation lang="en-gb" value="Rinderragout [Paprika, Zucchini]&#xA;Paprikagemüse (VG) (RUB)&#xA;Couscous 200 g (VG) (RUB)" />
            </GastDesc>
            <ProductInfo>
              <Product name="" PLU="" ProductPrice="0.00" ProductPrice2="0.00" ProductPrice3="0.00" ProductPrice4="0.00" ProductPrice5="0.00" ProductPrice6="0.00" ProductPrice7="0.00" ProductPrice8="0.00" ProductPrice9="0.00" ProductPrice10="0.00" />
            </ProductInfo>
            <NutritionInfo>
              <Nutrient name="Kilokalorien" shortName="kcal" unit="kcal" digitalSignageCode="kcal" value="649.91" value100="108.32" />
              <Nutrient name="Kilojoule" shortName="kJ" unit="kJ" digitalSignageCode="kJ" value="2722.46" value100="453.74" />
              <Nutrient name="Fett" shortName="F" unit="g" digitalSignageCode="F" value="22.32" value100="3.72" />
              <Nutrient name="gesättigte Fettsäuren" shortName="ges FS " unit="g" digitalSignageCode="ges FS " value="8.08" value100="1.35" />
              <Nutrient name="Kohlenhydrate" shortName="KH" unit="g" digitalSignageCode="KH" value="66.47" value100="11.08" />
              <Nutrient name="Zucker" shortName="Zucker" unit="g" digitalSignageCode="Zucker" value="13.37" value100="2.23" />
              <Nutrient name="Eiweiss" shortName="EW" unit="g" digitalSignageCode="EW" value="40.73" value100="6.79" />
              <Nutrient name="Salz" shortName="Salz" unit="g" digitalSignageCode="Salz" value="3.05" value100="0.51" />
              <Nutrient name="Ballaststoffe" shortName="BST" unit="g" digitalSignageCode="BST" value="3.06" value100="0.51" />
            </NutritionInfo>
            <AdditiveInfo>
              <AdditiveGroup name="Allergene" code="Al">
                <Additive name="Gluten" shortName="GLU" digitalSignageCode="GLU" />
                <Additive name="Sojabohnen" shortName="SJB" digitalSignageCode="SJB" />
                <Additive name="Sellerie" shortName="i" digitalSignageCode="i" />
                <Additive name="Weizen" shortName="a1" digitalSignageCode="a1" />
                <Additive name="Gerste" shortName="a3" digitalSignageCode="a3" />
              </AdditiveGroup>
              <AdditiveGroup name="Information" code="Info">
                <Additive name="mit Rind" shortName="RIND" digitalSignageCode="RIND" />
                <Additive name="ohne Kennzeichnung" shortName="(-)" digitalSignageCode="(-)" />
              </AdditiveGroup>
            </AdditiveInfo>
            <FoodLabelInfo>
              <FoodLabelGroup name="Allergene" code="Al">
                <Allergens>
                  <FoodLabel name="Gluten" code="GLU" digitalSignageCode="GLU" />
                  <FoodLabel name="Sojabohnen" code="SJB" digitalSignageCode="SJB" />
                  <FoodLabel name="Sellerie" code="i" digitalSignageCode="i" />
                  <FoodLabel name="Weizen" code="a1" digitalSignageCode="a1" />
                  <FoodLabel name="Gerste" code="a3" digitalSignageCode="a3" />
                </Allergens>
              </FoodLabelGroup>
              <FoodLabelGroup name="Information" code="Info">
                <Information>
                  <FoodLabel name="mit Rind" code="RIND" digitalSignageCode="RIND" />
                  <FoodLabel name="ohne Kennzeichnung" code="(-)" digitalSignageCode="(-)" />
                </Information>
              </FoodLabelGroup>
            </FoodLabelInfo>
          </SetMenuDetails>
          <Component IdentNr="32022121900310" RecipeID="17448" Name="Rinderragout [Paprika, Zucchini]" SalesPrice="0.00" SalesPrice1="0.00" SalesPrice2="0.00" TrafficLight="0" SalesUnit="Portion" CompGroup="Hauptgerichte Rind/Lamm" CompType="2" CompID="17448" Weight="0.250" NutriScore="" ServingTool="" Seasonality="0">
            <ComponentDetails>
              <GastDesc value="Rinderragout [Paprika, Zucchini]" />
              <ProductInfo>
                <Product name="Mediterranes Rinderragout (R) (RUB)" PLU="1864" ProductPrice="2.80" ProductPrice2="2.80" ProductPrice3="3.80" ProductPrice4="3.80" ProductPrice5="3.80" ProductPrice6="1.90" ProductPrice7="3.80" ProductPrice8="0.00" ProductPrice9="0.00" ProductPrice10="0.00" />
              </ProductInfo>
              <NutritionInfo>
                <Nutrient name="Kilokalorien" shortName="kcal" unit="kcal" digitalSignageCode="kcal" value="316.14" value100="126.46" />
                <Nutrient name="Kilojoule" shortName="kJ" unit="kJ" digitalSignageCode="kJ" value="1317.30" value100="526.92" />
                <Nutrient name="Fett" shortName="F" unit="g" digitalSignageCode="F" value="16.84" value100="6.74" />
                <Nutrient name="gesättigte Fettsäuren" shortName="ges FS " unit="g" digitalSignageCode="ges FS " value="7.38" value100="2.95" />
                <Nutrient name="Kohlenhydrate" shortName="KH" unit="g" digitalSignageCode="KH" value="9.94" value100="3.97" />
                <Nutrient name="Zucker" shortName="Zucker" unit="g" digitalSignageCode="Zucker" value="4.80" value100="1.92" />
                <Nutrient name="Eiweiss" shortName="EW" unit="g" digitalSignageCode="EW" value="30.76" value100="12.31" />
                <Nutrient name="Salz" shortName="Salz" unit="g" digitalSignageCode="Salz" value="1.49" value100="0.59" />
                <Nutrient name="Ballaststoffe" shortName="BST" unit="g" digitalSignageCode="BST" value="0.24" value100="0.10" />
              </NutritionInfo>
              <DietaryValues Exchanges="0.6" Fuids="" />
              <AdditiveInfo>
                <AdditiveGroup name="Allergene" code="Al">
                  <Additive name="Gluten" shortName="GLU" digitalSignageCode="GLU" />
                  <Additive name="Sojabohnen" shortName="SJB" digitalSignageCode="SJB" />
                  <Additive name="Sellerie" shortName="i" digitalSignageCode="i" />
                  <Additive name="Weizen" shortName="a1" digitalSignageCode="a1" />
                  <Additive name="Gerste" shortName="a3" digitalSignageCode="a3" />
                </AdditiveGroup>
                <AdditiveGroup name="Information" code="Info">
                  <Additive name="mit Rind" shortName="RIND" digitalSignageCode="RIND" />
                  <Additive name="ohne Kennzeichnung" shortName="(-)" digitalSignageCode="(-)" />
                </AdditiveGroup>
              </AdditiveInfo>
              <FoodLabelInfo>
                <FoodLabelGroup name="Allergene" code="Al">
                  <Allergens>
                    <FoodLabel name="Gluten" code="GLU" digitalSignageCode="GLU" />
                    <FoodLabel name="Sojabohnen" code="SJB" digitalSignageCode="SJB" />
                    <FoodLabel name="Sellerie" code="i" digitalSignageCode="i" />
                    <FoodLabel name="Weizen" code="a1" digitalSignageCode="a1" />
                    <FoodLabel name="Gerste" code="a3" digitalSignageCode="a3" />
                  </Allergens>
                </FoodLabelGroup>
                <FoodLabelGroup name="Information" code="Info">
                  <Information>
                    <FoodLabel name="mit Rind" code="RIND" digitalSignageCode="RIND" />
                    <FoodLabel name="ohne Kennzeichnung" code="(-)" digitalSignageCode="(-)" />
                  </Information>
                </FoodLabelGroup>
              </FoodLabelInfo>
              <ListOfIngredients value="" />
              <CategoryInfo />
            </ComponentDetails>
          </Component>
          <Component IdentNr="32022121900310" RecipeID="2296" Name="Paprikagemüse" SalesPrice="0.00" SalesPrice1="0.00" SalesPrice2="0.00" TrafficLight="0" SalesUnit="Portion" CompGroup="Gemüsebeilagen" CompType="2" CompID="2296" Weight="0.150" NutriScore="" ServingTool="" Seasonality="0">
            <ComponentDetails>
              <GastDesc value="Paprikagemüse" />
              <ProductInfo>
                <Product name="Paprikagemüse (VG)" PLU="40257" ProductPrice="1.00" ProductPrice2="1.00" ProductPrice3="1.20" ProductPrice4="1.20" ProductPrice5="1.20" ProductPrice6="1.20" ProductPrice7="0.00" ProductPrice8="0.00" ProductPrice9="0.00" ProductPrice10="0.00" />
              </ProductInfo>
              <NutritionInfo>
                <Nutrient name="Kilokalorien" shortName="kcal" unit="kcal" digitalSignageCode="kcal" value="40.68" value100="27.12" />
                <Nutrient name="Kilojoule" shortName="kJ" unit="kJ" digitalSignageCode="kJ" value="168.65" value100="112.43" />
                <Nutrient name="Fett" shortName="F" unit="g" digitalSignageCode="F" value="1.32" value100="0.88" />
                <Nutrient name="gesättigte Fettsäuren" shortName="ges FS " unit="g" digitalSignageCode="ges FS " value="0.16" value100="0.11" />
                <Nutrient name="Kohlenhydrate" shortName="KH" unit="g" digitalSignageCode="KH" value="5.06" value100="3.37" />
                <Nutrient name="Zucker" shortName="Zucker" unit="g" digitalSignageCode="Zucker" value="4.11" value100="2.74" />
                <Nutrient name="Eiweiss" shortName="EW" unit="g" digitalSignageCode="EW" value="1.78" value100="1.18" />
                <Nutrient name="Salz" shortName="Salz" unit="g" digitalSignageCode="Salz" value="0.22" value100="0.15" />
                <Nutrient name="Ballaststoffe" shortName="BST" unit="g" digitalSignageCode="BST" value="2.80" value100="1.87" />
              </NutritionInfo>
              <DietaryValues Exchanges="0.3" Fuids="" />
              <AdditiveInfo>
                <AdditiveGroup name="Information" code="Info">
                  <Additive name="ohne Kennzeichnung" shortName="(-)" digitalSignageCode="(-)" />
                </AdditiveGroup>
              </AdditiveInfo>
              <FoodLabelInfo>
                <FoodLabelGroup name="Information" code="Info">
                  <Information>
                    <FoodLabel name="ohne Kennzeichnung" code="(-)" digitalSignageCode="(-)" />
                  </Information>
                </FoodLabelGroup>
              </FoodLabelInfo>
              <ListOfIngredients value="" />
              <CategoryInfo />
            </ComponentDetails>
          </Component>
          <Component IdentNr="32022121900310" RecipeID="5202" Name="Couscous" SalesPrice="0.00" SalesPrice1="0.00" SalesPrice2="0.00" TrafficLight="0" SalesUnit="Portion" CompGroup="Stärkebeilagen" CompType="2" CompID="5202" Weight="0.200" NutriScore="" ServingTool="" Seasonality="0">
            <ComponentDetails>
              <GastDesc value="Couscous" />
              <ProductInfo>
                <Product name="Couscous" PLU="40290" ProductPrice="1.00" ProductPrice2="1.00" ProductPrice3="1.20" ProductPrice4="1.20" ProductPrice5="1.20" ProductPrice6="0.30" ProductPrice7="1.13" ProductPrice8="0.00" ProductPrice9="0.00" ProductPrice10="0.00" />
              </ProductInfo>
              <NutritionInfo>
                <Nutrient name="Kilokalorien" shortName="kcal" unit="kcal" digitalSignageCode="kcal" value="293.09" value100="146.54" />
                <Nutrient name="Kilojoule" shortName="kJ" unit="kJ" digitalSignageCode="kJ" value="1236.50" value100="618.25" />
                <Nutrient name="Fett" shortName="F" unit="g" digitalSignageCode="F" value="4.16" value100="2.08" />
                <Nutrient name="gesättigte Fettsäuren" shortName="ges FS " unit="g" digitalSignageCode="ges FS " value="0.53" value100="0.27" />
                <Nutrient name="Kohlenhydrate" shortName="KH" unit="g" digitalSignageCode="KH" value="51.47" value100="25.74" />
                <Nutrient name="Zucker" shortName="Zucker" unit="g" digitalSignageCode="Zucker" value="4.47" value100="2.23" />
                <Nutrient name="Eiweiss" shortName="EW" unit="g" digitalSignageCode="EW" value="8.19" value100="4.10" />
                <Nutrient name="Salz" shortName="Salz" unit="g" digitalSignageCode="Salz" value="1.35" value100="0.67" />
                <Nutrient name="Ballaststoffe" shortName="BST" unit="g" digitalSignageCode="BST" value="0.02" value100="0.01" />
              </NutritionInfo>
              <DietaryValues Exchanges="3.4" Fuids="" />
              <AdditiveInfo>
                <AdditiveGroup name="Allergene" code="Al">
                  <Additive name="Gluten" shortName="GLU" digitalSignageCode="GLU" />
                  <Additive name="Sellerie" shortName="i" digitalSignageCode="i" />
                  <Additive name="Weizen" shortName="a1" digitalSignageCode="a1" />
                </AdditiveGroup>
                <AdditiveGroup name="Information" code="Info">
                  <Additive name="ohne Kennzeichnung" shortName="(-)" digitalSignageCode="(-)" />
                </AdditiveGroup>
              </AdditiveInfo>
              <FoodLabelInfo>
                <FoodLabelGroup name="Allergene" code="Al">
                  <Allergens>
                    <FoodLabel name="Gluten" code="GLU" digitalSignageCode="GLU" />
                    <FoodLabel name="Sellerie" code="i" digitalSignageCode="i" />
                    <FoodLabel name="Weizen" code="a1" digitalSignageCode="a1" />
                  </Allergens>
                </FoodLabelGroup>
                <FoodLabelGroup name="Information" code="Info">
                  <Information>
                    <FoodLabel name="ohne Kennzeichnung" code="(-)" digitalSignageCode="(-)" />
                  </Information>
                </FoodLabelGroup>
              </FoodLabelInfo>
              <ListOfIngredients value="" />
              <CategoryInfo>
                <CategoryGroup name="" categoryNo="2">
                  <Category name="WHS" />
                </CategoryGroup>
              </CategoryInfo>
            </ComponentDetails>
          </Component>
        </SetMenu>
      </MenuLine>
      <MenuLine Name="Nudeltheke" ShortName="Nud">
        <InfoText>
        </InfoText>
        <SetMenu IdentNr="12022121900400" ItemID="15276" Name="Nudeltheke" DisplayName="" IndividualName="" SalesPrice="0.00" SalesPrice1="0.00" SalesPrice2="0.00" TrafficLight="0" SalesUnit="Stück" Weight="4.250" IsComponentOriented="false" NutriScore="">
          <SetMenuDetails>
            <GastDesc value="Rinderbolognese&#xA;Käse Sahnesauce&#xA;Champignonrahmsauce&#xA;Sojabolognese&#xA;Tortellini gelb gefüllt mit Käse/Spinat">
              <GastDescTranslation lang="en-gb" value="Rinderbolognese 1 lt SB (RUB)&#xA;Käse Sahnesauce&#xA;Champignonrahmsauce 1 lt SB (RUB)&#xA;Sojabolognese 1 lt SB (RUB)&#xA;Tortellini gelb gefüllt mit Käse/Spinat" />
            </GastDesc>
            <ProductInfo>
              <Product name="Nudeltheke" PLU="4000046" ProductPrice="2.60" ProductPrice2="2.60" ProductPrice3="3.90" ProductPrice4="3.90" ProductPrice5="3.90" ProductPrice6="1.50" ProductPrice7="0.00" ProductPrice8="0.00" ProductPrice9="0.00" ProductPrice10="0.00" />
              <Product name="Nudeltheke Cafeteria" PLU="4000155" ProductPrice="3.51" ProductPrice2="3.51" ProductPrice3="3.90" ProductPrice4="3.90" ProductPrice5="3.90" ProductPrice6="3.90" ProductPrice7="0.00" ProductPrice8="0.00" ProductPrice9="0.00" ProductPrice10="0.00" />
              <Product name="Nudeltheke" PLU="2001847" ProductPrice="0.00" ProductPrice2="0.00" ProductPrice3="0.00" ProductPrice4="0.00" ProductPrice5="0.00" ProductPrice6="0.00" ProductPrice7="0.00" ProductPrice8="0.00" ProductPrice9="0.00" ProductPrice10="0.00" />
              <Product name="Nudeltheke" PLU="30366" ProductPrice="3.51" ProductPrice2="3.51" ProductPrice3="3.90" ProductPrice4="3.90" ProductPrice5="3.90" ProductPrice6="0.00" ProductPrice7="0.00" ProductPrice8="0.00" ProductPrice9="0.00" ProductPrice10="3.51" />
            </ProductInfo>
            <NutritionInfo>
              <Nutrient name="Kilokalorien" shortName="kcal" unit="kcal" digitalSignageCode="kcal" value="3840.21" value100="90.36" />
              <Nutrient name="Kilojoule" shortName="kJ" unit="kJ" digitalSignageCode="kJ" value="16002.67" value100="376.53" />
              <Nutrient name="Fett" shortName="F" unit="g" digitalSignageCode="F" value="201.94" value100="4.75" />
              <Nutrient name="gesättigte Fettsäuren" shortName="ges FS " unit="g" digitalSignageCode="ges FS " value="110.75" value100="2.61" />
              <Nutrient name="Kohlenhydrate" shortName="KH" unit="g" digitalSignageCode="KH" value="336.00" value100="7.91" />
              <Nutrient name="Zucker" shortName="Zucker" unit="g" digitalSignageCode="Zucker" value="141.11" value100="3.32" />
              <Nutrient name="Eiweiss" shortName="EW" unit="g" digitalSignageCode="EW" value="150.12" value100="3.53" />
              <Nutrient name="Salz" shortName="Salz" unit="g" digitalSignageCode="Salz" value="56.92" value100="1.34" />
              <Nutrient name="Ballaststoffe" shortName="BST" unit="g" digitalSignageCode="BST" value="0.12" value100="0.00" />
            </NutritionInfo>
            <AdditiveInfo>
              <AdditiveGroup name="Zusatzstoff" code="Zs">
                <Additive name="mit Farbstoff" shortName="1" digitalSignageCode="1" />
                <Additive name="mit Antioxidationsmittel" shortName="3" digitalSignageCode="3" />
              </AdditiveGroup>
              <AdditiveGroup name="Allergene" code="Al">
                <Additive name="Gluten" shortName="GLU" digitalSignageCode="GLU" />
                <Additive name="Sojabohnen" shortName="SJB" digitalSignageCode="SJB" />
                <Additive name="Milch/Lactose" shortName="MILA" digitalSignageCode="MILA" />
                <Additive name="Sellerie" shortName="i" digitalSignageCode="i" />
                <Additive name="Weizen" shortName="a1" digitalSignageCode="a1" />
                <Additive name="Gerste" shortName="a3" digitalSignageCode="a3" />
              </AdditiveGroup>
              <AdditiveGroup name="Information" code="Info">
                <Additive name="mit Rind" shortName="RIND" digitalSignageCode="RIND" />
                <Additive name="ohne Kennzeichnung" shortName="(-)" digitalSignageCode="(-)" />
              </AdditiveGroup>
            </AdditiveInfo>
            <FoodLabelInfo>
              <FoodLabelGroup name="Allergene" code="Al">
                <Allergens>
                  <FoodLabel name="Gluten" code="GLU" digitalSignageCode="GLU" />
                  <FoodLabel name="Sojabohnen" code="SJB" digitalSignageCode="SJB" />
                  <FoodLabel name="Milch/Lactose" code="MILA" digitalSignageCode="MILA" />
                  <FoodLabel name="Sellerie" code="i" digitalSignageCode="i" />
                  <FoodLabel name="Weizen" code="a1" digitalSignageCode="a1" />
                  <FoodLabel name="Gerste" code="a3" digitalSignageCode="a3" />
                </Allergens>
              </FoodLabelGroup>
              <FoodLabelGroup name="Information" code="Info">
                <Information>
                  <FoodLabel name="mit Rind" code="RIND" digitalSignageCode="RIND" />
                  <FoodLabel name="ohne Kennzeichnung" code="(-)" digitalSignageCode="(-)" />
                </Information>
              </FoodLabelGroup>
              <FoodLabelGroup name="Zusatzstoff" code="Zs">
                <Additives>
                  <FoodLabel name="mit Farbstoff" code="1" digitalSignageCode="1" />
                  <FoodLabel name="mit Antioxidationsmittel" code="3" digitalSignageCode="3" />
                </Additives>
              </FoodLabelGroup>
            </FoodLabelInfo>
          </SetMenuDetails>
          <Component IdentNr="32022121900400" RecipeID="13785" Name="Rinderbolognese" SalesPrice="0.00" SalesPrice1="0.00" SalesPrice2="0.00" TrafficLight="0" SalesUnit="Liter" CompGroup="Saucen" CompType="2" CompID="13785" Weight="1.000" NutriScore="" ServingTool="" Seasonality="0">
            <ComponentDetails>
              <GastDesc value="Rinderbolognese" />
              <ProductInfo>
                <Product name="" PLU="" ProductPrice="0.00" ProductPrice2="0.00" ProductPrice3="0.00" ProductPrice4="0.00" ProductPrice5="0.00" ProductPrice6="0.00" ProductPrice7="0.00" ProductPrice8="0.00" ProductPrice9="0.00" ProductPrice10="0.00" />
              </ProductInfo>
              <NutritionInfo>
                <Nutrient name="Kilokalorien" shortName="kcal" unit="kcal" digitalSignageCode="kcal" value="777.12" value100="77.71" />
                <Nutrient name="Kilojoule" shortName="kJ" unit="kJ" digitalSignageCode="kJ" value="3224.05" value100="322.41" />
                <Nutrient name="Fett" shortName="F" unit="g" digitalSignageCode="F" value="37.59" value100="3.76" />
                <Nutrient name="gesättigte Fettsäuren" shortName="ges FS " unit="g" digitalSignageCode="ges FS " value="15.67" value100="1.57" />
                <Nutrient name="Kohlenhydrate" shortName="KH" unit="g" digitalSignageCode="KH" value="59.01" value100="5.90" />
                <Nutrient name="Zucker" shortName="Zucker" unit="g" digitalSignageCode="Zucker" value="37.12" value100="3.71" />
                <Nutrient name="Eiweiss" shortName="EW" unit="g" digitalSignageCode="EW" value="46.98" value100="4.70" />
                <Nutrient name="Salz" shortName="Salz" unit="g" digitalSignageCode="Salz" value="11.38" value100="1.14" />
                <Nutrient name="Ballaststoffe" shortName="BST" unit="g" digitalSignageCode="BST" value="0.00" value100="0.00" />
              </NutritionInfo>
              <DietaryValues Exchanges="3.9" Fuids="" />
              <AdditiveInfo>
                <AdditiveGroup name="Allergene" code="Al">
                  <Additive name="Sellerie" shortName="i" digitalSignageCode="i" />
                </AdditiveGroup>
                <AdditiveGroup name="Information" code="Info">
                  <Additive name="mit Rind" shortName="RIND" digitalSignageCode="RIND" />
                  <Additive name="ohne Kennzeichnung" shortName="(-)" digitalSignageCode="(-)" />
                </AdditiveGroup>
              </AdditiveInfo>
              <FoodLabelInfo>
                <FoodLabelGroup name="Allergene" code="Al">
                  <Allergens>
                    <FoodLabel name="Sellerie" code="i" digitalSignageCode="i" />
                  </Allergens>
                </FoodLabelGroup>
                <FoodLabelGroup name="Information" code="Info">
                  <Information>
                    <FoodLabel name="mit Rind" code="RIND" digitalSignageCode="RIND" />
                    <FoodLabel name="ohne Kennzeichnung" code="(-)" digitalSignageCode="(-)" />
                  </Information>
                </FoodLabelGroup>
              </FoodLabelInfo>
              <ListOfIngredients value="" />
              <CategoryInfo />
            </ComponentDetails>
          </Component>
          <Component IdentNr="32022121900400" RecipeID="7694" Name="Käse Sahnesauce" SalesPrice="0.00" SalesPrice1="0.00" SalesPrice2="0.00" TrafficLight="0" SalesUnit="Portion" CompGroup="Saucen" CompType="2" CompID="7694" Weight="1.000" NutriScore="" ServingTool="" Seasonality="0">
            <ComponentDetails>
              <GastDesc value="Käse Sahnesauce" />
              <ProductInfo>
                <Product name="" PLU="" ProductPrice="0.00" ProductPrice2="0.00" ProductPrice3="0.00" ProductPrice4="0.00" ProductPrice5="0.00" ProductPrice6="0.00" ProductPrice7="0.00" ProductPrice8="0.00" ProductPrice9="0.00" ProductPrice10="0.00" />
              </ProductInfo>
              <NutritionInfo>
                <Nutrient name="Kilokalorien" shortName="kcal" unit="kcal" digitalSignageCode="kcal" value="1072.99" value100="107.30" />
                <Nutrient name="Kilojoule" shortName="kJ" unit="kJ" digitalSignageCode="kJ" value="4451.60" value100="445.16" />
                <Nutrient name="Fett" shortName="F" unit="g" digitalSignageCode="F" value="82.09" value100="8.21" />
                <Nutrient name="gesättigte Fettsäuren" shortName="ges FS " unit="g" digitalSignageCode="ges FS " value="52.52" value100="5.25" />
                <Nutrient name="Kohlenhydrate" shortName="KH" unit="g" digitalSignageCode="KH" value="48.27" value100="4.83" />
                <Nutrient name="Zucker" shortName="Zucker" unit="g" digitalSignageCode="Zucker" value="12.17" value100="1.22" />
                <Nutrient name="Eiweiss" shortName="EW" unit="g" digitalSignageCode="EW" value="36.05" value100="3.60" />
                <Nutrient name="Salz" shortName="Salz" unit="g" digitalSignageCode="Salz" value="12.99" value100="1.30" />
                <Nutrient name="Ballaststoffe" shortName="BST" unit="g" digitalSignageCode="BST" value="0.00" value100="0.00" />
              </NutritionInfo>
              <DietaryValues Exchanges="3.2" Fuids="" />
              <AdditiveInfo>
                <AdditiveGroup name="Zusatzstoff" code="Zs">
                  <Additive name="mit Farbstoff" shortName="1" digitalSignageCode="1" />
                </AdditiveGroup>
                <AdditiveGroup name="Allergene" code="Al">
                  <Additive name="Milch/Lactose" shortName="MILA" digitalSignageCode="MILA" />
                </AdditiveGroup>
                <AdditiveGroup name="Information" code="Info">
                  <Additive name="ohne Kennzeichnung" shortName="(-)" digitalSignageCode="(-)" />
                </AdditiveGroup>
              </AdditiveInfo>
              <FoodLabelInfo>
                <FoodLabelGroup name="Allergene" code="Al">
                  <Allergens>
                    <FoodLabel name="Milch/Lactose" code="MILA" digitalSignageCode="MILA" />
                  </Allergens>
                </FoodLabelGroup>
                <FoodLabelGroup name="Information" code="Info">
                  <Information>
                    <FoodLabel name="ohne Kennzeichnung" code="(-)" digitalSignageCode="(-)" />
                  </Information>
                </FoodLabelGroup>
                <FoodLabelGroup name="Zusatzstoff" code="Zs">
                  <Additives>
                    <FoodLabel name="mit Farbstoff" code="1" digitalSignageCode="1" />
                  </Additives>
                </FoodLabelGroup>
              </FoodLabelInfo>
              <ListOfIngredients value="" />
              <CategoryInfo />
            </ComponentDetails>
          </Component>
          <Component IdentNr="32022121900400" RecipeID="7924" Name="Champignonrahmsauce" SalesPrice="0.00" SalesPrice1="0.00" SalesPrice2="0.00" TrafficLight="0" SalesUnit="Kilogramm" CompGroup="Saucen" CompType="2" CompID="7924" Weight="1.000" NutriScore="" ServingTool="" Seasonality="0">
            <ComponentDetails>
              <GastDesc value="Champignonrahmsauce" />
              <ProductInfo>
                <Product name="" PLU="" ProductPrice="0.00" ProductPrice2="0.00" ProductPrice3="0.00" ProductPrice4="0.00" ProductPrice5="0.00" ProductPrice6="0.00" ProductPrice7="0.00" ProductPrice8="0.00" ProductPrice9="0.00" ProductPrice10="0.00" />
              </ProductInfo>
              <NutritionInfo>
                <Nutrient name="Kilokalorien" shortName="kcal" unit="kcal" digitalSignageCode="kcal" value="860.63" value100="86.06" />
                <Nutrient name="Kilojoule" shortName="kJ" unit="kJ" digitalSignageCode="kJ" value="3577.51" value100="357.75" />
                <Nutrient name="Fett" shortName="F" unit="g" digitalSignageCode="F" value="51.43" value100="5.14" />
                <Nutrient name="gesättigte Fettsäuren" shortName="ges FS " unit="g" digitalSignageCode="ges FS " value="34.68" value100="3.47" />
                <Nutrient name="Kohlenhydrate" shortName="KH" unit="g" digitalSignageCode="KH" value="72.07" value100="7.21" />
                <Nutrient name="Zucker" shortName="Zucker" unit="g" digitalSignageCode="Zucker" value="24.68" value100="2.47" />
                <Nutrient name="Eiweiss" shortName="EW" unit="g" digitalSignageCode="EW" value="23.42" value100="2.34" />
                <Nutrient name="Salz" shortName="Salz" unit="g" digitalSignageCode="Salz" value="16.70" value100="1.67" />
                <Nutrient name="Ballaststoffe" shortName="BST" unit="g" digitalSignageCode="BST" value="0.12" value100="0.01" />
              </NutritionInfo>
              <DietaryValues Exchanges="4.8" Fuids="" />
              <AdditiveInfo>
                <AdditiveGroup name="Zusatzstoff" code="Zs">
                  <Additive name="mit Antioxidationsmittel" shortName="3" digitalSignageCode="3" />
                </AdditiveGroup>
                <AdditiveGroup name="Allergene" code="Al">
                  <Additive name="Gluten" shortName="GLU" digitalSignageCode="GLU" />
                  <Additive name="Sojabohnen" shortName="SJB" digitalSignageCode="SJB" />
                  <Additive name="Milch/Lactose" shortName="MILA" digitalSignageCode="MILA" />
                  <Additive name="Sellerie" shortName="i" digitalSignageCode="i" />
                  <Additive name="Weizen" shortName="a1" digitalSignageCode="a1" />
                  <Additive name="Gerste" shortName="a3" digitalSignageCode="a3" />
                </AdditiveGroup>
                <AdditiveGroup name="Information" code="Info">
                  <Additive name="ohne Kennzeichnung" shortName="(-)" digitalSignageCode="(-)" />
                </AdditiveGroup>
              </AdditiveInfo>
              <FoodLabelInfo>
                <FoodLabelGroup name="Allergene" code="Al">
                  <Allergens>
                    <FoodLabel name="Gluten" code="GLU" digitalSignageCode="GLU" />
                    <FoodLabel name="Sojabohnen" code="SJB" digitalSignageCode="SJB" />
                    <FoodLabel name="Milch/Lactose" code="MILA" digitalSignageCode="MILA" />
                    <FoodLabel name="Sellerie" code="i" digitalSignageCode="i" />
                    <FoodLabel name="Weizen" code="a1" digitalSignageCode="a1" />
                    <FoodLabel name="Gerste" code="a3" digitalSignageCode="a3" />
                  </Allergens>
                </FoodLabelGroup>
                <FoodLabelGroup name="Information" code="Info">
                  <Information>
                    <FoodLabel name="ohne Kennzeichnung" code="(-)" digitalSignageCode="(-)" />
                  </Information>
                </FoodLabelGroup>
                <FoodLabelGroup name="Zusatzstoff" code="Zs">
                  <Additives>
                    <FoodLabel name="mit Antioxidationsmittel" code="3" digitalSignageCode="3" />
                  </Additives>
                </FoodLabelGroup>
              </FoodLabelInfo>
              <ListOfIngredients value="" />
              <CategoryInfo />
            </ComponentDetails>
          </Component>
          <Component IdentNr="32022121900400" RecipeID="9256" Name="Sojabolognese" SalesPrice="0.00" SalesPrice1="0.00" SalesPrice2="0.00" TrafficLight="0" SalesUnit="Liter" CompGroup="Saucen" CompType="2" CompID="9256" Weight="1.000" NutriScore="" ServingTool="" Seasonality="0">
            <ComponentDetails>
              <GastDesc value="Sojabolognese" />
              <ProductInfo>
                <Product name="" PLU="" ProductPrice="0.00" ProductPrice2="0.00" ProductPrice3="0.00" ProductPrice4="0.00" ProductPrice5="0.00" ProductPrice6="0.00" ProductPrice7="0.00" ProductPrice8="0.00" ProductPrice9="0.00" ProductPrice10="0.00" />
              </ProductInfo>
              <NutritionInfo>
                <Nutrient name="Kilokalorien" shortName="kcal" unit="kcal" digitalSignageCode="kcal" value="581.90" value100="58.19" />
                <Nutrient name="Kilojoule" shortName="kJ" unit="kJ" digitalSignageCode="kJ" value="2451.40" value100="245.14" />
                <Nutrient name="Fett" shortName="F" unit="g" digitalSignageCode="F" value="12.24" value100="1.22" />
                <Nutrient name="gesättigte Fettsäuren" shortName="ges FS " unit="g" digitalSignageCode="ges FS " value="5.63" value100="0.56" />
                <Nutrient name="Kohlenhydrate" shortName="KH" unit="g" digitalSignageCode="KH" value="81.47" value100="8.15" />
                <Nutrient name="Zucker" shortName="Zucker" unit="g" digitalSignageCode="Zucker" value="64.51" value100="6.45" />
                <Nutrient name="Eiweiss" shortName="EW" unit="g" digitalSignageCode="EW" value="26.97" value100="2.70" />
                <Nutrient name="Salz" shortName="Salz" unit="g" digitalSignageCode="Salz" value="7.90" value100="0.79" />
                <Nutrient name="Ballaststoffe" shortName="BST" unit="g" digitalSignageCode="BST" value="0.00" value100="0.00" />
              </NutritionInfo>
              <DietaryValues Exchanges="5.4" Fuids="" />
              <AdditiveInfo>
                <AdditiveGroup name="Allergene" code="Al">
                  <Additive name="Gluten" shortName="GLU" digitalSignageCode="GLU" />
                  <Additive name="Sojabohnen" shortName="SJB" digitalSignageCode="SJB" />
                  <Additive name="Sellerie" shortName="i" digitalSignageCode="i" />
                  <Additive name="Weizen" shortName="a1" digitalSignageCode="a1" />
                </AdditiveGroup>
                <AdditiveGroup name="Information" code="Info">
                  <Additive name="ohne Kennzeichnung" shortName="(-)" digitalSignageCode="(-)" />
                </AdditiveGroup>
              </AdditiveInfo>
              <FoodLabelInfo>
                <FoodLabelGroup name="Allergene" code="Al">
                  <Allergens>
                    <FoodLabel name="Gluten" code="GLU" digitalSignageCode="GLU" />
                    <FoodLabel name="Sojabohnen" code="SJB" digitalSignageCode="SJB" />
                    <FoodLabel name="Sellerie" code="i" digitalSignageCode="i" />
                    <FoodLabel name="Weizen" code="a1" digitalSignageCode="a1" />
                  </Allergens>
                </FoodLabelGroup>
                <FoodLabelGroup name="Information" code="Info">
                  <Information>
                    <FoodLabel name="ohne Kennzeichnung" code="(-)" digitalSignageCode="(-)" />
                  </Information>
                </FoodLabelGroup>
              </FoodLabelInfo>
              <ListOfIngredients value="" />
              <CategoryInfo />
            </ComponentDetails>
          </Component>
          <Component IdentNr="32022121900400" RecipeID="15687" Name="Tortellini gelb gefüllt mit Käse/Spinat" SalesPrice="0.00" SalesPrice1="0.00" SalesPrice2="0.00" TrafficLight="0" SalesUnit="Portion" CompGroup="Stärkebeilagen" CompType="2" CompID="15687" Weight="0.250" NutriScore="" ServingTool="" Seasonality="0">
            <ComponentDetails>
              <GastDesc value="Tortellini gelb gefüllt mit Käse/Spinat" />
              <ProductInfo>
                <Product name="" PLU="" ProductPrice="0.00" ProductPrice2="0.00" ProductPrice3="0.00" ProductPrice4="0.00" ProductPrice5="0.00" ProductPrice6="0.00" ProductPrice7="0.00" ProductPrice8="0.00" ProductPrice9="0.00" ProductPrice10="0.00" />
              </ProductInfo>
              <NutritionInfo>
                <Nutrient name="Kilokalorien" shortName="kcal" unit="kcal" digitalSignageCode="kcal" value="547.57" value100="219.03" />
                <Nutrient name="Kilojoule" shortName="kJ" unit="kJ" digitalSignageCode="kJ" value="2298.10" value100="919.24" />
                <Nutrient name="Fett" shortName="F" unit="g" digitalSignageCode="F" value="18.60" value100="7.44" />
                <Nutrient name="gesättigte Fettsäuren" shortName="ges FS " unit="g" digitalSignageCode="ges FS " value="2.24" value100="0.90" />
                <Nutrient name="Kohlenhydrate" shortName="KH" unit="g" digitalSignageCode="KH" value="75.18" value100="30.07" />
                <Nutrient name="Zucker" shortName="Zucker" unit="g" digitalSignageCode="Zucker" value="2.64" value100="1.06" />
                <Nutrient name="Eiweiss" shortName="EW" unit="g" digitalSignageCode="EW" value="16.69" value100="6.68" />
                <Nutrient name="Salz" shortName="Salz" unit="g" digitalSignageCode="Salz" value="7.96" value100="3.18" />
                <Nutrient name="Ballaststoffe" shortName="BST" unit="g" digitalSignageCode="BST" value="0.00" value100="0.00" />
              </NutritionInfo>
              <DietaryValues Exchanges="5" Fuids="" />
              <AdditiveInfo>
                <AdditiveGroup name="Allergene" code="Al">
                  <Additive name="Gluten" shortName="GLU" digitalSignageCode="GLU" />
                  <Additive name="Sojabohnen" shortName="SJB" digitalSignageCode="SJB" />
                  <Additive name="Milch/Lactose" shortName="MILA" digitalSignageCode="MILA" />
                  <Additive name="Weizen" shortName="a1" digitalSignageCode="a1" />
                </AdditiveGroup>
                <AdditiveGroup name="Information" code="Info">
                  <Additive name="ohne Kennzeichnung" shortName="(-)" digitalSignageCode="(-)" />
                </AdditiveGroup>
              </AdditiveInfo>
              <FoodLabelInfo>
                <FoodLabelGroup name="Allergene" code="Al">
                  <Allergens>
                    <FoodLabel name="Gluten" code="GLU" digitalSignageCode="GLU" />
                    <FoodLabel name="Sojabohnen" code="SJB" digitalSignageCode="SJB" />
                    <FoodLabel name="Milch/Lactose" code="MILA" digitalSignageCode="MILA" />
                    <FoodLabel name="Weizen" code="a1" digitalSignageCode="a1" />
                  </Allergens>
                </FoodLabelGroup>
                <FoodLabelGroup name="Information" code="Info">
                  <Information>
                    <FoodLabel name="ohne Kennzeichnung" code="(-)" digitalSignageCode="(-)" />
                  </Information>
                </FoodLabelGroup>
              </FoodLabelInfo>
              <ListOfIngredients value="" />
              <CategoryInfo />
            </ComponentDetails>
          </Component>
        </SetMenu>
      </MenuLine>
      <MenuLine Name="Döner" ShortName="Döner">
        <InfoText>
        </InfoText>
        <SetMenu IdentNr="12022121900431" ItemID="16078" Name="Döner" DisplayName="" IndividualName="" SalesPrice="0.00" SalesPrice1="0.00" SalesPrice2="0.00" TrafficLight="0" SalesUnit="Stück" Weight="0.430" IsComponentOriented="false" NutriScore="">
          <SetMenuDetails>
            <GastDesc value="Halal Hähnchendöner mit Pommes oder Reis und Salat">
              <GastDescTranslation lang="en-gb" value="Döner Teller Halal (170 g) mit Pommes (G) (RUB)" />
            </GastDesc>
            <ProductInfo>
              <Product name="" PLU="" ProductPrice="0.00" ProductPrice2="0.00" ProductPrice3="0.00" ProductPrice4="0.00" ProductPrice5="0.00" ProductPrice6="0.00" ProductPrice7="0.00" ProductPrice8="0.00" ProductPrice9="0.00" ProductPrice10="0.00" />
            </ProductInfo>
            <NutritionInfo>
              <Nutrient name="Kilokalorien" shortName="kcal" unit="kcal" digitalSignageCode="kcal" value="788.40" value100="183.35" />
              <Nutrient name="Kilojoule" shortName="kJ" unit="kJ" digitalSignageCode="kJ" value="3291.81" value100="765.54" />
              <Nutrient name="Fett" shortName="F" unit="g" digitalSignageCode="F" value="43.05" value100="10.01" />
              <Nutrient name="gesättigte Fettsäuren" shortName="ges FS " unit="g" digitalSignageCode="ges FS " value="14.09" value100="3.28" />
              <Nutrient name="Kohlenhydrate" shortName="KH" unit="g" digitalSignageCode="KH" value="53.74" value100="12.50" />
              <Nutrient name="Zucker" shortName="Zucker" unit="g" digitalSignageCode="Zucker" value="5.16" value100="1.20" />
              <Nutrient name="Eiweiss" shortName="EW" unit="g" digitalSignageCode="EW" value="45.14" value100="10.50" />
              <Nutrient name="Salz" shortName="Salz" unit="g" digitalSignageCode="Salz" value="6.45" value100="1.50" />
              <Nutrient name="Ballaststoffe" shortName="BST" unit="g" digitalSignageCode="BST" value="1.68" value100="0.39" />
            </NutritionInfo>
            <AdditiveInfo>
              <AdditiveGroup name="Zusatzstoff" code="Zs">
                <Additive name="mit Farbstoff" shortName="1" digitalSignageCode="1" />
                <Additive name="mit Konservierungsstoff" shortName="2" digitalSignageCode="2" />
              </AdditiveGroup>
              <AdditiveGroup name="Allergene" code="Al">
                <Additive name="Gluten" shortName="GLU" digitalSignageCode="GLU" />
                <Additive name="Milch/Lactose" shortName="MILA" digitalSignageCode="MILA" />
                <Additive name="Senf" shortName="j" digitalSignageCode="j" />
                <Additive name="Weizen" shortName="a1" digitalSignageCode="a1" />
              </AdditiveGroup>
              <AdditiveGroup name="Information" code="Info">
                <Additive name="mit Geflügel" shortName="g" digitalSignageCode="g" />
                <Additive name="ohne Kennzeichnung" shortName="(-)" digitalSignageCode="(-)" />
                <Additive name="Halal" shortName="Halal" digitalSignageCode="Halal" />
              </AdditiveGroup>
            </AdditiveInfo>
            <FoodLabelInfo>
              <FoodLabelGroup name="Allergene" code="Al">
                <Allergens>
                  <FoodLabel name="Gluten" code="GLU" digitalSignageCode="GLU" />
                  <FoodLabel name="Milch/Lactose" code="MILA" digitalSignageCode="MILA" />
                  <FoodLabel name="Senf" code="j" digitalSignageCode="j" />
                  <FoodLabel name="Weizen" code="a1" digitalSignageCode="a1" />
                </Allergens>
              </FoodLabelGroup>
              <FoodLabelGroup name="Information" code="Info">
                <Information>
                  <FoodLabel name="mit Geflügel" code="g" digitalSignageCode="g" />
                  <FoodLabel name="ohne Kennzeichnung" code="(-)" digitalSignageCode="(-)" />
                  <FoodLabel name="Halal" code="Halal" digitalSignageCode="Halal" />
                </Information>
              </FoodLabelGroup>
              <FoodLabelGroup name="Zusatzstoff" code="Zs">
                <Additives>
                  <FoodLabel name="mit Farbstoff" code="1" digitalSignageCode="1" />
                  <FoodLabel name="mit Konservierungsstoff" code="2" digitalSignageCode="2" />
                </Additives>
              </FoodLabelGroup>
            </FoodLabelInfo>
          </SetMenuDetails>
          <Component IdentNr="32022121900431" RecipeID="7143" Name="Halal Hähnchendöner mit Pommes oder Reis und Salat" SalesPrice="0.00" SalesPrice1="0.00" SalesPrice2="0.00" TrafficLight="0" SalesUnit="Portion" CompGroup="Hauptgerichte Geflügel" CompType="2" CompID="7143" Weight="0.430" NutriScore="" ServingTool="" Seasonality="0">
            <ComponentDetails>
              <GastDesc value="Halal Hähnchendöner mit Pommes oder Reis und Salat" />
              <ProductInfo>
                <Product name="Döner Teller Halal (170 g) mit Pommes (G) (RUB)" PLU="1079" ProductPrice="3.90" ProductPrice2="3.90" ProductPrice3="5.20" ProductPrice4="5.20" ProductPrice5="5.20" ProductPrice6="5.20" ProductPrice7="0.00" ProductPrice8="0.00" ProductPrice9="0.00" ProductPrice10="0.00" />
              </ProductInfo>
              <NutritionInfo>
                <Nutrient name="Kilokalorien" shortName="kcal" unit="kcal" digitalSignageCode="kcal" value="788.40" value100="183.35" />
                <Nutrient name="Kilojoule" shortName="kJ" unit="kJ" digitalSignageCode="kJ" value="3291.81" value100="765.54" />
                <Nutrient name="Fett" shortName="F" unit="g" digitalSignageCode="F" value="43.05" value100="10.01" />
                <Nutrient name="gesättigte Fettsäuren" shortName="ges FS " unit="g" digitalSignageCode="ges FS " value="14.09" value100="3.28" />
                <Nutrient name="Kohlenhydrate" shortName="KH" unit="g" digitalSignageCode="KH" value="53.74" value100="12.50" />
                <Nutrient name="Zucker" shortName="Zucker" unit="g" digitalSignageCode="Zucker" value="5.16" value100="1.20" />
                <Nutrient name="Eiweiss" shortName="EW" unit="g" digitalSignageCode="EW" value="45.14" value100="10.50" />
                <Nutrient name="Salz" shortName="Salz" unit="g" digitalSignageCode="Salz" value="6.45" value100="1.50" />
                <Nutrient name="Ballaststoffe" shortName="BST" unit="g" digitalSignageCode="BST" value="1.68" value100="0.39" />
              </NutritionInfo>
              <DietaryValues Exchanges="3.5" Fuids="" />
              <AdditiveInfo>
                <AdditiveGroup name="Zusatzstoff" code="Zs">
                  <Additive name="mit Farbstoff" shortName="1" digitalSignageCode="1" />
                  <Additive name="mit Konservierungsstoff" shortName="2" digitalSignageCode="2" />
                </AdditiveGroup>
                <AdditiveGroup name="Allergene" code="Al">
                  <Additive name="Gluten" shortName="GLU" digitalSignageCode="GLU" />
                  <Additive name="Milch/Lactose" shortName="MILA" digitalSignageCode="MILA" />
                  <Additive name="Senf" shortName="j" digitalSignageCode="j" />
                  <Additive name="Weizen" shortName="a1" digitalSignageCode="a1" />
                </AdditiveGroup>
                <AdditiveGroup name="Information" code="Info">
                  <Additive name="mit Geflügel" shortName="g" digitalSignageCode="g" />
                  <Additive name="ohne Kennzeichnung" shortName="(-)" digitalSignageCode="(-)" />
                  <Additive name="Halal" shortName="Halal" digitalSignageCode="Halal" />
                </AdditiveGroup>
              </AdditiveInfo>
              <FoodLabelInfo>
                <FoodLabelGroup name="Allergene" code="Al">
                  <Allergens>
                    <FoodLabel name="Gluten" code="GLU" digitalSignageCode="GLU" />
                    <FoodLabel name="Milch/Lactose" code="MILA" digitalSignageCode="MILA" />
                    <FoodLabel name="Senf" code="j" digitalSignageCode="j" />
                    <FoodLabel name="Weizen" code="a1" digitalSignageCode="a1" />
                  </Allergens>
                </FoodLabelGroup>
                <FoodLabelGroup name="Information" code="Info">
                  <Information>
                    <FoodLabel name="mit Geflügel" code="g" digitalSignageCode="g" />
                    <FoodLabel name="ohne Kennzeichnung" code="(-)" digitalSignageCode="(-)" />
                    <FoodLabel name="Halal" code="Halal" digitalSignageCode="Halal" />
                  </Information>
                </FoodLabelGroup>
                <FoodLabelGroup name="Zusatzstoff" code="Zs">
                  <Additives>
                    <FoodLabel name="mit Farbstoff" code="1" digitalSignageCode="1" />
                    <FoodLabel name="mit Konservierungsstoff" code="2" digitalSignageCode="2" />
                  </Additives>
                </FoodLabelGroup>
              </FoodLabelInfo>
              <ListOfIngredients value="" />
              <CategoryInfo />
            </ComponentDetails>
          </Component>
        </SetMenu>
      </MenuLine>
    </WeekDay>
    <WeekDay Day="Dienstag" Date="2022-12-20" Mealtime="Mittagsverpflegung">
      <MenuLine Name="Schulessen 1" ShortName="Schul1">
        <InfoText>
        </InfoText>
        <SetMenu IdentNr="12022122000490" ItemID="15285" Name="Schulessen 1" DisplayName="" IndividualName="" SalesPrice="0.00" SalesPrice1="0.00" SalesPrice2="0.00" TrafficLight="0" SalesUnit="Stück" Weight="0.790" IsComponentOriented="false" NutriScore="">
          <SetMenuDetails>
            <GastDesc value="Bratwurstschnecke mit Pilzrahmsauce&#xA;Paprika-Maisgemüse&#xA;Risolée-Kartoffeln&#xA;Schokopudding ">
              <GastDescTranslation lang="en-gb" value="Bratwurstschnecke mit Pilzrahmsauce&#xA;Paprika Maisgemüse (VG) (RUB)&#xA;Risoleekartoffeln 200 g (VG) (RUB)&#xA;Dessert Schokopudding mit Vanillesauce (RUB)" />
            </GastDesc>
            <ProductInfo>
              <Product name="" PLU="" ProductPrice="0.00" ProductPrice2="0.00" ProductPrice3="0.00" ProductPrice4="0.00" ProductPrice5="0.00" ProductPrice6="0.00" ProductPrice7="0.00" ProductPrice8="0.00" ProductPrice9="0.00" ProductPrice10="0.00" />
            </ProductInfo>
            <NutritionInfo>
              <Nutrient name="Kilokalorien" shortName="kcal" unit="kcal" digitalSignageCode="kcal" value="1054.34" value100="133.46" />
              <Nutrient name="Kilojoule" shortName="kJ" unit="kJ" digitalSignageCode="kJ" value="4401.49" value100="557.15" />
              <Nutrient name="Fett" shortName="F" unit="g" digitalSignageCode="F" value="58.53" value100="7.41" />
              <Nutrient name="gesättigte Fettsäuren" shortName="ges FS " unit="g" digitalSignageCode="ges FS " value="26.28" value100="3.33" />
              <Nutrient name="Kohlenhydrate" shortName="KH" unit="g" digitalSignageCode="KH" value="83.62" value100="10.59" />
              <Nutrient name="Zucker" shortName="Zucker" unit="g" digitalSignageCode="Zucker" value="32.51" value100="4.12" />
              <Nutrient name="Eiweiss" shortName="EW" unit="g" digitalSignageCode="EW" value="43.96" value100="5.56" />
              <Nutrient name="Salz" shortName="Salz" unit="g" digitalSignageCode="Salz" value="5.95" value100="0.75" />
              <Nutrient name="Ballaststoffe" shortName="BST" unit="g" digitalSignageCode="BST" value="8.55" value100="1.08" />
            </NutritionInfo>
            <AdditiveInfo>
              <AdditiveGroup name="Zusatzstoff" code="Zs">
                <Additive name="mit Farbstoff" shortName="1" digitalSignageCode="1" />
                <Additive name="mit Antioxidationsmittel" shortName="3" digitalSignageCode="3" />
              </AdditiveGroup>
              <AdditiveGroup name="Allergene" code="Al">
                <Additive name="Gluten" shortName="GLU" digitalSignageCode="GLU" />
                <Additive name="Sojabohnen" shortName="SJB" digitalSignageCode="SJB" />
                <Additive name="Milch/Lactose" shortName="MILA" digitalSignageCode="MILA" />
                <Additive name="Sellerie" shortName="i" digitalSignageCode="i" />
                <Additive name="Weizen" shortName="a1" digitalSignageCode="a1" />
                <Additive name="Gerste" shortName="a3" digitalSignageCode="a3" />
              </AdditiveGroup>
              <AdditiveGroup name="Information" code="Info">
                <Additive name="mit Schwein" shortName="SCHW" digitalSignageCode="SCHW" />
                <Additive name="ohne Kennzeichnung" shortName="(-)" digitalSignageCode="(-)" />
              </AdditiveGroup>
            </AdditiveInfo>
            <FoodLabelInfo>
              <FoodLabelGroup name="Allergene" code="Al">
                <Allergens>
                  <FoodLabel name="Gluten" code="GLU" digitalSignageCode="GLU" />
                  <FoodLabel name="Sojabohnen" code="SJB" digitalSignageCode="SJB" />
                  <FoodLabel name="Milch/Lactose" code="MILA" digitalSignageCode="MILA" />
                  <FoodLabel name="Sellerie" code="i" digitalSignageCode="i" />
                  <FoodLabel name="Weizen" code="a1" digitalSignageCode="a1" />
                  <FoodLabel name="Gerste" code="a3" digitalSignageCode="a3" />
                </Allergens>
              </FoodLabelGroup>
              <FoodLabelGroup name="Information" code="Info">
                <Information>
                  <FoodLabel name="mit Schwein" code="SCHW" digitalSignageCode="SCHW" />
                  <FoodLabel name="ohne Kennzeichnung" code="(-)" digitalSignageCode="(-)" />
                </Information>
              </FoodLabelGroup>
              <FoodLabelGroup name="Zusatzstoff" code="Zs">
                <Additives>
                  <FoodLabel name="mit Farbstoff" code="1" digitalSignageCode="1" />
                  <FoodLabel name="mit Antioxidationsmittel" code="3" digitalSignageCode="3" />
                </Additives>
              </FoodLabelGroup>
            </FoodLabelInfo>
          </SetMenuDetails>
          <Component IdentNr="32022122000490" RecipeID="17457" Name="Bratwurstschnecke mit Pilzrahmsauce" SalesPrice="0.00" SalesPrice1="0.00" SalesPrice2="0.00" TrafficLight="0" SalesUnit="Portion" CompGroup="Hauptgerichte Schwein" CompType="2" CompID="17457" Weight="0.260" NutriScore="" ServingTool="" Seasonality="0">
            <ComponentDetails>
              <GastDesc value="Bratwurstschnecke mit Pilzrahmsauce" />
              <ProductInfo>
                <Product name="Bratwurstschnecke mit Pilzrahmsauce (S) (RUB)" PLU="1853" ProductPrice="2.70" ProductPrice2="2.70" ProductPrice3="3.70" ProductPrice4="3.70" ProductPrice5="3.70" ProductPrice6="1.90" ProductPrice7="3.70" ProductPrice8="0.00" ProductPrice9="0.00" ProductPrice10="0.00" />
              </ProductInfo>
              <NutritionInfo>
                <Nutrient name="Kilokalorien" shortName="kcal" unit="kcal" digitalSignageCode="kcal" value="465.34" value100="178.98" />
                <Nutrient name="Kilojoule" shortName="kJ" unit="kJ" digitalSignageCode="kJ" value="1943.29" value100="747.42" />
                <Nutrient name="Fett" shortName="F" unit="g" digitalSignageCode="F" value="34.57" value100="13.30" />
                <Nutrient name="gesättigte Fettsäuren" shortName="ges FS " unit="g" digitalSignageCode="ges FS " value="15.53" value100="5.97" />
                <Nutrient name="Kohlenhydrate" shortName="KH" unit="g" digitalSignageCode="KH" value="8.21" value100="3.16" />
                <Nutrient name="Zucker" shortName="Zucker" unit="g" digitalSignageCode="Zucker" value="3.46" value100="1.33" />
                <Nutrient name="Eiweiss" shortName="EW" unit="g" digitalSignageCode="EW" value="30.09" value100="11.57" />
                <Nutrient name="Salz" shortName="Salz" unit="g" digitalSignageCode="Salz" value="5.13" value100="1.97" />
                <Nutrient name="Ballaststoffe" shortName="BST" unit="g" digitalSignageCode="BST" value="0.79" value100="0.30" />
              </NutritionInfo>
              <DietaryValues Exchanges="0.5" Fuids="" />
              <AdditiveInfo>
                <AdditiveGroup name="Zusatzstoff" code="Zs">
                  <Additive name="mit Antioxidationsmittel" shortName="3" digitalSignageCode="3" />
                </AdditiveGroup>
                <AdditiveGroup name="Allergene" code="Al">
                  <Additive name="Gluten" shortName="GLU" digitalSignageCode="GLU" />
                  <Additive name="Sojabohnen" shortName="SJB" digitalSignageCode="SJB" />
                  <Additive name="Milch/Lactose" shortName="MILA" digitalSignageCode="MILA" />
                  <Additive name="Sellerie" shortName="i" digitalSignageCode="i" />
                  <Additive name="Weizen" shortName="a1" digitalSignageCode="a1" />
                  <Additive name="Gerste" shortName="a3" digitalSignageCode="a3" />
                </AdditiveGroup>
                <AdditiveGroup name="Information" code="Info">
                  <Additive name="mit Schwein" shortName="SCHW" digitalSignageCode="SCHW" />
                  <Additive name="ohne Kennzeichnung" shortName="(-)" digitalSignageCode="(-)" />
                </AdditiveGroup>
              </AdditiveInfo>
              <FoodLabelInfo>
                <FoodLabelGroup name="Allergene" code="Al">
                  <Allergens>
                    <FoodLabel name="Gluten" code="GLU" digitalSignageCode="GLU" />
                    <FoodLabel name="Sojabohnen" code="SJB" digitalSignageCode="SJB" />
                    <FoodLabel name="Milch/Lactose" code="MILA" digitalSignageCode="MILA" />
                    <FoodLabel name="Sellerie" code="i" digitalSignageCode="i" />
                    <FoodLabel name="Weizen" code="a1" digitalSignageCode="a1" />
                    <FoodLabel name="Gerste" code="a3" digitalSignageCode="a3" />
                  </Allergens>
                </FoodLabelGroup>
                <FoodLabelGroup name="Information" code="Info">
                  <Information>
                    <FoodLabel name="mit Schwein" code="SCHW" digitalSignageCode="SCHW" />
                    <FoodLabel name="ohne Kennzeichnung" code="(-)" digitalSignageCode="(-)" />
                  </Information>
                </FoodLabelGroup>
                <FoodLabelGroup name="Zusatzstoff" code="Zs">
                  <Additives>
                    <FoodLabel name="mit Antioxidationsmittel" code="3" digitalSignageCode="3" />
                  </Additives>
                </FoodLabelGroup>
              </FoodLabelInfo>
              <ListOfIngredients value="" />
              <CategoryInfo />
            </ComponentDetails>
          </Component>
          <Component IdentNr="32022122000490" RecipeID="16344" Name="Paprika-Maisgemüse" SalesPrice="0.00" SalesPrice1="0.00" SalesPrice2="0.00" TrafficLight="0" SalesUnit="Portion" CompGroup="Gemüsebeilagen" CompType="2" CompID="16344" Weight="0.150" NutriScore="" ServingTool="" Seasonality="0">
            <ComponentDetails>
              <GastDesc value="Paprika-Maisgemüse" />
              <ProductInfo>
                <Product name="Paprika Maisgemüse (VG) (RUB)" PLU="40303" ProductPrice="1.00" ProductPrice2="1.00" ProductPrice3="1.20" ProductPrice4="1.20" ProductPrice5="1.20" ProductPrice6="1.20" ProductPrice7="0.00" ProductPrice8="0.00" ProductPrice9="0.00" ProductPrice10="0.00" />
              </ProductInfo>
              <NutritionInfo>
                <Nutrient name="Kilokalorien" shortName="kcal" unit="kcal" digitalSignageCode="kcal" value="121.94" value100="81.29" />
                <Nutrient name="Kilojoule" shortName="kJ" unit="kJ" digitalSignageCode="kJ" value="501.66" value100="334.44" />
                <Nutrient name="Fett" shortName="F" unit="g" digitalSignageCode="F" value="6.27" value100="4.18" />
                <Nutrient name="gesättigte Fettsäuren" shortName="ges FS " unit="g" digitalSignageCode="ges FS " value="0.80" value100="0.53" />
                <Nutrient name="Kohlenhydrate" shortName="KH" unit="g" digitalSignageCode="KH" value="12.09" value100="8.06" />
                <Nutrient name="Zucker" shortName="Zucker" unit="g" digitalSignageCode="Zucker" value="6.47" value100="4.32" />
                <Nutrient name="Eiweiss" shortName="EW" unit="g" digitalSignageCode="EW" value="3.33" value100="2.22" />
                <Nutrient name="Salz" shortName="Salz" unit="g" digitalSignageCode="Salz" value="0.12" value100="0.08" />
                <Nutrient name="Ballaststoffe" shortName="BST" unit="g" digitalSignageCode="BST" value="3.36" value100="2.24" />
              </NutritionInfo>
              <DietaryValues Exchanges="0.8" Fuids="" />
              <AdditiveInfo>
                <AdditiveGroup name="Information" code="Info">
                  <Additive name="ohne Kennzeichnung" shortName="(-)" digitalSignageCode="(-)" />
                </AdditiveGroup>
              </AdditiveInfo>
              <FoodLabelInfo>
                <FoodLabelGroup name="Information" code="Info">
                  <Information>
                    <FoodLabel name="ohne Kennzeichnung" code="(-)" digitalSignageCode="(-)" />
                  </Information>
                </FoodLabelGroup>
              </FoodLabelInfo>
              <ListOfIngredients value="" />
              <CategoryInfo />
            </ComponentDetails>
          </Component>
          <Component IdentNr="32022122000490" RecipeID="9417" Name="Risolée-Kartoffeln" SalesPrice="0.00" SalesPrice1="0.00" SalesPrice2="0.00" TrafficLight="0" SalesUnit="Portion" CompGroup="Stärkebeilagen" CompType="2" CompID="9417" Weight="0.200" NutriScore="" ServingTool="" Seasonality="0">
            <ComponentDetails>
              <GastDesc value="Risolée-Kartoffeln" />
              <ProductInfo>
                <Product name="Risoleekartoffeln 200 g (VG) (RUB)" PLU="40591" ProductPrice="1.00" ProductPrice2="1.00" ProductPrice3="1.20" ProductPrice4="1.20" ProductPrice5="1.20" ProductPrice6="0.30" ProductPrice7="0.00" ProductPrice8="0.00" ProductPrice9="0.00" ProductPrice10="0.00" />
              </ProductInfo>
              <NutritionInfo>
                <Nutrient name="Kilokalorien" shortName="kcal" unit="kcal" digitalSignageCode="kcal" value="216.85" value100="108.43" />
                <Nutrient name="Kilojoule" shortName="kJ" unit="kJ" digitalSignageCode="kJ" value="909.13" value100="454.57" />
                <Nutrient name="Fett" shortName="F" unit="g" digitalSignageCode="F" value="5.56" value100="2.78" />
                <Nutrient name="gesättigte Fettsäuren" shortName="ges FS " unit="g" digitalSignageCode="ges FS " value="1.82" value100="0.91" />
                <Nutrient name="Kohlenhydrate" shortName="KH" unit="g" digitalSignageCode="KH" value="33.72" value100="16.86" />
                <Nutrient name="Zucker" shortName="Zucker" unit="g" digitalSignageCode="Zucker" value="0.12" value100="0.06" />
                <Nutrient name="Eiweiss" shortName="EW" unit="g" digitalSignageCode="EW" value="4.65" value100="2.32" />
                <Nutrient name="Salz" shortName="Salz" unit="g" digitalSignageCode="Salz" value="0.50" value100="0.25" />
                <Nutrient name="Ballaststoffe" shortName="BST" unit="g" digitalSignageCode="BST" value="4.40" value100="2.20" />
              </NutritionInfo>
              <DietaryValues Exchanges="2.2" Fuids="" />
              <AdditiveInfo>
                <AdditiveGroup name="Information" code="Info">
                  <Additive name="ohne Kennzeichnung" shortName="(-)" digitalSignageCode="(-)" />
                </AdditiveGroup>
              </AdditiveInfo>
              <FoodLabelInfo>
                <FoodLabelGroup name="Information" code="Info">
                  <Information>
                    <FoodLabel name="ohne Kennzeichnung" code="(-)" digitalSignageCode="(-)" />
                  </Information>
                </FoodLabelGroup>
              </FoodLabelInfo>
              <ListOfIngredients value="" />
              <CategoryInfo />
            </ComponentDetails>
          </Component>
          <Component IdentNr="32022122000490" RecipeID="2854" Name="Schokopudding " SalesPrice="0.00" SalesPrice1="0.00" SalesPrice2="0.00" TrafficLight="0" SalesUnit="Portion" CompGroup="Dessert" CompType="2" CompID="2854" Weight="0.180" NutriScore="" ServingTool="" Seasonality="0">
            <ComponentDetails>
              <GastDesc value="Schokopudding " />
              <ProductInfo>
                <Product name="Schokopudding" PLU="150052" ProductPrice="1.00" ProductPrice2="1.00" ProductPrice3="1.20" ProductPrice4="1.20" ProductPrice5="1.20" ProductPrice6="0.30" ProductPrice7="0.00" ProductPrice8="0.00" ProductPrice9="0.00" ProductPrice10="0.00" />
              </ProductInfo>
              <NutritionInfo>
                <Nutrient name="Kilokalorien" shortName="kcal" unit="kcal" digitalSignageCode="kcal" value="250.20" value100="139.00" />
                <Nutrient name="Kilojoule" shortName="kJ" unit="kJ" digitalSignageCode="kJ" value="1047.40" value100="581.89" />
                <Nutrient name="Fett" shortName="F" unit="g" digitalSignageCode="F" value="12.12" value100="6.73" />
                <Nutrient name="gesättigte Fettsäuren" shortName="ges FS " unit="g" digitalSignageCode="ges FS " value="8.14" value100="4.52" />
                <Nutrient name="Kohlenhydrate" shortName="KH" unit="g" digitalSignageCode="KH" value="29.60" value100="16.44" />
                <Nutrient name="Zucker" shortName="Zucker" unit="g" digitalSignageCode="Zucker" value="22.46" value100="12.48" />
                <Nutrient name="Eiweiss" shortName="EW" unit="g" digitalSignageCode="EW" value="5.90" value100="3.28" />
                <Nutrient name="Salz" shortName="Salz" unit="g" digitalSignageCode="Salz" value="0.20" value100="0.11" />
                <Nutrient name="Ballaststoffe" shortName="BST" unit="g" digitalSignageCode="BST" value="0.00" value100="0.00" />
              </NutritionInfo>
              <DietaryValues Exchanges="1.9" Fuids="" />
              <AdditiveInfo>
                <AdditiveGroup name="Zusatzstoff" code="Zs">
                  <Additive name="mit Farbstoff" shortName="1" digitalSignageCode="1" />
                </AdditiveGroup>
                <AdditiveGroup name="Allergene" code="Al">
                  <Additive name="Gluten" shortName="GLU" digitalSignageCode="GLU" />
                  <Additive name="Milch/Lactose" shortName="MILA" digitalSignageCode="MILA" />
                  <Additive name="Weizen" shortName="a1" digitalSignageCode="a1" />
                </AdditiveGroup>
              </AdditiveInfo>
              <FoodLabelInfo>
                <FoodLabelGroup name="Allergene" code="Al">
                  <Allergens>
                    <FoodLabel name="Gluten" code="GLU" digitalSignageCode="GLU" />
                    <FoodLabel name="Milch/Lactose" code="MILA" digitalSignageCode="MILA" />
                    <FoodLabel name="Weizen" code="a1" digitalSignageCode="a1" />
                  </Allergens>
                </FoodLabelGroup>
                <FoodLabelGroup name="Zusatzstoff" code="Zs">
                  <Additives>
                    <FoodLabel name="mit Farbstoff" code="1" digitalSignageCode="1" />
                  </Additives>
                </FoodLabelGroup>
              </FoodLabelInfo>
              <ListOfIngredients value="" />
              <CategoryInfo />
            </ComponentDetails>
          </Component>
        </SetMenu>
      </MenuLine>
      <MenuLine Name="USB" ShortName="USB">
        <InfoText>
        </InfoText>
        <SetMenu IdentNr="12022122000550" ItemID="16729" Name="USB" DisplayName="" IndividualName="" SalesPrice="0.00" SalesPrice1="0.00" SalesPrice2="0.00" TrafficLight="0" SalesUnit="Stück" Weight="0.600" IsComponentOriented="false" NutriScore="">
          <SetMenuDetails>
            <GastDesc value="Rinderragout [Paprika, Zucchini]&#xA;Leipziger Allerlei&#xA;Couscous">
              <GastDescTranslation lang="en-gb" value="Rinderragout [Paprika, Zucchini]&#xA;Leipziger Allerlei (VG) (RUB)&#xA;Couscous 200 g (VG) (RUB)" />
            </GastDesc>
            <ProductInfo>
              <Product name="" PLU="" ProductPrice="0.00" ProductPrice2="0.00" ProductPrice3="0.00" ProductPrice4="0.00" ProductPrice5="0.00" ProductPrice6="0.00" ProductPrice7="0.00" ProductPrice8="0.00" ProductPrice9="0.00" ProductPrice10="0.00" />
            </ProductInfo>
            <NutritionInfo>
              <Nutrient name="Kilokalorien" shortName="kcal" unit="kcal" digitalSignageCode="kcal" value="678.66" value100="113.11" />
              <Nutrient name="Kilojoule" shortName="kJ" unit="kJ" digitalSignageCode="kJ" value="2845.12" value100="474.19" />
              <Nutrient name="Fett" shortName="F" unit="g" digitalSignageCode="F" value="21.62" value100="3.60" />
              <Nutrient name="gesättigte Fettsäuren" shortName="ges FS " unit="g" digitalSignageCode="ges FS " value="8.08" value100="1.35" />
              <Nutrient name="Kohlenhydrate" shortName="KH" unit="g" digitalSignageCode="KH" value="70.61" value100="11.77" />
              <Nutrient name="Zucker" shortName="Zucker" unit="g" digitalSignageCode="Zucker" value="14.70" value100="2.45" />
              <Nutrient name="Eiweiss" shortName="EW" unit="g" digitalSignageCode="EW" value="43.01" value100="7.17" />
              <Nutrient name="Salz" shortName="Salz" unit="g" digitalSignageCode="Salz" value="3.25" value100="0.54" />
              <Nutrient name="Ballaststoffe" shortName="BST" unit="g" digitalSignageCode="BST" value="0.26" value100="0.04" />
            </NutritionInfo>
            <AdditiveInfo>
              <AdditiveGroup name="Allergene" code="Al">
                <Additive name="Gluten" shortName="GLU" digitalSignageCode="GLU" />
                <Additive name="Sojabohnen" shortName="SJB" digitalSignageCode="SJB" />
                <Additive name="Sellerie" shortName="i" digitalSignageCode="i" />
                <Additive name="Weizen" shortName="a1" digitalSignageCode="a1" />
                <Additive name="Gerste" shortName="a3" digitalSignageCode="a3" />
              </AdditiveGroup>
              <AdditiveGroup name="Information" code="Info">
                <Additive name="mit Rind" shortName="RIND" digitalSignageCode="RIND" />
                <Additive name="ohne Kennzeichnung" shortName="(-)" digitalSignageCode="(-)" />
              </AdditiveGroup>
            </AdditiveInfo>
            <FoodLabelInfo>
              <FoodLabelGroup name="Allergene" code="Al">
                <Allergens>
                  <FoodLabel name="Gluten" code="GLU" digitalSignageCode="GLU" />
                  <FoodLabel name="Sojabohnen" code="SJB" digitalSignageCode="SJB" />
                  <FoodLabel name="Sellerie" code="i" digitalSignageCode="i" />
                  <FoodLabel name="Weizen" code="a1" digitalSignageCode="a1" />
                  <FoodLabel name="Gerste" code="a3" digitalSignageCode="a3" />
                </Allergens>
              </FoodLabelGroup>
              <FoodLabelGroup name="Information" code="Info">
                <Information>
                  <FoodLabel name="mit Rind" code="RIND" digitalSignageCode="RIND" />
                  <FoodLabel name="ohne Kennzeichnung" code="(-)" digitalSignageCode="(-)" />
                </Information>
              </FoodLabelGroup>
            </FoodLabelInfo>
          </SetMenuDetails>
          <Component IdentNr="32022122000550" RecipeID="17448" Name="Rinderragout [Paprika, Zucchini]" SalesPrice="0.00" SalesPrice1="0.00" SalesPrice2="0.00" TrafficLight="0" SalesUnit="Portion" CompGroup="Hauptgerichte Rind/Lamm" CompType="2" CompID="17448" Weight="0.250" NutriScore="" ServingTool="" Seasonality="0">
            <ComponentDetails>
              <GastDesc value="Rinderragout [Paprika, Zucchini]" />
              <ProductInfo>
                <Product name="Mediterranes Rinderragout (R) (RUB)" PLU="1864" ProductPrice="2.80" ProductPrice2="2.80" ProductPrice3="3.80" ProductPrice4="3.80" ProductPrice5="3.80" ProductPrice6="1.90" ProductPrice7="3.80" ProductPrice8="0.00" ProductPrice9="0.00" ProductPrice10="0.00" />
              </ProductInfo>
              <NutritionInfo>
                <Nutrient name="Kilokalorien" shortName="kcal" unit="kcal" digitalSignageCode="kcal" value="316.14" value100="126.46" />
                <Nutrient name="Kilojoule" shortName="kJ" unit="kJ" digitalSignageCode="kJ" value="1317.30" value100="526.92" />
                <Nutrient name="Fett" shortName="F" unit="g" digitalSignageCode="F" value="16.84" value100="6.74" />
                <Nutrient name="gesättigte Fettsäuren" shortName="ges FS " unit="g" digitalSignageCode="ges FS " value="7.38" value100="2.95" />
                <Nutrient name="Kohlenhydrate" shortName="KH" unit="g" digitalSignageCode="KH" value="9.94" value100="3.97" />
                <Nutrient name="Zucker" shortName="Zucker" unit="g" digitalSignageCode="Zucker" value="4.80" value100="1.92" />
                <Nutrient name="Eiweiss" shortName="EW" unit="g" digitalSignageCode="EW" value="30.76" value100="12.31" />
                <Nutrient name="Salz" shortName="Salz" unit="g" digitalSignageCode="Salz" value="1.49" value100="0.59" />
                <Nutrient name="Ballaststoffe" shortName="BST" unit="g" digitalSignageCode="BST" value="0.24" value100="0.10" />
              </NutritionInfo>
              <DietaryValues Exchanges="0.6" Fuids="" />
              <AdditiveInfo>
                <AdditiveGroup name="Allergene" code="Al">
                  <Additive name="Gluten" shortName="GLU" digitalSignageCode="GLU" />
                  <Additive name="Sojabohnen" shortName="SJB" digitalSignageCode="SJB" />
                  <Additive name="Sellerie" shortName="i" digitalSignageCode="i" />
                  <Additive name="Weizen" shortName="a1" digitalSignageCode="a1" />
                  <Additive name="Gerste" shortName="a3" digitalSignageCode="a3" />
                </AdditiveGroup>
                <AdditiveGroup name="Information" code="Info">
                  <Additive name="mit Rind" shortName="RIND" digitalSignageCode="RIND" />
                  <Additive name="ohne Kennzeichnung" shortName="(-)" digitalSignageCode="(-)" />
                </AdditiveGroup>
              </AdditiveInfo>
              <FoodLabelInfo>
                <FoodLabelGroup name="Allergene" code="Al">
                  <Allergens>
                    <FoodLabel name="Gluten" code="GLU" digitalSignageCode="GLU" />
                    <FoodLabel name="Sojabohnen" code="SJB" digitalSignageCode="SJB" />
                    <FoodLabel name="Sellerie" code="i" digitalSignageCode="i" />
                    <FoodLabel name="Weizen" code="a1" digitalSignageCode="a1" />
                    <FoodLabel name="Gerste" code="a3" digitalSignageCode="a3" />
                  </Allergens>
                </FoodLabelGroup>
                <FoodLabelGroup name="Information" code="Info">
                  <Information>
                    <FoodLabel name="mit Rind" code="RIND" digitalSignageCode="RIND" />
                    <FoodLabel name="ohne Kennzeichnung" code="(-)" digitalSignageCode="(-)" />
                  </Information>
                </FoodLabelGroup>
              </FoodLabelInfo>
              <ListOfIngredients value="" />
              <CategoryInfo />
            </ComponentDetails>
          </Component>
          <Component IdentNr="32022122000550" RecipeID="2291" Name="Leipziger Allerlei" SalesPrice="0.00" SalesPrice1="0.00" SalesPrice2="0.00" TrafficLight="0" SalesUnit="Portion" CompGroup="Gemüsebeilagen" CompType="2" CompID="2291" Weight="0.150" NutriScore="" ServingTool="" Seasonality="0">
            <ComponentDetails>
              <GastDesc value="Leipziger Allerlei" />
              <ProductInfo>
                <Product name="Leipziger Allerlei (VG) (RUB)" PLU="180044" ProductPrice="1.00" ProductPrice2="1.00" ProductPrice3="1.20" ProductPrice4="1.20" ProductPrice5="1.20" ProductPrice6="0.30" ProductPrice7="0.00" ProductPrice8="0.00" ProductPrice9="0.00" ProductPrice10="0.00" />
              </ProductInfo>
              <NutritionInfo>
                <Nutrient name="Kilokalorien" shortName="kcal" unit="kcal" digitalSignageCode="kcal" value="69.43" value100="46.29" />
                <Nutrient name="Kilojoule" shortName="kJ" unit="kJ" digitalSignageCode="kJ" value="291.31" value100="194.21" />
                <Nutrient name="Fett" shortName="F" unit="g" digitalSignageCode="F" value="0.62" value100="0.41" />
                <Nutrient name="gesättigte Fettsäuren" shortName="ges FS " unit="g" digitalSignageCode="ges FS " value="0.16" value100="0.11" />
                <Nutrient name="Kohlenhydrate" shortName="KH" unit="g" digitalSignageCode="KH" value="9.20" value100="6.14" />
                <Nutrient name="Zucker" shortName="Zucker" unit="g" digitalSignageCode="Zucker" value="5.44" value100="3.63" />
                <Nutrient name="Eiweiss" shortName="EW" unit="g" digitalSignageCode="EW" value="4.06" value100="2.71" />
                <Nutrient name="Salz" shortName="Salz" unit="g" digitalSignageCode="Salz" value="0.42" value100="0.28" />
                <Nutrient name="Ballaststoffe" shortName="BST" unit="g" digitalSignageCode="BST" value="0.00" value100="0.00" />
              </NutritionInfo>
              <DietaryValues Exchanges="0.6" Fuids="" />
              <AdditiveInfo>
                <AdditiveGroup name="Information" code="Info">
                  <Additive name="ohne Kennzeichnung" shortName="(-)" digitalSignageCode="(-)" />
                </AdditiveGroup>
              </AdditiveInfo>
              <FoodLabelInfo>
                <FoodLabelGroup name="Information" code="Info">
                  <Information>
                    <FoodLabel name="ohne Kennzeichnung" code="(-)" digitalSignageCode="(-)" />
                  </Information>
                </FoodLabelGroup>
              </FoodLabelInfo>
              <ListOfIngredients value="" />
              <CategoryInfo />
            </ComponentDetails>
          </Component>
          <Component IdentNr="32022122000550" RecipeID="5202" Name="Couscous" SalesPrice="0.00" SalesPrice1="0.00" SalesPrice2="0.00" TrafficLight="0" SalesUnit="Portion" CompGroup="Stärkebeilagen" CompType="2" CompID="5202" Weight="0.200" NutriScore="" ServingTool="" Seasonality="0">
            <ComponentDetails>
              <GastDesc value="Couscous" />
              <ProductInfo>
                <Product name="Couscous" PLU="40290" ProductPrice="1.00" ProductPrice2="1.00" ProductPrice3="1.20" ProductPrice4="1.20" ProductPrice5="1.20" ProductPrice6="0.30" ProductPrice7="1.13" ProductPrice8="0.00" ProductPrice9="0.00" ProductPrice10="0.00" />
              </ProductInfo>
              <NutritionInfo>
                <Nutrient name="Kilokalorien" shortName="kcal" unit="kcal" digitalSignageCode="kcal" value="293.09" value100="146.54" />
                <Nutrient name="Kilojoule" shortName="kJ" unit="kJ" digitalSignageCode="kJ" value="1236.50" value100="618.25" />
                <Nutrient name="Fett" shortName="F" unit="g" digitalSignageCode="F" value="4.16" value100="2.08" />
                <Nutrient name="gesättigte Fettsäuren" shortName="ges FS " unit="g" digitalSignageCode="ges FS " value="0.53" value100="0.27" />
                <Nutrient name="Kohlenhydrate" shortName="KH" unit="g" digitalSignageCode="KH" value="51.47" value100="25.74" />
                <Nutrient name="Zucker" shortName="Zucker" unit="g" digitalSignageCode="Zucker" value="4.47" value100="2.23" />
                <Nutrient name="Eiweiss" shortName="EW" unit="g" digitalSignageCode="EW" value="8.19" value100="4.10" />
                <Nutrient name="Salz" shortName="Salz" unit="g" digitalSignageCode="Salz" value="1.35" value100="0.67" />
                <Nutrient name="Ballaststoffe" shortName="BST" unit="g" digitalSignageCode="BST" value="0.02" value100="0.01" />
              </NutritionInfo>
              <DietaryValues Exchanges="3.4" Fuids="" />
              <AdditiveInfo>
                <AdditiveGroup name="Allergene" code="Al">
                  <Additive name="Gluten" shortName="GLU" digitalSignageCode="GLU" />
                  <Additive name="Sellerie" shortName="i" digitalSignageCode="i" />
                  <Additive name="Weizen" shortName="a1" digitalSignageCode="a1" />
                </AdditiveGroup>
                <AdditiveGroup name="Information" code="Info">
                  <Additive name="ohne Kennzeichnung" shortName="(-)" digitalSignageCode="(-)" />
                </AdditiveGroup>
              </AdditiveInfo>
              <FoodLabelInfo>
                <FoodLabelGroup name="Allergene" code="Al">
                  <Allergens>
                    <FoodLabel name="Gluten" code="GLU" digitalSignageCode="GLU" />
                    <FoodLabel name="Sellerie" code="i" digitalSignageCode="i" />
                    <FoodLabel name="Weizen" code="a1" digitalSignageCode="a1" />
                  </Allergens>
                </FoodLabelGroup>
                <FoodLabelGroup name="Information" code="Info">
                  <Information>
                    <FoodLabel name="ohne Kennzeichnung" code="(-)" digitalSignageCode="(-)" />
                  </Information>
                </FoodLabelGroup>
              </FoodLabelInfo>
              <ListOfIngredients value="" />
              <CategoryInfo>
                <CategoryGroup name="" categoryNo="2">
                  <Category name="WHS" />
                </CategoryGroup>
              </CategoryInfo>
            </ComponentDetails>
          </Component>
        </SetMenu>
      </MenuLine>
      <MenuLine Name="Cafeteria ID" ShortName="ID">
        <InfoText>
        </InfoText>
        <SetMenu IdentNr="12022122000560" ItemID="20812" Name="Cafeteria ID" DisplayName="" IndividualName="" SalesPrice="0.00" SalesPrice1="0.00" SalesPrice2="0.00" TrafficLight="0" SalesUnit="Stück" Weight="0.430" IsComponentOriented="false" NutriScore="">
          <SetMenuDetails>
            <GastDesc value="Currywurstpfanne mit Brötchen ">
              <GastDescTranslation lang="en-gb" value="Currywurstpfanne mit Brötchen (G) (RUB)" />
            </GastDesc>
            <ProductInfo>
              <Product name="Cafeteria ID" PLU="4000007" ProductPrice="2.50" ProductPrice2="2.50" ProductPrice3="3.50" ProductPrice4="3.50" ProductPrice5="3.50" ProductPrice6="3.50" ProductPrice7="3.50" ProductPrice8="0.00" ProductPrice9="3.50" ProductPrice10="0.00" />
            </ProductInfo>
            <NutritionInfo>
              <Nutrient name="Kilokalorien" shortName="kcal" unit="kcal" digitalSignageCode="kcal" value="1170.40" value100="272.19" />
              <Nutrient name="Kilojoule" shortName="kJ" unit="kJ" digitalSignageCode="kJ" value="4877.47" value100="1134.30" />
              <Nutrient name="Fett" shortName="F" unit="g" digitalSignageCode="F" value="73.53" value100="17.10" />
              <Nutrient name="gesättigte Fettsäuren" shortName="ges FS " unit="g" digitalSignageCode="ges FS " value="26.71" value100="6.21" />
              <Nutrient name="Kohlenhydrate" shortName="KH" unit="g" digitalSignageCode="KH" value="80.89" value100="18.81" />
              <Nutrient name="Zucker" shortName="Zucker" unit="g" digitalSignageCode="Zucker" value="19.95" value100="4.64" />
              <Nutrient name="Eiweiss" shortName="EW" unit="g" digitalSignageCode="EW" value="43.44" value100="10.10" />
              <Nutrient name="Salz" shortName="Salz" unit="g" digitalSignageCode="Salz" value="8.87" value100="2.06" />
              <Nutrient name="Ballaststoffe" shortName="BST" unit="g" digitalSignageCode="BST" value="0.83" value100="0.19" />
            </NutritionInfo>
            <AdditiveInfo>
              <AdditiveGroup name="Zusatzstoff" code="Zs">
                <Additive name="mit Farbstoff" shortName="1" digitalSignageCode="1" />
                <Additive name="mit Konservierungsstoff" shortName="2" digitalSignageCode="2" />
                <Additive name="mit Phosphat" shortName="8" digitalSignageCode="8" />
                <Additive name="mit Süßungsmittel(n)" shortName="9" digitalSignageCode="9" />
                <Additive name="koffeinhaltig" shortName="12" digitalSignageCode="12" />
              </AdditiveGroup>
              <AdditiveGroup name="Allergene" code="Al">
                <Additive name="Gluten" shortName="GLU" digitalSignageCode="GLU" />
                <Additive name="Milch/Lactose" shortName="MILA" digitalSignageCode="MILA" />
                <Additive name="Senf" shortName="j" digitalSignageCode="j" />
                <Additive name="Weizen" shortName="a1" digitalSignageCode="a1" />
              </AdditiveGroup>
              <AdditiveGroup name="Information" code="Info">
                <Additive name="mit Geflügel" shortName="g" digitalSignageCode="g" />
                <Additive name="ohne Kennzeichnung" shortName="(-)" digitalSignageCode="(-)" />
              </AdditiveGroup>
            </AdditiveInfo>
            <FoodLabelInfo>
              <FoodLabelGroup name="Allergene" code="Al">
                <Allergens>
                  <FoodLabel name="Gluten" code="GLU" digitalSignageCode="GLU" />
                  <FoodLabel name="Milch/Lactose" code="MILA" digitalSignageCode="MILA" />
                  <FoodLabel name="Senf" code="j" digitalSignageCode="j" />
                  <FoodLabel name="Weizen" code="a1" digitalSignageCode="a1" />
                </Allergens>
              </FoodLabelGroup>
              <FoodLabelGroup name="Information" code="Info">
                <Information>
                  <FoodLabel name="mit Geflügel" code="g" digitalSignageCode="g" />
                  <FoodLabel name="ohne Kennzeichnung" code="(-)" digitalSignageCode="(-)" />
                </Information>
              </FoodLabelGroup>
              <FoodLabelGroup name="Zusatzstoff" code="Zs">
                <Additives>
                  <FoodLabel name="mit Farbstoff" code="1" digitalSignageCode="1" />
                  <FoodLabel name="mit Konservierungsstoff" code="2" digitalSignageCode="2" />
                  <FoodLabel name="mit Phosphat" code="8" digitalSignageCode="8" />
                  <FoodLabel name="mit Süßungsmittel(n)" code="9" digitalSignageCode="9" />
                  <FoodLabel name="koffeinhaltig" code="12" digitalSignageCode="12" />
                </Additives>
              </FoodLabelGroup>
            </FoodLabelInfo>
          </SetMenuDetails>
          <Component IdentNr="32022122000560" RecipeID="17026" Name="Currywurstpfanne mit Brötchen " SalesPrice="0.00" SalesPrice1="0.00" SalesPrice2="0.00" TrafficLight="0" SalesUnit="Portion" CompGroup="Pfannengerichte" CompType="2" CompID="17026" Weight="0.430" NutriScore="" ServingTool="" Seasonality="0">
            <ComponentDetails>
              <GastDesc value="Currywurstpfanne mit Brötchen " />
              <ProductInfo>
                <Product name="Currywurstpfanne mit Brötchen (G)" PLU="30293" ProductPrice="2.50" ProductPrice2="2.50" ProductPrice3="3.70" ProductPrice4="3.70" ProductPrice5="3.70" ProductPrice6="1.50" ProductPrice7="0.00" ProductPrice8="0.00" ProductPrice9="0.00" ProductPrice10="0.00" />
                <Product name="Currywurstpfanne mit Brötchen (G)" PLU="30394" ProductPrice="3.51" ProductPrice2="3.51" ProductPrice3="3.90" ProductPrice4="3.90" ProductPrice5="3.90" ProductPrice6="0.00" ProductPrice7="0.00" ProductPrice8="0.00" ProductPrice9="0.00" ProductPrice10="0.00" />
              </ProductInfo>
              <NutritionInfo>
                <Nutrient name="Kilokalorien" shortName="kcal" unit="kcal" digitalSignageCode="kcal" value="1170.40" value100="272.19" />
                <Nutrient name="Kilojoule" shortName="kJ" unit="kJ" digitalSignageCode="kJ" value="4877.47" value100="1134.30" />
                <Nutrient name="Fett" shortName="F" unit="g" digitalSignageCode="F" value="73.53" value100="17.10" />
                <Nutrient name="gesättigte Fettsäuren" shortName="ges FS " unit="g" digitalSignageCode="ges FS " value="26.71" value100="6.21" />
                <Nutrient name="Kohlenhydrate" shortName="KH" unit="g" digitalSignageCode="KH" value="80.89" value100="18.81" />
                <Nutrient name="Zucker" shortName="Zucker" unit="g" digitalSignageCode="Zucker" value="19.95" value100="4.64" />
                <Nutrient name="Eiweiss" shortName="EW" unit="g" digitalSignageCode="EW" value="43.44" value100="10.10" />
                <Nutrient name="Salz" shortName="Salz" unit="g" digitalSignageCode="Salz" value="8.87" value100="2.06" />
                <Nutrient name="Ballaststoffe" shortName="BST" unit="g" digitalSignageCode="BST" value="0.83" value100="0.19" />
              </NutritionInfo>
              <DietaryValues Exchanges="5.3" Fuids="" />
              <AdditiveInfo>
                <AdditiveGroup name="Zusatzstoff" code="Zs">
                  <Additive name="mit Farbstoff" shortName="1" digitalSignageCode="1" />
                  <Additive name="mit Konservierungsstoff" shortName="2" digitalSignageCode="2" />
                  <Additive name="mit Phosphat" shortName="8" digitalSignageCode="8" />
                  <Additive name="mit Süßungsmittel(n)" shortName="9" digitalSignageCode="9" />
                  <Additive name="koffeinhaltig" shortName="12" digitalSignageCode="12" />
                </AdditiveGroup>
                <AdditiveGroup name="Allergene" code="Al">
                  <Additive name="Gluten" shortName="GLU" digitalSignageCode="GLU" />
                  <Additive name="Milch/Lactose" shortName="MILA" digitalSignageCode="MILA" />
                  <Additive name="Senf" shortName="j" digitalSignageCode="j" />
                  <Additive name="Weizen" shortName="a1" digitalSignageCode="a1" />
                </AdditiveGroup>
                <AdditiveGroup name="Information" code="Info">
                  <Additive name="mit Geflügel" shortName="g" digitalSignageCode="g" />
                  <Additive name="ohne Kennzeichnung" shortName="(-)" digitalSignageCode="(-)" />
                </AdditiveGroup>
              </AdditiveInfo>
              <FoodLabelInfo>
                <FoodLabelGroup name="Allergene" code="Al">
                  <Allergens>
                    <FoodLabel name="Gluten" code="GLU" digitalSignageCode="GLU" />
                    <FoodLabel name="Milch/Lactose" code="MILA" digitalSignageCode="MILA" />
                    <FoodLabel name="Senf" code="j" digitalSignageCode="j" />
                    <FoodLabel name="Weizen" code="a1" digitalSignageCode="a1" />
                  </Allergens>
                </FoodLabelGroup>
                <FoodLabelGroup name="Information" code="Info">
                  <Information>
                    <FoodLabel name="mit Geflügel" code="g" digitalSignageCode="g" />
                    <FoodLabel name="ohne Kennzeichnung" code="(-)" digitalSignageCode="(-)" />
                  </Information>
                </FoodLabelGroup>
                <FoodLabelGroup name="Zusatzstoff" code="Zs">
                  <Additives>
                    <FoodLabel name="mit Farbstoff" code="1" digitalSignageCode="1" />
                    <FoodLabel name="mit Konservierungsstoff" code="2" digitalSignageCode="2" />
                    <FoodLabel name="mit Phosphat" code="8" digitalSignageCode="8" />
                    <FoodLabel name="mit Süßungsmittel(n)" code="9" digitalSignageCode="9" />
                    <FoodLabel name="koffeinhaltig" code="12" digitalSignageCode="12" />
                  </Additives>
                </FoodLabelGroup>
              </FoodLabelInfo>
              <ListOfIngredients value="" />
              <CategoryInfo />
            </ComponentDetails>
          </Component>
        </SetMenu>
      </MenuLine>
    </WeekDay>
  </WeekDays>
</NewDataSet>
''');
