import { Pagination as AntPagination } from "antd"

const Pagination = props => {
  const { page, limit, totalEntries } = props
  const itemRender = (current, type, originalElement) => {
    if (type === 'prev') {
      return <a>Previous</a>;
    }
    if (type === 'next') {
      return <a>Next</a>;
    }
    return originalElement;
  }

  return (
    <div className="is-flex is-flex--space-between is-flex--vcenter">
      <div>{`Showing ${((page || 1) - 1) * (limit || 15) + 1} to ${((totalEntries || 1) > (limit || 15)) ? (page || 1) * (limit || 15) : totalEntries} of ${totalEntries || 0} entries`}</div>
      <AntPagination className="cus-pagination" page={page || 1} total={totalEntries || 1} pageSize={limit || 15} itemRender={itemRender} showSizeChanger={false} />
    </div>
  )
}

export default Pagination