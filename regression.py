print("enter brand")
brand=str(input()).title()
print("enter type")
type=str(input()).title()
print("有電動椅輸入1 沒有輸入0")
auto_chair=int(input())
print("有安全氣囊輸入1 沒有輸入0")
safe_bag=int(input())
print("四輪傳動輸入4 兩輪傳動輸入2")
power=int(input())
print("輸入排氣CC數")
cc=int(input())
print("輸入西元出廠年份")
year=2020-int(input())
print("手自排車輸入1 否輸入0")
semiauto=int(input())
hand=1-semiauto
print("油電混和車輸入1 否輸入0")
hybrid=int(input())
gas=1-hybrid
#查找使用者二手車brand、type對應係數
with open(r'E:/data/regression.json', "r", encoding='utf-8')as f:
    dic = {}
    for data in f.readlines():
        data=data.split(",")

        if brand in data[0][6:-1]:
            coeb=float(data[1][12:-2])
        if type in data[0][6:-1]:
            coet=float(data[1][12:-2])
#將使用者二手車資料建立字典
car={"auto_chair":auto_chair,"safe_bag":safe_bag,"power":power,"cc":cc,"year":year,"semiauto":semiauto,"hand":hand,
     "hybrid":hybrid,"gas":gas,"coeb":coeb,"coet":coet}
#使用者二手車市價估算 複回歸方程式
price_predict=168.106775+11.54561071*car["auto_chair"]-1.072887273*car["safe_bag"]-4.56611175*car["power"]-0.001975656*car["cc"]\
        -3.371553644*car["year"]-2.52933161*car["semiauto"]-2.705297375*car["hand"]+16.41229107*car["hybrid"]+9.246868102*car["gas"]\
      +1*car["coeb"]+1*car["coet"]
#估算合理價上下限，殘差值的標準差6.684836，單位萬
estimate_price=round(price_predict,2)
upboard=round(estimate_price+6.68,1)
downboard=round(estimate_price-6.68,1)
print(upboard,estimate_price,downboard)