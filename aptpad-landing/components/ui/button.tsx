interface ButtonProps {
  text: string;
  onClick?: () => void;
}

export default function Button({ text, onClick }: ButtonProps) {
  return (
    <button
      onClick={onClick}
      className="bg-teal-500 text-black px-6 py-2 rounded font-bold hover:bg-teal-600"
    >
      {text}
    </button>
  );
}
