import { useDAOStore } from "@/store/daoStore";
import DAOTile from "@/components/ui/daocard";

export default function TrendingDAOs() {
  const { trendingDAOs } = useDAOStore();
  return (
    <section className="mt-10">
      <h2 className="text-white text-xl font-bold mb-4">🔥 Trending DAOs</h2>
      <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-5 gap-4">
        {trendingDAOs.map((dao, index) => (
          <DAOTile key={index} {...dao} />
        ))}
      </div>
    </section>
  );
}
