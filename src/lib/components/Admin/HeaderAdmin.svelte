<script>
  import { onMount } from 'svelte';
  let animate = false;
  onMount(() => {
    setTimeout(() => animate = true, 50);
  });
</script>

<header class="header-admin {animate ? 'show' : ''}">
  <div class="header-icon">
    <svg width="38" height="38" fill="none" viewBox="0 0 38 38" class="spin">
      <circle cx="19" cy="19" r="16" fill="#a36be6"/>
      <circle cx="19" cy="19" r="10" fill="#fff" fill-opacity="0.2"/>
      <text x="50%" y="56%" text-anchor="middle" fill="#fff" font-size="16" font-family="Arial" dy=".3em">AC</text>
    </svg>
  </div>
  <h2><span>Amazon Camp</span> <span class="divider">|</span> <span class="admin">Administración</span></h2>
</header>

<style>
.header-admin {
  display: flex;
  align-items: center;
  gap: 1.2rem;
  background: linear-gradient(90deg, #29d407 0%, #1a1333 100%);
  padding: 1.4rem 2.4rem 1.2rem 2.4rem;
  box-shadow: 0 6px 32px #33d80e33, 0 1.5px 0 rgba(56, 243, 4, 0.623) inset;
  color: #fff;
  font-size: 1.5em;
  font-weight: 700;
  position: relative;
  opacity: 0;
  transform: translateY(-22px) scale(0.98);
  transition: opacity 0.7s cubic-bezier(.6,.1,.2,1), transform 0.7s cubic-bezier(.6,.1,.2,1);
  z-index: 2;
}
.header-admin.show {
  opacity: 1;
  transform: translateY(0) scale(1);
}
.header-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(255,255,255,0.09);
  border-radius: 50%;
  box-shadow: 0 2px 12px #a36be644;
  padding: 0.4rem;
  margin-right: 0.3rem;
}
.header-icon .spin {
  animation: spin 2.2s cubic-bezier(.6,.1,.2,1) infinite alternate;
}
@keyframes spin {
  0% { transform: rotate(-10deg) scale(1); }
  100% { transform: rotate(8deg) scale(1.07); }
}
h2 {
  margin: 0;
  font-size: 1.1em;
  font-weight: 700;
  letter-spacing: 0.01em;
  display: flex;
  align-items: center;
  gap: 0.7em;
}
.divider {
  color: #fff9;
  font-weight: 400;
  font-size: 1.1em;
}
.admin {
  color: #ffe066;
  font-weight: 700;
  letter-spacing: 0.01em;
  text-shadow: 0 1px 8px #0002;
}
@media (max-width: 700px) {
  .header-admin {
    padding: 1rem 0.8rem 0.8rem 1rem;
    font-size: 1.07em;
    border-radius: 0 0 1rem 1rem;
  }
  .header-icon svg { width: 30px; height: 30px; }
  h2 { font-size: 1em; }
}
</style>
