import { BrowserRouter, Routes, Route } from 'react-router-dom';
import Navbar from './components/Navbar';
import Home from './pages/Home';
import DestinyPage from './pages/DestinyPage';
import { ORDER } from './data';

function App() {
  return (
    <BrowserRouter>
      <div className="bg-arcana-midnight min-h-screen text-gray-200">
        <Navbar />
        
        <Routes>
          <Route path="/" element={<Home />} />
          {ORDER.map((slug) => (
            <Route key={slug} path={`/${slug}`} element={<DestinyPage slug={slug} />} />
          ))}
        </Routes>
      </div>
    </BrowserRouter>
  );
}

export default App;
