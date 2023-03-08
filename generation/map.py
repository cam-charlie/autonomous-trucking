import math
import yaml
import random

coords = [

(52.216243, 0.134205),
(52.208402,0.137113),
(52.202536,0.131115),
(52.196525625608125, 0.12710304867680677),
(52.19811070793719, 0.12377672722948195),

(52.19801206694715, 0.12204938474842407),
(52.197499130269996, 0.12206011358371015),
(52.19840906038535, 0.11280378609355081),
(52.200651424827726, 0.11302909177456123),
(52.210084875060446, 0.11181541011902636),

(52.21077693567621, 0.11503291396449669),
(52.21427333729109, 0.12560433095352497),
(52.207965437964084, 0.12707034143893087),
(52.20482191055226, 0.12547268266409473),
(52.20504726048839, 0.12443520183229001),

(52.204044768484344, 0.12305249054538658),
(52.203516105449395, 0.12349123149621942),
(52.2028400553504, 0.12065683516776891),
(52.20196189673818, 0.11813582398501951),
(52.20239683594796, 0.11783168056102522),

(52.205508017508784, 0.11795525590966822),
(52.206232965720005, 0.11812846175233664),
(52.20646557899469, 0.11826850051874942),
(52.20637357336635, 0.11637241411904832),
(52.20489823526959, 0.11603007447548117),

(52.20622219074807, 0.12061696593282971),
(52.20532548574344, 0.1217709818280803),
(52.20696661135876, 0.12008689163964675),
(52.20777192506838, 0.11939116907451088),
(52.20846218232926, 0.11846353907258697),

(52.2072408523191, 0.12139070231165482),
(52.20835185574577, 0.1204107864389347),
(52.20905551004547, 0.11979131059131735),
(52.20974364858587, 0.11959862717024947),
(52.210398569469135, 0.1183070463690916),

(52.20924184353115, 0.11762061182179567),


]

roundabouts = [
True,
True,
True,
True,
True,

True,
True,
True,
True,
True,

True,
True,
True,
False,
False,

False,
False,
False,
True,
True,

True,
True,
False,
True,
True,

False,
False,
False,
False,
False,

False,
True,
True,
True,
True,

True,
]

children = {
0 : [1,11],
1: [0,12,2],
2: [1,13,3],
3: [2,4],
4: [3,17,5],
5: [6,4,18],
6: [5,7],
7: [6,8],
8: [7,19,9],
9: [8,10],
10: [9,35,11],
11: [0,10,12],
12: [11,1,31],
13: [14,12],
14: [15],
15: [16, 26],
16: [3],
17: [16],
18: [19,5,17],
19: [8,20,18],
20: [19,25],
21: [20,23],
22: [21],
23: [21,24],
24: [23],
25: [27],
26: [25, 30],
27: [22, 28],
28: [29],
29: [35, 32, 22],
30: [12],
31: [28,32,12],
32: [33,31],
33: [32,34],
34: [33,35],
35: [29, 10]
}


Kings = [
(52.203516940408, 0.11752535140912948),
(52.203140002829045, 0.1144501233391948),
(52.20475542705797, 0.11423384358174107),
(52.20495631545206, 0.11719417305748062)
]

Cats = [
(52.20244158164068, 0.11777179174022263),
(52.20223653960718, 0.11649438935944657),
(52.20337772112711, 0.11621728090647397),
(52.20349784379288, 0.1175352357437826)
]

Queens = [
(52.20221761661032, 0.11642213869295252),
(52.20198302878633, 0.11544290019545234),
(52.203126632731895, 0.11448598961157597),
(52.20337098873329, 0.11613825521973586)
]

Corpus = [
(52.202748688104116, 0.11910609216023148),
(52.20256662446759, 0.11780056047428654),
(52.203168709262286, 0.11766245033585325),
(52.20331084480078, 0.11873345537162842)
]

Pembroke = [
(52.20193075839457, 0.11816908430967789),
(52.202783103608446, 0.12060645230570383),
(52.20081477654486, 0.12163874933931479),
(52.20027874380385, 0.12017154938876584)
]

Peterhouse = [
(52.201868244948166, 0.11804149012899968),
(52.20062624767426, 0.11947361784159008),
(52.20028831308049, 0.11890792739511687),
(52.19962560268959, 0.11969559772944982),
(52.19993282064384, 0.12037585839293023),
(52.19868638034493, 0.12162180950288388),
(52.19840109860009, 0.1191585498372284),
(52.20150223905819, 0.11606749642407228)
]

Downing = [
(52.200779569918794, 0.12190351648526003),
(52.20162470316062, 0.12500282631191717),
(52.199374197163706, 0.12711973451540323),
(52.19827068385713, 0.12384041623406787)
]

Clare = [
(52.20533856105689, 0.11597326316126752),
(52.204919832018135, 0.11600840245475016),
(52.20480497993508, 0.11475900535314566),
(52.20533377560447, 0.11469653549806542)
]

Tit = [
(52.20626453643239, 0.11811285573492139),
(52.20642006011505, 0.11632075176730741),
(52.20606833654854, 0.1162934212057098),
(52.2061855040532, 0.11470116868249795),
(52.20736027453503, 0.11496910364598335),
(52.207259144675376, 0.11615013345287171),
(52.20786830973247, 0.11626483312327293),
(52.20748172518377, 0.11794231580289076)
]

Tithall = [
(52.20601139508844, 0.11625834251204777),
(52.205343829603024, 0.11597332379824425),
(52.20533425869876, 0.11421245475817038),
(52.20588458234492, 0.11409922814583749),
(52.20612145868564, 0.11483715330897265)
]

Caius = [
(52.206364598880256, 0.11641603833000823),
(52.20621608542365, 0.1180942068045562),
(52.20565077159637, 0.11789876792941476),
(52.20564757771252, 0.11630919841159758)
]

Christ = [
(52.207261855703244, 0.12155477939891926),
(52.20732042962576, 0.12437925878254928),
(52.20557782237974, 0.12333740340103601),
(52.20496276822079, 0.12231944382622521),
(52.205328872912396, 0.12180329530941973)
]

Johns = [
(52.20752092851126, 0.1178711354518279),
(52.20808698508119, 0.11583751409994954),
(52.209454214767725, 0.11613695018929146),
(52.209776837155765, 0.1166224951128926),
(52.20845407043799, 0.11840087658160657)
]

RiverJohns = [
(52.208421807356046, 0.1156748048928015),
(52.20862255512122, 0.11421232013234592),
(52.209966824817776, 0.11291363366506142),
(52.20949723122633, 0.11444631769401882),
(52.20930007213217, 0.11580350355172159)
]

Magdalene = [
(52.21021416601797, 0.11285513427928245),
(52.21068375203151, 0.1150254616637985),
(52.20986286941884, 0.116423597094794),
(52.2093968594397, 0.11579765361731902),
(52.20976608313303, 0.1150839610542167),
(52.20953666294668, 0.11477976422404194)
]

RoadMagdalene = [
(52.20998833283575, 0.1164528469270725),
(52.21071959811506, 0.11514831052074613),
(52.21148669679547, 0.11612525034073044),
(52.21069809048456, 0.11733618772238763)
]

Jesus = [
(52.2086833524483, 0.12126128042340151),
(52.20916188904761, 0.12111253335391975),
(52.21038099471114, 0.12256281728136668),
(52.21014173362123, 0.12395732105775793),
(52.2097961319943, 0.12440356226620317),
(52.20974296227464, 0.1254447917525753),
(52.20806808353272, 0.12545098954713704)
]

Sidney = [
(52.20739349801393, 0.12199793308874281),
(52.2069321460448, 0.12023163407357351),
(52.20774584601673, 0.11942501040154069),
(52.20854685697887, 0.12190692939241092)
]

Emma = [
(52.20412929322236, 0.12721587188019942),
(52.20228059308955, 0.12483404508807613),
(52.204048231811534, 0.12313000136400803),
(52.204989221652205, 0.12447878500659984)
]

Darwin = [
(52.20117430100285, 0.11446922484675222),
(52.200516289784325, 0.11361450548181068),
(52.19985507452289, 0.11385424384026989),
(52.19977202263522, 0.11361450548181068),
(52.20061531151276, 0.11318193409589512),
(52.20104653259642, 0.1141721577504006)
]

RiverQueens = [
(52.20187318846765, 0.11522494678488057),
(52.20124951600527, 0.11436914075797835),
(52.20218371668087, 0.1130024057597912),
(52.20264037187614, 0.11454796589792808)
]

names = [
"Kings' College",
"St. Catharine's College",
"Queens' College",
"Corpus Christi College",
"Pembroke College",
"Peterhouse College",
"Downing College",
"Clare College",
"Trinity College",
"Trinity Hall",
"Gonville & Caius College",
"Christ's College",
"St. John's College",
"Magdalene College",
"Jesus College",
"Sidney Sussex College",
"Emmanuel College",
"Dawrin College",
"Queens' College",
"St. John's College",
"Magdalene College"]


colleges = [
Kings,
Cats,
Queens,
Corpus,
Pembroke,
Peterhouse,
Downing,
Clare,
Tit,
Tithall,
Caius,
Christ,
Johns,
Magdalene,
Jesus,
Sidney,
Emma,
Darwin,
RiverQueens,
RiverJohns,
RoadMagdalene
]

depots = [
(52.20060931732512, 0.1133068889127282), #Darwin
(52.20226022705007, 0.11631149383423085), #Queens
(52.20824908644624, 0.12621816302490194), #Jesus
(52.20508672216755, 0.11537960257326384), #Clare
(52.20594466427574, 0.11706859290775677), #Caius
(52.20663138268741, 0.11638353003392114), #Trin
(52.208906613619845, 0.11708634048028999), #Johns
(52.21074856679287, 0.11562985391522548), #Magdalene
(52.199266444007115, 0.12666296662095566), #Downing
(52.20465274684887, 0.1160344467591665), #kings
(52.2018681086282, 0.11854499433677326), #pembroke
(52.20164782873971, 0.11794954397839617), #peterhouse
(52.203690299777634, 0.12399878145990985), #Emma
(52.20261945753242, 0.11715294243610334), #Cats
(52.2026436307059, 0.118156535555697), #Corpus

]

output = {}

ROUND = True

def getAngle(start, end):
	change_x = end[0] - start[0]
	change_y = end[1] - start[1]
	
	if change_x > 0 and change_y > 0:
		return math.atan(change_x/change_y)
	elif change_x > 0 and change_y <= 0:
		return (math.pi/2) + math.atan(-change_y/change_x)
	elif change_x <= 0 and change_y <= 0:
		return math.pi + math.atan(change_x/change_y)
	else:
		return 2*math.pi - math.atan(-change_x/change_y)

def measure(latlon):
	earth = 6.371 * 1000 * 1000
	return [(math.radians(latlon[1]) * earth - 14000)/1.5,
		-(math.radians(latlon[0]) * earth - 5805000)]

def main():
	text = []
	for name,coord in zip(names,colleges):
		text.append({"text":name, "position":measure(coord[0])})
	
	output["text"] = text
	
	outlines = [[measure(x) for x in t] for t in colleges]
	
	output["outlines"] = outlines
	
	roundabout = {}
	roundxy = {}
	

	
	unique_road_id = 0
	unique_node_id = 0
	nodes = {}
	roads = {}
	curves = []
	already_node = []
	
	round_node = []
	
	junc_node = []
	
	for index, coord in enumerate(coords):
		result = measure(coord)
		if roundabouts[index]:
			roundabout[index] = {"centre":{"x":result[0], "y": result[1]}, "radius": 5}
			roundxy[index] = result
	#Roundabout fixes
	roundabout[16] = {"centre":{"x":measure(coords[16])[0], "y": measure(coords[16])[0]}, "radius":0.5}
	roundxy[16] = measure(coords[16])

				
	for i in range(0,36):
		for j in children[i]:
			jxy = measure(coords[j])
			ixy = measure(coords[i])
			
			#start_id = unique_node_id
			
			if roundabouts[i] and ROUND:
				start_id = (i+1)*1000 + unique_node_id
				unique_node_id+=1
				startAngle = (getAngle(ixy,jxy) - 0.05) % (2*math.pi)
				nodes[start_id] = {"type": "roundabout junction", "position": {"roundabout":i, "angle":startAngle}}
				round_node.append(start_id)
			else:
				start_id = i
				if i not in already_node:
					#start_id = i
					nodes[start_id] = {"type": "junction", "position": {"x": ixy[0], "y": ixy[1]}}
					already_node.append(i)
					junc_node.append(start_id)
			

			
			#end_id = unique_node_id
					
			if roundabouts[j] and ROUND:
				end_id = (j+1)*1000 + unique_node_id
				unique_node_id+=1
				endAngle = (getAngle(jxy,ixy) + 0.05) % (2*math.pi)
				nodes[end_id] = {"type": "roundabout junction", "position": {"roundabout":j, "angle":endAngle}}
				round_node.append(end_id)
			else:
				end_id = j
				if j not in already_node:
					#end_id = j
					nodes[end_id] = {"type": "junction", "position": {"x": jxy[0], "y": jxy[1]}}
					already_node.append(j)
					junc_node.append(end_id)
			
			
			roads[unique_road_id] = {"type": "straight", "start node": start_id, "end node": end_id}
			unique_node_id += 1
			unique_road_id+=1
	
	ids = []
	
	for i in depots:
		r = measure(i)
		d = float('inf')
		for name,j in roundxy.items():
			if math.pow(j[1]-r[1],2) + math.pow(j[0]-r[0],2) < d:
				d = math.pow(j[1]-r[1],2) + math.pow(j[0]-r[0],2)
				pos = j
				target = name
				
		end = 1000000 + unique_node_id
		unique_node_id += 1
		start = 1000000 + unique_node_id
		unique_node_id += 1
		d_name = 2000000 + unique_node_id
		unique_node_id += 1
		ids.append(d_name)
		if ROUND:
			nodes[start] = {"type": "roundabout junction", "position": {"roundabout":name, "angle":(getAngle(pos,r) - 0.05) % (2*math.pi)}}
			nodes[end] = {"type": "roundabout junction", "position": {"roundabout":name, "angle":(getAngle(r,pos) + 0.05) % (2*math.pi)}}
		nodes[d_name] = {"type": "depot", "max capacity": 5, "position": {"x": r[0], "y":r[1]}}
		
		if ROUND:
			roads[unique_road_id] = {"type": "straight", "start node": start, "end node": d_name}
			curves.append({"roads":[unique_road_id],"node":start, "radius": 2.5})
			unique_road_id+=1
			roads[unique_road_id] = {"type": "straight", "start node": d_name, "end node": end}
			curves.append({"roads":[unique_road_id],"node":end, "radius": 2.5})
			unique_road_id+=1
			
			
		else:
			roads[unique_road_id] = {"type": "straight", "start node": target, "end node": d_name}
			unique_road_id+=1
			roads[unique_road_id] = {"type": "straight", "start node": d_name, "end node": target}
			unique_road_id+=1
		
	for name1, road1 in roads.items():
		for name2, road2 in roads.items():
			if name1 != name2:
				if road2["start node"] not in roundabout.keys():
					if road1["end node"] == road2["start node"]:
						curves.append({"roads":[name1, name2], "node":road1["end node"], "radius" : 2.5})
				
			
			


	output["roundabouts"] = roundabout	
				
	output["nodes"] = nodes
	output["roads"] = roads
	
	for name, road  in roads.items():
		if road["start node"] in round_node:
			curves.append({"roads":[name],"node":road["start node"], "radius": 2.5})
		if road["end node"] in round_node:
			curves.append({"roads":[name],"node":road["end node"], "radius": 2.5})	
	
	output["curves"] = curves
	
	
	
				
				
				
			
	print(ids)	
	print(yaml.dump(output))
	
	
		

main()