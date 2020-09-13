import json
print("enter brand")
brand=str(input()).lower()
print("enter type")
type=str(input()).lower()
print("有電動椅輸入1 沒有輸入0")
auto_chair=int(input())
l_chair=1-auto_chair
print("有安全氣囊輸入1 沒有輸入0")
safe_bag=int(input())
print("有天窗輸入1 沒有輸入0")
window=int(input())
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
# 查找使用者二手車brand、type對應係數
with open(r'E:/data/regression2.json', "r", encoding='utf-8')as f:
    coe_dic = json.load(f)
#使用者二手車市價估算 複回歸方程式
price_predict=154.1392221+11.80682461*auto_chair-6.41950482*l_chair\
      +4.571555743*safe_bag+1.220113211*window-0.002609202*cc\
    -3.37803454*year-4.720416481*semiauto-3.76528218*hand\
      +16.11014399*hybrid+8.901650607*gas+1*coe_dic[brand]+1*coe_dic[type]
#估算合理價上下限，殘差值的標準差6.684836，單位萬
estimate_price=round(price_predict,2)
upboard=round(estimate_price+7.05,1)
downboard=round(estimate_price-7.05,1)
print("合理價區間:",downboard,"~",upboard)