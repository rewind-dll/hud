import React from 'react';
import { Fuel, Lightbulb, Zap, TriangleAlert, BellRing } from 'lucide-react';

interface VehicleHUDProps {
  speed: number;
  fuel: number;
  unit: 'KMH' | 'MPH';
  rpm: number; // 0.0 to 1.0
  gear: number | string;
  odometer: number;
  lights?: boolean;
  seatbelt?: boolean;
  engine?: boolean;
}

export const VehicleHUD: React.FC<VehicleHUDProps> = ({ 
  speed, fuel, unit, rpm, gear, odometer, lights, seatbelt, engine 
}) => {
  const rpmValue = Math.min(Math.max(rpm, 0), 1);
  const fuelValue = Math.min(Math.max(fuel / 100, 0), 1);
  
  // Arc parameters - more compact gaps like reference
  const radius = 88;
  const strokeWidth = 14;
  const arcLength = 105; // Longer arcs
  const gapLength = 18; // Smaller gap
  
  return (
    <div className="fixed bottom-6 right-6 flex flex-col items-center pointer-events-none select-none animate-in fade-in zoom-in duration-500">
      <div className="relative w-[300px] h-[300px] flex items-center justify-center">
        {/* Dark Background Circle */}
        <div className="absolute w-[235px] h-[235px] rounded-full bg-black/70 border border-white/5" />
        
        {/* Dual Arc SVG - Left and Right segments */}
        <svg className="absolute w-full h-full -rotate-[135deg]" viewBox="0 0 200 200">
          {/* Left Arc - Background */}
          <circle
            cx="100"
            cy="100"
            r={radius}
            fill="transparent"
            stroke="rgba(255,255,255,0.08)"
            strokeWidth={strokeWidth}
            strokeDasharray={`${arcLength} ${534 - arcLength}`}
            strokeLinecap="round"
          />
          {/* Left Arc - Fuel Fill */}
          <circle
            cx="100"
            cy="100"
            r={radius}
            fill="transparent"
            stroke="#ffffff"
            strokeWidth={strokeWidth - 1}
            strokeDasharray={`${fuelValue * arcLength} 534`}
            strokeLinecap="round"
            className="transition-all duration-300"
          />
          
          {/* Right Arc - Background */}
          <circle
            cx="100"
            cy="100"
            r={radius}
            fill="transparent"
            stroke="rgba(255,255,255,0.08)"
            strokeWidth={strokeWidth}
            strokeDasharray={`0 ${arcLength + gapLength} ${arcLength} ${534 - (2 * arcLength + gapLength)}`}
            strokeLinecap="round"
          />
          {/* Right Arc - RPM Fill */}
          <circle
            cx="100"
            cy="100"
            r={radius}
            fill="transparent"
            stroke="#ffffff"
            strokeWidth={strokeWidth - 1}
            strokeDasharray={`0 ${arcLength + gapLength} ${rpmValue * arcLength} 534`}
            strokeLinecap="round"
            className="transition-all duration-100 ease-linear"
          />
        </svg>

        {/* RPM Number Markers (Right side) */}
        {[2, 3, 4, 5, 6, 7, 8].map((n) => {
          const normalizedPos = (n - 2) / 6;
          const angle = 48 + normalizedPos * 84;
          const rad = (angle - 90) * (Math.PI / 180);
          const x = 100 + 74 * Math.cos(rad);
          const y = 100 + 74 * Math.sin(rad);
          return (
            <span key={n} className="absolute text-sm font-bold text-white/50" 
                  style={{ left: `${(x/200)*300}px`, top: `${(y/200)*300}px`, transform: 'translate(-50%, -50%)' }}>
              {n}
            </span>
          );
        })}

        {/* Top Icons */}
        <div className="absolute top-[16%] left-1/2 -translate-x-1/2 flex items-center gap-8">
          <Fuel size={22} className={fuel < 15 ? "text-red-500 animate-pulse" : "text-white/90"} />
          <Lightbulb size={22} className={lights ? "text-white/90" : "text-white/20"} />
        </div>

        {/* Center Digital Display */}
        <div className="relative z-10 flex flex-col items-center justify-center mt-1">
          {/* Gear Badge at top center */}
          <div className="w-[46px] h-[46px] rounded-full bg-white flex items-center justify-center mb-1.5 shadow-lg">
            <span className="text-black font-black text-[26px]">{gear}</span>
          </div>
          
          {/* Speed */}
          <span className="text-[68px] font-black text-white leading-none tracking-[-0.02em]">
            {Math.round(speed)}
          </span>
          
          {/* Unit */}
          <span className="text-[13px] font-bold text-white/50 tracking-[0.12em] uppercase mt-0.5">
            {unit}
          </span>
          
          {/* Odometer */}
          <span className="text-[11px] font-mono font-bold text-white/35 mt-2.5 tracking-wider">
            {odometer.toString().padStart(6, '0')} MI
          </span>
        </div>
      </div>

      {/* Bottom Indicators Bar - more compact */}
      <div className="flex items-center gap-5 mt-[-24px] bg-black/70 px-6 py-2 rounded-lg border border-white/5">
        <div className="w-5 h-5 flex items-center justify-center">
          <BellRing size={16} className={seatbelt ? "text-white/20" : "text-red-500 animate-pulse"} />
        </div>
        <div className="w-5 h-5 flex items-center justify-center">
          <TriangleAlert size={16} className="text-white/15" />
        </div>
        <div className="w-5 h-5 flex items-center justify-center">
          <Zap size={16} className={engine ? "text-green-400" : "text-white/20"} />
        </div>
        <div className="w-5 h-5 flex items-center justify-center">
          <div className="text-[10px] font-black text-orange-400 tracking-tight">IG</div>
        </div>
      </div>
    </div>
  );
};
