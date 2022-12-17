const Map<String, String> mensaSampleDish1 = {
  'title': 'Kohlroulade mit Kümmelsauce',
  'price': '2,30 €  / 3,30 €',
  'allergies': '(S,a,a1,a3,f,i)'
};

const Map<String, String> mensaSampleDish2 = {
  'title': 'Paprika-Bohnengemüse',
  'price': '1,00 €  / 1,20 €',
  'allergies': '(VG)'
};

const Map<String, String> mensaSampleDish3 = {
  'title': 'Falafel Teller mit Pommes oder Reis und Salat',
  'price': '3,40 €  / 4,50 €',
  'allergies': '(VG,a,a1,f,i,j,l,1,2,5)'
};

const String mensaSampleDishXML = '''
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
''';
