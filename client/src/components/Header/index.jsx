import { BrowserRouter as Router, Switch, Route, Link } from 'react-router-dom';
import useEth from '../../contexts/EthContext/useEth';

function Header() {

  return (
    <div className="bg-indigo-900">
      <nav className="flex items-center justify-between flex-wrap bg-light py-6">
        <div className="flex items-center flex-shrink-0">
          <li className="font-semibold text-xl text-white tracking-tight">
            <Link to={'/'} className="nav-link"> Lawfirm Registration </Link>
          </li>
        </div>
        <div className="w-full block flex-grow lg:flex lg:items-center lg:w-auto">
          <div className="text-sm lg:flex-grow">
            <li className="block mt-4 lg:inline-block lg:mt-0 text-gray-200 hover:text-white ml-4">
              <Link to={'/user'} className="nav-link">User</Link>
            </li>
          </div>
        </div>
      </nav>
    </div>
  );
}

export default Header;