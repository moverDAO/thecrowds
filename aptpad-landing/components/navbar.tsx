export default function Navbar() {
  return (
    <nav className="w-full py-4 px-6 flex justify-between items-center text-white">
      <div className="text-lg font-bold">Aptpad</div>
      <div className="space-x-4">
        <button className="hover:text-teal-400">How it Works</button>
        <button className="hover:text-teal-400">Start DAO</button>
        <button className="bg-teal-500 text-black px-4 py-2 rounded">
          Connect Wallet
        </button>
      </div>
    </nav>
  );
}
