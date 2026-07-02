<script setup>
defineProps(['simulation', 'durationLabel']);

function typeAccent(type) {
  if (type === '增益') {
    return 'type-accent-buff';
  }
  if (type === '减益') {
    return 'type-accent-debuff';
  }
  return 'type-accent-mech';
}

function probabilityWidth(value) {
  return `${Math.max(8, Math.min(100, Number(value || 0) * 100)).toFixed(2)}%`;
}
</script>

<template>
  <section class="allocator-section">
    <header class="allocator-section-head">
      <div>
        <p class="allocator-eyebrow">4 小时长局模拟</p>
        <h3>单局覆盖概率</h3>
      </div>
      <p class="session-copy">口径：4 小时单局，统计事件至少出现一次的概率。</p>
    </header>

    <div v-if="!simulation" class="state-block">当前没有可显示的长局模拟结果。</div>
    <template v-else>
      <div class="session-hero-strip">
        <article class="session-hero-card">
          <p class="session-hero-label">模拟时长</p>
          <p class="session-hero-value">{{ durationLabel }}</p>
        </article>
        <article class="session-hero-card">
          <p class="session-hero-label">基线场景</p>
          <p class="session-hero-value session-hero-value-text">{{ simulation.label }}</p>
        </article>
        <article class="session-hero-card">
          <p class="session-hero-label">单局预计轮数</p>
          <p class="session-hero-value">{{ simulation.estimatedCycleCountLabel }}</p>
        </article>
      </div>

      <div class="session-type-strip">
        <article
          v-for="summary in simulation.typeSummaries"
          :key="summary.type"
          class="session-type-card"
          :class="typeAccent(summary.typeLabel)"
        >
          <div class="session-type-head">
            <p class="session-type-label">{{ summary.typeLabel }}</p>
            <p class="session-type-rate">{{ summary.averageAtLeastOnceProbabilityPercent }}</p>
          </div>
          <p class="session-type-note">平均命中率</p>
          <div class="session-type-foot">
            <p>最高事件：{{ summary.highestEvent ? `${summary.highestEvent.eventNameZh} ${summary.highestEvent.atLeastOnceProbabilityPercent}` : '暂无' }}</p>
            <p>最低事件：{{ summary.lowestEvent ? `${summary.lowestEvent.eventNameZh} ${summary.lowestEvent.atLeastOnceProbabilityPercent}` : '暂无' }}</p>
          </div>
        </article>
      </div>

      <div class="session-table">
        <div class="session-row session-row-head">
          <span>事件</span>
          <span>类型</span>
          <span>随机事件包</span>
          <span>4 小时内至少出现一次</span>
          <span>等级</span>
        </div>
        <div v-for="item in simulation.eventSummaries" :key="item.key" class="session-row">
          <div class="session-name-cell">
            <span class="session-name">{{ item.eventNameZh }}</span>
            <span class="session-tier-note">{{ item.probabilityTierLabel }}</span>
          </div>
          <span>{{ item.eventTypeLabelZh }}</span>
          <span>{{ item.packLabelZh }}</span>
          <span class="session-probability-cell">
            <span class="session-probability">{{ item.atLeastOnceProbabilityPercent }}</span>
            <span class="session-probability-track">
              <span class="session-probability-bar" :style="{ width: probabilityWidth(item.atLeastOnceProbability) }"></span>
            </span>
          </span>
          <span class="session-tier">{{ item.probabilityTierLabel }}</span>
        </div>
      </div>
    </template>
  </section>
</template>

<style scoped>
.allocator-section {
  display: grid;
  gap: 0.95rem;
}

.allocator-section-head {
  display: flex;
  align-items: end;
  justify-content: space-between;
  gap: 1rem;
}

.allocator-section-head h3 {
  margin: 0;
  color: var(--ow-text);
}

.allocator-eyebrow {
  margin: 0;
  color: var(--ow-text-muted);
  font-size: 0.74rem;
  font-weight: 700;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}

.session-copy {
  margin: 0;
  color: var(--ow-text-soft);
  max-width: 22rem;
  text-align: right;
}

.session-hero-strip,
.session-type-strip {
  display: grid;
  gap: 0.8rem;
  grid-template-columns: repeat(3, minmax(0, 1fr));
}

.session-hero-card,
.session-type-card {
  padding: 0.95rem 1rem;
  border: 1px solid var(--ow-line);
  border-radius: var(--ow-radius-md);
  background: rgba(255, 255, 255, 0.03);
}

.session-hero-label,
.session-type-label,
.session-type-note,
.session-tier-note {
  margin: 0;
  color: var(--ow-text-muted);
  font-size: 0.74rem;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}

.session-hero-value,
.session-type-rate {
  margin: 0.3rem 0 0;
  color: var(--ow-text);
  font-family: var(--font-display);
  font-size: clamp(1.45rem, 2.2vw, 2rem);
  line-height: 1;
}

.session-hero-value-text {
  font-size: clamp(1rem, 1.8vw, 1.5rem);
  line-height: 1.1;
}

.session-type-head {
  display: flex;
  align-items: start;
  justify-content: space-between;
  gap: 0.8rem;
}

.session-type-foot {
  margin-top: 0.9rem;
  padding-top: 0.8rem;
  border-top: 1px solid rgba(255, 255, 255, 0.08);
  display: grid;
  gap: 0.24rem;
}

.session-type-foot p {
  margin: 0;
  color: var(--ow-text-soft);
  font-size: 0.82rem;
}

.type-accent-buff {
  background:
    linear-gradient(180deg, rgba(36, 173, 127, 0.08), rgba(255, 255, 255, 0.03)),
    rgba(255, 255, 255, 0.03);
}

.type-accent-debuff {
  background:
    linear-gradient(180deg, rgba(214, 120, 38, 0.08), rgba(255, 255, 255, 0.03)),
    rgba(255, 255, 255, 0.03);
}

.type-accent-mech {
  background:
    linear-gradient(180deg, rgba(54, 121, 212, 0.08), rgba(255, 255, 255, 0.03)),
    rgba(255, 255, 255, 0.03);
}

.session-table {
  display: grid;
  gap: 0.5rem;
}

.session-row {
  display: grid;
  grid-template-columns: minmax(160px, 1.5fr) minmax(70px, 0.6fr) minmax(110px, 0.9fr) minmax(220px, 1.6fr) minmax(70px, 0.5fr);
  gap: 0.7rem;
  align-items: center;
  color: var(--ow-text-soft);
  font-size: 0.84rem;
}

.session-row-head {
  color: var(--ow-text-muted);
  font-size: 0.76rem;
  text-transform: uppercase;
  letter-spacing: 0.04em;
}

.session-name-cell {
  display: grid;
  gap: 0.14rem;
}

.session-name {
  color: var(--ow-text);
  font-weight: 700;
}

.session-probability-cell {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.session-probability {
  width: 4.8rem;
  flex-shrink: 0;
}

.session-probability-track {
  position: relative;
  flex: 1;
  min-width: 0;
  height: 0.58rem;
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.08);
  overflow: hidden;
}

.session-probability-bar {
  position: absolute;
  inset: 0 auto 0 0;
  border-radius: 999px;
  background: linear-gradient(90deg, rgba(240, 160, 44, 0.35), rgba(240, 160, 44, 0.96));
}

.session-tier {
  color: var(--ow-text);
  font-weight: 700;
}

@media (max-width: 980px) {
  .session-hero-strip,
  .session-type-strip {
    grid-template-columns: 1fr;
  }

  .allocator-section-head {
    display: grid;
  }

  .session-copy {
    text-align: left;
    max-width: none;
  }

  .session-row {
    grid-template-columns: 1fr;
    padding: 0.72rem 0;
    border-top: 1px solid rgba(255, 255, 255, 0.06);
  }

  .session-row-head {
    display: none;
  }
}
</style>
