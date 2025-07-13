import Button from "@/components/ui/button";

export default function HeroSection() {
  return (
    <section className="py-16 text-white text-center">
      <h1 className="text-4xl font-bold">
        Launch Your Vision.{" "}
        <span className="text-teal-400">Fund Your Future.</span>
      </h1>
      <p className="mt-4 max-w-xl mx-auto text-gray-400">
        The premier decentralized launchpad for innovative token projects.
      </p>
      <div className="mt-6">
        <Button text="🚀 Start a New DAO" />
      </div>
    </section>
  );
}
