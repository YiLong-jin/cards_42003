local m=15000093
local cm=_G["c"..m]
cm.name="无底的开辟者·娜蓝多耶"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--dark synchro summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.sprcon)
	e0:SetOperation(cm.sprop)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)
	--discard deck
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCategory(CATEGORY_DECKDES)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,15000093)
	e3:SetCondition(cm.discon)
	e3:SetTarget(cm.distg)
	e3:SetOperation(cm.disop)
	c:RegisterEffect(e3)
end
--这 是 声 明 此 卡 为 暗 黑 同 调 怪 兽 ， 用 于 检 测
cm.dark_synchro=true
function cm.ntfilter(c,sc,tp)  
	return c:GetLevel()~=0 and c:IsFaceup() and Duel.IsExistingMatchingCard(cm.dtfilter,tp,LOCATION_MZONE,0,1,c,c:GetSynchroLevel(sc),sc)
end  
function cm.dtfilter(c,x,sc)
	return c.dark_tuner and c:IsFaceup() and c:GetSynchroLevel(sc)==x+sc:GetLevel()
end
function cm.sprcon(e)
	local c=e:GetHandler()
	if c==nil then return true end
	local tp=c:GetControler()  
	return Duel.IsExistingMatchingCard(cm.ntfilter,tp,LOCATION_MZONE,0,1,nil,c,tp)
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local tp=c:GetControler()  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
	local g1=Duel.SelectMatchingCard(tp,cm.ntfilter,tp,LOCATION_MZONE,0,1,1,nil,c,tp)
	local x=g1:GetFirst():GetLevel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
	local g2=Duel.SelectMatchingCard(tp,cm.dtfilter,tp,LOCATION_MZONE,0,1,1,nil,x,c)
	g1:Merge(g2)
	c:SetMaterial(g1) 
	Duel.SendtoGrave(g1,REASON_MATERIAL+REASON_SYNCHRO+REASON_COST)
	Debug.Message("The ugly church worships the ugly gods.")
	Debug.Message("I don't believe it. I hate it.")
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,3,REASON_EFFECT)
end