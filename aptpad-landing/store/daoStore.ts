import { create } from "zustand";

interface DAO {
  name: string;
  description: string;
  mcap: string;
  image: string;
}

interface DAOStore {
  featuredDAOs: DAO[];
  trendingDAOs: DAO[];
  setDAOs: (featured: DAO[], trending: DAO[]) => void;
}

export const useDAOStore = create<DAOStore>((set) => ({
  featuredDAOs: [],
  trendingDAOs: [],
  setDAOs: (featured, trending) =>
    set({ featuredDAOs: featured, trendingDAOs: trending }),
}));
