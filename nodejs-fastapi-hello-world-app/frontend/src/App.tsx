import { useState, useEffect } from 'react'
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  Title,
  Tooltip,
  Legend,
} from 'chart.js'
import { Line } from 'react-chartjs-2'
import './App.css'

ChartJS.register(
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  Title,
  Tooltip,
  Legend
)

interface ApiResponse {
  message: string
}

interface DataSource {
  id: string
  name: string
  type: string
  status: string
  last_sync: string
  records: number
}

interface DataPoint {
  x: number
  y: number
}

interface ChartData {
  datasource: string
  data: DataPoint[]
  title: string
  x_title: string
  y_title: string
}

interface Stats {
  total_sources: number
  connected_sources: number
  total_records: number
  last_updated: string
}

function App() {
  const [apiData, setApiData] = useState<ApiResponse | null>(null)
  const [dataSources, setDataSources] = useState<DataSource[]>([])
  const [selectedSource, setSelectedSource] = useState<string | null>(null)
  const [chartData, setChartData] = useState<ChartData | null>(null)
  const [stats, setStats] = useState<Stats | null>(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    // Fetch initial data
    Promise.all([
      fetch('/api/hello').then(response => response.json()),
      fetch('/api/datasources').then(response => response.json()),
      fetch('/api/stats').then(response => response.json())
    ])
      .then(([helloData, sourcesData, statsData]) => {
        setApiData(helloData)
        setDataSources(sourcesData.datasources)
        setStats(statsData)
        setLoading(false)
      })
      .catch(error => {
        console.error('Error:', error)
        setLoading(false)
      })
  }, [])

  const loadSourceData = (sourceId: string) => {
    setSelectedSource(sourceId)
    fetch(`/api/datasources/${sourceId}/data`)
      .then(response => response.json())
      .then(data => {
        setChartData(data)
      })
      .catch(error => {
        console.error('Error loading source data:', error)
      })
  }

  const chartOptions = {
    responsive: true,
    plugins: {
      legend: {
        display: false,
      },
      title: {
        display: true,
        text: chartData?.title || 'Data Visualization',
        font: {
          size: 18
        }
      },
    },
    scales: {
      x: {
        display: true,
        title: {
          display: true,
          text: chartData?.x_title || 'X Axis'
        }
      },
      y: {
        display: true,
        title: {
          display: true,
          text: chartData?.y_title || 'Y Axis'
        }
      }
    }
  }

  const lineData = {
    datasets: [
      {
        data: chartData?.data || [],
        backgroundColor: 'rgba(75, 192, 192, 0.2)',
        borderColor: 'rgba(75, 192, 192, 1)',
        borderWidth: 2,
        tension: 0.4,
        pointRadius: 3,
      },
    ],
  }

  const getStatusColor = (status: string) => {
    return status === 'connected' ? '#4ade80' : '#ef4444'
  }

  return (
    <div className="App">
      <header className="App-header">
        <h1>🔗 Dataconnect Node.js FastAPI App</h1>
        
        {loading ? (
          <p>Loading...</p>
        ) : (
          <div className="content">
            {apiData && (
              <div className="api-info">
                <p className="message">{apiData.message}</p>
              </div>
            )}

            {stats && (
              <div className="stats-container">
                <div className="stat-card">
                  <h3>{stats.total_sources}</h3>
                  <p>Total Sources</p>
                </div>
                <div className="stat-card">
                  <h3>{stats.connected_sources}</h3>
                  <p>Connected</p>
                </div>
                <div className="stat-card">
                  <h3>{stats.total_records.toLocaleString()}</h3>
                  <p>Total Records</p>
                </div>
              </div>
            )}

            <div className="datasources-section">
              <h2>Data Sources</h2>
              <div className="datasources-grid">
                {dataSources.map((source) => (
                  <div 
                    key={source.id} 
                    className={`datasource-card ${selectedSource === source.id ? 'selected' : ''}`}
                    onClick={() => loadSourceData(source.id)}
                  >
                    <div className="datasource-header">
                      <h3>{source.name}</h3>
                      <span 
                        className="status-indicator"
                        style={{ backgroundColor: getStatusColor(source.status) }}
                      ></span>
                    </div>
                    <p className="datasource-type">{source.type}</p>
                    <p className="datasource-records">{source.records.toLocaleString()} records</p>
                  </div>
                ))}
              </div>
            </div>
            
            {chartData && (
              <div className="chart-container">
                <h2>Data Visualization</h2>
                <Line data={lineData} options={chartOptions} />
              </div>
            )}
          </div>
        )}
      </header>
    </div>
  )
}

export default App 