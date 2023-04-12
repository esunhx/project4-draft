import { EthProvider, useEth } from "./contexts/EthContext";
import { Route, Routes } from 'react-router-dom';
import Home from "./pages/Home";
import User from "./pages/User";
import Header from "./components/Header";
import NotFound from "./components/utils/NotFound";

function App() {
  return (
    <EthProvider>
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
