--枯国古王族·噬身大蛇 拉卡德
local cm,m,o=GetID()
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	e0:SetCondition(cm.sycon)
	e0:SetOperation(cm.syop)
	c:RegisterEffect(e0)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(3019642,0))
	e1:SetCategory(CATEGORY_EQUIP+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.eqtg)
	e1:SetOperation(cm.eqop)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79194594,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.immcon)
	e2:SetOperation(cm.immop)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(cm.val)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_LEVEL)
	e4:SetValue(cm.vall)
	c:RegisterEffect(e4)
end
function cm.stfilter1(c,tc)
	return bit.band(c:GetSynchroLevel(tc),9)~=0 and c:IsSynchroType(TYPE_TUNER) and c:IsPosition(POS_FACEUP) and c:IsCanBeSynchroMaterial(tc) and c:IsFaceup()
end
function cm.stfilter2(c,tc)
	return bit.band(c:GetSynchroLevel(tc),6)~=0 and c:IsPosition(POS_FACEUP) and c:IsCanBeSynchroMaterial(tc) and not c:IsSynchroType(TYPE_TUNER) and c:IsFaceup()
end
function cm.stfilterg(g,tp,tc,lv,smat)
	if smat then
		g:AddCard(smat)
	end
	local g1=g:Filter(cm.stfilter1,nil,tc)
	local g2=g:Filter(cm.stfilter2,nil,tc)
	local count=g:GetCount()
	return count==2 and g1:GetCount()==1 and g2:GetCount()==1 and Duel.GetLocationCountFromEx(tp,tp,g,tc)>0
end
function cm.sycon(e,c,smat,mg)
	if c==nil then return true end
	local lv=e:GetLabel()
	local tp=c:GetControler()
	if not mg then
		mg=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
	end
	if smat then
		mg:RemoveCard(smat)
		return mg:CheckSubGroup(cm.stfilterg,1,nil,tp,c,lv,smat)
	else
		return mg:CheckSubGroup(cm.stfilterg,2,nil,tp,c,lv,nil)
	end
end
function cm.syop(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
	local lv=e:GetLabel()
	if not mg then
		mg=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
	end
	local g=Group.CreateGroup()
	if smat then
		mg:RemoveCard(smat)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		g:Merge(mg:SelectSubGroup(tp,cm.stfilterg,false,1,nil,tp,c,lv,smat))
		g:AddCard(smat)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		g:Merge(mg:SelectSubGroup(tp,cm.stfilterg,false,2,nil,tp,c,lv,nil))
	end
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and tc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_ONFIELD) then 
		local atk=tc:GetTextAttack()
		if atk<0 then atk=0 end
		if not Duel.Equip(tp,tc,c,false) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(cm.eqlimit)
		tc:RegisterEffect(e1)
	end
end
function cm.eqlimit(e,c)
	return e:GetOwner()==c
end
function cm.immcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and e:GetHandler():GetEquipGroup():IsExists(Card.IsAbleToRemove,1,nil)
end
function cm.immop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetEquipGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:FilterSelect(tp,Card.IsAbleToRemove,1,1,nil)
	if #sg>0 and Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)~=0 then 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetTargetRange(LOCATION_ONFIELD,0)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetLabelObject(re)
		e1:SetValue(cm.efilter)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)  
	end
end
function cm.efilter(e,te)
	return te==e:GetLabelObject()
end
function cm.val(e,c)
	return c:GetEquipCount()*1000
end
function cm.vall(e,c)
	return c:GetEquipCount()*3
end