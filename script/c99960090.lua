--魔界的创世神 神绮
local s,id,o=GetID()
Duel.LoadScript("c99960010.lua")
function s.initial_effect(c)
		c:EnableReviveLimit()

	--special summon condition
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e9)
	--special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetDescription(aux.Stringid(99960010,1))
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(shenqi_Savior.spcon3)
	e0:SetOperation(shenqi_Savior.spop3)
	c:RegisterEffect(e0)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e0:SetLabelObject(g)
	--special summon rule2
	--[[local e0_1=Effect.CreateEffect(c)
	e0_1:SetType(EFFECT_TYPE_FIELD)
	e0_1:SetDescription(aux.Stringid(99960010,2))
	e0_1:SetCode(EFFECT_SPSUMMON_PROC)
	e0_1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0_1:SetRange(LOCATION_EXTRA)
	e0_1:SetCountLimit(1,99960010+5)
	e0_1:SetCondition(shenqi_Savior.spcon31)
	e0_1:SetOperation(shenqi_Savior.spop31)
	c:RegisterEffect(e0_1)
	local g1=Group.CreateGroup()
	g1:KeepAlive()
	e0_1:SetLabelObject(g1)]]
	--xyzop
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(shenqi_Savior.xyzop)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
	--xyzop2
	--[[local e1_1=Effect.CreateEffect(c)
	e1_1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1_1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1_1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1_1:SetOperation(shenqi_Savior.xyzop)
	e1_1:SetLabelObject(e0_1)
	c:RegisterEffect(e1_1)]]
	
	
	
	
	
	
		--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99960090,2))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(shenqi_Savior.xyzcost)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
	
		--cannot set
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_CANNOT_MSET)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(0,1)
	e7:SetTarget(aux.TRUE)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_CANNOT_SSET)
	c:RegisterEffect(e8)
	local e11=e7:Clone()
	e11:SetCode(EFFECT_CANNOT_TURN_SET)
	c:RegisterEffect(e11)
	local e10=e7:Clone()
	e10:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e10:SetTarget(s.sumlimit)
	c:RegisterEffect(e10)
			if s.global_check then return end 
		s.global_check= {{},{}}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(s.op_hint)
		Duel.RegisterEffect(ge1,0)
end
s.Savior_mojie=true
s.Savior_shenqi=true

-----------------------------怪兽全局标识提示-------------------------------
function s.op_hint(e,tp,eg,ep,ev,re,r,rp)
	s.SetHint(e:GetHandler(), 0)
	s.SetHint(e:GetHandler(), 1)
end
function s.SetHint(c, tp)
	local fa=Duel.GetFlagEffect(tp,99960010)
	local fb=Duel.GetFlagEffect(tp,99960020)
	local fc=3-fa+fb
	for _, e in ipairs(s.global_check[tp + 1]) do
		e:Reset()
	end
	local lst = {}
	if fc>0 then
		local e = Effect.CreateEffect(c)
		e:SetType(EFFECT_TYPE_FIELD)
		e:SetDescription(aux.Stringid(99960010,7))
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e:SetTargetRange(1,0)
		Duel.RegisterEffect(e,tp)
		table.insert(lst, e)
	end
	if fc<1 then
		local e = Effect.CreateEffect(c)
		e:SetType(EFFECT_TYPE_FIELD)
		e:SetDescription(aux.Stringid(99960010,8))
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e:SetTargetRange(1,0)
		Duel.RegisterEffect(e,tp)
		table.insert(lst, e)
	end
	----------------神的考验--------------------
		if fc>1 then
		local e1 = Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetDescription(aux.Stringid(99960120,1))
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e1:SetTargetRange(1,0)
		Duel.RegisterEffect(e1,tp)
		table.insert(lst, e1)
	end
		if fc<2 then
		local e1 = Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetDescription(aux.Stringid(99960120,2))
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e1:SetTargetRange(1,0)
		Duel.RegisterEffect(e1,tp)
		table.insert(lst, e1)
	end
	-----------------真魔法·魔神诵-------------------------
		if fc>2 then
		local e2 = Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetDescription(aux.Stringid(99960130,0))
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e2:SetTargetRange(1,0)
		Duel.RegisterEffect(e2,tp)
		table.insert(lst, e2)
	end
		if fc<3 then
		local e2 = Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetDescription(aux.Stringid(99960130,1))
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e2:SetTargetRange(1,0)
		Duel.RegisterEffect(e2,tp)
		table.insert(lst, e2)
	end
	---------------真魔法·消歧义--------------------------
		if fc>4 then
		local e3 = Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetDescription(aux.Stringid(99960140,0))
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e3:SetTargetRange(1,0)
		Duel.RegisterEffect(e3,tp)
		table.insert(lst, e3)
	end
		if fc<5 then
		local e3 = Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetDescription(aux.Stringid(99960140,1))
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e3:SetTargetRange(1,0)
		Duel.RegisterEffect(e3,tp)
		table.insert(lst, e3)
	end
	---------------真魔法·创世纪-------------------
		if fc>3 then
		local e4 = Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetDescription(aux.Stringid(99960180,2))
		e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e4:SetTargetRange(1,0)
		Duel.RegisterEffect(e4,tp)
		table.insert(lst, e4)
	end
	if fc<4 then
		local e4 = Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetDescription(aux.Stringid(99960180,3))
		e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e4:SetTargetRange(1,0)
		Duel.RegisterEffect(e4,tp)
		table.insert(lst, e4)
	end
	s.global_check[tp + 1] = lst
end


function s.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return bit.band(sumpos,POS_FACEDOWN)>0
end
--to hand
function s.thfilter(c,e,tp)
	return (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsFaceup() and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and s.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetChainLimit(s.chainlimit)
end
function s.chainlimit(c,e,rp,tp)
	return not (e:GetHandler():IsType(TYPE_SPELL) or e:GetHandler():IsType(TYPE_TRAP))
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsCanBeDisabledByEffect(e) then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		Duel.AdjustInstantly()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,1)
		e1:SetValue(s.aclimit)
		e1:SetLabel(tc:GetCode())
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end 
end
function s.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end




