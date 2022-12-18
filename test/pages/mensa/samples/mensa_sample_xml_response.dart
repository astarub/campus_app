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
