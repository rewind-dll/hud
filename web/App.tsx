import { useState } from 'react';
import { isDebug, useNuiEvent } from './hooks/useNui';
import { StatusHUD, WeaponHUD } from './components/PlayerHUD';
import { VehicleHUD } from './components/VehicleHUD';
import { StatusCircles } from './components/StatusCircles';

interface PlayerData {
  id: number;
  cash: number;
  bank: number;
  dirty: number;
  job: string;
  time: string;
  voiceRange: number;
  isTalking?: boolean;
}

interface StatusData {
  health: number;
  armor: number;
  hunger: number;
  thirst: number;
  stamina: number;
}

interface WeaponData {
  name: string;
  ammo: number;
  clipAmmo?: number;
}

interface VehicleData {
  active: boolean;
  speed: number;
  fuel: number;
  unit: 'KMH' | 'MPH';
  rpm: number;
  gear: number | string;
  odometer: number;
  lights?: boolean;
  seatbelt?: boolean;
  engine?: boolean;
}

export default function App() {
  const [player, setPlayer] = useState<PlayerData>({
    id: 1,
    cash: 0,
    bank: 1011500,
    dirty: 5250,
    job: 'LSPD (Chief)',
    time: '15:50',
    voiceRange: 2,
    isTalking: false,
  });

  const [status, setStatus] = useState<StatusData>({
    health: 85,
    armor: 40,
    hunger: 65,
    thirst: 90,
    stamina: 100,
  });

  const [weapon, setWeapon] = useState<WeaponData>({
    name: 'unarmed',
    ammo: 0,
    clipAmmo: 0,
  });

  const [vehicle, setVehicle] = useState<VehicleData>({
    active: isDebug,
    speed: 12,
    fuel: 85,
    unit: 'MPH',
    rpm: 0.15,
    gear: 1,
    odometer: 0,
    lights: true,
    seatbelt: false,
    engine: true,
  });

  const [visible, setVisible] = useState(true);

  useNuiEvent<PlayerData>('updatePlayer', (data) => setPlayer(prev => ({ ...prev, ...data })));
  useNuiEvent<StatusData>('updateStatus', (data) => setStatus(prev => ({ ...prev, ...data })));
  useNuiEvent<WeaponData>('updateWeapon', (data) => {
    if (typeof (window as any).GetParentResourceName !== 'function') {
      console.log('[App] Received weapon update:', data);
    }
    setWeapon(data);
  });
  useNuiEvent<VehicleData>('updateVehicle', (data) => setVehicle(data));
  useNuiEvent<boolean>('setVisibility', (v) => setVisible(v));

  if (!visible) return null;

  return (
    <div className="w-screen h-screen relative select-none font-sans overflow-hidden pointer-events-none">
      {/* Top Right: Status HUD with integrated weapon */}
      <div className="fixed top-6 right-6 flex flex-col items-end gap-2">
        <StatusHUD {...player} />
        {!vehicle.active && <WeaponHUD {...weapon} />}
      </div>

      {/* Bottom Left: Status Circles (Positioned to match standard mini-map) */}
      <StatusCircles {...status} />

      {/* Bottom Right: Circular Speedometer */}
      {vehicle.active && <VehicleHUD {...vehicle} />}
    </div>
  );
}
