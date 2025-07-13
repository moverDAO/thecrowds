"use client";

import { useEffect } from "react";
import { useDAOStore } from "@/store/daoStore";
import HeroSection from "@/views/hero";
import FeaturedDAOs from "@/views/featured-daos";
import TrendingDAOs from "@/views/trending-daos";

export default function Home() {
  const setDAOs = useDAOStore((s) => s.setDAOs);

  useEffect(() => {
    const dummyDAO = {
      name: "Project Token",
      description: "Revolutionizing DeFi with AI-powered analytics.",
      mcap: "$1.2k",
      image: "/images/3250.jpeg",
    };

    const featured = Array(5).fill(dummyDAO);
    const trending = Array(15).fill(dummyDAO);

    setDAOs(featured, trending);
  }, []);

  return (
    <main className="bg-black min-h-screen px-6">
      <HeroSection />
      <FeaturedDAOs />
      <TrendingDAOs />
    </main>
  );
}
