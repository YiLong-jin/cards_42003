MagiaRecord=MagiaRecord or {}
mR=MagiaRecord
--cm.fusion_effect=true ocg包含融合召唤效果的卡标记

--批量检测是否是有...卡名记述的卡，...必须全是int，满足1个即可
function Card.IsCodeListed(c,...)
	for k, v in pairs{...} do
		if aux.IsCodeListed(c,v) then return true end
	end
end

--aux.AddCodeList(c,9878396) 带「天音姐妹」记述
---非卡名记述标识一览（所有非卡名记述全用c.格式）
--cm.Uwasa=true 卡名带谣言记述 get c.Uwasa
function mR.UwasaCheck(f)
	return	function(c,...)
		return c.Uwasa and (not f or f(c,...))
	end
end
--cm.Eternal_Sakura=true 卡名带「柊樱子」记述 get c.Eternal_Sakura
function Card.EternalSakuraCheck(c)
	return c.Eternal_Sakura
end
--cm.Mariko_Ayaka=true 卡名带「球子彩花」记述 get c.Mariko_Ayaka
function Card.MarikoAyakaCheck(c)
	return c.Mariko_Ayaka
end
--cm.Makino_Ikumi=true 卡名带「牧野郁美」记述 get c.Makino_Ikumi
function Card.MakinoIkumiCheck(c)
	return c.Makino_Ikumi
end
--cm.Midori_Ryo=true 卡名带「观鸟令」记述 get c.Midori_Ryo
function Card.MidoriRyoCheck(c)
	return c.Midori_Ryo
end
--cm.Hozumi_Shizuku=true 卡名带「保澄雫」记述 get c.Hozumi_Shizuku
function Card.HozumiShizukuCheck(c)
	return c.Hozumi_Shizuku
end
--cm.Benqi_JueXing=true 内置字段「本气觉醒」get c.Benqi_JueXing/c:BenqiJueXingCheck()
function Card.BenqiJueXingCheck(c)
	return c.Benqi_JueXing
end
--cm.Magia_Summer_Vacation=true 内置字段「魔法少女的夏日」get c.Magia_Summer_Vacation
function Card.MagiaSummerVacationCheck(c)
	return c.Magia_Summer_Vacation
end
--cm.Ancient_Legend_Magias=true 内置字段「传说中的魔法少女」get c.Ancient_Legend_Magias
function Card.AncientLegendMagias(c)
	return c.Ancient_Legend_Magias
end
--cm.Pure_Wedding=true 内置字段「洁白的约定」get c.Pure_Wedding
function Card.PureWeddingMagia(c)
	return c.Pure_Wedding_Magia
end
function mR.PureWeddingCheck(f)
	return	function(c,...)
		return c.Pure_Wedding_Magia and (not f or f(c,...))
	end
end
--cm.Dopple=true 内置字段「魔女化身」get c.Dopple
--mR.DoppleChar[m]=对应角色code 内置字段「魔女化身」get mR.GetDoppleCode(c)
MagiaRecord.DoppleChar={}
function MagiaRecord.GetDoppleCode(c)
	local id
	if Auxiliary.GetValueType(c)=="Card" then id=c:GetCode() end
	if Auxiliary.GetValueType(c)=="number" then id=c end
	return MagiaRecord.DoppleChar[id]
end
--cm.Majo=true 内置字段「魔女编号」get c.Majo
--mR.MajoID[m]=XXX 内置字段「魔女编号XXX」
MagiaRecord.MajoID={}
function MagiaRecord.GetMajoID(c)
	local id
	if Auxiliary.GetValueType(c)=="Card" then id=c:GetCode() end
	if Auxiliary.GetValueType(c)=="number" then id=c end
	return MagiaRecord.MajoID[id]
end
--use like mR.MajoCheck() not mR.MajoCheck
function mR.MajoCheck(f)
	return	function(c,...)
		return c.Majo and (not f or f(c,...))
	end
end

--樱子和保澄互通
function Card.UwasaCodeListCheck(c)
	return c:IsCodeListed(9877924) or (Duel.IsPlayerAffectedByEffect(c:GetControler(),9878649) and c:IsCodeListed(9878524))
end
function mR.UwasaCodeListCheck(f)
	return	function(c,...)
		return c:UwasaCodeListCheck() and f(c,...)
	end
end
function Card.ShizukuCodeListCheck(c)
	return c:IsCodeListed(9878524) or (Duel.IsPlayerAffectedByEffect(c:GetControler(),9878649) and c:IsCodeListed(9877924))
end
function mR.ShizukuCodeListCheck(f)
	return	function(c,...)
		return c:ShizukuCodeListCheck() and f(c,...)
	end
end

--樱子和保澄记述怪兽二速效果,9878648
function mR.Shizuku_Uwasa_EffectIgnitionCheck(f)
	return function (e,tp,eg,ep,ev,re,r,rp)
		return not (Duel.IsPlayerAffectedByEffect(tp,9878648) and e:GetHandler():ShizukuCodeListCheck()) and f(e,tp,eg,ep,ev,re,r,rp)
	end
end
function mR.Shizuku_Uwasa_EffectQuickCheck(f)
	return function (e,tp,eg,ep,ev,re,r,rp)
		return Duel.IsPlayerAffectedByEffect(tp,9878648) and e:GetHandler():ShizukuCodeListCheck() and f(e,tp,eg,ep,ev,re,r,rp)
	end
end
function Effect.CreateShizuku_Uwasa_IgnitiontoQuick_Effect(e1,c,f)
	local e=e1:Clone()
	e:SetType(EFFECT_TYPE_QUICK_O)
	e:SetCode(EVENT_FREE_CHAIN)
	e:SetCondition(mR.Shizuku_Uwasa_EffectQuickCheck(f))
	c:RegisterEffect(e)
end

--if b1 or b2 then if b1 and not b2 or (selectoption/selectyesno) then f1 else f2 end
function MagiaRecord.SelectFilterOperaion(b1,b2,f1,f2,optionck,desc1,desc2,e,tp,eg,ep,ev,re,r,rp,...)
	local ck=false
	if b1 or b2 then
		if b1 and (not b2 or (optionck and Duel.SelectOption(tp,desc1,desc2)==0) or (not optionck and Duel.SelectYesNo(tp,desc1))) then
			e:SetLabel(0)
			if f1(e,tp,eg,ep,ev,re,r,rp,...) then ck=true end
		else
			e:SetLabel(1)
			if f2(e,tp,eg,ep,ev,re,r,rp,...) then ck=true end
		end
	end
	return ck,e:GetLabel()
end

--faceup filter,
function MagiaRecord.FaceupFilter(f)
	return	function(c,...)
		return c:IsFaceup() and f(c,...)
	end
end

--cm.Magius_DesEffect=true 玛吉斯破坏效果确认 get c.Magius_DesEffect
--自己场上有Magius之翼(42624039)存在
function mR.MagiusWingExistsCheck(tp)
	return Duel.IsExistingMatchingCard(mR.FaceupFilter(Card.IsCode),tp,0x0c,0,1,nil,42624039) or Duel.GetFlagEffect(tp,9878733)~=0
end
--自己场上有蓝家姬奈(9878706)存在 对需要操作那些卡的情景不适用
function mR.AikaHimenaExistsCheck(tp)
	return Duel.IsExistingMatchingCard(mR.FaceupFilter(Card.IsCode),tp,0x0c,0,1,nil,9878706) or Duel.GetFlagEffect(tp,9878709)~=0
end

--forbidden filter,
function MagiaRecord.ToFieldForbiddenCheck(f)
	return	function(c,...)
		return not c:IsForbidden() and f(c,...)
	end
end

--public filter,
function MagiaRecord.ConfirmCardsCheck(f)
	return	function(c,...)
		return not c:IsPublic() and f(c,...)
	end
end

--abletohand filter,
function MagiaRecord.ToHandFilter(f)
	return	function(c,...)
		return c:IsAbleToHand() and f(c,...)
	end
end

--todeck filter,
function MagiaRecord.ToDeckFilter(f)
	return	function(c,...)
		return c:IsAbleToDeck() and f(c,...)
	end
end

--discard filter,
function MagiaRecord.DiscardFilter(f)
	return	function(c,...)
		return c:IsDiscardable() and f(c,...)
	end
end

--sset filter,
function MagiaRecord.ToGraveFilter(f)
	return	function(c,...)
		return c:IsAbleToGrave() and f(c,...)
	end
end

--sset filter,
function MagiaRecord.ToGraveCostFilter(f)
	return	function(c,...)
		return c:IsAbleToGraveAsCost() and f(c,...)
	end
end

--sset filter,
function MagiaRecord.RemoveFilter(f)
	return	function(c,...)
		return c:IsAbleToRemove() and f(c,...)
	end
end

--sset filter,
function MagiaRecord.RemoveCostFilter(f)
	return	function(c,...)
		return c:IsAbleToRemoveAsCost() and f(c,...)
	end
end

--sset filter,
function MagiaRecord.SSetFilter(f)
	return	function(c,...)
		return c:IsSSetable() and f(c,...)
	end
end

--spsummon filter,
function MagiaRecord.SpSummonFilter(f)
	return	function(c,e,summonvalue,tp,nocheck,nolimit,...)
		return c:IsCanBeSpecialSummoned(e,summonvalue,tp,nocheck,nolimit) and f(c,...)
	end
end

--iscode filter,
function MagiaRecord.IsCodeFilter(f)
	return	function(c,code,...)
		return c:IsCode(code) and f(c,...)
	end
end

--ispreviouslocation filter,
function MagiaRecord.IsPreviousLocationFilter(f)
	return	function(c,loc,...)
		return c:IsPreviousLocation(loc) and f(c,...)
	end
end

--feequal filter,
function MagiaRecord.FlagEffectEqualFilter(f)
	return	function(c,m,n,...)
		return c:GetFlagEffect(m)==n and f(c,...)
	end
end

--istype filter,
function MagiaRecord.IsTypeFilter(f)
	return	function(c,type,...)
		return c:IsType(type) and f(c,...)
	end
end

--istype filter,
function MagiaRecord.GetTypeFilter(f)
	return	function(c,type,...)
		return c:GetType()==type and f(c,...)
	end
end

--isatt filter,
function MagiaRecord.IsAttFilter(f)
	return	function(c,att,...)
		return c:IsAttribute(att) and f(c,...)
	end
end

--israce filter,
function MagiaRecord.IsRaceFilter(f)
	return	function(c,race,...)
		return c:IsRace(race) and f(c,...)
	end
end

--canbeeffecttarget filter,
function MagiaRecord.CanBeEffectTargetFilter(f)
	return	function(c,e,...)
		return c:IsCanBeEffectTarget(e) and f(c,...)
	end
end

--isbaseattackabove filter,
function MagiaRecord.GetBaseAttackAboveFilter(f)
	return	function(c,n,...)
		return c:GetBaseAttack()>n and f(c,...)
	end
end

--iscodelisted filter,only one
function MagiaRecord.IsCodeListedFilter(f)
	return	function(c,code,...)
		return c:IsCodeListed(code) and f(c,...)
	end
end

function Card.IsOriginalCode(c,code)
	return c:GetOriginalCode()==code
end

--iscodelisted filter,only one
function MagiaRecord.IsOriginalCodeFilter(f)
	return	function(c,code,...)
		return c:GetOriginalCode()==code and f(c,...)
	end
end

--iscodelisted filter,only one
function MagiaRecord.Mzctcheck(f)
	return	function(c,tp,...)
		return aux.mzctcheck(c,tp) and f(c,...)
	end
end

--Chkc用集成检测
function Card.Chkc(c,tp,loc,f,...)
	local b1,b2,b3=true,true,true
	if tp then b1=c:IsControler(tp) end
	if loc then b2=c:IsLocation(loc) end
	if f then b3=f(c,...) end
	return b1 and b2 and b3
end

--原本种族Is
function Card.IsOriginalRace(c,race)
	return c:GetOriginalRace()&race~=0
end

--指定卡在场上适用，检测是否是对方场上的，如是必须表侧表示
function Card.CheckUnknownOpCard(c,tp)
	return c:IsControler(tp) or c:IsFaceup()
end

--默认Activateeffect创建
function Card.CreateDefaultActivateEffect(c,m,rck)
	local e=Effect.CreateEffect(c)
	e:SetType(EFFECT_TYPE_ACTIVATE)
	e:SetCode(EVENT_FREE_CHAIN)
	if m then
		e:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	end
	if not rck then
		c:RegisterEffect(e)
	else
		return e
	end
end

--移除重叠卡
function mR.RemoveOverlayCardCostOnlyCheck(n)
	return function (e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,n,REASON_COST) end
		e:GetHandler():RemoveOverlayCard(tp,n,n,REASON_COST)
	end
end

--不是xx怪兽不能特殊召唤
--f function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
function Card.SPSummonLimit(c,f,reset,tp,range,p1,p2,rc,ct)
	p1=p1 or 1
	p2=p2 or 0
	ct=ct or 1
	local e=Effect.CreateEffect(c)
	e:SetType(EFFECT_TYPE_FIELD)
	e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	if reset then
		e:SetReset(reset,ct)
	end
	if range then
		e:SetRange(range)
	end
	e:SetTargetRange(p1,p2)
	e:SetTarget(f)
	if tp then
		Duel.RegisterEffect(e,tp)
	else
		if rc then
			rc:RegisterEffect(e)
		else
			c:RegisterEffect(e)
		end
	end
end

--攻击力上升single
function Card.AtkDefSingleUpdate(c,code,val,cc,reset,ck)
	cc=cc or c
	ck=ck or false
	local resetf
	if not reset then
		resetf=RESET_EVENT+RESETS_STANDARD
		reset=1
	else
		if reset<5 then
			resetf=RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END
		else
			resetf=reset
			reset=1
		end
	end
	local e1=Effect.CreateEffect(cc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(code)
	e1:SetValue(val)
	e1:SetReset(resetf,reset)
	c:RegisterEffect(e1,ck)
end

--赋予卡片不受对方f效果影响默认格式
--f cm.efilter(e,re)
function Card.ImmGiven(c,desc,f,reset,tp,tc,ck,ct)
	ct=ct or 1
	local e=Effect.CreateEffect(c)
	if desc then
		e:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e:SetDescription(desc)
	end
	e:SetType(EFFECT_TYPE_SINGLE)
	e:SetCode(EFFECT_IMMUNE_EFFECT)
	e:SetValue(f)
	e:SetReset(reset,ct)
	e:SetOwnerPlayer(tp)
	if ck then
		return e
	else
		tc:RegisterEffect(e)
	end
end

function Card.DisableEffectGiven(c,tc,reset,resetct)
	reset=reset or RESET_EVENT+RESETS_STANDARD
	resetct=resetct or 1
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(reset,resetct)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetValue(RESET_TURN_SET)
	c:RegisterEffect(e2)
end
--赋予怪兽效果无效化
function Card.ForbiddenMonsterGiven(c,tc,reset)
	local resetct=1
	if not reset then
		reset=RESET_EVENT+RESETS_STANDARD
	elseif type(reset)=="number" then
		resetct=reset
		reset=RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END
	end
	Duel.NegateRelatedChain(c,RESET_TURN_SET)
	c:DisableEffectGiven(tc,reset,resetct)
end

--Duel.GetFirstTarget to AllRelateChainTargets / return Group 
function Duel.GetAllTarget()
	return Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToChain,nil)
end

----泛用简写标准发动效果生成
function Effect.SetCTCRPC(e,category,typey,code,range,property,countlimit,cardm)
	if category then e:SetCategory(category) end
	if type(typey)=="number" then
		e:SetType(typey)
	else
		if typey=="eta" then
			e:SetType(EFFECT_TYPE_ACTIVATE)
		elseif typey=="eti" then
			e:SetType(EFFECT_TYPE_IGNITION)
		elseif typey=="etto+s" then
			e:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
		elseif typey=="etto+f" then
			e:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
		elseif typey=="etqo" then
			e:SetType(EFFECT_TYPE_QUICK_O)
		elseif typey=="ettf+s" then
			e:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
		elseif typey=="ettf+f" then
			e:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
		elseif typey=="etc+s" then
			e:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
		elseif typey=="etc+f" then
			e:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		elseif typey=="etqf" then
			e:SetType(EFFECT_TYPE_QUICK_F)
		end
	end
	if code then e:SetCode(code) end
	if range then e:SetRange(range) end
	if property then e:SetProperty(property) end
	if countlimit then
		if cardm then
			e:SetCountLimit(countlimit,cardm)
		else
			e:SetCountLimit(countlimit)
		end
	end
end

function Effect.SetCCTO(e,condition,cost,target,opreation)
	if condition then e:SetCondition(condition) end
	if cost then e:SetCost(cost) end
	if target then e:SetTarget(target) end
	if opreation then e:SetOperation(opreation) end
end

----泛用回手处理
function Card.RTOHANDsolve(c,tp,falseck)
	if Duel.SendtoHand(c,nil,REASON_EFFECT) then
		if tp==nil then tp=1-c:GetControler() end
		if c:IsLocation(0x02) then
			Duel.ConfirmCards(1-tp,c)
			return true
		end
	end
	if not falseck then return false end
end

function Group.RTOHANDsolve(g,tp,falseck)
	if Duel.SendtoHand(g,nil,REASON_EFFECT) then
		if g:FilterCount(Card.IsLocation,nil,0x02)>0 then
			Duel.ConfirmCards(1-tp,g:Filter(Card.IsLocation,nil,0x02))
			return true
		end
	end
	if not falseck then return false end
end