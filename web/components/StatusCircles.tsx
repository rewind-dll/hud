import React from 'react';
import { Heart, Shield, Utensils, Droplet, Zap } from 'lucide-react';

interface CircleProps {
  icon: React.ReactNode;
  value: number; // 0-100
  color: string;
  glowColor: string;
}

const StatusCircle: React.FC<CircleProps> = ({ icon, value, color, glowColor }) => {
  const radius = 18;
  const circumference = 2 * Math.PI * radius;
  const offset = circumference - (value / 100) * circumference;

  return (
    <div className="relative flex items-center justify-center group">
      {/* Black Background Circle */}
      <div className="absolute w-12 h-12 rounded-full bg-black/70" />
      
      {/* Background Outer Ring (Glass) */}
      <div className="absolute w-12 h-12 rounded-full border border-white/10" />
      
      {/* SVG Ring */}
      <svg className="w-12 h-12 -rotate-90 relative z-10">
        {/* Track */}
        <circle
          cx="24"
          cy="24"
          r={radius}
          fill="transparent"
          stroke="rgba(255,255,255,0.05)"
          strokeWidth="3.5"
        />
        {/* Progress Fill */}
        <circle
          cx="24"
          cy="24"
          r={radius}
          fill="transparent"
          stroke={color}
          strokeWidth="3.5"
          strokeDasharray={circumference}
          strokeDashoffset={offset}
          strokeLinecap="round"
          style={{ 
            transition: 'stroke-dashoffset 0.8s cubic-bezier(0.4, 0, 0.2, 1)'
          }}
        />
      </svg>

      {/* Center Icon */}
      <div className="absolute inset-0 flex items-center justify-center z-20">
        <div className="transition-transform duration-300 group-hover:scale-110">
          {React.cloneElement(icon as React.ReactElement, { 
            size: 14,
            className: "text-white/90",
            strokeWidth: 2.5,
            fill: value > 10 ? "currentColor" : "none"
          })}
        </div>
      </div>
    </div>
  );
};

interface StatusCirclesProps {
  health: number;
  armor: number;
  hunger: number;
  thirst: number;
  stamina: number;
}

export const StatusCircles: React.FC<StatusCirclesProps> = ({ health, armor, hunger, thirst, stamina }) => {
  // Minimap dimensions: ~220px wide, positioned at bottom-left
  const minimapWidth = 220;
  const offsetFromMinimap = 195;
  
  return (
    <div 
      className="fixed bottom-4 flex flex-col gap-3 animate-in fade-in zoom-in-95 duration-500"
      style={{ left: `${minimapWidth + offsetFromMinimap}px` }}
    >
      <StatusCircle 
        icon={<Heart />} 
        value={health} 
        color="#ff4757" 
        glowColor="rgba(255, 71, 87, 0.5)" 
      />
      <StatusCircle 
        icon={<Shield />} 
        value={armor} 
        color="#2e86de" 
        glowColor="rgba(46, 134, 222, 0.5)" 
      />
      <StatusCircle 
        icon={<Utensils />} 
        value={hunger} 
        color="#ffa502" 
        glowColor="rgba(255, 165, 2, 0.5)" 
      />
      <StatusCircle 
        icon={<Droplet />} 
        value={thirst} 
        color="#1e90ff" 
        glowColor="rgba(30, 144, 255, 0.5)" 
      />
      <StatusCircle 
        icon={<Zap />} 
        value={stamina} 
        color="#7bed9f" 
        glowColor="rgba(123, 237, 159, 0.5)" 
      />
    </div>
  );
};
