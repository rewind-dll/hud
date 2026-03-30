import React from 'react';
import { Wallet, Landmark, User, Briefcase, Clock, Mic, Skull } from 'lucide-react';

interface BadgeProps {
  icon: React.ReactNode;
  text: string | number;
  className?: string;
}

const Badge: React.FC<BadgeProps> = ({ icon, text, className = "" }) => (
  <div className={`flex items-center gap-2 bg-black/70 px-3 py-1 rounded-[4px] border border-white/10 ${className}`}>
    <span className="text-white/60">{icon}</span>
    <span className="text-white font-black text-sm tracking-tight">{text}</span>
  </div>
);

interface StatusHUDProps {
  id: number;
  cash: number;
  bank: number;
  dirty: number;
  job: string;
  time: string;
  voiceRange: number; // 1-3
  isTalking?: boolean;
}

export const StatusHUD: React.FC<StatusHUDProps> = ({ id, cash, bank, dirty, job, time, voiceRange, isTalking }) => {
  // Voice colors from config (passed via Lua)
  // Whisper (1): Blue, Normal (2): White, Shout (3): Yellow, Talking: Green
  const getMicColor = () => {
    if (isTalking) return "#2ecc71"; // Config.Voice.TalkingColor
    if (voiceRange === 3) return "#f39c12"; // Shout: Yellow
    if (voiceRange === 1) return "#3498db"; // Whisper: Blue
    return "rgba(255, 255, 255, 0.7)"; // Normal: White/Transparent
  };

  return (
    <>
      {/* Voice indicator */}
      <div className="flex items-center gap-2 mb-1">
        <div className={`bg-black/70 p-1.5 rounded-md border transition-all duration-200`}
          style={{ 
            borderColor: isTalking ? '#2ecc71' : 'rgba(255, 255, 255, 0.1)',
            transform: isTalking ? 'scale(1.1)' : 'scale(1)'
          }}>
          <Mic size={16} className="transition-colors duration-200" style={{ color: getMicColor() }} />
        </div>
      </div>

      {/* ID and Time row */}
      <div className="flex items-center gap-2">
        <Badge icon={<span className="text-xs font-black">#</span>} text={id} />
        <Badge icon={<Clock size={14} />} text={time} />
      </div>

      {/* Job and Cash row */}
      <div className="flex items-center gap-2">
        <Badge icon={<Briefcase size={14} />} text={job} />
        <Badge icon={<Wallet size={14} className="text-green-400" />} text={`$${cash.toLocaleString()}`} />
      </div>

      {/* Bank and Dirty row */}
      <div className="flex items-center gap-2">
        {dirty > 0 && (
          <Badge icon={<Skull size={14} className="text-red-500" />} text={`$${dirty.toLocaleString()}`} />
        )}
        <Badge icon={<Landmark size={14} className="text-blue-400" />} text={`$${bank.toLocaleString()}`} />
      </div>
    </>
  );
};

// Weapon HUD integrated into top-right status area
export const WeaponHUD: React.FC<{ name: string; ammo: number; clipAmmo?: number }> = ({ name, ammo, clipAmmo = 0 }) => {
  // Debug: Log weapon data (only in browser preview)
  if (typeof (window as any).GetParentResourceName !== 'function') {
    console.log('[WeaponHUD] Rendering with:', { name, ammo, clipAmmo });
  }
  
  // Hide if weapon is unarmed or not set
  if (!name || name.toLowerCase() === 'unarmed') {
    return null;
  }
  
  return (
    <div className="flex items-center gap-3 bg-black/70 px-3 py-1.5 rounded-[4px] border border-white/10">
      <span className="text-[10px] uppercase text-white/50 font-bold tracking-wider">{name}</span>
      <div className="flex items-baseline gap-1">
        <span className="text-lg font-black text-white">{clipAmmo}</span>
        <span className="text-xs text-white/40 font-bold">/</span>
        <span className="text-sm font-bold text-white/60">{ammo}</span>
      </div>
    </div>
  );
};
