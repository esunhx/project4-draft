import { EthProvider, useEth } from "./contexts/EthContext";
import { Route, Routes } from 'react-router-dom';
import Home from "./pages/Home";
import User from "./pages/User";
import Header from "./components/Header";
import NotFound from "./components/utils/NotFound";

function App() {
  return (
    <EthProvider>
      <h1 className="flex flex-row justify-between bg-cyan-600">yeeee</h1>
      <Header />
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/user" element={<User />} />
        <Route component={NotFound}/>
      </Routes>
    </EthProvider>
  );
}

export default App;
