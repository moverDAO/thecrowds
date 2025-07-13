interface Props {
  name: string;
  description: string;
  mcap: string;
  image: string;
}

export default function daoCard({ name, description, mcap, image }: Props) {
  return (
    <div className="bg-night-900 rounded-md p-4 text-white shadow">
      <img
        src={image}
        className="rounded-md w-full h-40 object-cover"
        alt={name}
      />
      <div className="mt-3 text-sm text-gray-300">{name}</div>
      <div className="text-lg font-semibold">{mcap} mcap</div>
      <p className="text-xs mt-1">{description}</p>
    </div>
  );
}
