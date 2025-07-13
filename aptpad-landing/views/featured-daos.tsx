import { useDAOStore } from "@/store/daoStore";
import DAOTile from "@/components/ui/daocard";

export default function FeaturedDAOs() {
  const { featuredDAOs } = useDAOStore();
  return (
    <section className="mt-8">
      <h2 className="text-white text-xl font-bold mb-4">🌟 Featured DAOs</h2>
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-4">
        {featuredDAOs.map((dao, index) => (
          <DAOTile key={index} {...dao} />
        ))}
      </div>
    </section>
  );
}
