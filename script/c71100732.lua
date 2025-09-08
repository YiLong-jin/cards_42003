--天王星之渴望驾驭 2025/08/12 03:31:23 scripted by 翼龙
local this,id,ofs=GetID()
function this.initial_effect(c)
	-- Xyz summon procedure
	aux.AddXyzProcedure(c,nil,3,2,this.ovfilter,aux.Stringid(id,2),2,this.xyzop)
	-- ATK increase effect 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(this.atkval)
	c:RegisterEffect(e1)
	-- Special Summon effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES+CATEGORY_GRAVE_SPSUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id)
	e2:SetCondition(this.spcon)
	e2:SetTarget(this.sptg)
	e2:SetOperation(this.spop)
	c:RegisterEffect(e2)
end
function this.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
-- Overlay summon filter (on "渴望" monsters)
function this.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x67a3)
end

-- ATK increase calculation (修正版：排除里侧表示怪兽)
function this.atkval(e,c)
	return Duel.GetMatchingGroupCount(function(sc)return sc:IsFaceup() and sc:IsSetCard(0x67a3) end,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil)*1000
end

-- Special Summon condition (leave field by opponent)
function this.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end

-- Special Summon target
function this.spfilter(c,e,tp)
	return c:IsSetCard(0x67a3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function this.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(this.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end

-- Special Summon operation
function this.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(this.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end